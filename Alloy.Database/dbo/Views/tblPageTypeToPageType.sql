CREATE VIEW [dbo].[tblPageTypeToPageType]
AS
SELECT
	[fkContentTypeParentID] AS fkPageTypeParentID,
	[fkContentTypeChildID] AS fkPageTypeChildID,
	[Access],
	[Availability],
	[Allow]
FROM    dbo.tblContentTypeToContentType
