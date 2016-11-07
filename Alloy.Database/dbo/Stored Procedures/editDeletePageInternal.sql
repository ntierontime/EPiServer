CREATE PROCEDURE [dbo].[editDeletePageInternal]
(
    @pages editDeletePageInternalTable READONLY,
    @PageID INT,
    @ForceDelete INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
-- STRUCTURE
	
	-- Make sure we dump structure and features like fetch data before we start off repairing links for pages that should not get deleted
	UPDATE 
	    tblPage 
	SET 
	    fkParentID = NULL,
	    ArchivePageGUID=NULL 
	WHERE 
	    pkID IN ( SELECT pkID FROM @pages )
	UPDATE 
	    tblContentLanguage
	SET 
	    Version = NULL 
	WHERE 
	    fkContentID IN ( SELECT pkID FROM @pages )
	    
	UPDATE 
	    tblWorkPage 
	SET 
	    fkMasterVersionID=NULL,
	    PageLinkGUID=NULL,
	    ArchivePageGUID=NULL 
	WHERE 
	    fkPageID IN ( SELECT pkID FROM @pages )
-- VERSION DATA
	-- Delete page links, archiving and fetch data pointing to us from external pages
	DELETE FROM 
	    tblWorkProperty 
	WHERE 
	    PageLink IN ( SELECT pkID FROM @pages )
	    
	UPDATE 
	    tblWorkPage 
	SET 
	    ArchivePageGUID = NULL 
	WHERE 
	    ArchivePageGUID IN ( SELECT PageGUID FROM @pages )
	    
	UPDATE 
	    tblWorkPage 
	SET 
	    PageLinkGUID = NULL, 
	    LinkType=0,
	    LinkURL=
		(
			SELECT TOP 1 
			      '~/link/' + CONVERT(NVARCHAR(32),REPLACE((select top 1 PageGUID FROM tblPage where tblPage.pkID = tblWorkPage.fkPageID),'-','')) + '.aspx'
			FROM 
			    tblPageType
			WHERE 
			    tblPageType.pkID=(SELECT fkPageTypeID FROM tblPage WHERE tblPage.pkID=tblWorkPage.fkPageID)
		)
	 WHERE 
	    PageLinkGUID IN ( SELECT PageGUID FROM @pages )
	
	-- Remove workproperties,workcategories and finally the work versions themselves
	DELETE FROM 
	    tblWorkProperty 
	WHERE 
	    fkWorkPageID IN ( SELECT pkID FROM tblWorkPage WHERE fkPageID IN ( SELECT pkID FROM @pages ) )
	    
	DELETE FROM 
	    tblWorkCategory 
	WHERE 
	    fkWorkPageID IN ( SELECT pkID FROM tblWorkPage WHERE fkPageID IN ( SELECT pkID FROM @pages ) )
	    
	DELETE FROM 
	    tblWorkPage 
	WHERE 
	    fkPageID IN ( SELECT pkID FROM @pages )
-- PUBLISHED PAGE DATA
	IF (@ForceDelete IS NOT NULL)
	BEGIN
		DELETE FROM 
		    tblProperty 
		WHERE 
		    PageLink IN (SELECT pkID FROM @pages)
	END
	ELSE
	BEGIN
		/* Default action: Only delete references from pages in wastebasket */
		DELETE FROM 
			tblProperty
		FROM 
		    tblProperty AS P
		INNER JOIN 
		    tblPage ON P.fkPageID=tblPage.pkID
		WHERE
			tblPage.Deleted=1 AND
			P.PageLink IN (SELECT pkID FROM @pages)
	END
	DELETE FROM 
	    tblPropertyDefault 
	WHERE 
	    PageLink IN ( SELECT pkID FROM @pages )
	    
	UPDATE 
	    tblPage 
	SET 
	    ArchivePageGUID = NULL 
	WHERE 
	    ArchivePageGUID IN ( SELECT PageGUID FROM @pages )
	-- Remove fetch data from any external pages pointing to us
	UPDATE 
	    tblPageLanguage 
	SET     
	    PageLinkGUID = NULL, 
	    FetchData=0,
	    LinkURL=
		(
			SELECT TOP 1 
		      '~/link/' + CONVERT(NVARCHAR(32),REPLACE((select top 1 PageGUID FROM tblPage where tblPage.pkID = tblPageLanguage.fkPageID),'-','')) + '.aspx'
			FROM 
			    tblPageType
			WHERE 
			    tblPageType.pkID=(SELECT tblPage.fkPageTypeID FROM tblPage WHERE tblPage.pkID=tblPageLanguage.fkPageID)
		)
	 WHERE 
	    PageLinkGUID IN ( SELECT PageGUID FROM @pages )
	-- Remove ALC, categories and the properties
	DELETE FROM 
	    tblCategoryPage 
	WHERE 
	    fkPageID IN ( SELECT pkID FROM @pages )
	    
	DELETE FROM 
	    tblProperty 
	WHERE 
	    fkPageID IN ( SELECT pkID FROM @pages )
	    
	DELETE FROM 
	    tblContentAccess 
	WHERE 
	    fkContentID IN ( SELECT pkID FROM @pages )
-- KEYWORDS AND INDEXING
	
	DELETE FROM 
	    tblContentSoftlink
	WHERE 
	    fkOwnerContentID IN ( SELECT pkID FROM @pages )
-- PAGETYPES
	    
	UPDATE 
	    tblPageTypeDefault 
	SET 
	    fkArchivePageID=NULL 
	WHERE fkArchivePageID IN (SELECT pkID FROM @pages)
-- PAGE/TREE
	DELETE FROM 
	    tblTree 
	WHERE 
	    fkChildID IN ( SELECT pkID FROM @pages )
	    
	DELETE FROM 
	    tblTree 
	WHERE 
	    fkParentID IN ( SELECT pkID FROM @pages )
	    
	DELETE FROM 
	    tblPageLanguage 
	WHERE 
	    fkPageID IN ( SELECT pkID FROM @pages )
	    
	DELETE FROM 
	    tblPageLanguageSetting 
	WHERE 
	    fkPageID IN ( SELECT pkID FROM @pages )
   
	DELETE FROM
	    tblPage 
	WHERE 
	    pkID IN ( SELECT pkID FROM @pages )
END
