-- Return a list of pages in a particular branch of the tree published between a start date and a stop date
CREATE PROCEDURE [dbo].[netReportPublishedPages](
	@PageID int,
	@StartDate datetime,
	@StopDate datetime,
	@Language int = -1,
	@ChangedByUserName nvarchar(256) = null,
	@PageSize int,
	@PageNumber int = 0,
	@SortColumn varchar(40) = 'StartPublish',
	@SortDescending bit = 0
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @OrderBy NVARCHAR(MAX)
	SET @OrderBy =
		CASE @SortColumn
			WHEN 'PageName' THEN 'tblPageLanguage.Name'
			WHEN 'StartPublish' THEN 'tblPageLanguage.StartPublish'
			WHEN 'StopPublish' THEN 'tblPageLanguage.StopPublish'
			WHEN 'ChangedBy' THEN 'tblPageLanguage.ChangedByName'
			WHEN 'Saved' THEN 'tblPageLanguage.Saved'
			WHEN 'Language' THEN 'tblLanguageBranch.LanguageID'
			WHEN 'PageTypeName' THEN 'tblPageType.Name'
		END
	IF(@SortDescending = 1)
		SET @OrderBy = @OrderBy + ' DESC'
	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'WITH PageCTE AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY ' 
			+ @OrderBy
			+ ') AS rownum,
		tblPageLanguage.fkPageID, tblPageLanguage.Version AS PublishedVersion, count(*) over () as totcount
		FROM tblPageLanguage 
		INNER JOIN tblTree ON tblTree.fkChildID=tblPageLanguage.fkPageID 
		INNER JOIN tblPage ON tblPage.pkID=tblPageLanguage.fkPageID 
		INNER JOIN tblPageType ON tblPageType.pkID=tblPage.fkPageTypeID 
		INNER JOIN tblLanguageBranch ON tblLanguageBranch.pkID=tblPageLanguage.fkLanguageBranchID
		WHERE
		(tblTree.fkParentID=@PageID OR (tblPageLanguage.fkPageID=@PageID AND tblTree.NestingLevel = 1 ))
        AND tblPage.ContentType = 0
		AND tblPageLanguage.Status=4
		AND 
		(@StartDate IS NULL OR tblPageLanguage.StartPublish>@StartDate)
		AND
		(@StopDate IS NULL OR tblPageLanguage.StartPublish<@StopDate)
		AND
		(@Language = -1 OR tblPageLanguage.fkLanguageBranchID = @Language)
		AND
		(@ChangedByUserName IS NULL OR tblPageLanguage.ChangedByName = @ChangedByUserName)
	)
	SELECT PageCTE.fkPageID, PageCTE.PublishedVersion, PageCTE.rownum, totcount
	FROM PageCTE
	WHERE rownum > @PageSize * (@PageNumber)
	AND rownum <= @PageSize * (@PageNumber+1)
	ORDER BY rownum'
	EXEC sp_executesql @sql, N'@PageID int, @StartDate datetime, @StopDate datetime, @Language int, @ChangedByUserName nvarchar(256), @PageSize int, @PageNumber int',
		@PageID = @PageID, 
		@StartDate = @StartDate, 
		@StopDate = @StopDate, 
		@Language = @Language, 
		@ChangedByUserName = @ChangedByUserName, 
		@PageSize = @PageSize, 
		@PageNumber = @PageNumber
	
END
