CREATE PROCEDURE dbo.netPropertySearchValue
(
	@PageID			INT,
	@PropertyName 	NVARCHAR(255),
	@Equals			BIT = 0,
	@NotEquals		BIT = 0,
	@GreaterThan	BIT = 0,
	@LessThan		BIT = 0,
	@Boolean		BIT = NULL,
	@Number			INT = NULL,
	@FloatNumber	FLOAT = NULL,
	@PageType		INT = NULL,
	@PageLink		INT = NULL,
	@Date			DATETIME = NULL,
	@LanguageBranch	NCHAR(17) = NULL
)
AS
BEGIN
	DECLARE @LangBranchID NCHAR(17);
	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END
		
	IF NOT @Boolean IS NULL
		SELECT DISTINCT(tblProperty.fkPageID)
		FROM       tblProperty
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
		INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
		INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
		INNER JOIN tblPageLanguage on tblPageLanguage.fkPageID=tblProperty.fkPageID
		WHERE tblPageType.ContentType = 0
		AND tblTree.fkParentID=@PageID 
		AND tblPageDefinition.Name=@PropertyName
		AND Property = 0
		AND Boolean = @Boolean
		AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
	ELSE IF NOT @Number IS NULL
		SELECT DISTINCT(tblProperty.fkPageID)
		FROM       tblProperty
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
		INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
		INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
		INNER JOIN tblPageLanguage on tblPageLanguage.fkPageID=tblProperty.fkPageID
		WHERE tblPageType.ContentType = 0
		AND tblTree.fkParentID=@PageID 
		AND tblPageDefinition.Name=@PropertyName
		AND Property = 1
		AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND 
		(
			(@Equals=1 		AND (Number = @Number OR (@Number IS NULL AND Number IS NULL)))
			OR
			(@GreaterThan=1 	AND Number > @Number)
			OR
			(@LessThan=1 		AND Number < @Number)
			OR
			(@NotEquals=1		AND Number <> @Number)
		)
	ELSE IF NOT @FloatNumber IS NULL
		SELECT DISTINCT(tblProperty.fkPageID)
		FROM       tblProperty
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
		INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
		INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
		INNER JOIN tblPageLanguage on tblPageLanguage.fkPageID=tblProperty.fkPageID
		WHERE tblPageType.ContentType = 0
		AND tblTree.fkParentID=@PageID 
		AND tblPageDefinition.Name=@PropertyName
		AND Property = 2
		AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND
		(
			(@Equals=1 		AND (FloatNumber = @FloatNumber OR (@FloatNumber IS NULL AND FloatNumber IS NULL)))
			OR
			(@GreaterThan=1 	AND FloatNumber > @FloatNumber)
			OR
			(@LessThan=1 		AND FloatNumber < @FloatNumber)
			OR
			(@NotEquals=1		AND FloatNumber <> @FloatNumber)
		)
	ELSE IF NOT @PageType IS NULL
		SELECT DISTINCT(tblProperty.fkPageID)
		FROM       tblProperty
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
		INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
		INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
		INNER JOIN tblPageLanguage on tblPageLanguage.fkPageID=tblProperty.fkPageID
		WHERE tblPageType.ContentType = 0
		AND tblTree.fkParentID=@PageID 
		AND tblPageDefinition.Name=@PropertyName
		AND Property = 3
		AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND
		(
			(@Equals=1 		AND (PageType = @PageType OR (@PageType IS NULL AND PageType IS NULL)))
			OR
			(@GreaterThan=1 	AND PageType > @PageType)
			OR
			(@LessThan=1 		AND PageType < @PageType)
			OR
			(@NotEquals=1		AND PageType <> @PageType)
		)
	ELSE IF NOT @PageLink IS NULL
		SELECT DISTINCT(tblProperty.fkPageID)
		FROM       tblProperty
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
		INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
		INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
		INNER JOIN tblPageLanguage on tblPageLanguage.fkPageID=tblProperty.fkPageID
		WHERE tblPageType.ContentType = 0
		AND tblTree.fkParentID=@PageID 
		AND tblPageDefinition.Name=@PropertyName
		AND Property = 4
		AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND
		(
			(@Equals=1 		AND (PageLink = @PageLink OR (@PageLink IS NULL AND PageLink IS NULL)))
			OR
			(@GreaterThan=1 	AND PageLink > @PageLink)
			OR
			(@LessThan=1 		AND PageLink < @PageLink)
			OR
			(@NotEquals=1		AND PageLink <> @PageLink)
		)
	ELSE IF NOT @Date IS NULL
		SELECT DISTINCT(tblProperty.fkPageID)
		FROM       tblProperty
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
		INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
		INNER JOIN tblTree ON tblTree.fkChildID=tblProperty.fkPageID
		INNER JOIN tblPageLanguage on tblPageLanguage.fkPageID=tblProperty.fkPageID
		WHERE tblPageType.ContentType = 0
		AND tblTree.fkParentID=@PageID 
		AND tblPageDefinition.Name=@PropertyName
		AND Property = 5
		AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
		AND
		(
			(@Equals=1 		AND ([Date] = @Date OR (@Date IS NULL AND [Date] IS NULL)))
			OR
			(@GreaterThan=1 	AND [Date] > @Date)
			OR
			(@LessThan=1 		AND [Date] < @Date)
			OR
			(@NotEquals=1		AND [Date] <> @Date)
		)
	ELSE
		SELECT DISTINCT(tblProperty.fkPageID)
		FROM tblProperty
		INNER JOIN tblPageLanguage on tblPageLanguage.fkPageID=tblProperty.fkPageID
		INNER JOIN tblPageDefinition ON tblPageDefinition.pkID=tblProperty.fkPageDefinitionID
		INNER JOIN tblPageType ON tblPageDefinition.fkPageTypeID=tblPageType.pkID
		WHERE tblPageType.ContentType = 0
		AND (@LangBranchID=-1 OR tblProperty.fkLanguageBranchID=@LangBranchID OR tblPageDefinition.LanguageSpecific<3)
END
