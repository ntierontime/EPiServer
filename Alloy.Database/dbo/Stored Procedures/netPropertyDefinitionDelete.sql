CREATE PROCEDURE [dbo].[netPropertyDefinitionDelete]
(
	@PropertyDefinitionID INT
)
AS
BEGIN
	DELETE FROM tblContentProperty WHERE ScopeName IN (SELECT ScopeName FROM dbo.GetExistingScopesForDefinition(@PropertyDefinitionID)) 
	DELETE FROM tblWorkContentProperty WHERE ScopeName IN (SELECT ScopeName FROM dbo.GetExistingScopesForDefinition(@PropertyDefinitionID))
	DELETE FROM tblPropertyDefault WHERE fkPageDefinitionID=@PropertyDefinitionID
	DELETE FROM tblProperty WHERE fkPageDefinitionID=@PropertyDefinitionID
	DELETE FROM tblWorkProperty WHERE fkPageDefinitionID=@PropertyDefinitionID
	DELETE FROM tblCategoryPage WHERE CategoryType=@PropertyDefinitionID
	DELETE FROM tblWorkCategory WHERE CategoryType=@PropertyDefinitionID
	DELETE FROM tblPageDefinition WHERE pkID=@PropertyDefinitionID
END
