USE [POS]
GO
/****** Object:  Schema [finance]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SCHEMA [finance]
GO
/****** Object:  Schema [identity]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SCHEMA [identity]
GO
/****** Object:  Schema [masterdata]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SCHEMA [masterdata]
GO
/****** Object:  Schema [operation]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SCHEMA [operation]
GO
/****** Object:  Schema [pub]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SCHEMA [pub]
GO
/****** Object:  UserDefinedTableType [dbo].[InvoiceItems_TYPE]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE TYPE [dbo].[InvoiceItems_TYPE] AS TABLE(
	[InvoiceID] [int] NULL,
	[ProductID] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](38, 2) NULL,
	[Discount] [decimal](3, 2) NULL,
	[LineTotal] [decimal](38, 2) NULL
)
GO
/****** Object:  Synonym [dbo].[Category]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[Category] FOR [masterdata].[Invoices]
GO
/****** Object:  Synonym [dbo].[Customers]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[Customers] FOR [identity].[Invoices]
GO
/****** Object:  Synonym [dbo].[InvoiceItems]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[InvoiceItems] FOR [finance].[Invoices]
GO
/****** Object:  Synonym [dbo].[Invoices]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[Invoices] FOR [finance].[Invoices]
GO
/****** Object:  Synonym [dbo].[PaymentMethod]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[PaymentMethod] FOR [finance].[Invoices]
GO
/****** Object:  Synonym [dbo].[Payments]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[Payments] FOR [finance].[Invoices]
GO
/****** Object:  Synonym [dbo].[Products]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[Products] FOR [masterdata].[Invoices]
GO
/****** Object:  Synonym [dbo].[SP_AddInvoice]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[SP_AddInvoice] FOR [operation].[SP_AddInvoice]
GO
/****** Object:  Synonym [dbo].[SP_AddNewCustomer]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[SP_AddNewCustomer] FOR [operation].[SP_AddNewCustomer]
GO
/****** Object:  Synonym [dbo].[SP_GetMonthlyRepor]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[SP_GetMonthlyRepor] FOR [finance].[SP_GetMonthlyRepor]
GO
/****** Object:  Synonym [dbo].[SP_ShowStockStatusByCategory]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[SP_ShowStockStatusByCategory] FOR [pub].[SP_ShowStockStatusByCategory]
GO
/****** Object:  Synonym [dbo].[SP_SoftDeleteCustomer]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[SP_SoftDeleteCustomer] FOR [operation].[SP_SoftDeleteCustomer]
GO
/****** Object:  Synonym [dbo].[SP_TopCustomers]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[SP_TopCustomers] FOR [pub].[SP_TopCustomers]
GO
/****** Object:  Synonym [dbo].[V_SalesPerMonthEveryYear]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[V_SalesPerMonthEveryYear] FOR [finance].[V_SalesPerMonthEveryYear]
GO
/****** Object:  Synonym [dbo].[V_UnpaidInvoices]    Script Date: 8/8/2025 10:20:50 AM ******/
CREATE SYNONYM [dbo].[V_UnpaidInvoices] FOR [pub].[V_UnpaidInvoices]
GO
/****** Object:  Table [finance].[Invoices]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [finance].[Invoices](
	[InvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[InvoiceDate] [datetime2](7) NOT NULL,
	[TotalAmount] [decimal](38, 2) NOT NULL,
	[Payment_Status] [int] NOT NULL,
 CONSTRAINT [PK_InvoiceID] PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO
/****** Object:  Table [finance].[InvoiceItems]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [finance].[InvoiceItems](
	[InvoiceItemID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](38, 2) NOT NULL,
	[Discount] [decimal](3, 2) NOT NULL,
	[LineTotal] [decimal](38, 2) NOT NULL,
 CONSTRAINT [PK_InvoiceItemID] PRIMARY KEY CLUSTERED 
(
	[InvoiceItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_SalesPerformanceByMonth]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_SalesPerformanceByMonth] (@Year INT)
RETURNS TABLE
AS
RETURN (

    WITH Months AS (
        SELECT 1 AS [Month] UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
        UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
    ),
    AmountData AS (
        SELECT 
            YEAR(InvoiceDate) AS [Year],
            MONTH(InvoiceDate) AS [Month],
            SUM(TotalAmount) AS [TotalAmount]
        FROM finance.Invoices
        WHERE Payment_Status = 2 AND YEAR(InvoiceDate) = @Year
        GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
    ),
    QuantityData AS (
        SELECT 
            YEAR(i.InvoiceDate) AS [Year],
            MONTH(i.InvoiceDate) AS [Month],
            SUM(ii.Quantity) AS [total_Quantity],
            COUNT(DISTINCT i.InvoiceID) AS [total_Invoice]
        FROM finance.Invoices i 
        JOIN finance.InvoiceItems ii ON i.InvoiceID = ii.InvoiceID
        WHERE i.Payment_Status = 2 AND YEAR(i.InvoiceDate) = @Year
        GROUP BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)
    )
    
    SELECT 
        ISNULL(a.Year , @Year) AS [Year],
        m.[Month],
        ISNULL(a.[TotalAmount], 0) AS [TotalAmount],
        ISNULL(q.[total_Quantity], 0) AS [total_Quantity],
        ISNULL(q.[total_Invoice], 0) AS [total_Invoice]
    FROM Months m
    LEFT JOIN AmountData a ON a.[Month] = m.[Month]
    LEFT JOIN QuantityData q ON q.[Month] = m.[Month]

);

GO
/****** Object:  Table [identity].[Customers]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [identity].[Customers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](80) NOT NULL,
	[Phone] [nvarchar](11) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](100) NOT NULL,
	[RegisterDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_CustomerID] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO
/****** Object:  Table [finance].[PaymentMethod]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [finance].[PaymentMethod](
	[PayID] [int] IDENTITY(1,1) NOT NULL,
	[PayName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PayID] PRIMARY KEY CLUSTERED 
(
	[PayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO
/****** Object:  View [pub].[V_UnpaidInvoices]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [pub].[V_UnpaidInvoices] AS
SELECT c.CustomerID, c.FullName, c.Phone, i.InvoiceID AS Invoice, i.InvoiceDate AS Date, i.TotalAmount, pm.PayName AS PayStatus
FROM finance.Invoices i          JOIN [identity].Customers c 
  ON i.CustomerID = c.CustomerID JOIN finance.PaymentMethod pm 
  ON i.Payment_Status = pm.PayID
WHERE i.Payment_Status = 1
GO
/****** Object:  View [finance].[V_SalesPerMonthEveryYear]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [finance].[V_SalesPerMonthEveryYear] 
AS 
SELECT PivotedData.year
      ,ISNULL(PivotedData.[1] , 0) AS [January]
      ,ISNULL(PivotedData.[2] , 0) as [February]
      ,ISNULL(PivotedData.[3] , 0) as [March]
      ,ISNULL(PivotedData.[4] , 0) as [April]
      ,ISNULL(PivotedData.[5] , 0) as [May]
      ,ISNULL(PivotedData.[6] , 0) as [June]
      ,ISNULL(PivotedData.[7] , 0) as [July]
      ,ISNULL(PivotedData.[8] , 0) as [August]
      ,ISNULL(PivotedData.[9] , 0) as [September]
      ,ISNULL(PivotedData.[10], 0) as [October]
      ,ISNULL(PivotedData.[11], 0) as [November]
      ,ISNULL(PivotedData.[12], 0) as [December]
FROM (
    SELECT 
        YEAR(InvoiceDate) AS year,
        MONTH(InvoiceDate) AS month,
        SUM(TotalAmount) AS TotalAmount
    FROM dbo.Invoices
    WHERE Payment_Status = 2
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
) AS RawData
PIVOT (
    SUM(TotalAmount)
    FOR month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS PivotedData

GO
/****** Object:  Table [finance].[Payments]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [finance].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[PaymentDate] [datetime2](7) NOT NULL,
	[Amount] [decimal](38, 2) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_PaymentID] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO
/****** Object:  Table [masterdata].[Category]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [masterdata].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_CategoryID] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO
/****** Object:  Table [masterdata].[Products]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [masterdata].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[Stock] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ProductID] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO
ALTER TABLE [finance].[InvoiceItems]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceID_Invoices] FOREIGN KEY([InvoiceID])
REFERENCES [finance].[Invoices] ([InvoiceID])
GO
ALTER TABLE [finance].[InvoiceItems] CHECK CONSTRAINT [FK_InvoiceID_Invoices]
GO
ALTER TABLE [finance].[InvoiceItems]  WITH CHECK ADD  CONSTRAINT [FK_ProductID_Products] FOREIGN KEY([ProductID])
REFERENCES [masterdata].[Products] ([ProductID])
GO
ALTER TABLE [finance].[InvoiceItems] CHECK CONSTRAINT [FK_ProductID_Products]
GO
ALTER TABLE [finance].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_CustomerID_Customer] FOREIGN KEY([CustomerID])
REFERENCES [identity].[Customers] ([CustomerID])
GO
ALTER TABLE [finance].[Invoices] CHECK CONSTRAINT [FK_CustomerID_Customer]
GO
ALTER TABLE [finance].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_PaymentStatus_PaymentMethod] FOREIGN KEY([Payment_Status])
REFERENCES [finance].[PaymentMethod] ([PayID])
GO
ALTER TABLE [finance].[Invoices] CHECK CONSTRAINT [FK_PaymentStatus_PaymentMethod]
GO
ALTER TABLE [finance].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_PaymentMethod_PaymentMethod] FOREIGN KEY([PaymentMethod])
REFERENCES [finance].[PaymentMethod] ([PayID])
GO
ALTER TABLE [finance].[Payments] CHECK CONSTRAINT [FK_PaymentMethod_PaymentMethod]
GO
ALTER TABLE [finance].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_PaymentsInvoiceID_Invoices] FOREIGN KEY([InvoiceID])
REFERENCES [finance].[Invoices] ([InvoiceID])
GO
ALTER TABLE [finance].[Payments] CHECK CONSTRAINT [FK_PaymentsInvoiceID_Invoices]
GO
ALTER TABLE [masterdata].[Products]  WITH CHECK ADD  CONSTRAINT [FK_CategoryID_Category] FOREIGN KEY([CategoryID])
REFERENCES [masterdata].[Category] ([CategoryID])
GO
ALTER TABLE [masterdata].[Products] CHECK CONSTRAINT [FK_CategoryID_Category]
GO
ALTER TABLE [masterdata].[Products]  WITH CHECK ADD  CONSTRAINT [CheckStockProducts] CHECK  (([Stock]>=(0)))
GO
ALTER TABLE [masterdata].[Products] CHECK CONSTRAINT [CheckStockProducts]
GO
/****** Object:  Trigger [finance].[tr_CalculateLineTotal]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [finance].[tr_CalculateLineTotal] ON [finance].[InvoiceItems]
AFTER INSERT, UPDATE
AS 
BEGIN
	  SET NOCOUNT ON
    
      UPDATE InvoiceItems 
      SET LineTotal = CAST((Quantity * UnitPrice) - ((Quantity * UnitPrice) * Discount) AS DECIMAL(38,2))
      WHERE InvoiceItemID IN (SELECT InvoiceItemID FROM INSERTED)


      UPDATE inv
      SET inv.TotalAmount = subq.TotalPrice
      FROM Invoices inv
      INNER JOIN (
          SELECT InvoiceID, SUM(ii.LineTotal) AS TotalPrice
          FROM finance.InvoiceItems ii
          WHERE InvoiceID IN (SELECT DISTINCT InvoiceID FROM inserted)
          GROUP BY InvoiceID
      ) subq ON inv.InvoiceID = subq.InvoiceID;

END

GO
ALTER TABLE [finance].[InvoiceItems] ENABLE TRIGGER [tr_CalculateLineTotal]
GO
/****** Object:  Trigger [finance].[tr_CalculateLineTotalDelete]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [finance].[tr_CalculateLineTotalDelete] ON [finance].[InvoiceItems]
AFTER DELETE
AS 
BEGIN
	  SET NOCOUNT ON

      UPDATE inv
      SET inv.TotalAmount = subq.TotalPrice
      FROM Invoices inv
      INNER JOIN (
          SELECT InvoiceID, SUM(ii.LineTotal) AS TotalPrice
          FROM InvoiceItems ii
          WHERE InvoiceID IN (SELECT DISTINCT InvoiceID FROM DELETED)
          GROUP BY InvoiceID
      ) subq ON inv.InvoiceID = subq.InvoiceID;

END

GO
ALTER TABLE [finance].[InvoiceItems] ENABLE TRIGGER [tr_CalculateLineTotalDelete]
GO
/****** Object:  Trigger [finance].[tr_UpdateStock]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [finance].[tr_UpdateStock] ON [finance].[InvoiceItems]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	
  SET NOCOUNT ON 

  IF EXISTS (SELECT * FROM DELETED)
  BEGIN
  	  UPDATE Products
      SET Stock = Stock + del.Quantity
      FROM (SELECT * FROM DELETED) del 
      WHERE del.ProductID = Products.ProductID
  END
  
  IF EXISTS (SELECT * FROM INSERTED)
  BEGIN
  	  UPDATE Products
      SET Stock = Stock - ins.Quantity
      FROM (SELECT * FROM INSERTED) ins 
      WHERE ins.ProductID = Products.ProductID
  END


END
GO
ALTER TABLE [finance].[InvoiceItems] ENABLE TRIGGER [tr_UpdateStock]
GO
/****** Object:  Trigger [finance].[tr_UpdateAmount]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [finance].[tr_UpdateAmount] ON [finance].[Payments] 
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

  UPDATE Payments
  SET Amount = i.TotalAmount
  FROM Invoices i JOIN (SELECT * FROM INSERTED) ins ON ins.InvoiceID = i.InvoiceID
  WHERE Payments.InvoiceID = ins.InvoiceID

END
GO
ALTER TABLE [finance].[Payments] ENABLE TRIGGER [tr_UpdateAmount]
GO
/****** Object:  Trigger [identity].[tr_AuthDuplicateCustomer]    Script Date: 8/8/2025 10:20:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [identity].[tr_AuthDuplicateCustomer] 
ON [identity].[Customers]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN Customers c 
          ON c.Phone = i.Phone AND c.FullName = i.FullName
          WHERE c.CustomerID <> i.CustomerID 
    )
    BEGIN  
        RAISERROR(N'کاربر قبلا در لیست است.', 16, 1);
        ROLLBACK;
    END
END
GO
ALTER TABLE [identity].[Customers] ENABLE TRIGGER [tr_AuthDuplicateCustomer]
GO
