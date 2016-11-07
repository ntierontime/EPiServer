CREATE PROCEDURE [dbo].[netProjectItemGetSingle]
	@ID INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		  pkID, fkProjectID, ContentLinkID, ContentLinkWorkID, ContentLinkProvider, [Language], Category
	FROM
		tblProjectItem
	WHERE pkID = @ID
END
