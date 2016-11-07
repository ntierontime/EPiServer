-- Returns a list of pages which will expire between the supplied dates in a particular branch of the tree.
CREATE PROCEDURE [dbo].[netReportExpiredPages](
	@PageID int,
	@StartDate datetime,
	@StopDate datetime,
	@Language int = -1,
	@PageSize int,
	@PageNumber int = 0,
	@SortColumn varchar(40) = 'StopPublish',
	@SortDescending bit = 0,
	@PublishedByName nvarchar(256) = null
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
        tblPageLanguage.fkPageID, tblPageLanguage.Version AS PublishedVersion, count(tblPageLanguage.fkPageID) over () as totcount                        
        FROM tblPageLanguage 
        INNER JOIN tblTree ON tblTree.fkChildID=tblPageLanguage.fkPageID 
        INNER JOIN tblPage ON tblPage.pkID=tblPageLanguage.fkPageID 
        INNER JOIN tblPageType ON tblPageType.pkID=tblPage.fkPageTypeID 
        INNER JOIN tblLanguageBranch ON tblLanguageBranch.pkID=tblPageLanguage.fkLanguageBranchID 
        WHERE 
        (tblTree.fkParentID = @PageID OR (tblPageLanguage.fkPageID = @PageID AND tblTree.NestingLevel = 1))
        AND 
        (@StartDate IS NULL OR tblPageLanguage.StopPublish>@StartDate)
        AND
        (@StopDate IS NULL OR tblPageLanguage.StopPublish<@StopDate)
		AND
		(@Language = -1 OR tblPageLanguage.fkLanguageBranchID = @Language)
        AND tblPage.ContentType = 0
		AND tblPageLanguage.Status=4
		AND
		(@PublishedByName IS NULL OR tblPageLanguage.ChangedByName = @PublishedByName)
    )
    SELECT PageCTE.fkPageID, PageCTE.PublishedVersion, PageCTE.rownum, totcount
    FROM PageCTE
    WHERE rownum > @PageSize * (@PageNumber)
    AND rownum <= @PageSize * (@PageNumber+1)
    ORDER BY rownum'
    
    EXEC sp_executesql @sql, N'@PageID int, @StartDate datetime, @StopDate datetime, @Language int, @PublishedByName nvarchar(256), @PageSize int, @PageNumber int',
		@PageID = @PageID, 
		@StartDate = @StartDate, 
		@StopDate = @StopDate, 
		@Language = @Language, 
		@PublishedByName = @PublishedByName, 
		@PageSize = @PageSize, 
		@PageNumber = @PageNumber
END
