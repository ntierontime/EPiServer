CREATE VIEW [dbo].[tblWorkCategory]
AS
SELECT
	[fkWorkContentID] AS fkWorkPageID,
	[fkCategoryID],
	[CategoryType]
FROM    dbo.tblWorkContentCategory
