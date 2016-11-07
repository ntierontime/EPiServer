-- Return a list of pages in a particular branch of the tree published between a start date and a stop date
CREATE PROCEDURE [dbo].netReportReadyToPublish(
	@PageID int,
	@StartDate datetime,
	@StopDate datetime,
	@Language int = -1,
	@ChangedByUserName nvarchar(256) = null,
	@PageSize int,
	@PageNumber int = 0,
	@SortColumn varchar(40) = 'PageName',
	@SortDescending bit = 0,
	@IsReadyToPublish bit = 1
)
AS
BEGIN
	SET NOCOUNT ON;
	WITH PageCTE AS
                    (
                        SELECT ROW_NUMBER() OVER(ORDER BY 
							-- Page Name Sorting
							CASE WHEN @SortColumn = 'PageName' AND @SortDescending = 1 THEN tblWorkPage.Name END DESC,
							CASE WHEN @SortColumn = 'PageName' THEN tblWorkPage.Name END ASC,
							-- Saved Sorting
							CASE WHEN @SortColumn = 'Saved' AND @SortDescending = 1 THEN tblWorkPage.Saved END DESC,
							CASE WHEN @SortColumn = 'Saved' THEN tblWorkPage.Saved END ASC,
							-- StartPublish Sorting
							CASE WHEN @SortColumn = 'StartPublish' AND @SortDescending = 1 THEN tblWorkPage.StartPublish END DESC,
							CASE WHEN @SortColumn = 'StartPublish' THEN tblWorkPage.StartPublish END ASC,
							-- Changed By Sorting
							CASE WHEN @SortColumn = 'ChangedBy' AND @SortDescending = 1 THEN tblWorkPage.ChangedByName END DESC,
							CASE WHEN @SortColumn = 'ChangedBy' THEN tblWorkPage.ChangedByName END ASC,
							-- Language Sorting
							CASE WHEN @SortColumn = 'Language' AND @SortDescending = 1 THEN tblLanguageBranch.LanguageID END DESC,
							CASE WHEN @SortColumn = 'Language' THEN tblLanguageBranch.LanguageID END ASC
							, 
							tblWorkPage.pkID ASC
                        ) AS rownum,
                        tblWorkPage.fkPageID, count(tblWorkPage.fkPageID) over () as totcount,
                        tblWorkPage.pkID as versionId
                        FROM tblWorkPage 
                        INNER JOIN tblTree ON tblTree.fkChildID=tblWorkPage.fkPageID 
                        INNER JOIN tblPage ON tblPage.pkID=tblWorkPage.fkPageID 
						INNER JOIN tblLanguageBranch ON tblLanguageBranch.pkID=tblWorkPage.fkLanguageBranchID 
                        WHERE 
							(tblTree.fkParentID=@PageID OR (tblWorkPage.fkPageID=@PageID AND tblTree.NestingLevel = 1 ))
                        AND
							(@ChangedByUserName IS NULL OR tblWorkPage.ChangedByName = @ChangedByUserName)
                        AND
							tblPage.ContentType = 0
                        AND
							(@Language = -1 OR tblWorkPage.fkLanguageBranchID = @Language)
                        AND 
							(@StartDate IS NULL OR tblWorkPage.Saved > @StartDate)
                        AND
							(@StopDate IS NULL OR tblWorkPage.Saved < @StopDate)
                        AND
							(tblWorkPage.ReadyToPublish = @IsReadyToPublish AND tblWorkPage.HasBeenPublished = 0)
                    )
                    SELECT PageCTE.fkPageID, PageCTE.rownum, totcount, PageCTE.versionId
                    FROM PageCTE
                    WHERE rownum > @PageSize * (@PageNumber)
                    AND rownum <= @PageSize * (@PageNumber+1)
                    ORDER BY rownum
	END
