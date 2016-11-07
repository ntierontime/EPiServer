CREATE PROCEDURE dbo.netQuickSearchByExternalUrl
(
	@Url	NVARCHAR(255),
	@CurrentTime	DATETIME
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @LoweredUrl NVARCHAR(255)
	
	SET @LoweredUrl = Lower(@Url)
	/*
		Performance notes: The subquery "Pages" must not have any more predicates or return the values used in the outer WHERE-clause, otherwise
		SQL Server falls back to a costly index scan. The performance hints LOOP on the joins are also required for the same reason, the resultset
		from "Pages" is so small that a loop join is superior in performance to index scan/hash match, a factor 1000x.
	*/
	
	SELECT 
		tblPageLanguage.fkPageID,
		tblLanguageBranch.LanguageID as LanguageBranch
	FROM 
		(
			SELECT fkPageID,fkLanguageBranchID
			FROM tblPageLanguage
			WHERE tblPageLanguage.ExternalURL=@LoweredUrl
		) AS Pages
	INNER LOOP JOIN 
		tblPage ON tblPage.pkID = Pages.fkPageID
	INNER LOOP JOIN
		tblPageLanguage ON tblPageLanguage.fkPageID=Pages.fkPageID AND tblPageLanguage.fkLanguageBranchID=Pages.fkLanguageBranchID
	INNER LOOP JOIN
		tblLanguageBranch ON tblLanguageBranch.pkID = Pages.fkLanguageBranchID
	WHERE 
		tblPage.Deleted=0 AND 
		tblPageLanguage.[Status]=4 AND
		tblPageLanguage.StartPublish <= @CurrentTime AND
		(tblPageLanguage.StopPublish IS NULL OR tblPageLanguage.StopPublish >= @CurrentTime)
	ORDER BY
		tblPageLanguage.Changed DESC
END
