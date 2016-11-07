CREATE PROCEDURE dbo.netTabInfoUpdate
(
	@pkID int,
	@Name nvarchar(100),
	@DisplayName nvarchar(100),
	@GroupOrder int,
	@Access int
)
AS
BEGIN
	UPDATE tblPageDefinitionGroup	SET 
		Name = @Name,
		DisplayName = @DisplayName,
		GroupOrder = @GroupOrder,
		Access = @Access
	WHERE pkID = @pkID
END
