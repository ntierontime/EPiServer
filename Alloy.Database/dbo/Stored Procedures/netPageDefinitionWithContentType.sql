CREATE PROCEDURE dbo.netPageDefinitionWithContentType
(
	@ContentTypeID	UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT count(*) FROM tblPageDefinition INNER JOIN 
	tblPageDefinitionType ON tblPageDefinition.fkPageDefinitionTypeID = tblPageDefinitionType.pkID
	WHERE
	fkPageTypeGUID = @ContentTypeID
END
