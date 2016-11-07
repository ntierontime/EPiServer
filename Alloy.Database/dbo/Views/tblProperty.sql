CREATE VIEW [dbo].[tblProperty]
AS
SELECT
	[pkID],
	[fkPropertyDefinitionID] AS fkPageDefinitionID,
	[fkContentID] AS fkPageID,
	[fkLanguageBranchID],
	[ScopeName],
	[guid],
	[Boolean],
	[Number],
	[FloatNumber],
	[ContentType] AS PageType,
	[ContentLink] AS PageLink,
	[Date],
	[String],
	[LongString],
	[LongStringLength],
	[LinkGuid]
FROM    dbo.tblContentProperty
