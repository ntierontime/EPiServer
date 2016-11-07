CREATE PROCEDURE dbo.EntityTypeGetNameByID
@intObjectTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT strName FROM dbo.tblEntityType WHERE intID = @intObjectTypeID
END
