CREATE PROCEDURE [dbo].[netContentListBlobUri] 
@ContentID INT
AS
BEGIN
	SET NOCOUNT ON
	SELECT tblContentLanguage.BlobUri
	FROM tblContentLanguage
	WHERE fkContentID=@ContentID AND NOT BlobUri IS NULL
		
	SELECT tblContentLanguage.BlobUri
	FROM tblContentLanguage
	INNER JOIN tblTree ON tblTree.fkChildID=tblContentLanguage.fkContentID
	WHERE tblTree.fkParentID=@ContentID AND NOT BlobUri IS NULL		
END
