CREATE PROCEDURE dbo.netPermissionSave
(
	@Name NVARCHAR(255) = NULL,
	@IsRole INT = NULL,
	@Permission NVARCHAR(150),
	@GroupName NVARCHAR(150),
	@ClearByName INT = NULL,
	@ClearByPermission INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (NOT @ClearByName IS NULL)
		DELETE FROM 
		    tblUserPermission 
		WHERE 
		    Name=@Name AND 
		IsRole=@IsRole
		
	IF (NOT @ClearByPermission IS NULL)
		DELETE FROM 
		    tblUserPermission 
		WHERE 
		    Permission=@Permission AND GroupName = @GroupName	
    IF ((@Name IS NULL) OR (@IsRole IS NULL))
        RETURN
        
	IF (NOT EXISTS(SELECT Name FROM tblUserPermission WHERE Name=@Name AND IsRole=@IsRole AND Permission=@Permission AND GroupName = @GroupName))
		INSERT INTO tblUserPermission 
		    (Name, 
		    IsRole, 
		    Permission,
			GroupName) 
		VALUES 
		    (@Name, 
		    @IsRole, 
		    @Permission,
			@GroupName)
END
