CREATE VIEW [dbo].[tblPage]
AS
SELECT  [pkID],
		[fkContentTypeID] AS fkPageTypeID,
		[fkParentID],
		[ArchiveContentGUID] AS ArchivePageGUID,
		[CreatorName],
		[ContentGUID] AS PageGUID,
		[VisibleInMenu],
		[Deleted],
		CAST (0 AS BIT) AS PendingPublish,
		[ChildOrderRule],
		[PeerOrder],
		[ContentAssetsID],
		[ContentOwnerID],
		NULL as PublishedVersion,
		[fkMasterLanguageBranchID],
		[ContentPath] AS PagePath,
		[ContentType],
		[DeletedBy],
		[DeletedDate]
FROM    dbo.tblContent
