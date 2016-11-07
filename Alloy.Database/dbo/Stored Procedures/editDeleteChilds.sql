CREATE PROCEDURE [dbo].[editDeleteChilds]
(
    @PageID			INT,
    @ForceDelete	INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    DECLARE @retval INT
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
	DECLARE @sql NVARCHAR(200) = N'EXEC @retval=editDeletePageInternal @pages, @PageID=@PageID, @ForceDelete=@ForceDelete'
	DECLARE @params NVARCHAR(200) = N'@pages editDeletePageInternalTable READONLY, @PageID INT, @ForceDelete INT, @retval int OUTPUT'
	EXEC sp_executesql @sql, @params, @pages, @PageID, @ForceDelete, @retval=@retval OUTPUT
	UPDATE tblContent SET IsLeafNode = 1 WHERE pkID=@PageID
        
	RETURN @retval
END
