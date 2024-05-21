--*************************************************************************--
-- Title: Assignment06
-- Author: CateB
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2024-05-16,CateB,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_CateB')
	 Begin 
	  Alter Database [Assignment06DB_CateB] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_CateB;
	 End
	Create Database Assignment06DB_CateB;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_CateB;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!

--Create Drop Views
--Go
--Drop View vCategories 
--Go

--Go
--Drop View vEmployees 
--Go

--Go
--Drop View vInventories 
--Go

--Go
--Drop View vProducts 
--Go

--Create Views
Go
Create View vCategories 
With SchemaBinding
As
Select
 [CategoryID],
 [CategoryName] 
From [dbo].[Categories]
Go

Go
Create View vEmployees
With SchemaBinding
 As
Select 
 [EmployeeID],
 [EmployeeFirstName],
 [EmployeeLastName],
 [ManagerID] 
From [dbo].[Employees]
Go

Go
Create View vInventories 
With SchemaBinding
 As
Select  
 [InventoryID],
 [InventoryDate],
 [EmployeeID],[ProductID],
 [Count] 
From [dbo].[Inventories]
Go

Go
Create View vProducts 
With SchemaBinding
 As
Select 
 [ProductID],
 [ProductName],
 [CategoryID],
 [UnitPrice] 
From [dbo].[Products]
Go
  
--Create Select all
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

--Create Views
--Go
--Create View 
-- vCategories 
--As
--Select
-- [CategoryID] ,
-- [CategoryName] 
--From 
-- Categories
--Go

--Go
--Create View 
-- vEmployees 
--As
--Select 
-- [EmployeeID],
-- [EmployeeFirstName],
-- [EmployeeLastName],
-- [ManagerID] 
-- From 
-- Employees
--Go

--Go
--Create View 
-- vInventories 
--As
--Select 
-- [InventoryID],
-- [InventoryDate],
-- [EmployeeID],[ProductID],
-- [Count]
--From 
-- Inventories
--Go

--Go
--Create View 
-- vProducts 
--As
--Select 
-- [ProductID],
-- [ProductName],
-- [CategoryID],
-- [UnitPrice] 
-- From 
--  Products
--Go

--Create Permissions

Deny Select On Categories to Public
Deny Select On Employees to Public
Deny Select On Inventories to Public
Deny Select On Products to Public
Go

Grant Select On vCategories to Public 
Grant Select On vEmployees to Public
Grant Select On vInventories to Public
Grant Select On vProducts to Public
Go

----Create Select all
--Select * From [dbo].[vCategories]
--Select * From [dbo].[vProducts]
--Select * From [dbo].[vInventories]
--Select * From [dbo].[vEmployees]



-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

----Select Data
--Select 
-- CategoryName, 
-- ProductName, 
-- UnitPrice 
--From Categories
-- Join Products
--  on Categories.CategoryID = Products.CategoryID
--Order By 
-- CategoryName ASC,
-- ProductName
--Go

--Create Drop View
--Drop View [dbo].[vProductsByCategories]
--Go

--Create View
Go
Create View 
 [dbo].[vProductsByCategories]
As
Select Top 1000000
 CategoryName, 
 ProductName, 
 UnitPrice 
From vCategories
 Join vProducts
  on vCategories.CategoryID = vProducts.CategoryID
Order By 
 CategoryName ASC,
 ProductName
Go

--Create Select all
--Select * From [dbo].[vProductsByCategories]  
--Go



-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

--Select Data
--Select 
-- ProductName,
-- InventoryDate, 
-- Count
--From vProducts
-- Join vInventories 
--  on vProducts.ProductID = vInventories.ProductID 
--Order By
-- ProductName ASC,
-- InventoryDate,
-- Count
-- Go

--Create Drop View
--Drop View [dbo].[vInventoriesByProductsByDates]
--Go

--Create View
Go
Create View 
 [dbo].[vInventoriesByProductsByDates]
As
Select Top 1000000 
 ProductName,
 InventoryDate, 
 Count
From vProducts
 Join vInventories 
  on vProducts.ProductID = vInventories.ProductID 
Order By
 ProductName ASC,
 InventoryDate,
 Count
 Go

 --Create Select all
--Select * From [dbo].[vInventoriesByProductsByDates]
--Go



-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

--Select Data
--Select Distinct  
-- InventoryDate, 
-- [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
--From vInventories
-- Join vEmployees
--  on vinventories.EmployeeID = vEmployees.EmployeeID
--Group By 
-- InventoryDate, 
-- EmployeeFirstName + ' ' + EmployeeLastName
-- Go


--Create Drop View 
--Drop View [dbo].[vInventoriesByEmployeesByDates]
--Go

--Create View
Go
Create View 
 [dbo].[vInventoriesByEmployeesByDates]
As
Select Distinct Top 100000 
 InventoryDate, 
 [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From vInventories
 Join vEmployees
  on vinventories.EmployeeID = vEmployees.EmployeeID
Group By 
 InventoryDate, 
 EmployeeFirstName + ' ' + EmployeeLastName
 Go

--Create Select all
--Select * From [dbo].[vInventoriesByEmployeesByDates]
--Go



-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

--Select Data
--Select 
-- CategoryName, 
-- ProductName, 
-- InventoryDate, 
-- Count
--From vInventories
-- Join vEmployees 
--  on vInventories.EmployeeID = vEmployees.EmployeeID
--  Join vProducts
--  on vInventories.ProductID = vProducts.ProductID
-- Join vCategories 
--  on vProducts.CategoryID = vCategories.CategoryID
--Order By 
-- CategoryName, 
-- ProductName, 
-- InventoryDate, 
-- Count
-- Go


--Create Drop View 
--Drop View [dbo].[vInventoriesByProductsByCategories]
--Go

--Create View
Go
Create View 
 [dbo].[vInventoriesByProductsByCategories]
As
Select Top 100000
 CategoryName, 
 ProductName, 
 InventoryDate, 
 Count
From vInventories
 Join vEmployees 
  on vInventories.EmployeeID = vEmployees.EmployeeID
  Join vProducts
  on vInventories.ProductID = vProducts.ProductID
 Join vCategories 
  on vProducts.CategoryID = vCategories.CategoryID
Order By 
 CategoryName, 
 ProductName, 
 InventoryDate, 
 Count
 Go

 --Create Select all
--Select * From [dbo].[vInventoriesByProductsByCategories]
--Go





-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

--Select Data
--Select 
-- CategoryName,
-- ProductName,
-- InventoryDate, 
-- Count,
-- EmployeeFirstName + ' ' + EmployeeLastName as EmployeeName
--From vInventories 
-- Inner Join vEmployees 
--  on vInventories.EmployeeID = vEmployees.EmployeeID
-- Inner Join vProducts 
--  on vInventories.ProductID = vProducts.ProductID
-- Inner Join vCategories 
--  on vProducts.CategoryID = vCategories.CategoryID
--Order By 
-- InventoryDate, 
-- CategoryName, 
-- ProductName, 
-- EmployeeName
--Go


--Create Drop Veiw
--Drop View [dbo].[vInventoriesByProductsByEmployees]
--Go

--Create View
Go
Create View 
 [dbo].[vInventoriesByProductsByEmployees]
As
Select Top 100000
 CategoryName,
 ProductName,
 InventoryDate, 
 Count,
 EmployeeFirstName + ' ' + EmployeeLastName as EmployeeName
From vInventories 
 Inner Join vEmployees 
  on vInventories.EmployeeID = vEmployees.EmployeeID
 Inner Join vProducts 
  on vInventories.ProductID = vProducts.ProductID
 Inner Join vCategories 
  on vProducts.CategoryID = vCategories.CategoryID
Order By 
 InventoryDate, 
 CategoryName, 
 ProductName, 
 EmployeeName
Go

--Create Select all
 --Select * From [dbo].[vInventoriesByProductsByEmployees]
 --Go



-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

--Select Data
--Select 
-- CategoryName,
-- ProductName,
-- InventoryDate, 
-- Count,
-- EmployeeFirstName + ' ' + EmployeeLastName as EmployeeName
--From vInventories 
-- Inner Join vEmployees 
--  on vInventories.EmployeeID = vEmployees.EmployeeID
-- Inner Join vProducts 
--  on vInventories.ProductID = vProducts.ProductID
-- Inner Join vCategories 
--  on vProducts.CategoryID = vCategories.CategoryID
--Where vInventories.ProductID In (Select ProductID From vProducts Where ProductName In ( 'Chai', 'Chang'))
--Order By  
-- InventoryDate, 
-- ProductName, 
-- EmployeeName
--Go

--Create Drop View
--Drop View [dbo].[vInventoriesForChaiAndChangByEmployees]
--Go

--Create View
Go
Create View 
 [dbo].[vInventoriesForChaiAndChangByEmployees]
As
Select Top 100000
 CategoryName,
 ProductName,
 InventoryDate, 
 Count,
 EmployeeFirstName + ' ' + EmployeeLastName as EmployeeName
From vInventories 
 Inner Join vEmployees 
  on vInventories.EmployeeID = vEmployees.EmployeeID
 Inner Join vProducts 
  on vInventories.ProductID = vProducts.ProductID
 Inner Join vCategories 
  on vProducts.CategoryID = vCategories.CategoryID
Where vInventories.ProductID In (Select ProductID From vProducts Where ProductName In ( 'Chai', 'Chang'))
Order By  
 InventoryDate, 
 ProductName, 
 EmployeeName
Go

--Create Select all
 --Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
 --Go



-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

--Select Data
--Select 
-- Man.EmployeeFirstName + ' ' + Man.EmployeeLastName as ManagerName,
-- Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName as EmployeeName
--From vEmployees as Emp 
-- Join vEmployees as Man
--    on Emp.ManagerID = Man.EmployeeID  
--Order By  
--  ManagerName ASC,
--  EmployeeName
--Go



--Create Drop View
--Drop View [dbo].[vEmployeesByManager]
--Go

--Create View
Go
Create View 
 [dbo].[vEmployeesByManager]
As
Select Top 100000 
 Man.EmployeeFirstName + ' ' + Man.EmployeeLastName as ManagerName,
 Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName as EmployeeName
From vEmployees as Emp 
 Join vEmployees as Man
    on Emp.ManagerID = Man.EmployeeID  
Order By  
  ManagerName ASC,
  EmployeeName
Go

--Create Select all
--Select * From [dbo].[vEmployeesByManager]
--Go



-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.

--Select Data 

--SELECT 
--vCategories.CategoryID, 
--vCategories.CategoryName, 
--vProducts.ProductID, 
--vProducts.ProductName, 
--vProducts.UnitPrice,
--vInventories.InventoryID,
--vInventories.InventoryDate,
--vInventories.Count,
--vEmployees.EmployeeID, 
--vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName as EmployeeName,
--Man.EmployeeFirstName + ' ' + Man.EmployeeLastName as ManagerName
--FROM   
--dbo.vCategories 
--INNER JOIN vProducts
--ON vProducts.CategoryID = vCategories.CategoryID
--INNER JOIN vInventories 
--ON vProducts.ProductID = vInventories.ProductID 
--INNER JOIN vEmployees 
--ON vInventories.EmployeeID = vEmployees.EmployeeID
-- INNER JOIN     
-- vEmployees as Man
--    on vEmployees.ManagerID = Man.EmployeeID 
--Order By
-- CategoryID, ProductID, InventoryID



--Drop View [dbo].[vInventoriesByProductsByCategoriesByEmployees]
--Go

Go
Create View 
 [dbo].[vInventoriesByProductsByCategoriesByEmployees]
As
Select Top 100000 
vCategories.CategoryID, 
vCategories.CategoryName, 
vProducts.ProductID, 
vProducts.ProductName, 
vProducts.UnitPrice,
vInventories.InventoryID,
vInventories.InventoryDate,
vInventories.Count,
vEmployees.EmployeeID, 
vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName as EmployeeName,
Man.EmployeeFirstName + ' ' + Man.EmployeeLastName as ManagerName
FROM   
dbo.vCategories 
INNER JOIN vProducts
ON vProducts.CategoryID = vCategories.CategoryID
INNER JOIN vInventories 
ON vProducts.ProductID = vInventories.ProductID 
INNER JOIN vEmployees 
ON vInventories.EmployeeID = vEmployees.EmployeeID
 INNER JOIN     
 vEmployees as Man
    on vEmployees.ManagerID = Man.EmployeeID 
Order By
 CategoryID, ProductID, InventoryID
Go




--Create Select all
--Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]
--Go

-- Test your Views (NOTE: You must change the your view names to match what I have below!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/