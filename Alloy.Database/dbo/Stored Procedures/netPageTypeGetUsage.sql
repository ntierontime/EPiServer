CREATE PROCEDURE [dbo].[netPageTypeGetUsage]
(
	@PageTypeID		INT,
	@OnlyPublished	BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	IF (@OnlyPublished = 1)
	BEGIN
		SELECT DISTINCT
			tblPage.pkID as PageID, 
			0 AS WorkID,
			tblPageLanguage.Name,
			tblLanguageBranch.LanguageID AS LanguageBranch
		FROM 
			tblPage
		INNER JOIN 
			tblPageLanguage ON tblPage.pkID=tblPageLanguage.fkPageID
		INNER JOIN
			tblLanguageBranch ON tblLanguageBranch.pkID=tblPageLanguage.fkLanguageBranchID
		WHERE
			tblPage.fkPageTypeID = @PageTypeID
	END
	ELSE
	BEGIN
		SELECT DISTINCT
			tblPage.pkID as PageID, 
			tblWorkPage.pkID as WorkID,
			tblWorkPage.Name,
			tblLanguageBranch.LanguageID AS LanguageBranch
		FROM 
			tblWorkPage
		INNER JOIN 
			tblPage ON tblWorkPage.fkPageID = tblPage.pkID
		INNER JOIN 
			tblPageLanguage ON tblWorkPage.fkPageID=tblPageLanguage.fkPageID 
		INNER JOIN
			tblLanguageBranch ON tblLanguageBranch.pkID=tblWorkPage.fkLanguageBranchID
		WHERE
			tblPage.fkPageTypeID = @PageTypeID
	END
END
