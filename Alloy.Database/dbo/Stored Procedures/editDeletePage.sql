CREATE PROCEDURE [dbo].[editDeletePage]
(
	@PageID			INT,
	@ForceDelete	INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	DECLARE @retval INT
	DECLARE @ParentID INT
	/* Get all pages to delete (= PageID and all its childs) */
	DECLARE @pages AS editDeletePageInternalTable
	INSERT INTO @pages (pkID) 
	SELECT 
		fkChildID 
	FROM 
		tblTree 
	WHERE fkParentID=@PageID
	UNION
	SELECT @PageID
	
	UPDATE @pages 
		SET PageGUID = tblPage.PageGUID
	FROM tblPage INNER JOIN @pages pages ON pages.pkID=tblPage.pkID
	
	SELECT @ParentID=fkParentID FROM tblPage WHERE pkID=@PageID
				
	DECLARE @sql NVARCHAR(200) = N'EXEC @retval=editDeletePageInternal @pages, @PageID=@PageID, @ForceDelete=@ForceDelete'
	DECLARE @params NVARCHAR(200) = N'@pages editDeletePageInternalTable READONLY, @PageID INT, @ForceDelete INT, @retval int OUTPUT'
	EXEC sp_executesql @sql, @params, @pages, @PageID, @ForceDelete, @retval=@retval OUTPUT
	IF NOT EXISTS(SELECT * FROM tblContent WHERE fkParentID=@ParentID)
		UPDATE tblContent SET IsLeafNode = 1 WHERE pkID=@ParentID
	
	RETURN @retval
END
