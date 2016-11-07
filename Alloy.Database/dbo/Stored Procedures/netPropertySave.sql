CREATE PROCEDURE [dbo].[netPropertySave]
(
	@PageID				INT,
	@WorkPageID			INT,
	@PageDefinitionID	INT,
	@Override			BIT,
	@LanguageBranch		NCHAR(17) = NULL,
	@ScopeName			NVARCHAR(450) = NULL,
--Per Type:
	@Number				INT = NULL,
	@Boolean			BIT = 0,
	@Date				DATETIME = NULL,
	@FloatNumber		FLOAT = NULL,
	@PageType			INT = NULL,
	@String				NVARCHAR(450) = NULL,
	@LinkGuid			uniqueidentifier = NULL,
	@PageLink			INT = NULL,
	@LongString			NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @LangBranchID NCHAR(17);
	IF (@WorkPageID <> 0)
		SELECT @LangBranchID = fkLanguageBranchID FROM tblWorkPage WHERE pkID = @WorkPageID
	ELSE
		SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = 1
	END
	DECLARE @IsLanguagePublished BIT;
	IF EXISTS(SELECT fkContentID FROM tblContentLanguage 
		WHERE fkContentID = @PageID AND fkLanguageBranchID = CAST(@LangBranchID AS INT) AND Status = 4)
		SET @IsLanguagePublished = 1
	ELSE
		SET @IsLanguagePublished = 0
	
	DECLARE @DynProp INT
	DECLARE @retval	INT
	SET @retval = 0
	
		SELECT
			@DynProp = pkID
		FROM
			tblPageDefinition
		WHERE
			pkID = @PageDefinitionID
		AND
			fkPageTypeID IS NULL
		IF (@WorkPageID IS NOT NULL)
		BEGIN
			/* Never store dynamic properties in work table */
			IF (@DynProp IS NOT NULL)
				GOTO cleanup
				
			/* Insert or update property */
			IF EXISTS(SELECT fkWorkPageID FROM tblWorkProperty 
				WHERE fkWorkPageID=@WorkPageID AND fkPageDefinitionID=@PageDefinitionID AND ((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName)))
				UPDATE
					tblWorkProperty
				SET
					ScopeName = @ScopeName,
					Number = @Number,
					Boolean = @Boolean,
					[Date] = @Date,
					FloatNumber = @FloatNumber,
					PageType = @PageType,
					String = @String,
					LinkGuid = @LinkGuid,
					PageLink = @PageLink,
					LongString = @LongString
				WHERE
					fkWorkPageID = @WorkPageID
				AND
					fkPageDefinitionID = @PageDefinitionID
				AND 
					((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
			ELSE
				INSERT INTO
					tblWorkProperty
					(fkWorkPageID,
					fkPageDefinitionID,
					ScopeName,
					Number,
					Boolean,
					[Date],
					FloatNumber,
					PageType,
					String,
					LinkGuid,
					PageLink,
					LongString)
				VALUES
					(@WorkPageID,
					@PageDefinitionID,
					@ScopeName,
					@Number,
					@Boolean,
					@Date,
					@FloatNumber,
					@PageType,
					@String,
					@LinkGuid,
					@PageLink,
					@LongString)
		END
		
		/* For published or languages where no version is published we save value in tblProperty as well. Reason for this is that if when page is loaded
		through tblProperty (typically netPageListPaged) the page gets populated correctly. */
		IF (@WorkPageID IS NULL OR @IsLanguagePublished = 0)
		BEGIN
			/* Insert or update property */
			IF EXISTS(SELECT fkPageID FROM tblProperty 
				WHERE fkPageID = @PageID AND fkPageDefinitionID = @PageDefinitionID  AND
					((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName)) AND @LangBranchID = tblProperty.fkLanguageBranchID)
				UPDATE
					tblProperty
				SET
					ScopeName = @ScopeName,
					Number = @Number,
					Boolean = @Boolean,
					[Date] = @Date,
					FloatNumber = @FloatNumber,
					PageType = @PageType,
					String = @String,
					LinkGuid = @LinkGuid,
					PageLink = @PageLink,
					LongString = @LongString
				WHERE
					fkPageID = @PageID
				AND
					fkPageDefinitionID = @PageDefinitionID
				AND 
					((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
				AND
					@LangBranchID = tblProperty.fkLanguageBranchID
			ELSE
				INSERT INTO
					tblProperty
					(fkPageID,
					fkPageDefinitionID,
					ScopeName,
					Number,
					Boolean,
					[Date],
					FloatNumber,
					PageType,
					String,
					LinkGuid,
					PageLink,
					LongString,
					fkLanguageBranchID)
				VALUES
					(@PageID,
					@PageDefinitionID,
					@ScopeName,
					@Number,
					@Boolean,
					@Date,
					@FloatNumber,
					@PageType,
					@String,
					@LinkGuid,
					@PageLink,
					@LongString,
					@LangBranchID)
				
			/* Override dynamic property definitions below the current level */
			IF (@DynProp IS NOT NULL)
			BEGIN
				IF (@Override = 1)
					DELETE FROM
						tblProperty
					WHERE
						fkPageDefinitionID = @PageDefinitionID
					AND
					(	
						@LanguageBranch IS NULL
					OR
						@LangBranchID = tblProperty.fkLanguageBranchID
					)
					AND
						fkPageID
					IN
						(SELECT fkChildID FROM tblTree WHERE fkParentID = @PageID)
				SET @retval = 1
			END
		END
cleanup:		
		
	RETURN @retval
END
