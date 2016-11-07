CREATE PROCEDURE [dbo].[netContentTypeSave]
(
	@ContentTypeID			INT,
	@ContentTypeGUID		UNIQUEIDENTIFIER,
	@Name				NVARCHAR(50),
	@DisplayName		NVARCHAR(50)    = NULL,
	@Description		NVARCHAR(255)	= NULL,
	@DefaultWebFormTemplate	NVARCHAR(1024)   = NULL,
	@DefaultMvcController NVARCHAR(1024)   = NULL,
	@DefaultMvcPartialView			NVARCHAR(255)   = NULL,
	@Filename			NVARCHAR(255)   = NULL,
	@Available			BIT				= NULL,
	@SortOrder			INT				= NULL,
	@ModelType			NVARCHAR(1024)	= NULL,
	
	@DefaultID			INT				= NULL,
	@DefaultName 		NVARCHAR(100)	= NULL,
	@StartPublishOffset	INT				= NULL,
	@StopPublishOffset	INT				= NULL,
	@VisibleInMenu		BIT				= NULL,
	@PeerOrder 			INT				= NULL,
	@ChildOrderRule 	INT				= NULL,
	@ArchiveContentID 		INT				= NULL,
	@FrameID 			INT				= NULL,
	@ACL				NVARCHAR(MAX)	= NULL,	
	@ContentType		INT				= 0,
	@Created			DATETIME
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @IdString NVARCHAR(255)
	
	IF @ContentTypeID <= 0
	BEGIN
		SET @ContentTypeID = ISNULL((SELECT pkID FROM tblContentType where Name = @Name), @ContentTypeID)
	END
	IF (@ContentTypeID <= 0)
	BEGIN
		SELECT TOP 1 @IdString=IdString FROM tblContentType
		INSERT INTO tblContentType
			(Name,
			DisplayName,
			DefaultMvcController,
			DefaultWebFormTemplate,
			DefaultMvcPartialView,
			Description,
			Available,
			SortOrder,
			ModelType,
			Filename,
			IdString,
			ContentTypeGUID,
			ACL,
			ContentType,
			Created)
		VALUES
			(@Name,
			@DisplayName,
			@DefaultMvcController,
			@DefaultWebFormTemplate,
			@DefaultMvcPartialView,
			@Description,
			@Available,
			@SortOrder,
			@ModelType,
			@Filename,
			@IdString,
			@ContentTypeGUID,
			@ACL,
			@ContentType,
			@Created)
		SET @ContentTypeID= SCOPE_IDENTITY() 
		
	END
	ELSE
	BEGIN
		BEGIN
			UPDATE tblContentType
			SET
				Name=@Name,
				DisplayName=@DisplayName,
				Description=@Description,
				DefaultWebFormTemplate=@DefaultWebFormTemplate,
				DefaultMvcController=@DefaultMvcController,
				DefaultMvcPartialView=@DefaultMvcPartialView,
				Available=@Available,
				SortOrder=@SortOrder,
				ModelType = @ModelType,
				Filename = @Filename,
				ACL=@ACL,
				ContentType = @ContentType,
				@ContentTypeGUID = ContentTypeGUID
			WHERE
				pkID=@ContentTypeID
		END
	END
	IF (@DefaultID IS NULL)
	BEGIN
		DELETE FROM tblContentTypeDefault WHERE fkContentTypeID=@ContentTypeID
	END
	ELSE
	BEGIN
		IF (EXISTS (SELECT pkID FROM tblContentTypeDefault WHERE fkContentTypeID=@ContentTypeID))
		BEGIN
			UPDATE tblContentTypeDefault SET
				Name 				= @DefaultName,
				StartPublishOffset 	= @StartPublishOffset,
				StopPublishOffset 	= @StopPublishOffset,
				VisibleInMenu 		= @VisibleInMenu,
				PeerOrder 			= @PeerOrder,
				ChildOrderRule 		= @ChildOrderRule,
				fkArchiveContentID 	= @ArchiveContentID,
				fkFrameID 			= @FrameID
			WHERE fkContentTypeID=@ContentTypeID
		END
		ELSE
		BEGIN
			INSERT INTO tblContentTypeDefault 
				(fkContentTypeID,
				Name,
				StartPublishOffset,
				StopPublishOffset,
				VisibleInMenu,
				PeerOrder,
				ChildOrderRule,
				fkArchiveContentID,
				fkFrameID)
			VALUES
				(@ContentTypeID,
				@DefaultName,
				@StartPublishOffset,
				@StopPublishOffset,
				@VisibleInMenu,
				@PeerOrder,
				@ChildOrderRule,
				@ArchiveContentID,
				@FrameID)
		END
	END
		
	SELECT @ContentTypeID AS "ID", @ContentTypeGUID AS "GUID"
END
