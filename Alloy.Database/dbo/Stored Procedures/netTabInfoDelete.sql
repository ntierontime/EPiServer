CREATE PROCEDURE dbo.netTabInfoDelete
(
	@pkID		INT,
	@ReplaceID	INT = NULL
)
AS
BEGIN
	IF NOT @ReplaceID IS NULL
		UPDATE tblPageDefinition SET Advanced = @ReplaceID WHERE Advanced = @pkID
	DELETE FROM tblPageDefinitionGroup WHERE pkID = @pkID AND SystemGroup = 0
END
