CREATE PROCEDURE [dbo].[editSaveContentVersionData]
(
	@WorkContentID		INT,
	@UserName			NVARCHAR(255),
	@Saved				DATETIME,
	@Name				NVARCHAR(255)		= NULL,
	@ExternalURL		NVARCHAR(255)		= NULL,
	@Created			DATETIME			= NULL,
	@Changed			BIT					= 0,
	@StartPublish		DATETIME			= NULL,
	@StopPublish		DATETIME			= NULL,
	@ChildOrder			INT					= 3,
	@PeerOrder			INT					= 100,
	@ContentLinkGUID	UNIQUEIDENTIFIER	= NULL,
	@LinkURL			NVARCHAR(255)		= NULL,
	@BlobUri			NVARCHAR(255)		= NULL,
	@ThumbnailUri		NVARCHAR(255)		= NULL,
	@LinkType			INT					= 0,
	@FrameID			INT					= NULL,
	@VisibleInMenu		BIT					= NULL,
	@ArchiveContentGUID	UNIQUEIDENTIFIER	= NULL,
	@ContentAssetsID	UNIQUEIDENTIFIER	= NULL,
	@ContentOwnerID		UNIQUEIDENTIFIER	= NULL,
	@URLSegment			NVARCHAR(255)		= NULL,
	@SetStartPublish    BIT					= 1
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @ChangedDate			DATETIME
	DECLARE @ContentID				INT
	DECLARE @ContentTypeID			INT
	DECLARE @ParentID				INT
	DECLARE @AssetsID				UNIQUEIDENTIFIER
	DECLARE @OwnerID				UNIQUEIDENTIFIER
	DECLARE @CurrentLangBranchID	INT
	DECLARE @IsMasterLang			BIT
	
	/* Pull some useful information from the published Content */
	SELECT
		@ContentID				= fkContentID,
		@ParentID				= fkParentID,
		@ContentTypeID			= fkContentTypeID,
		@AssetsID				= ContentAssetsID,
		@OwnerID				= ContentOwnerID,
		@IsMasterLang			= CASE WHEN tblContent.fkMasterLanguageBranchID=tblWorkContent.fkLanguageBranchID THEN 1 ELSE 0 END,
		@CurrentLangBranchID	= fkLanguageBranchID
	FROM
		tblWorkContent
	INNER JOIN tblContent ON tblContent.pkID=tblWorkContent.fkContentID
	INNER JOIN tblContentType ON tblContentType.pkID=tblContent.fkContentTypeID
	WHERE
		tblWorkContent.pkID=@WorkContentID
	
	if (@ContentID IS NULL)
	BEGIN
		RAISERROR (N'editSaveContentVersionData: The WorkContentId dosen´t exist (WorkContentID=%d)', 16, 1, @WorkContentID)
		RETURN -1
	END			
		IF ((@AssetsID IS NULL) AND (@ContentAssetsID IS NOT NULL))
		BEGIN
			UPDATE
				tblContent
			SET
				ContentAssetsID = @ContentAssetsID
			WHERE
				pkID=@ContentID
		END
		IF ((@OwnerID IS NULL) AND (@ContentOwnerID IS NOT NULL))
		BEGIN
			UPDATE
				tblContent
			SET
				ContentOwnerID = @ContentOwnerID
			WHERE
				pkID=@ContentID
		END
		/* Set new values for work Content */
		UPDATE
			tblWorkContent
		SET
			ChangedByName		= @UserName,
			ContentLinkGUID		= @ContentLinkGUID,
			ArchiveContentGUID	= @ArchiveContentGUID,
			fkFrameID			= @FrameID,
			Name				= @Name,
			LinkURL				= @LinkURL,
			BlobUri				= @BlobUri,
			ThumbnailUri		= @ThumbnailUri,
			ExternalURL			= @ExternalURL,
			URLSegment			= @URLSegment,
			VisibleInMenu		= @VisibleInMenu,
			LinkType			= @LinkType,
			Created				= COALESCE(@Created, Created),
			Saved				= @Saved,
			StartPublish		= CASE WHEN @SetStartPublish = 1 THEN @StartPublish ELSE StartPublish END,
			StopPublish			= @StopPublish,
			ChildOrderRule		= @ChildOrder,
			PeerOrder			= COALESCE(@PeerOrder, PeerOrder),
			ChangedOnPublish	= @Changed
		WHERE
			pkID=@WorkContentID
		
		IF EXISTS(SELECT * FROM tblContentLanguage WHERE fkContentID=@ContentID AND fkLanguageBranchID=@CurrentLangBranchID AND Status <> 4)
		BEGIN
			UPDATE
				tblContentLanguage
			SET
				Name			= @Name,
				Created			= @Created,
				Saved			= @Saved,
				URLSegment		= @URLSegment,
				LinkURL			= @LinkURL,
				BlobUri			= @BlobUri,
				ThumbnailUri	= @ThumbnailUri,
				StartPublish	= CASE WHEN @SetStartPublish = 1 THEN @StartPublish ELSE StartPublish END,
				StopPublish		= @StopPublish,
				ExternalURL		= Lower(@ExternalURL),
				fkFrameID		= @FrameID,
				AutomaticLink	= CASE WHEN @LinkType = 2 OR @LinkType = 3 THEN 0 ELSE 1 END,
				FetchData		= CASE WHEN @LinkType = 4 THEN 1 ELSE 0 END
			WHERE
				fkContentID=@ContentID AND fkLanguageBranchID=@CurrentLangBranchID
			/* Set some values needed for proper display in edit tree even though we have not yet published the Content */
			IF @IsMasterLang = 1
			BEGIN
				UPDATE
					tblContent
				SET
					ArchiveContentGUID	= @ArchiveContentGUID,
					ChildOrderRule		= @ChildOrder,
					PeerOrder			= @PeerOrder,
					VisibleInMenu		= @VisibleInMenu
				WHERE
					pkID=@ContentID 
			END
		END
END
