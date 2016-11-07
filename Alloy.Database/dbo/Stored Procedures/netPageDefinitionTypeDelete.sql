CREATE PROCEDURE dbo.netPageDefinitionTypeDelete
(
	@ID INT
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT DISTINCT pkID
	FROM tblPageDefinition 
	WHERE fkPageDefinitionTypeID=@ID
	IF (@@ROWCOUNT <> 0)
		RETURN
	
	IF @ID>=1000
		DELETE FROM tblPageDefinitionType WHERE pkID=@ID
	ELSE
		RAISERROR('Cannot delete system types',16,1)
END
