/*========================================================
 PHASE 3: Access Management – ECommerceDB
========================================================*/

USE master;
GO

-- Server roles
ALTER SERVER ROLE serveradmin ADD MEMBER [AdminUser];
ALTER SERVER ROLE securityadmin ADD MEMBER [AdminUser];
GO

USE ECommerceDB;
GO

-- Developer access
ALTER ROLE db_ddladmin ADD MEMBER [DevUser];
GO

-- BI Read-only role
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'BI_ReadOnly')
    CREATE ROLE BI_ReadOnly;
GO

GRANT SELECT ON dbo.Products  TO BI_ReadOnly;
GRANT SELECT ON dbo.Orders    TO BI_ReadOnly;
GRANT SELECT ON dbo.Customers TO BI_ReadOnly;

ALTER ROLE BI_ReadOnly ADD MEMBER [BIUser];
GO

-- Support Read-only role
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Support_ReadOnly')
    CREATE ROLE Support_ReadOnly;
GO

GRANT SELECT ON dbo.Customers TO Support_ReadOnly;
ALTER ROLE Support_ReadOnly ADD MEMBER [SupportUser];
GO
