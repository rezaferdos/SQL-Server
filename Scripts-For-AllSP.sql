USE POS
GO

/****** Object:  Stored Procedure [pub].[SP_TopCustomers]   Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE   PROC [pub].[SP_TopCustomers] @TopCount INT = 10, @FromDate DATETIME2 = NULL, @EndDate DATETIME2 = NULL  -- Fomrat '1996-07-31'
WITH ENCRYPTION
AS 
BEGIN
  SET NOCOUNT ON
	;WITH t AS (
  SELECT i.InvoiceID
        ,i.CustomerID
        ,i.InvoiceDate AS Last_Invoice
        , COUNT(ii.InvoiceItemID) AS Product_Count, SUM(ii.LineTotal) AS TotalPrice
  FROM finance.Invoices i  JOIN finance.InvoiceItems ii ON i.InvoiceID = ii.InvoiceID
  WHERE (i.InvoiceDate BETWEEN @FromDate AND @EndDate) AND (i.Payment_Status = 2) 
  GROUP BY i.InvoiceID
        ,i.CustomerID
        ,i.InvoiceDate
  ), t2 AS (
  SELECT CustomerID, MAX(Last_Invoice) AS Last_Invoice, SUM(Product_Count) AS Product_Count, SUM(TotalPrice) AS TotalPrice, COUNT(InvoiceID) AS Total_Invoice
  FROM t
  GROUP BY CustomerID)
  SELECT TOP(@TopCount) WITH TIES t2.CustomerID AS CID
        ,c.FullName
        ,Last_Invoice
        ,Product_Count
        ,TotalPrice
        ,Total_Invoice
  FROM t2 JOIN [identity].Customers c ON t2.CustomerID = c.CustomerID
  ORDER BY TotalPrice DESC, Product_Count DESC, Last_Invoice DESC

END 
GO


/****** Object:  Stored Procedure [pub].[SP_ShowStockStatusByCategory]   Script Date: 8/8/2025 10:20:50 AM ******/

CREATE   PROC [pub].[SP_ShowStockStatusByCategory] @Cat INT = NULL, @Min_Stock INT = NULL
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON;

  WITH t AS (
  SELECT p.ProductID
        ,p.ProductName
        ,c.CategoryName
        ,p.Price
        ,p.Stock
  FROM [masterdata].Products p INNER JOIN [masterdata].Category c ON p.CategoryID = c.CategoryID
  WHERE (c.CategoryID = @Cat OR @Cat IS NULL) AND (p.Stock < @Min_Stock OR @Min_Stock IS NULL)
  )
  
  
  SELECT *
        ,CASE 
          WHEN Stock = 0 THEN 'ZERO'
        	WHEN Stock < 20 THEN 'LOW'
        	WHEN Stock BETWEEN 20 AND 50 THEN 'Medium'
          WHEN Stock > 50 THEN 'Available'
        END AS Stock_Status
  FROM t
  ORDER BY Stock_Status ASC, Stock



END
GO

/****** Object:  Stored Procedure [operation].[SP_SoftDeleteCustomer]   Script Date: 8/8/2025 10:20:50 AM ******/

CREATE   PROC [operation].[SP_SoftDeleteCustomer] @CustomerID INT
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON 
  BEGIN TRY
    UPDATE [identity].Customers
    SET IsActive = 0
    WHERE CustomerID = @CustomerID
  END TRY
  BEGIN CATCH
    RAISERROR(N'خطا در حذف مشتری', 16, 1)
    ROLLBACK TRAN
  END CATCH
END
GO

/****** Object:  Stored Procedure [operation].[SP_AddNewCustomer]   Script Date: 8/8/2025 10:20:50 AM ******/

CREATE   PROC [operation].[SP_AddNewCustomer] @FullName NVARCHAR(80), @Phone NVARCHAR(11), @Email NVARCHAR(50), @Address NVARCHAR(100)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

  BEGIN TRY
      BEGIN TRAN
        	
          INSERT INTO [identity].Customers (FullName, Phone, Email, Address, RegisterDate, IsActive)
                      VALUES (@FullName, @Phone, @Email, @Address, SYSDATETIME(), 1);

      COMMIT TRAN
  END TRY
  BEGIN CATCH
      RAISERROR(N'خطا در افزودن مشتری جدید.' , 16, 1)    
      IF XACT_STATE() <> 0 BEGIN
        ROLLBACK TRANSACTION
      END
   END CATCH;
END
GO


/****** Object:  Stored Procedure [operation].[SP_AddInvoice]   Script Date: 8/8/2025 10:20:50 AM ******/

CREATE   PROC [operation].[SP_AddInvoice](@CustomerID INT,
                                   @InvoiceDate DATETIME2, 
                                   @Payment_Status INT,
                                   @PaymentDate DATETIME2,
                                   @InvoiceItems InvoiceItems_TYPE READONLY,
                                   @InvoiceNumber INT OUTPUT)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

  BEGIN TRAN
    
    INSERT INTO finance.Invoices (CustomerID, InvoiceDate, TotalAmount, Payment_Status)
           VALUES (@CustomerID, @InvoiceDate, 0, @Payment_Status);

    SET @InvoiceNumber = SCOPE_IDENTITY()

    INSERT INTO finance.InvoiceItems (InvoiceID, ProductID, Quantity, UnitPrice, Discount, LineTotal)
           SELECT @InvoiceNumber, oi.ProductID, oi.Quantity, oi.UnitPrice, oi.Discount, 0
           FROM @InvoiceItems oi
    
    IF @Payment_Status <> 1 
    BEGIN  
      
      INSERT INTO finance.Payments (InvoiceID, PaymentMethod, PaymentDate, Amount, Description)
            VALUES (@InvoiceNumber, @Payment_Status, SYSDATETIME(), 0, N'');

    END
    

  COMMIT TRAN
END
GO


/****** Object:  Stored Procedure [finance].[SP_GetMonthlyReport]   Script Date: 8/8/2025 10:20:50 AM ******/

CREATE   PROCEDURE [finance].[SP_GetMonthlyReport] @Month INT = NULL, @Year INT = NULL
WITH ENCRYPTION
AS 
BEGIN
	SET NOCOUNT ON

   IF @Year IS NULL
        SET @Year = YEAR(SYSDATETIME())

    IF @Month IS NULL
        SET @Month = MONTH(SYSDATETIME())

  ;WITH t AS (
      SELECT 
          i.InvoiceID,
          i.CustomerID,
          i.InvoiceDate,
          i.TotalAmount,
          pm.PayName AS Payment_Status,
          MONTH(i.InvoiceDate) AS mont,
          YEAR(i.InvoiceDate) AS year
      FROM finance.Invoices i JOIN finance.PaymentMethod pm ON i.Payment_Status = pm.PayID
      WHERE YEAR(i.InvoiceDate) = @Year AND MONTH(i.InvoiceDate) = @Month
  )
  SELECT 
      CASE WHEN GROUPING(t.InvoiceID) = 1 THEN COUNT(DISTINCT t.InvoiceID) ELSE t.InvoiceID END AS InvoiceID,
      t.CustomerID,
      t.InvoiceDate,
      t.TotalAmount,
      t.Payment_Status,
      COUNT(ii.InvoiceItemID) AS InvoiceItems
  FROM t
  INNER JOIN finance.InvoiceItems ii ON t.InvoiceID = ii.InvoiceID
  GROUP BY 
      GROUPING SETS (
          (), 
          (t.InvoiceID, t.CustomerID, t.InvoiceDate, t.TotalAmount, t.Payment_Status)
      )
  ORDER BY
      CASE WHEN GROUPING(t.InvoiceID) = 1 THEN 1 ELSE 0 END,  
      t.InvoiceDate
END

GO
