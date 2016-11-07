CREATE PROCEDURE dbo.netSynchedUserMatchRoleList 
(
	@RoleName NVARCHAR(255),
	@UserNameToMatch NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE @GroupID INT
	SELECT 
	    @GroupID=pkID
	FROM
	    [tblSynchedUserRole]
	WHERE
	    [LoweredRoleName]=LOWER(@RoleName)
	IF (@GroupID IS NULL)
	BEGIN
	    RETURN -1   /* Role does not exist */
	END
	
	SELECT
	    UserName
	FROM
	    [tblSynchedUserRelations] AS WR
	INNER JOIN
	    [tblSynchedUser] AS WU
	ON
	    WU.pkID=WR.[fkSynchedUser]
	WHERE
	    WR.[fkSynchedRole]=@GroupID AND
	    ((WU.LoweredUserName LIKE LOWER(@UserNameToMatch)) OR (@UserNameToMatch IS NULL))
END
