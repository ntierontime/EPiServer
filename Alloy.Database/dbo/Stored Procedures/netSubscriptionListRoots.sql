CREATE PROCEDURE dbo.netSubscriptionListRoots
AS
BEGIN
	SELECT tblPage.pkID AS PageID
	FROM tblPage
	INNER JOIN tblProperty ON tblProperty.fkPageID		= tblPage.pkID
	INNER JOIN tblPageDefinition ON tblPageDefinition.pkID	= tblProperty.fkPageDefinitionID
	WHERE tblPageDefinition.Name='EPSUBSCRIBE-ROOT' AND NOT tblProperty.PageLink IS NULL AND tblPage.Deleted=0
END
