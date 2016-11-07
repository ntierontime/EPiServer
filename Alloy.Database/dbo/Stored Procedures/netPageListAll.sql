CREATE PROCEDURE [dbo].[netPageListAll]
(
	@PageID INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	IF @PageID IS NULL
	BEGIN
		SELECT tblPage.pkID as "PageID", tblPage.fkParentID AS "ParentID", tblPage.ContentType
		FROM tblPage
	END
	ELSE
	BEGIN
		SELECT tblPage.pkID as "PageID", tblPage.fkParentID AS "ParentID", tblPage.ContentType
		FROM tblPage
		INNER JOIN tblTree ON tblTree.fkChildID=tblPage.pkID
		WHERE tblTree.fkParentID=@PageID
		ORDER BY NestingLevel DESC
	END
END
