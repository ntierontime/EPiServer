CREATE PROCEDURE dbo.netPageDefinitionSave
(
	@PageDefinitionID      INT OUTPUT,
	@PageTypeID            INT,
	@Name                  NVARCHAR(100),
	@PageDefinitionTypeID  INT,
	@Required              BIT = NULL,
	@Advanced              INT = NULL,
	@Searchable            BIT = NULL,
	@DefaultValueType      INT = NULL,
	@EditCaption           NVARCHAR(255) = NULL,
	@HelpText              NVARCHAR(2000) = NULL,
	@ObjectProgID          NVARCHAR(255) = NULL,
	@LongStringSettings    INT = NULL,
	@SettingsID            UNIQUEIDENTIFIER = NULL,
	@FieldOrder            INT = NULL,
	@Type                  INT = NULL OUTPUT,
	@OldType               INT = NULL OUTPUT,
	@LanguageSpecific      INT = 0,
	@DisplayEditUI         BIT = NULL,
	@ExistsOnModel         BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	SELECT @OldType = tblPageDefinitionType.Property 
	FROM tblPageDefinition
	INNER JOIN tblPageDefinitionType ON tblPageDefinitionType.pkID=tblPageDefinition.fkPageDefinitionTypeID
	WHERE tblPageDefinition.pkID=@PageDefinitionID
	SELECT @Type = Property FROM tblPageDefinitionType WHERE pkID=@PageDefinitionTypeID
	IF @Type IS NULL
		RAISERROR('Cannot find data type',16,1)
	IF @PageTypeID=0
		SET @PageTypeID = NULL
	IF @PageDefinitionID = 0 AND @ExistsOnModel = 1
	BEGIN
		SET @PageDefinitionID = ISNULL((SELECT pkID FROM tblPageDefinition where Name = @Name AND fkPageTypeID = @PageTypeID), @PageDefinitionID)
	END
	IF @PageDefinitionID=0
	BEGIN	
		INSERT INTO tblPageDefinition
		(
			fkPageTypeID,
			fkPageDefinitionTypeID,
			Name,
			Property,
			Required,
			Advanced,
			Searchable,
			DefaultValueType,
			EditCaption,
			HelpText,
			ObjectProgID,
			LongStringSettings,
			SettingsID,
			FieldOrder,
			LanguageSpecific,
			DisplayEditUI,
			ExistsOnModel
		)
		VALUES
		(
			@PageTypeID,
			@PageDefinitionTypeID,
			@Name,
			@Type,
			@Required,
			@Advanced,
			@Searchable,
			@DefaultValueType,
			@EditCaption,
			@HelpText,
			@ObjectProgID,
			@LongStringSettings,
			@SettingsID,
			@FieldOrder,
			@LanguageSpecific,
			@DisplayEditUI,
			@ExistsOnModel
		)
		SET @PageDefinitionID =  SCOPE_IDENTITY() 
	END
	ELSE
	BEGIN
		UPDATE tblPageDefinition SET
			Name 		= @Name,
			fkPageDefinitionTypeID	= @PageDefinitionTypeID,
			Property 	= @Type,
			Required 	= @Required,
			Advanced 	= @Advanced,
			Searchable 	= @Searchable,
			DefaultValueType = @DefaultValueType,
			EditCaption 	= @EditCaption,
			HelpText 	= @HelpText,
			ObjectProgID 	= @ObjectProgID,
			LongStringSettings = @LongStringSettings,
			SettingsID = @SettingsID,
			LanguageSpecific = @LanguageSpecific,
			FieldOrder = @FieldOrder,
			DisplayEditUI = @DisplayEditUI,
			ExistsOnModel = @ExistsOnModel
		WHERE pkID=@PageDefinitionID
	END
	DELETE FROM tblPropertyDefault WHERE fkPageDefinitionID=@PageDefinitionID
	IF @LanguageSpecific<3
	BEGIN
		/* NOTE: Here we take into consideration that language neutral dynamic properties are always stored on language 
			with id 1 (which perhaps should be changed and in that case the special handling here could be removed). */
		IF @PageTypeID IS NULL
		BEGIN
			DELETE tblProperty
			FROM tblProperty
			INNER JOIN tblPage ON tblPage.pkID=tblProperty.fkPageID
			WHERE fkPageDefinitionID=@PageDefinitionID AND tblProperty.fkLanguageBranchID<>1
		END
		ELSE
		BEGIN
			DELETE tblProperty
			FROM tblProperty
			INNER JOIN tblPage ON tblPage.pkID=tblProperty.fkPageID
			WHERE fkPageDefinitionID=@PageDefinitionID AND tblProperty.fkLanguageBranchID<>tblPage.fkMasterLanguageBranchID
		END
		DELETE tblWorkProperty
		FROM tblWorkProperty
		INNER JOIN tblWorkPage ON tblWorkProperty.fkWorkPageID=tblWorkPage.pkID
		INNER JOIN tblPage ON tblPage.pkID=tblWorkPage.fkPageID
		WHERE fkPageDefinitionID=@PageDefinitionID AND tblWorkPage.fkLanguageBranchID<>tblPage.fkMasterLanguageBranchID
		DELETE 
			tblCategoryPage
		FROM
			tblCategoryPage
		INNER JOIN
			tblPage
		ON
			tblPage.pkID = tblCategoryPage.fkPageID
		WHERE
			CategoryType = @PageDefinitionID
		AND
			tblCategoryPage.fkLanguageBranchID <> tblPage.fkMasterLanguageBranchID
		DELETE 
			tblWorkCategory
		FROM
			tblWorkCategory
		INNER JOIN 
			tblWorkPage
		ON
			tblWorkCategory.fkWorkPageID = tblWorkPage.pkID
		INNER JOIN
			tblPage
		ON
			tblPage.pkID = tblWorkPage.fkPageID
		WHERE
			CategoryType = @PageDefinitionID
		AND
			tblWorkPage.fkLanguageBranchID <> tblPage.fkMasterLanguageBranchID
	END
END
