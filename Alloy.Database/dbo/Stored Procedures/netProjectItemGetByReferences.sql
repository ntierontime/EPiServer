CREATE PROCEDURE [dbo].[netProjectItemGetByReferences]
	@References dbo.ContentReferenceTable READONLY
AS
BEGIN
	SET NOCOUNT ON;
	--ProjectItems
	SELECT
		tblProjectItem.pkID, tblProjectItem.fkProjectID, tblProjectItem.ContentLinkID, tblProjectItem.ContentLinkWorkID, tblProjectItem.ContentLinkProvider, tblProjectItem.Language, tblProjectItem.Category
	FROM
		tblProjectItem
	INNER JOIN @References AS Refs ON Refs.ID = tblProjectItem.ContentLinkID
	WHERE 
		(Refs.WorkID = 0 OR Refs.WorkID = tblProjectItem.ContentLinkWorkID) AND 
		((Refs.Provider IS NULL AND tblProjectItem.ContentLinkProvider = '') OR (Refs.Provider = tblProjectItem.ContentLinkProvider)) 
END
