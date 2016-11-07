CREATE PROCEDURE dbo.netSynchedUserGetMetadata
(
	@UserName NVARCHAR(255)
)
AS
BEGIN
	SET @UserName = LOWER(@UserName)
	SELECT Email, GivenName, Surname, Metadata FROM [tblSynchedUser]
	WHERE LoweredUserName = @UserName
END
