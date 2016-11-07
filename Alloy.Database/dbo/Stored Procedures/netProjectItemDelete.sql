CREATE PROCEDURE [dbo].[netProjectItemDelete]
	@ProjectItemIDs dbo.IDTable READONLY
AS
BEGIN
	SET NOCOUNT ON
	MERGE tblProjectItem AS Target
	USING @ProjectItemIDs AS Source
    ON (Target.pkID = Source.ID)
    WHEN MATCHED THEN 
		DELETE
	OUTPUT DELETED.pkID, DELETED.fkProjectID, DELETED.ContentLinkID, DELETED.ContentLinkWorkID, DELETED.ContentLinkProvider, DELETED.Language, DELETED.Category;
END
