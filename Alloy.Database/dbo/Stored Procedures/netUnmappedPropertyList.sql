CREATE PROCEDURE [dbo].netUnmappedPropertyList
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT 
		tblProperty.LinkGuid as GuidID,
		tblProperty.fkPageID as PageID, 
		tblProperty.fkLanguageBranchID as LanguageBranchID,
		tblPageDefinition.Name as PropertyName,
		tblPageDefinition.fkPageTypeID as PageTypeID
		
	FROM
		tblProperty INNER JOIN tblPageDefinition on tblProperty.fkPageDefinitionID = tblPageDefinition.pkID
	WHERE
		tblProperty.LinkGuid IS NOT NULL AND
		tblProperty.PageLink IS NULL		
END
