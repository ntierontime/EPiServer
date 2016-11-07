CREATE PROCEDURE dbo.EntityTypeGetIDByName
@strObjectType varchar(400)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @intID int
	SELECT @intID = intID FROM dbo.tblEntityType WHERE strName = @strObjectType
	IF @intID IS NULL
	BEGIN
		INSERT INTO dbo.tblEntityType (strName) VALUES(@strObjectType)
		SET @intID = SCOPE_IDENTITY()
	END
	SELECT @intID
END
