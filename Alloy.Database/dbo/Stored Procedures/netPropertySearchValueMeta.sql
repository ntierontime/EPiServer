CREATE PROCEDURE [dbo].[netPropertySearchValueMeta]
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
	DECLARE @LangBranchID NCHAR(17)
	SELECT @LangBranchID=pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
	IF @LangBranchID IS NULL 
	BEGIN 
		if @LanguageBranch IS NOT NULL
			RAISERROR('Language branch %s is not defined',16,1, @LanguageBranch)
		else
			SET @LangBranchID = -1
	END
	
	DECLARE @DynSql NVARCHAR(2000)
	DECLARE @compare NVARCHAR(2)
	
	IF (@Equals = 1)
	BEGIN
	    SET @compare = '='
	END
	ELSE IF (@GreaterThan = 1)
	BEGIN
	    SET @compare = '>'
	END
	ELSE IF (@LessThan = 1)
	BEGIN
	    SET @compare = '<'
	END
	ELSE IF (@NotEquals = 1)
	BEGIN
	    SET @compare = '<>'
	END
	ELSE
	BEGIN
	    RAISERROR('No compare condition is defined.',16,1)
	END
	
	SET @DynSql = 'SELECT PageLanguages.fkPageID FROM tblPageLanguage as PageLanguages INNER JOIN tblTree ON tblTree.fkChildID=PageLanguages.fkPageID INNER JOIN tblContent as Pages ON Pages.pkID=PageLanguages.fkPageID'
	IF (@PropertyName = 'PageArchiveLink')
	BEGIN
		SET @DynSql = @DynSql + ' LEFT OUTER JOIN tblContent as Pages2 ON Pages.ArchiveContentGUID = Pages2.ContentGUID'
	END
	
	IF (@PropertyName = 'PageShortcutLink')
	BEGIN
		SET @DynSql = @DynSql + ' LEFT OUTER JOIN tblContent as Pages2 ON PageLanguages.PageLinkGUID = Pages2.ContentGUID'
	END
	
	SET @DynSql = @DynSql + ' WHERE Pages.ContentType = 0 AND tblTree.fkParentID=@PageID'
	IF (@LangBranchID <> -1)
	BEGIN
	    SET @DynSql = @DynSql + ' AND PageLanguages.fkLanguageBranchID=@LangBranchID'
	END
	
	IF (@PropertyName = 'PageVisibleInMenu')
	BEGIN
	    SET @DynSql = @DynSql + ' AND Pages.VisibleInMenu=@Boolean'
	END
	ELSE IF (@PropertyName = 'PageTypeID')
	BEGIN
	    IF (@Equals=1)
	        SET @DynSql = @DynSql + ' AND (Pages.fkContentTypeID = @PageType OR (@PageType IS NULL AND Pages.fkContentTypeID IS NULL))'
	    ELSE
	        SET @DynSql = @DynSql + ' AND (Pages.fkContentTypeID' + @compare + '@PageType OR (@PageType IS NULL AND NOT Pages.fkContentTypeID IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageLink')
	BEGIN
	    IF (@Equals=1)
	        SET @DynSql = @DynSql + ' AND (PageLanguages.fkPageID = @PageLink OR (@PageLink IS NULL AND PageLanguages.fkPageID IS NULL))'
	    ELSE
	        SET @DynSql = @DynSql + ' AND (PageLanguages.fkPageID' + @compare + '@PageLink OR (@PageLink IS NULL AND NOT PageLanguages.fkPageID IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageParentLink')
	BEGIN
	    IF (@Equals=1)
	        SET @DynSql = @DynSql + ' AND (Pages.fkParentID = @PageLink OR (@PageLink IS NULL AND Pages.fkParentID IS NULL))'
	    ELSE
	        SET @DynSql = @DynSql + ' AND (Pages.fkParentID' + @compare + '@PageLink OR (@PageLink IS NULL AND NOT Pages.fkParentID IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageShortcutLink')
	BEGIN
		SET @DynSql = @DynSql + ' AND (Pages2.pkID' + @compare + '@PageLink OR (@PageLink IS NULL AND NOT PageLanguages.PageLinkGUID IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageArchiveLink')
	BEGIN
		SET @DynSql = @DynSql + ' AND (Pages2.pkID' + @compare + '@PageLink OR (@PageLink IS NULL AND NOT Pages.ArchiveContentGUID IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageChanged')
	BEGIN
	    IF (@Equals=1)
	        SET @DynSql = @DynSql + ' AND (PageLanguages.Changed = @Date OR (@Date IS NULL AND PageLanguages.Changed IS NULL))'
	    ELSE
	        SET @DynSql = @DynSql + ' AND (PageLanguages.Changed' + @compare + '@Date OR (@Date IS NULL AND NOT PageLanguages.Changed IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageCreated')
	BEGIN
	    IF (@Equals=1)
	        SET @DynSql = @DynSql + ' AND (PageLanguages.Created = @Date OR (@Date IS NULL AND PageLanguages.Created IS NULL))'
	    ELSE
	        SET @DynSql = @DynSql + ' AND (PageLanguages.Created' + @compare + '@Date OR (@Date IS NULL AND NOT PageLanguages.Created IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageSaved')
	BEGIN
	    IF (@Equals=1)
	        SET @DynSql = @DynSql + ' AND (PageLanguages.Saved = @Date OR (@Date IS NULL AND PageLanguages.Saved IS NULL))'
	    ELSE
	        SET @DynSql = @DynSql + ' AND (PageLanguages.Saved' + @compare + '@Date  OR (@Date IS NULL AND NOT PageLanguages.Saved IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageStartPublish')
	BEGIN
	    IF (@Equals=1)
	        SET @DynSql = @DynSql + ' AND (PageLanguages.StartPublish = @Date OR (@Date IS NULL AND PageLanguages.StartPublish IS NULL))'
	    ELSE
	        SET @DynSql = @DynSql + ' AND (PageLanguages.StartPublish' + @compare + '@Date OR (@Date IS NULL AND NOT PageLanguages.StartPublish IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageStopPublish')
	BEGIN
	    IF (@Equals=1)
	        SET @DynSql = @DynSql + ' AND (PageLanguages.StopPublish = @Date OR (@Date IS NULL AND PageLanguages.StopPublish IS NULL))'
	    ELSE
	        SET @DynSql = @DynSql + ' AND (PageLanguages.StopPublish' + @compare + '@Date OR (@Date IS NULL AND NOT PageLanguages.StopPublish IS NULL))'
	END
	ELSE IF (@PropertyName = 'PageDeleted')
	BEGIN
		SET @DynSql = @DynSql + ' AND Pages.Deleted = @Boolean'
	END
	ELSE IF (@PropertyName = 'PagePendingPublish')
	BEGIN
		SET @DynSql = @DynSql + ' AND PageLanguages.PendingPublish = @Boolean'
	END
	ELSE IF (@PropertyName = 'PageShortcutType')
	BEGIN
	    IF (@Number=0)
	        SET @DynSql = @DynSql + ' AND PageLanguages.AutomaticLink=1 AND PageLanguages.PageLinkGUID IS NULL'
	    ELSE IF (@Number=1)
	        SET @DynSql = @DynSql + ' AND PageLanguages.AutomaticLink=1 AND NOT PageLanguages.PageLinkGUID IS NULL AND PageLanguages.FetchData=0'
	    ELSE IF (@Number=2)
	        SET @DynSql = @DynSql + ' AND PageLanguages.AutomaticLink=0 AND PageLanguages.LinkURL<>N''#'''
	    ELSE IF (@Number=3)
	        SET @DynSql = @DynSql + ' AND PageLanguages.AutomaticLink=0 AND PageLanguages.LinkURL=N''#'''
	    ELSE IF (@Number=4)
	        SET @DynSql = @DynSql + ' AND PageLanguages.AutomaticLink=1 AND PageLanguages.FetchData=1'
	END
	EXEC sp_executesql @DynSql, 
		N'@PageID INT, @LangBranchID NCHAR(17), @Boolean BIT, @Number INT, @PageType INT, @PageLink INT, @Date DATETIME',
		@PageID=@PageID,
		@LangBranchID=@LangBranchID, 
		@Boolean=@Boolean,
		@Number=@Number,
		@PageType=@PageType,
		@PageLink=@PageLink,
		@Date=@Date
END
