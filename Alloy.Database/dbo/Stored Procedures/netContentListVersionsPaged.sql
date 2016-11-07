CREATE PROCEDURE dbo.netContentListVersionsPaged
(
	@Binary VARBINARY(8000),
	@Threshold INT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @ContentVersions TABLE (VersionID INT, ContentID INT, MasterVersionID INT, LanguageBranchID INT, ContentTypeID INT)
	DECLARE @WorkId INT;
	DECLARE	@Length SMALLINT
	DECLARE @Index SMALLINT
	SET @Index = 1
	SET @Length = DATALENGTH(@Binary)
	WHILE (@Index <= @Length)
	BEGIN
		SET @WorkId = SUBSTRING(@Binary, @Index, 4)
		INSERT INTO @ContentVersions VALUES(@WorkId, NULL, NULL, NULL, NULL)
		SET @Index = @Index + 4
	END
	/* Add some meta data to temp table*/
	UPDATE @ContentVersions SET ContentID = tblContent.pkID, MasterVersionID = tblContentLanguage.Version, LanguageBranchID = tblWorkContent.fkLanguageBranchID, ContentTypeID = tblContent.fkContentTypeID
	FROM tblWorkContent INNER JOIN tblContent on tblWorkContent.fkContentID = tblContent.pkID
	INNER JOIN tblContentLanguage ON tblContentLanguage.fkContentID = tblContent.pkID
	WHERE tblWorkContent.pkID = VersionID AND tblWorkContent.fkLanguageBranchID = tblContentLanguage.fkLanguageBranchID
	/*Add master language version to support loading non localized props*/
	INSERT INTO @ContentVersions (ContentID, MasterVersionID, LanguageBranchID, ContentTypeID)
	SELECT DISTINCT tblContent.pkID, tblContentLanguage.Version, tblContentLanguage.fkLanguageBranchID, tblContent.fkContentTypeID 
	FROM @ContentVersions AS CV INNER JOIN tblContent ON CV.ContentID = tblContent.pkID
	INNER JOIN tblContentLanguage ON tblContent.pkID = tblContentLanguage.fkContentID
	WHERE tblContent.fkMasterLanguageBranchID = tblContentLanguage.fkLanguageBranchID
	/* Get all languages for all items*/
	SELECT DISTINCT ContentID AS PageLinkID, ContentTypeID as PageTypeID, tblContentLanguage.fkLanguageBranchID as PageLanguageBranchID 
	FROM @ContentVersions AS CV INNER JOIN tblContentLanguage ON CV.ContentID = tblContentLanguage.fkContentID
	WHERE CV.VersionID IS NOT NULL
	ORDER BY ContentID
	/* Get data for languages */
	SELECT
		W.Status AS PageWorkStatus,
		W.fkContentID AS PageLinkID,
		W.pkID AS PageLinkWorkID,
		W.LinkType AS PageShortcutType,
		W.ExternalURL AS PageExternalURL,
		W.ContentLinkGUID AS PageShortcutLinkID,
		W.Name AS PageName,
		W.URLSegment AS PageURLSegment,
		W.LinkURL AS PageLinkURL,
		W.BlobUri,
		W.ThumbnailUri,
		W.Created AS PageCreated,
		L.Changed AS PageChanged,
		W.Saved AS PageSaved,
		W.StartPublish AS PageStartPublish,
		W.StopPublish AS PageStopPublish,
		CASE WHEN L.Status = 4 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS PagePendingPublish,
		L.CreatorName AS PageCreatedBy,
		W.ChangedByName AS PageChangedBy,
		W.fkFrameID AS PageTargetFrame,
		W.ChangedOnPublish AS PageChangedOnPublish,
		CASE WHEN W.Status = 6 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS  PageDelayedPublish,
		W.fkLanguageBranchID AS PageLanguageBranchID,
		W.DelayPublishUntil AS PageDelayPublishUntil
	FROM @ContentVersions AS CV
	INNER JOIN tblWorkContent AS W ON CV.VersionID = W.pkID 
	INNER JOIN tblContentLanguage AS L ON CV.ContentID = L.fkContentID
	WHERE 
		L.fkLanguageBranchID = W.fkLanguageBranchID
	ORDER BY L.fkContentID
	IF (@@ROWCOUNT = 0)
	BEGIN
		RETURN
	END
	/* Get common data for all versions of a content */
	SELECT
		CV.ContentID AS PageLinkID,
		CV.VersionID AS PageLinkWorkID,
		fkParentID  AS PageParentLinkID,
		fkContentTypeID AS PageTypeID,
		NULL AS PageTypeName,
		CONVERT(INT,VisibleInMenu) AS PageVisibleInMenu,
		ChildOrderRule AS PageChildOrderRule,
		0 AS PagePeerOrderRule,	-- No longer used
		PeerOrder AS PagePeerOrder,
		CONVERT(NVARCHAR(38),tblContent.ContentGUID) AS PageGUID,
		ArchiveContentGUID AS PageArchiveLinkID,
		ContentAssetsID,
		ContentOwnerID,
		CONVERT(INT,Deleted) AS PageDeleted,
		DeletedBy AS PageDeletedBy,
		DeletedDate AS PageDeletedDate,
		fkMasterLanguageBranchID AS PageMasterLanguageBranchID,
		CreatorName
	FROM @ContentVersions AS CV
	INNER JOIN tblContent ON CV.ContentID = tblContent.pkID
	WHERE CV.VersionID IS NOT NULL
	ORDER BY CV.ContentID
	IF (@@ROWCOUNT = 0)
	BEGIN
		RETURN
	END
		
	
	/* Get the properties for the specific versions*/
	SELECT
		CV.ContentID AS PageLinkID,
		CV.VersionID AS PageLinkWorkID,
		tblPropertyDefinition.Name AS PropertyName,
		tblPropertyDefinition.pkID as PropertyDefinitionID,
		ScopeName,
		CONVERT(INT, Boolean) AS Boolean,
		Number AS IntNumber,
		FloatNumber,
		P.ContentType AS PageType,
		ContentLink,
		LinkGuid,	
		Date AS DateValue,
		String,
		LongString,
		CV.LanguageBranchID AS PageLanguageBranchID
	FROM tblWorkContentProperty AS P 
	INNER JOIN @ContentVersions AS CV ON P.fkWorkContentID = CV.VersionID 
	INNER JOIN tblPropertyDefinition ON tblPropertyDefinition.pkID = P.fkPropertyDefinitionID
	WHERE NOT tblPropertyDefinition.fkContentTypeID IS NULL
	ORDER BY CV.ContentID
	/* Get the non language specific properties from master language*/
	SELECT
		CV.ContentID AS PageLinkID,
		CV.VersionID AS PageLinkWorkID,
		tblPropertyDefinition.Name AS PropertyName,
		tblPropertyDefinition.pkID as PropertyDefinitionID,
		ScopeName,
		CONVERT(INT, Boolean) AS Boolean,
		Number AS IntNumber,
		FloatNumber,
		P.ContentType AS PageType,
		ContentLink,
		LinkGuid,	
		Date AS DateValue,
		String,
		LongString,
		CV.LanguageBranchID AS PageLanguageBranchID
	FROM tblWorkContentProperty AS P
	INNER JOIN tblWorkContent AS W ON P.fkWorkContentID = W.pkID
	INNER JOIN @ContentVersions AS CV ON W.fkContentID = CV.ContentID
	INNER JOIN tblPropertyDefinition ON tblPropertyDefinition.pkID = P.fkPropertyDefinitionID
	WHERE NOT tblPropertyDefinition.fkContentTypeID IS NULL AND
		P.fkWorkContentID = CV.MasterVersionID AND tblPropertyDefinition.LanguageSpecific<3
	ORDER BY CV.ContentID
	/*Get category information*/
	SELECT DISTINCT
		CV.ContentID AS PageLinkID,
		CV.VersionID AS PageLinkWorkID,
		fkCategoryID,
		CategoryType
	FROM tblWorkContentCategory
	INNER JOIN tblWorkContent ON tblWorkContentCategory.fkWorkContentID = tblWorkContent.pkID
	INNER JOIN @ContentVersions AS CV ON CV.ContentID = tblWorkContent.fkContentID 
	INNER JOIN @ContentVersions AS MasterVersion ON CV.ContentID = MasterVersion.ContentID
	WHERE CategoryType=0 AND (CV.VersionID = tblWorkContent.pkID OR
	(MasterVersion.VersionID IS NULL AND tblWorkContentCategory.fkWorkContentID = MasterVersion.MasterVersionID 
		AND MasterVersion.LanguageBranchID <> CV.LanguageBranchID))
	ORDER BY CV.ContentID,fkCategoryID
	/* Get access information */
	SELECT
		CV.ContentID AS PageLinkID,
		CV.VersionID AS PageLinkWorkID,
		tblContentAccess.Name,
		IsRole,
		AccessMask
	FROM
		@ContentVersions as CV
	INNER JOIN 
	    tblContentAccess ON ContentID=tblContentAccess.fkContentID
	ORDER BY
		fkContentID
END
