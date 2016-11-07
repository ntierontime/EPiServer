CREATE PROCEDURE dbo.netSynchedUserRoleList 
(
    @UserID INT = NULL,
	@UserName NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	IF (@UserID IS NULL)
	BEGIN
		DECLARE @LoweredName NVARCHAR(255)
		SET @LoweredName=LOWER(@UserName)
		SELECT 
			@UserID=pkID 
		FROM
			[tblSynchedUser]
		WHERE
			LoweredUserName=@LoweredName
	END
	
    /* Get Group name and id */
    SELECT
        [RoleName],
        [fkSynchedRole] AS GroupID
    FROM
        [tblSynchedUserRelations] AS WR
    INNER JOIN
        [tblSynchedUserRole] AS WG
    ON
        WR.[fkSynchedRole]=WG.pkID
    WHERE
        WR.[fkSynchedUser]=@UserID
    ORDER BY
        [RoleName]
END
