CREATE VIEW [dbo].[tblPageLanguageSetting]
AS
SELECT
		[fkContentID] AS fkPageID,
		[fkLanguageBranchID],
		[fkReplacementBranchID],
    	[LanguageBranchFallback],
    	[Active]
FROM    dbo.tblContentLanguageSetting
