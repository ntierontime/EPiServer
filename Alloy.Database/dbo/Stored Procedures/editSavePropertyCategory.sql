CREATE PROCEDURE [dbo].[editSavePropertyCategory]
(
	@PageID				INT,
	@WorkPageID			INT,
	@PageDefinitionID	INT,
	@Override			BIT,
	@CategoryString		NVARCHAR(2000),
	@LanguageBranch		NCHAR(17) = NULL,
	@ScopeName			nvarchar(450) = NULL
)
AS
BEGIN
	SET NOCOUNT	ON
	SET XACT_ABORT ON
	DECLARE	@PageIDString			NVARCHAR(20)
	DECLARE	@PageDefinitionIDString	NVARCHAR(20)
	DECLARE @DynProp INT
	DECLARE @retval	INT
	SET @retval = 0
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
	SELECT @DynProp=pkID FROM tblPageDefinition WHERE pkID=@PageDefinitionID AND fkPageTypeID IS NULL
	IF (@WorkPageID IS NOT NULL)
	BEGIN
		/* Never store dynamic properties in work table */
		IF (@DynProp IS NOT NULL)
			GOTO cleanup
				
		/* Remove all categories */
		SET @PageIDString = CONVERT(NVARCHAR(20), @WorkPageID)
		SET @PageDefinitionIDString = CONVERT(NVARCHAR(20), @PageDefinitionID)
		DELETE FROM tblWorkContentCategory WHERE fkWorkContentID=@WorkPageID AND ScopeName=@ScopeName
		/* Insert new categories */
		IF (LEN(@CategoryString) > 0)
		BEGIN
			EXEC (N'INSERT INTO tblWorkContentCategory (fkWorkContentID, fkCategoryID, CategoryType, ScopeName) SELECT ' + @PageIDString + N',pkID,' + @PageDefinitionIDString + N', ''' + @ScopeName + N''' FROM tblCategory WHERE pkID IN (' + @CategoryString +N')' )
		END
		
		/* Finally update the property table */
		IF (@PageDefinitionID <> 0)
		BEGIN
			IF EXISTS(SELECT fkWorkContentID FROM tblWorkContentProperty WHERE fkWorkContentID=@WorkPageID AND fkPropertyDefinitionID=@PageDefinitionID AND ScopeName=@ScopeName)
				UPDATE tblWorkContentProperty SET Number=@PageDefinitionID WHERE fkWorkContentID=@WorkPageID 
					AND fkPropertyDefinitionID=@PageDefinitionID
					AND ((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
			ELSE
				INSERT INTO tblWorkContentProperty (fkWorkContentID, fkPropertyDefinitionID, Number, ScopeName) VALUES (@WorkPageID, @PageDefinitionID, @PageDefinitionID, @ScopeName)
		END
	END
	
	IF (@WorkPageID IS NULL OR @IsLanguagePublished = 0)
	BEGIN
		/* Insert or update property */
		/* Remove all categories */
		SET @PageIDString = CONVERT(NVARCHAR(20), @PageID)
		SET @PageDefinitionIDString = CONVERT(NVARCHAR(20), @PageDefinitionID)
		DELETE FROM tblContentCategory WHERE fkContentID=@PageID AND ScopeName=@ScopeName
		AND fkLanguageBranchID=@LangBranchID
		
		/* Insert new categories */
		IF (LEN(@CategoryString) > 0)
		BEGIN
			EXEC (N'INSERT INTO tblContentCategory (fkContentID, fkCategoryID, CategoryType, fkLanguageBranchID, ScopeName) SELECT ' + @PageIDString + N',pkID,' + @PageDefinitionIDString + N', ' + @LangBranchID + N', ''' + @ScopeName + N''' FROM tblCategory WHERE pkID IN (' + @CategoryString +N')' )
		END
		
		/* Finally update the property table */
		IF (@PageDefinitionID <> 0)
		BEGIN
			IF EXISTS(SELECT fkContentID FROM tblContentProperty WHERE fkContentID=@PageID AND fkPropertyDefinitionID=@PageDefinitionID 
						AND fkLanguageBranchID=@LangBranchID AND ScopeName=@ScopeName)
				UPDATE tblContentProperty SET Number=@PageDefinitionID WHERE fkContentID=@PageID AND fkPropertyDefinitionID=@PageDefinitionID
						AND fkLanguageBranchID=@LangBranchID
						AND ((@ScopeName IS NULL AND ScopeName IS NULL) OR (@ScopeName = ScopeName))
			ELSE
				INSERT INTO tblContentProperty (fkContentID, fkPropertyDefinitionID, Number, fkLanguageBranchID, ScopeName) VALUES (@PageID, @PageDefinitionID, @PageDefinitionID, @LangBranchID, @ScopeName)
		END
				
		/* Override dynamic property definitions below the current level */
		IF (@DynProp IS NOT NULL)
		BEGIN
			IF (@Override = 1)
				DELETE FROM tblContentProperty WHERE fkPropertyDefinitionID=@PageDefinitionID AND fkContentID IN (SELECT fkChildID FROM tblTree WHERE fkParentID=@PageID)
			SET @retval = 1
		END
	END
cleanup:		
	
	RETURN @retval
END
