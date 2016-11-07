CREATE PROCEDURE dbo.netSynchedRoleDelete
(
	@RoleName NVARCHAR(255),
	@ForceDelete INT
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE @GroupID INT
	DECLARE @LoweredName NVARCHAR(255)
    /* Check if group exists */
	SET @LoweredName=LOWER(@RoleName)
	SET @GroupID=NULL
	SELECT
		@GroupID = pkID
	FROM
		[tblSynchedUserRole]
	WHERE
		[LoweredRoleName]=@LoweredName
	
	/* Group does not exist - do nothing */	
    IF (@GroupID IS NULL)
    BEGIN
        RETURN 0
    END
    
    IF (@ForceDelete = 0)
    BEGIN
        IF (EXISTS(SELECT [fkSynchedRole] FROM [tblSynchedUserRelations] WHERE [fkSynchedRole]=@GroupID))
        BEGIN
            RETURN 1    /* Indicate failure - no force delete and group is populated */
        END
    END
    
    DELETE FROM
        [tblSynchedUserRelations]
    WHERE
        [fkSynchedRole]=@GroupID
    DELETE FROM
        [tblSynchedUserRole]
    WHERE
        pkID=@GroupID
        
    RETURN 0
END
