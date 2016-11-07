CREATE PROCEDURE [dbo].[editCreateContentVersion]
(
	@ContentID			INT,
	@WorkContentID		INT,
	@UserName		NVARCHAR(255),
	@MaxVersions	INT = NULL,
	@SavedDate		DATETIME,
	@LanguageBranch	NCHAR(17)
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE @NewWorkContentID		INT
	DECLARE @DeleteWorkContentID	INT
	DECLARE @ObsoleteVersions	INT
	DECLARE @retval				INT
	DECLARE @IsMasterLang		BIT
	DECLARE @LangBranchID		INT
	
	SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL
	BEGIN
		RAISERROR (N'editCreateContentVersion: LanguageBranchID is null, possibly empty table tblLanguageBranch', 16, 1, @WorkContentID)
		RETURN 0
	END
	IF (@WorkContentID IS NULL OR @WorkContentID=0 )
	BEGIN
		/* If we have a published version use it, else the latest saved version */
		IF EXISTS(SELECT * FROM tblContentLanguage WHERE Status = 4 AND fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID)
			SELECT @WorkContentID=[Version] FROM tblContentLanguage WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID
		ELSE
			SELECT TOP 1 @WorkContentID=pkID FROM tblWorkContent WHERE fkContentID=@ContentID AND fkLanguageBranchID=@LangBranchID ORDER BY Saved DESC
	END
	IF EXISTS( SELECT * FROM tblContent WHERE pkID=@ContentID AND fkMasterLanguageBranchID IS NULL )
		UPDATE tblContent SET fkMasterLanguageBranchID=@LangBranchID WHERE pkID=@ContentID
	
	SELECT @IsMasterLang = CASE WHEN @LangBranchID=fkMasterLanguageBranchID THEN 1 ELSE 0 END FROM tblContent WHERE pkID=@ContentID
		
		/* Create a new version of this content */
		INSERT INTO tblWorkContent
			(fkContentID,
			fkMasterVersionID,
			ChangedByName,
			ContentLinkGUID,
			fkFrameID,
			ArchiveContentGUID,
			Name,
			LinkURL,
			ExternalURL,
			VisibleInMenu,
			LinkType,
			Created,
			Saved,
			StartPublish,
			StopPublish,
			ChildOrderRule,
			PeerOrder,
			fkLanguageBranchID,
			URLSegment)
		SELECT 
			fkContentID,
			@WorkContentID,
			@UserName,
			ContentLinkGUID,
			fkFrameID,
			ArchiveContentGUID,
			Name,
			LinkURL,
			ExternalURL,
			VisibleInMenu,
			LinkType,
			Created,
			@SavedDate,
			StartPublish,
			StopPublish,
			ChildOrderRule,
			PeerOrder,
			@LangBranchID,
			URLSegment
		FROM 
			tblWorkContent 
		WHERE 
			pkID=@WorkContentID
	
		IF (@@ROWCOUNT = 1)
		BEGIN
			/* Remember version number */
			SET @NewWorkContentID= SCOPE_IDENTITY() 
			/* Copy all properties as well */
			INSERT INTO tblWorkContentProperty
				(fkPropertyDefinitionID,
				fkWorkContentID,
				ScopeName,
				Boolean,
				Number,
				FloatNumber,
				ContentType,
				ContentLink,
				Date,
				String,
				LongString,
                LinkGuid)          
			SELECT
				fkPropertyDefinitionID,
				@NewWorkContentID,
				ScopeName,
				Boolean,
				Number,
				FloatNumber,
				ContentType,
				ContentLink,
				Date,
				String,
				LongString,
                LinkGuid
			FROM
				tblWorkContentProperty
			INNER JOIN tblPropertyDefinition ON tblPropertyDefinition.pkID=tblWorkContentProperty.fkPropertyDefinitionID
			WHERE
				fkWorkContentID=@WorkContentID
				AND (tblPropertyDefinition.LanguageSpecific>2 OR @IsMasterLang=1)--Only lang specific on non-master 
				
			/* Finally take care of categories */
			INSERT INTO tblWorkContentCategory
				(fkWorkContentID,
				fkCategoryID,
				CategoryType,
				ScopeName)
			SELECT
				@NewWorkContentID,
				fkCategoryID,
				CategoryType,
				ScopeName
			FROM
				tblWorkContentCategory
			WHERE
				fkWorkContentID=@WorkContentID
				AND (CategoryType<>0 OR @IsMasterLang=1)--No content category on languages
		END
		ELSE
		BEGIN
			/* We did not have anything corresponding to the WorkContentID, create new work content from tblContent */
			INSERT INTO tblWorkContent
				(fkContentID,
				ChangedByName,
				ContentLinkGUID,
				fkFrameID,
				ArchiveContentGUID,
				Name,
				LinkURL,
				ExternalURL,
				VisibleInMenu,
				LinkType,
				Created,
				Saved,
				StartPublish,
				StopPublish,
				ChildOrderRule,
				PeerOrder,
				fkLanguageBranchID,
				URLSegment)
			SELECT 
				@ContentID,
				COALESCE(@UserName, tblContentLanguage.CreatorName),
				tblContentLanguage.ContentLinkGUID,
				tblContentLanguage.fkFrameID,
				tblContent.ArchiveContentGUID,
				tblContentLanguage.Name,
				tblContentLanguage.LinkURL,
				tblContentLanguage.ExternalURL,
				tblContent.VisibleInMenu,
				CASE tblContentLanguage.AutomaticLink 
					WHEN 1 THEN 
						(CASE
							WHEN tblContentLanguage.ContentLinkGUID IS NULL THEN 0	/* EPnLinkNormal */
							WHEN tblContentLanguage.FetchData=1 THEN 4				/* EPnLinkFetchdata */
							ELSE 1								/* EPnLinkShortcut */
						END)
					ELSE
						(CASE 
							WHEN tblContentLanguage.LinkURL=N'#' THEN 3				/* EPnLinkInactive */
							ELSE 2								/* EPnLinkExternal */
						END)
				END AS LinkType ,
				tblContentLanguage.Created,
				@SavedDate,
				tblContentLanguage.StartPublish,
				tblContentLanguage.StopPublish,
				tblContent.ChildOrderRule,
				tblContent.PeerOrder,
				@LangBranchID,
				tblContentLanguage.URLSegment
			FROM tblContentLanguage
			INNER JOIN tblContent ON tblContent.pkID=tblContentLanguage.fkContentID
			WHERE 
				tblContentLanguage.fkContentID=@ContentID AND tblContentLanguage.fkLanguageBranchID=@LangBranchID
			IF (@@ROWCOUNT = 1)
			BEGIN
				/* Remember version number */
				SET @NewWorkContentID= SCOPE_IDENTITY() 
				/* Copy all non-dynamic properties as well */
				INSERT INTO tblWorkContentProperty
					(fkPropertyDefinitionID,
					fkWorkContentID,
					ScopeName,
					Boolean,
					Number,
					FloatNumber,
					ContentType,
					ContentLink,
					Date,
					String,
					LongString,
                    LinkGuid)
				SELECT
					P.fkPropertyDefinitionID,
					@NewWorkContentID,
					P.ScopeName,
					P.Boolean,
					P.Number,
					P.FloatNumber,
					P.ContentType,
					P.ContentLink,
					P.Date,
					P.String,
					P.LongString,
                    P.LinkGuid
				FROM
					tblContentProperty AS P
				INNER JOIN
					tblPropertyDefinition AS PD ON P.fkPropertyDefinitionID=PD.pkID
				WHERE
					P.fkContentID=@ContentID AND (PD.fkContentTypeID IS NOT NULL)
					AND P.fkLanguageBranchID = @LangBranchID
					AND (PD.LanguageSpecific>2 OR @IsMasterLang=1)--Only lang specific on non-master 
					
				/* Finally take care of categories */
				INSERT INTO tblWorkContentCategory
					(fkWorkContentID,
					fkCategoryID,
					CategoryType)
				SELECT DISTINCT
					@NewWorkContentID,
					fkCategoryID,
					CategoryType
				FROM
					tblContentCategory
				LEFT JOIN
					tblPropertyDefinition AS PD ON tblContentCategory.CategoryType = PD.pkID
				WHERE
					tblContentCategory.fkContentID=@ContentID 
					AND (PD.fkContentTypeID IS NOT NULL OR tblContentCategory.CategoryType = 0) --Not dynamic properties
					AND (PD.LanguageSpecific=1 OR @IsMasterLang=1) --No content category on languages
			END
			ELSE
			BEGIN
				RAISERROR (N'Failed to create new version for content %d', 16, 1, @ContentID)
				RETURN 0
			END
		END
	/*If there is no version set for tblContentLanguage set it to this version*/
	UPDATE tblContentLanguage SET Version = @NewWorkContentID
	WHERE fkContentID = @ContentID AND fkLanguageBranchID = @LangBranchID AND Version IS NULL
		
	RETURN @NewWorkContentID
END
