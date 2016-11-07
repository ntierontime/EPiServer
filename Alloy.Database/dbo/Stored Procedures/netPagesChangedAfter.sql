CREATE PROCEDURE dbo.netPagesChangedAfter
( 
	@RootID INT,
	@ChangedAfter DATETIME,
	@MaxHits INT,
	@StopPublish DATETIME
)
AS
BEGIN
	SET NOCOUNT ON
    SET @MaxHits = @MaxHits + 1 -- Return one more to determine if there are more pages to fetch (gets MaxHits + 1)
    SET ROWCOUNT @MaxHits
    
	SELECT 
	    tblPageLanguage.fkPageID AS PageID,
		RTRIM(tblLanguageBranch.LanguageID) AS LanguageID
	FROM
		tblPageLanguage
	INNER JOIN
		tblTree
	ON
		tblPageLanguage.fkPageID = tblTree.fkChildID AND (tblTree.fkParentID = @RootID OR (tblTree.fkChildID = @RootID AND tblTree.NestingLevel = 1))
	INNER JOIN
		tblLanguageBranch
	ON
		tblPageLanguage.fkLanguageBranchID = tblLanguageBranch.pkID
	WHERE
		(tblPageLanguage.Changed > @ChangedAfter OR tblPageLanguage.StartPublish > @ChangedAfter) AND
		(tblPageLanguage.StopPublish is NULL OR tblPageLanguage.StopPublish > @StopPublish) AND
		tblPageLanguage.PendingPublish=0
	ORDER BY
		tblTree.NestingLevel,
		tblPageLanguage.fkPageID,
		tblPageLanguage.Changed DESC
		
	SET ROWCOUNT 0
END
