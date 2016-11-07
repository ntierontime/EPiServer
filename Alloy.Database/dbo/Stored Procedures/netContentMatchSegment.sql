CREATE PROCEDURE [dbo].[netContentMatchSegment]
(
	@ContentID INT,
	@Segment NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT 
		tblContent.pkID as ContentID, 
		tblContentLanguage.fkLanguageBranchID as LanguageBranchID,
		tblContent.ContentType as ContentType
	FROM tblContentLanguage INNER JOIN tblContent
		ON tblContentLanguage.fkContentID = tblContent.pkID
	WHERE tblContent.fkParentID = @ContentID AND tblContentLanguage.URLSegment = @Segment
	
END
