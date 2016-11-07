CREATE PROCEDURE dbo.netPageDefinitionDynamicCheck
(
	@PageDefinitionID	INT
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT  DISTINCT
		tblProperty.fkPageID as ContentID, 
		tblLanguageBranch.Name,
		tblLanguageBranch.LanguageID AS LanguageBranch,
		tblLanguageBranch.Name AS LanguageBranchName,
		0 AS WorkID
	FROM 
		tblProperty
	INNER JOIN
		tblPage ON tblPage.pkID=tblProperty.fkPageID
	INNER JOIN
		tblLanguageBranch ON tblLanguageBranch.pkID=tblProperty.fkLanguageBranchID
	WHERE
		tblProperty.fkPageDefinitionID=@PageDefinitionID AND
		tblProperty.fkLanguageBranchID<>tblPage.fkMasterLanguageBranchID
	RETURN 0
END
