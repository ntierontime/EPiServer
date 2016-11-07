CREATE PROCEDURE dbo.netPageCountDescendants
(
	@PageID INT = NULL
)
AS
BEGIN
	DECLARE @pageCount INT
	SET NOCOUNT ON
	IF @PageID IS NULL
	BEGIN
		SET @pageCount =
			(SELECT COUNT(*) AS PageCount
			 FROM tblPage)
	END
	ELSE
	BEGIN
		SET @pageCount =
			(SELECT COUNT(*) AS PageCount
			 FROM tblPage
			 INNER JOIN tblTree ON tblTree.fkChildID=tblPage.pkID
			 WHERE tblTree.fkParentID=@PageID)
	END
	RETURN @pageCount
END
