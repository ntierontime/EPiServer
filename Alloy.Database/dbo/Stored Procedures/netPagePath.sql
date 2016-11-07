CREATE PROCEDURE  [dbo].[netPagePath]
(
	@PageID INT
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT PagePath FROM tblPage where tblPage.pkID = @PageID
END
