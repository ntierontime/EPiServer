CREATE PROCEDURE dbo.editDeleteProperty
(
	@PageID			INT,
	@WorkPageID		INT,
	@PageDefinitionID	INT,
	@Override		BIT = 0,
	@LanguageBranch		NCHAR(17) = NULL,
	@ScopeName	NVARCHAR(450) = NULL
)
AS
BEGIN
	DECLARE @LangBranchID NCHAR(17);
	SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID = @LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END
	DECLARE @IsLanguagePublished BIT;
	IF EXISTS(SELECT fkContentID FROM tblContentLanguage 
		WHERE fkContentID = @PageID AND fkLanguageBranchID = CAST(@LangBranchID AS INT) AND [Status] = 4)
		SET @IsLanguagePublished = 1
	ELSE
		SET @IsLanguagePublished = 0
	
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE @retval INT
	SET @retval = 0
	
		IF (@WorkPageID IS NOT NULL)
		BEGIN
			/* This only applies to categories, but since PageDefinitionID is unique
				between all properties it is safe to blindly delete like this */
			DELETE FROM
				tblWorkContentCategory
			WHERE
				fkWorkContentID = @WorkPageID
			AND
				CategoryType = @PageDefinitionID
			AND
				(@ScopeName IS NULL OR ScopeName = @ScopeName)
			DELETE FROM
				tblWorkProperty
			WHERE
				fkWorkPageID = @WorkPageID
			AND
				fkPageDefinitionID = @PageDefinitionID
			AND 
				((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
		END
		ELSE
		BEGIN
			/* Might be dynamic properties */
			DELETE FROM
				tblContentCategory
			WHERE
				fkContentID = @PageID
			AND
				CategoryType = @PageDefinitionID
			AND
				(@ScopeName IS NULL OR ScopeName = @ScopeName)
			AND
			(
				@LanguageBranch IS NULL
			OR
				@LangBranchID = fkLanguageBranchID
			)
			IF (@Override = 1)
			BEGIN
				DELETE FROM
					tblProperty
				WHERE
					fkPageDefinitionID = @PageDefinitionID
				AND
					fkPageID IN (SELECT fkChildID FROM tblTree WHERE fkParentID = @PageID)
				AND
				(
					@LanguageBranch IS NULL
				OR
					@LangBranchID = tblProperty.fkLanguageBranchID
				)
				AND 
					((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
				SET @retval = 1
			END
		END
		
		/* When no version is published we save value in tblProperty as well, so the property also need to be removed from tblProperty*/
		IF (@WorkPageID IS NULL OR @IsLanguagePublished = 0)
		BEGIN
			DELETE FROM
				tblProperty
			WHERE
				fkPageID = @PageID
			AND 
				fkPageDefinitionID = @PageDefinitionID  
			AND
			(
				@LanguageBranch IS NULL
			OR
				@LangBranchID = tblProperty.fkLanguageBranchID
			)
			AND
				((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
		END
			
	RETURN @retval
END
