CREATE PROCEDURE [dbo].[editDeleteChildsCheck]
(
	@PageID			INT
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	/* Get all pages to delete (all childs of PageID) */
	DECLARE @pages AS editDeletePageInternalTable
	INSERT INTO @pages (pkID) 
	SELECT 
		fkChildID 
	FROM 
		tblTree 
	WHERE fkParentID=@PageID
	
	UPDATE @pages 
		SET PageGUID = tblPage.PageGUID
	FROM tblPage INNER JOIN @pages pages ON pages.pkID=tblPage.pkID
	
	EXEC sp_executesql N'EXEC editDeletePageCheckInternal @pages', N'@pages editDeletePageInternalTable READONLY', @pages
	RETURN 0
END
