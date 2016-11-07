CREATE PROCEDURE dbo.netLanguageBranchList
AS
BEGIN
	SELECT 
		pkID AS ID,
		Name,
		LanguageID,
		SortIndex,
		SystemIconPath,
		URLSegment,
		Enabled,
		ACL
	FROM 
		tblLanguageBranch
	ORDER BY 
		SortIndex
END
