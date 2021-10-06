CREATE DATABASE NGODB
GO
USE NGODB
GO
--department table
CREATE TABLE department(
 departmentid  INT PRIMARY KEY,
 departmentname NVARCHAR(30)
)
GO
--projects table
CREATE TABLE projects(
projectid INT PRIMARY KEY,
projectname NVARCHAR(30),
manager NVARCHAR(30),
budget  MONEY
)
GO
--employeelist table
CREATE TABLE employeeList(
employeeid INT PRIMARY KEY,
employeename NVARCHAR(30),
projectid INT REFERENCES projects(projectid),
departmentid INT REFERENCES department(departmentid),
payrate MONEY
)
GO
--Create VIEW
CREATE VIEW viewNGOProfile
AS
SELECT P.projectid, P.projectname, D.departmentname
FROM projects P						--Table1
INNER JOIN employeeList El			--Table2
	ON P.projectid=El.projectid
INNER JOIN department D			--Table3
	ON D.departmentid=El.departmentid
GO

--User Defined Function(UDF)
CREATE FUNCTION fnProjectData (@projectname NVARCHAR(40)) RETURNS TABLE
AS
RETURN
(
	SELECT P.projectid, P.manager, P.projectname, P.budget, D.departmentid, D.departmentname, El.employeeid,El.employeename
	FROM projects P					--Table1
	INNER JOIN employeeList El		--Table2
		ON P.projectid=El.projectid
	INNER JOIN department D		--Table3
		ON D.departmentid=El.departmentid
	WHERE P.projectname= @projectname
)
GO


---(UDF)Scalar Function
CREATE FUNCTION fnScalar(@projectid INT ) RETURNS INT
AS
	BEGIN
		DECLARE @n INT 
		SELECT @n = COUNT(*) FROM projects
		WHERE projectid =@projectid
		RETURN @n
	END
GO

GO
--=====================================================project================================
--Insert Procedure
CREATE PROC spInsertProject @pname NVARCHAR(30), 
					@m NVARCHAR(30), 
					@b MONEY, 
					@id INT OUTPUT
AS

SELECT @id = ISNULL(MAX(projectid), 0) +1 FROM projects

BEGIN TRY
	
	INSERT INTO projects VALUES(@id,@pname,  @m, @b)
	
END TRY
BEGIN CATCH
	RAISERROR ('Insert failed', 11, 1)
	RETURN
END CATCH
GO



--Update Procedure
CREATE PROC spUpdateProject @pname NVARCHAR(30), 
					@m NVARCHAR(30), 
					@b MONEY, 
					@id INT OUTPUT
					
AS
BEGIN TRY
	UPDATE projects SET projectname=@pname, [manager]= @m, budget=@b
	WHERE projectid = @id
	
END TRY
BEGIN CATCH
	;
	THROW 50002, 'Update failed',  1
	
END CATCH
GO


--Delete Procedure
CREATE PROC spDeleteProject @id INT					
AS
BEGIN TRY
	DELETE projects
	WHERE projectid = @id
	
END TRY
BEGIN CATCH
	;
	THROW 50003, 'DELETE failed',  1
END CATCH
GO


--Insert Trigger
CREATE TRIGGER TriProject
ON projects FOR INSERT
AS
BEGIN
	DECLARE @m NVARCHAR(30)
	SELECT @m = manager FROM inserted
	IF EXISTS (SELECT 1 FROM projects WHERE manager = @m)
	BEGIN
		ROLLBACK TRANSACTION
		;
		THROW 50001, 'Manager already assigned to another project.', 1
	END
END
GO
SELECT * FROM projects

--Delete Trigger
GO
CREATE TRIGGER trDel
ON projects
AFTER DELETE
AS
BEGIN 
	IF @@ROWCOUNT > 1
	BEGIN
		PRINT 'Cannot delete more than 1 at a time'
		ROLLBACK TRAN
	END
END
GO



-- =====================================================department================================
--Insert Procedure
CREATE PROC spDepInsert @depname NVARCHAR(30),  
					@id INT OUTPUT
AS

SELECT @id = ISNULL(MAX(departmentid), 0) +1 FROM department

BEGIN TRY
	
	INSERT INTO department VALUES(@id,@depname)
	
END TRY
BEGIN CATCH
	RAISERROR ('Insert failed', 11, 1)
	RETURN
END CATCH
GO



--Update Procedure
CREATE PROC spUpdateDep @depname NVARCHAR(30),  
					@id INT OUTPUT
					
AS
BEGIN TRY
	UPDATE department SET departmentname=@depname
	WHERE departmentid = @id
	
END TRY
BEGIN CATCH
	;
	THROW 50002, 'Update failed',  1
	
END CATCH
GO


--Delete Procedure
CREATE PROC spDeleteDep @id INT					
AS
BEGIN TRY
	DELETE department
	WHERE departmentid = @id
	
END TRY
BEGIN CATCH
	;
	THROW 50003, 'DELETE failed',  1
	
END CATCH
GO



--Insert Trigger
CREATE TRIGGER TriDep 
ON department
FOR INSERT
AS
BEGIN
	DECLARE @dname NVARCHAR(30)
	SELECT @dname=[departmentname] FROM inserted 
	IF EXISTS (SELECT 1 FROM department WHERE departmentname = @dname)
	BEGIN
		RAISERROR( 'Invalid format', 11, 1)
		ROLLBACK TRAN
		ROLLBACK TRANSACTION
		;
		THROW 50001, 'Manager already assigned to another project.', 1
	
	END
END
GO



--Delete Trigger
GO
CREATE TRIGGER trDepDel
ON department
AFTER DELETE
AS
BEGIN 
	IF @@ROWCOUNT > 1
	BEGIN
		PRINT 'Cannot delete more than 1 at a time'
		ROLLBACK TRAN
	END
END
GO




--============================================employeeList=================================
--Store Procedure 

CREATE PROC spInsertEmp @ename NVARCHAR(30), 
					@pid NVARCHAR(30), 
					@depid MONEY, 
					@payrate MONEY, 
					@id INT OUTPUT
AS

SELECT @id = ISNULL(MAX(employeeid), 0) +1 FROM employeeList

BEGIN TRY
	
	INSERT INTO employeeList VALUES(@id,@ename,  @depid, @pid,@payrate)
	
END TRY
BEGIN CATCH
	RAISERROR ('Insert failed', 11, 1)
	RETURN
END CATCH
GO



GO
--Update Procedure 
CREATE PROC spUpdateEmp @ename NVARCHAR(30), 
					@pid NVARCHAR(30), 
					@depid MONEY, 
					@payrate MONEY, 
					@id INT OUTPUT
					
AS
BEGIN TRY
	UPDATE employeeList SET employeename=@ename, projectid= @pid, departmentid=@depid
	WHERE employeeid = @id
	
END TRY
BEGIN CATCH
	;
	THROW 50002, 'Update failed',  1
	
END CATCH
GO


--Delete Procedure 
CREATE PROC spDeleteEmp @id INT					
AS
BEGIN TRY
	DELETE employeeList
	WHERE employeeid = @id
	
END TRY
BEGIN CATCH
	;
	THROW 50003, 'DELETE failed',  1
END CATCH
GO


--Insert Trigger 
CREATE TRIGGER TriEmp
ON employeeList FOR INSERT
AS
BEGIN
	DECLARE @empName NVARCHAR(30)
	SELECT @empName = employeename FROM inserted
	IF EXISTS (SELECT 1 FROM employeeList WHERE employeename = @empName)
	BEGIN
		ROLLBACK TRANSACTION
		;
		THROW 50001, 'Manager already assigned to another project.', 1
	END
END
GO
SELECT * FROM employeeList

--Delete Trigger 
GO
CREATE TRIGGER trEmp
ON employeeList
AFTER DELETE
AS
BEGIN 
	IF @@ROWCOUNT > 1
	BEGIN
		PRINT 'Cannot delete more than 1 at a time'
		ROLLBACK TRAN
	END
END
GO


--
GO
USE master
GO
DROP DATABASE NGODB
GO







