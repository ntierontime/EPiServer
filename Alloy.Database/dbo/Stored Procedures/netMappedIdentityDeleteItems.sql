CREATE PROCEDURE [dbo].[netMappedIdentityDeleteItems]
	@ContentGuids dbo.GuidParameterTable READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DELETE mi 
	FROM tblMappedIdentity mi
	INNER JOIN @ContentGuids cg ON mi.ContentGuid = cg.Id
END
