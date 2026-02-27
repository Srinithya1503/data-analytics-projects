/*========================================================
 PHASE 1: Employee Management System
========================================================*/

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'EmployeeDB')
    CREATE DATABASE EmployeeDB;
GO

USE EmployeeDB;
GO

-- Drop tables safely
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- Departments table
CREATE TABLE dbo.Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- Employees table
CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName  NVARCHAR(50) NOT NULL,
    Email     NVARCHAR(100) NOT NULL UNIQUE,
    DepartmentID INT NOT NULL,
    Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0),

    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Departments(DepartmentID)
);
GO

-- Insert Departments
INSERT INTO dbo.Departments (DepartmentName)
VALUES ('Human Resources'), ('IT'), ('Sales'), ('Marketing');
GO

-- Insert Employees
INSERT INTO dbo.Employees
(FirstName, LastName, Email, DepartmentID, Salary)
VALUES
('Alice','Johnson','alice.johnson@example.com',1,70000),
('Bob','Smith','bob.smith@example.com',2,80000),
('Charlie','Brown','charlie.brown@example.com',3,60000),
('David','Wilson','david.wilson@example.com',2,75000),
('Eva','Clark','eva.clark@example.com',4,55000);
GO

-- Subquery: Above average salary
SELECT FirstName, LastName, Salary
FROM dbo.Employees
WHERE Salary > (SELECT AVG(Salary) FROM dbo.Employees);
GO

-- Subquery: Employees in IT department
SELECT FirstName, LastName
FROM dbo.Employees
WHERE DepartmentID =
      (SELECT DepartmentID FROM dbo.Departments WHERE DepartmentName = 'IT');
GO

-- Scalar function
CREATE OR ALTER FUNCTION dbo.GetFullName (@EmployeeID INT)
RETURNS NVARCHAR(101)
AS
BEGIN
    DECLARE @Name NVARCHAR(101);
    SELECT @Name = FirstName + ' ' + LastName
    FROM dbo.Employees
    WHERE EmployeeID = @EmployeeID;
    RETURN @Name;
END;
GO

-- Function usage
SELECT dbo.GetFullName(EmployeeID) AS FullName, Salary
FROM dbo.Employees;
GO
