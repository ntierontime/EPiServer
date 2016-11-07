CREATE PROCEDURE dbo.netPermissionRoles
(
	@Permission	NVARCHAR(150),
	@GroupName  NVARCHAR(150)
)
AS
BEGIN
    SET NOCOUNT ON
    SELECT
        Name,
        IsRole
    FROM
        tblUserPermission
    WHERE
        Permission=@Permission AND GroupName = @GroupName
    ORDER BY
        IsRole
END
