USE NGODB
GO
--=====================Store Procedure for Project table
--Insert Procedure
DECLARE @pid INT
EXEC spInsertProject 'Website Development','Rakib',20000.00, @pid OUTPUT
SELECT @pid
EXEC spInsertProject 'Website Design','Sakib',20000.00, @pid OUTPUT
SELECT @pid
EXEC spInsertProject 'Social Development','Rashed',200000.00, @pid OUTPUT
SELECT @pid
SELECT * FROM projects
GO

--update procedure
EXEC spUpdateProject @id=1,@pname ='Data Analysis', @m='Mahin', @b=30000.00
GO
SELECT * FROM projects
GO
--Delete Procedure
EXEC spDeleteProject 1
GO

--===================== Store Procedure for department===============
--Insert procedure
DECLARE @depid INT
EXEC spDepInsert 'Account', @depid OUTPUT
SELECT @depid
EXEC spDepInsert 'Audit', @depid OUTPUT
SELECT @depid
EXEC spDepInsert 'Marketting', @depid OUTPUT
SELECT @depid
SELECT * FROM department
GO
--update procedure
EXEC spUpdateDep @id=1,@depname='HR'
GO
SELECT * FROM department
GO
--delete procedure for  department
EXEC spDeleteDep 1
GO
SELECT * FROM department

--==================Store Procedure for employeelist=====================
--store procedure
DECLARE @empid INT
EXEC spInsertEmp 'Rakib',2,2,2000.00, @empid OUTPUT
SELECT @empid
EXEC spInsertEmp 'Rahim',2,2,2000.00, @empid OUTPUT
SELECT @empid
EXEC spInsertEmp 'Karim',2,2,2000.00, @empid OUTPUT
SELECT @empid
SELECT * FROM employeeList

--update procedure
EXEC spUpdateEmp @id=1,@ename='Fahim',@pid=2,@depid=2,@payrate=1000.00
GO
SELECT * FROM employeeList

--delete procedure
EXEC spDeleteEmp 1
GO

--=============================View and Function==========================
--NGO profile view using view
SELECT * FROM viewNGOProfile

--Project Data using funciton
SELECT * FROM fnProjectData('Website Development')

--=================================Trigger=================================

--=====Project=======
--Insert Trigger
INSERT INTO projects VALUES(5,'Water',  'Rashedul', 200.00)
--Delete Trigger
DELETE FROM projects
WHERE projectid= 1
GO


--====Department======
--insert trigger
INSERT INTO department VALUES(6,'Accountt')

--delete trigger
DELETE FROM department
WHERE [departmentname]= 'Account'
GO
DELETE FROM department
WHERE departmentid= 1
GO

GO
USE master
GO
DROP DATABASE NGODB
GO

