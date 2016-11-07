CREATE PROCEDURE dbo.netTabInfoInsert
(
	@pkID INT OUTPUT,
	@Name NVARCHAR(100),
	@DisplayName NVARCHAR(100),
	@GroupOrder INT,
	@Access INT
)
AS
BEGIN
	INSERT INTO tblPageDefinitionGroup (Name, DisplayName, GroupOrder, Access)
	VALUES (@Name, @DisplayName, @GroupOrder, @Access)
	SET @pkID =  SCOPE_IDENTITY() 
END
