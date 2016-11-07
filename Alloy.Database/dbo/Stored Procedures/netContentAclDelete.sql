CREATE PROCEDURE dbo.netContentAclDelete
(
	@Name NVARCHAR(255),
	@IsRole INT,
	@ContentID INT
)
AS
BEGIN
	SET NOCOUNT ON
	
	DELETE FROM tblContentAccess WHERE fkContentID=@ContentID AND Name=@Name AND IsRole=@IsRole
END
