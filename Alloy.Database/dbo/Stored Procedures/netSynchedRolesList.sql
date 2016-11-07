CREATE PROCEDURE dbo.netSynchedRolesList 
(
	@RoleName NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
    SELECT
        [RoleName]
    FROM
        [tblSynchedUserRole]
    WHERE
		Enabled = 1 AND
        ((@RoleName IS NULL) OR
        ([LoweredRoleName] LIKE LOWER(@RoleName)))
    ORDER BY
        [RoleName]     
END
