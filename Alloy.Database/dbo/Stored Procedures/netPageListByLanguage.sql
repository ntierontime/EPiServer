CREATE PROCEDURE dbo.netPageListByLanguage
(
	@LanguageID nchar(17),
	@PageID INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	IF @PageID IS NULL
	BEGIN
		SELECT tblPageLanguage.fkPageID as "PageID", tblPage.ContentType
		FROM tblPageLanguage
		INNER JOIN tblPage on tblPage.pkID = tblPageLanguage.fkPageID
		INNER JOIN tblLanguageBranch ON tblLanguageBranch.pkID=tblPageLanguage.fkLanguageBranchID
		WHERE tblLanguageBranch.LanguageID = @LanguageID
	END
	ELSE
	BEGIN
		SELECT tblPageLanguage.fkPageID as "PageID", tblPage.ContentType
		FROM tblPageLanguage
		INNER JOIN tblPage on tblPage.pkID = tblPageLanguage.fkPageID
		INNER JOIN tblTree ON tblTree.fkChildID=tblPageLanguage.fkPageID
		INNER JOIN tblLanguageBranch ON tblLanguageBranch.pkID=tblPageLanguage.fkLanguageBranchID
		WHERE tblTree.fkParentID=@PageID AND
		tblLanguageBranch.LanguageID = @LanguageID
		ORDER BY NestingLevel DESC
	END
END
