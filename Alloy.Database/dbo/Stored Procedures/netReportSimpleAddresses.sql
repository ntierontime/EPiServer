-- Return a list of pages in a particular branch of the tree changed between a start date and a stop date
CREATE PROCEDURE [dbo].[netReportSimpleAddresses](
	@PageID int,
	@Language int = -1,
	@PageSize int,
	@PageNumber int = 0,
	@SortColumn varchar(40) = 'ExternalURL',
	@SortDescending bit = 0
)
AS
BEGIN
	SET NOCOUNT ON;
	WITH PageCTE AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY 
			-- Page Name Sorting
			CASE WHEN @SortColumn = 'PageName' AND @SortDescending = 1 THEN tblPageLanguage.Name END DESC,
			CASE WHEN @SortColumn = 'PageName' THEN tblPageLanguage.Name END ASC,
			-- Changed By Sorting
			CASE WHEN @SortColumn = 'ChangedBy' AND @SortDescending = 1 THEN tblPageLanguage.ChangedByName END DESC,
			CASE WHEN @SortColumn = 'ChangedBy' THEN tblPageLanguage.ChangedByName END ASC,
			-- External Url Sorting
			CASE WHEN @SortColumn = 'ExternalURL' AND @SortDescending = 1 THEN tblPageLanguage.ExternalURL END DESC,
			CASE WHEN @SortColumn = 'ExternalURL' THEN tblPageLanguage.ExternalURL END ASC,
			-- Language Sorting
			CASE WHEN @SortColumn = 'Language' AND @SortDescending = 1 THEN tblLanguageBranch.LanguageID END DESC,
			CASE WHEN @SortColumn = 'Language' THEN tblLanguageBranch.LanguageID END ASC
		) AS rownum,
		tblPageLanguage.fkPageID, tblPageLanguage.[Version], count(*) over () as totcount
		FROM tblPageLanguage 
		INNER JOIN tblTree ON tblTree.fkChildID=tblPageLanguage.fkPageID 
		INNER JOIN tblPage ON tblPage.pkID=tblPageLanguage.fkPageID 
		INNER JOIN tblPageType ON tblPageType.pkID=tblPage.fkPageTypeID
		INNER JOIN tblLanguageBranch ON tblLanguageBranch.pkID=tblPageLanguage.fkLanguageBranchID 
		WHERE 
        (tblTree.fkParentID=@PageID OR (tblPageLanguage.fkPageID=@PageID AND tblTree.NestingLevel = 1 ))
        AND 
        (tblPageLanguage.ExternalURL IS NOT NULL)
        AND tblPage.ContentType = 0
        AND
        (@Language = -1 OR tblPageLanguage.fkLanguageBranchID = @Language)
	)
	SELECT PageCTE.fkPageID, PageCTE.[Version], PageCTE.rownum, totcount
	FROM PageCTE
	WHERE rownum > @PageSize * (@PageNumber)
	AND rownum <= @PageSize * (@PageNumber+1)
	ORDER BY rownum
END
