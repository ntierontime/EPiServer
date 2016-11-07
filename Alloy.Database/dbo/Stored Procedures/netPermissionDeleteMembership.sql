CREATE PROCEDURE [dbo].[netPermissionDeleteMembership]
(
	@Name	NVARCHAR(255) = NULL,
	@IsRole int = NULL
)
AS
BEGIN
    SET NOCOUNT ON
	IF(@Name IS NOT NULL AND @IsRole IS NOT NULL)
	BEGIN
		DELETE
		FROM
			tblUserPermission
		WHERE
			Name=@Name 
			AND 
			IsRole=@IsRole
    END
END
