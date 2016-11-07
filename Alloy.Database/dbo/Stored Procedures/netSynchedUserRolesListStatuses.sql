CREATE PROCEDURE dbo.netSynchedUserRolesListStatuses 
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
    SELECT
        [RoleName] as Name, Enabled
    FROM
        [tblSynchedUserRole]
    ORDER BY
        [RoleName]     
END
