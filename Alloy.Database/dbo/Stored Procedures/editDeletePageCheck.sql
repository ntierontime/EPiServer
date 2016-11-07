CREATE PROCEDURE [dbo].[editDeletePageCheck]
(
	@PageID			INT,
	@IncludeDecendents BIT
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	/* Get all pages to delete (= PageID and all its childs) */
	DECLARE @pages AS editDeletePageInternalTable
	INSERT INTO @pages (pkID) 
	SELECT @PageID
	IF @IncludeDecendents = 1
	BEGIN
		INSERT INTO @pages (pkID) 
		SELECT 
			fkChildID 
		FROM 
			tblTree 
		WHERE fkParentID=@PageID
	END
	
	UPDATE @pages 
		SET PageGUID = tblPage.PageGUID
	FROM tblPage INNER JOIN @pages pages ON pages.pkID=tblPage.pkID
	
	EXEC sp_executesql N'EXEC editDeletePageCheckInternal @pages', N'@pages editDeletePageInternalTable READONLY', @pages
END
