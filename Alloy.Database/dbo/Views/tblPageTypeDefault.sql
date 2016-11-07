CREATE VIEW [dbo].[tblPageTypeDefault]
AS
SELECT
	[pkID],
	[fkContentTypeID] AS fkPageTypeID,
	[fkContentLinkID] AS fkPageLinkID,
	[fkFrameID],
	[fkArchiveContentID] AS fkArchivePageID,
	[Name],
	[VisibleInMenu],
	[StartPublishOffsetValue],
	[StartPublishOffsetType],
	[StopPublishOffsetValue],
	[StopPublishOffsetType],
	[ChildOrderRule],
	[PeerOrder],
	[StartPublishOffset],
	[StopPublishOffset]
FROM    dbo.tblContentTypeDefault
