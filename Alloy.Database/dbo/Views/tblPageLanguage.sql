CREATE VIEW [dbo].[tblPageLanguage]
AS
SELECT
	[fkContentID] AS fkPageID,
	[fkLanguageBranchID],
	[ContentLinkGUID] AS PageLinkGUID,
	[fkFrameID],
	[CreatorName],
    [ChangedByName],
    [ContentGUID] AS PageGUID,
    [Name],
    [URLSegment],
    [LinkURL],
	[BlobUri],
	[ThumbnailUri],
    [ExternalURL],
    [AutomaticLink],
    [FetchData],
    CASE WHEN Status = 4 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS PendingPublish,
    [Created],
    [Changed],
    [Saved],
    [StartPublish],
    [StopPublish],
    [Version],
	[Status]
FROM    dbo.tblContentLanguage
