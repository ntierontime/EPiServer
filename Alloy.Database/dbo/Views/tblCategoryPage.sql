CREATE VIEW [dbo].[tblCategoryPage]
AS
SELECT  [fkContentID] AS fkPageID,
		[fkCategoryID],
		[CategoryType],
		[fkLanguageBranchID]
FROM    dbo.tblContentCategory
