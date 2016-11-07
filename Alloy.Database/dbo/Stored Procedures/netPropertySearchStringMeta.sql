CREATE PROCEDURE dbo.netPropertySearchStringMeta
(
	@PageID				INT,
	@PropertyName 		NVARCHAR(255),
	@UseWildCardsBefore	BIT = 0,
	@UseWildCardsAfter	BIT = 0,
	@String				NVARCHAR(2000) = NULL,
	@LanguageBranch		NCHAR(17) = NULL
)
AS
BEGIN
	DECLARE @SearchString NVARCHAR(2010)
	DECLARE @DynSqlSelect NVARCHAR(2000)
	DECLARE @DynSqlWhere NVARCHAR(2000)
	DECLARE @LangBranchID NCHAR(17)
    
	
	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		IF @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		ELSE
			SET @LangBranchID = -1
	END
			
	SELECT @SearchString=CASE    WHEN @UseWildCardsBefore=0 AND @UseWildCardsAfter=0 THEN @String
						WHEN @UseWildCardsBefore=1 AND @UseWildCardsAfter=0 THEN N'%' + @String
						WHEN @UseWildCardsBefore=0 AND @UseWildCardsAfter=1 THEN @String + N'%'
						ELSE N'%' + @String + N'%'
					END
	SET @DynSqlSelect = 'SELECT tblPageLanguage.fkPageID FROM tblPageLanguage INNER JOIN tblTree ON tblTree.fkChildID=tblPageLanguage.fkPageID INNER JOIN tblContent as tblPage ON tblPageLanguage.fkPageID=tblPage.pkID'
	SET @DynSqlWhere = ' WHERE tblPage.ContentType = 0 AND tblTree.fkParentID=@PageID'
	IF (@LangBranchID <> -1)
		SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.fkLanguageBranchID=@LangBranchID'
	IF (@PropertyName = 'PageName')
	BEGIN
		IF (@String IS NULL)
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.Name IS NULL'
		ELSE
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.Name LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageLinkURL')
	BEGIN
		IF (@String IS NULL)
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.LinkURL IS NULL'
		ELSE
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.LinkURL LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageCreatedBy')
	BEGIN
		IF (@String IS NULL)
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.CreatorName IS NULL'
		ELSE
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.CreatorName LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageChangedBy')
	BEGIN
		IF (@String IS NULL)
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.ChangedByName IS NULL'
		ELSE
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.ChangedByName LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageTypeName')
	BEGIN
		SET @DynSqlSelect = @DynSqlSelect + ' INNER JOIN tblPageType ON tblPageType.pkID=tblPage.fkContentTypeID'
		IF (@String IS NULL)
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageType.Name IS NULL'
		ELSE
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageType.Name LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageExternalURL')
	BEGIN
		IF (@String IS NULL)
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.ExternalURL IS NULL'
		ELSE
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.ExternalURL LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageLanguageBranch')
	BEGIN
        SET @DynSqlSelect = @DynSqlSelect + ' INNER JOIN tblLanguageBranch ON tblLanguageBranch.pkid = tblPageLanguage.fklanguagebranchid'
		IF (@String IS NULL)
			SET @DynSqlWhere = @DynSqlWhere + ' AND tblLanguageBranch.languageid IS NULL'
		ELSE
			SET @DynSqlWhere = @DynSqlWhere + ' AND RTRIM(tblLanguageBranch.languageid) LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageShortcutLink')
	BEGIN
	    IF (@String IS NULL)
	        SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.PageLinkGUID IS NULL' 
	    ELSE
	        SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.PageLinkGUID LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageArchiveLink')
	BEGIN
	    IF (@String IS NULL)
	        SET @DynSqlWhere = @DynSqlWhere + ' AND tblPage.ArchiveContentGUID IS NULL' 
	    ELSE
	        SET @DynSqlWhere = @DynSqlWhere + ' AND tblPage.ArchiveContentGUID LIKE @SearchString'
	END
	ELSE IF (@PropertyName = 'PageURLSegment')
	BEGIN
	    IF (@String IS NULL)
	        SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.URLSegment IS NULL' 
	    ELSE
	        SET @DynSqlWhere = @DynSqlWhere + ' AND tblPageLanguage.URLSegment LIKE @SearchString'
	END
	SET @DynSqlSelect = @DynSqlSelect + @DynSqlWhere
	EXEC sp_executesql @DynSqlSelect, 
		N'@PageID INT, @LangBranchID NCHAR(17), @SearchString NVARCHAR(2010)',
		@PageID=@PageID,
		@LangBranchID=@LangBranchID, 
		@SearchString=@SearchString
END
