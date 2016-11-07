CREATE VIEW [dbo].[tblPropertyDefault]
AS
SELECT
	[pkID],
	[fkPropertyDefinitionID] AS fkPageDefinitionID,
	[Boolean],
	[Number],
	[FloatNumber],
	[ContentType] AS PageType,
	[ContentLink] AS PageLink,
	[Date],
	[String],
	[LongString],
	[LinkGuid]
FROM    dbo.tblPropertyDefinitionDefault
