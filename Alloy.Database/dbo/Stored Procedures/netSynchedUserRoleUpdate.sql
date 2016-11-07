CREATE PROCEDURE dbo.netSynchedUserRoleUpdate
(
	@UserName NVARCHAR(255),
	@Roles dbo.StringParameterTable READONLY
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @UserID INT
	SET @UserID = (SELECT pkID FROM [tblSynchedUser] WHERE LoweredUserName = LOWER(@UserName))
	IF (@UserID IS NULL)
	BEGIN
		RAISERROR(N'No user with username %s was found', 16, 1, @UserName)
	END
	/*First ensure roles are in role table*/
	MERGE [tblSynchedUserRole] AS TARGET
		USING @Roles AS Source
		ON (Target.LoweredRoleName = LOWER(Source.String))
		WHEN NOT MATCHED BY Target THEN
			INSERT (RoleName, LoweredRoleName)
			VALUES (Source.String, LOWER(Source.String));
	/* Remove all existing fole for user */
	DELETE FROM [tblSynchedUserRelations] WHERE [fkSynchedUser] = @UserID
	/* Insert roles */
	INSERT INTO [tblSynchedUserRelations] ([fkSynchedRole], [fkSynchedUser])
	SELECT [tblSynchedUserRole].pkID, @UserID FROM 
	[tblSynchedUserRole] INNER JOIN @Roles AS R ON [tblSynchedUserRole].LoweredRoleName = LOWER(R.String)
END
