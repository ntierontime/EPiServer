CREATE VIEW [dbo].[tblWorkProperty]
AS
SELECT
	[pkID],
	[fkPropertyDefinitionID] AS fkPageDefinitionID,
	[fkWorkContentID] AS fkWorkPageID,
	[ScopeName],
	[Boolean],
	[Number],
	[FloatNumber],
	[ContentType] AS PageType,
	[ContentLink] AS PageLink,
	[Date],
	[String],
	[LongString],
	[LinkGuid]
FROM    dbo.tblWorkContentProperty
