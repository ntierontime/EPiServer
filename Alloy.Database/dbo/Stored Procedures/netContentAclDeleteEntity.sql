CREATE PROCEDURE dbo.netContentAclDeleteEntity
(
	@Name NVARCHAR(255),
	@IsRole INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	DELETE FROM tblContentAccess WHERE Name=@Name AND IsRole=@IsRole
END
