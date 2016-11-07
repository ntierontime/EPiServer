CREATE PROCEDURE dbo.netSynchedRoleInsert 
(
	@RoleName NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @LoweredName NVARCHAR(255)
    /* Check if group exists, insert it if not */
	SET @LoweredName=LOWER(@RoleName)
    INSERT INTO [tblSynchedUserRole]
        ([RoleName], 
		[LoweredRoleName])
	SELECT
	    @RoleName,
	    @LoweredName
	WHERE NOT EXISTS(SELECT pkID FROM [tblSynchedUserRole] WHERE [LoweredRoleName]=@LoweredName)
	
    /* Inserted group, return the id */
    IF (@@ROWCOUNT > 0)
    BEGIN
        RETURN  SCOPE_IDENTITY() 
    END
	
	DECLARE @GroupID INT
	SELECT @GroupID=pkID FROM [tblSynchedUserRole] WHERE [LoweredRoleName]=@LoweredName
	RETURN @GroupID
END
