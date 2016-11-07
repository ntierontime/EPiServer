CREATE PROCEDURE [dbo].netTabListDependencies
(
	@TabID INT
)
AS
BEGIN
	SELECT tblPageDefinitionGroup.pkID as TabID,
		tblPageDefinition.Name as PropertyName,
		tblPageDefinitionGroup.Name as TabName
	FROM tblPageDefinition 
	INNER JOIN tblPageDefinitionGroup
	ON tblPageDefinitionGroup.pkID = tblPageDefinition.Advanced
	WHERE Advanced = @TabID
END
