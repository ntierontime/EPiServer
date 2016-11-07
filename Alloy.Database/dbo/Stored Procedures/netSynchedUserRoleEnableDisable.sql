CREATE PROCEDURE dbo.netSynchedUserRoleEnableDisable
(
	@RoleName NVARCHAR(255),
	@Enable BIT
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
    UPDATE [tblSynchedUserRole]
        SET Enabled = @Enable
    WHERE
        [LoweredRoleName]=LOWER(@RoleName)
END
