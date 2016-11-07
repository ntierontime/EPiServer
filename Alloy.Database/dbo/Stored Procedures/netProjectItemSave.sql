CREATE PROCEDURE [dbo].[netProjectItemSave]
	@ProjectItems dbo.ProjectItemTable READONLY
AS
BEGIN
	SET NOCOUNT ON
	IF (SELECT COUNT(*) FROM tblProjectItem tbl JOIN @ProjectItems items ON tbl.pkID = items.ID AND tbl.fkProjectID != items.ProjectID) > 0
		RAISERROR('Not allowed to change ProjectId', 16, 1)
	ELSE
		MERGE tblProjectItem AS Target
		USING @ProjectItems AS Source
		ON (Target.pkID = Source.ID)
		WHEN MATCHED THEN
		    UPDATE SET 
				Target.fkProjectID = Source.ProjectID,
				Target.ContentLinkID = Source.ContentLinkID,
				Target.ContentLinkWorkID = Source.ContentLinkWorkID,
				Target.ContentLinkProvider = Source.ContentLinkProvider,
				Target.Language = Source.Language,
				Target.Category = Source.Category
		WHEN NOT MATCHED BY Target THEN
			INSERT (fkProjectID, ContentLinkID, ContentLinkWorkID, ContentLinkProvider, Language, Category)
			VALUES (Source.ProjectID, Source.ContentLinkID, Source.ContentLinkWorkID, Source.ContentLinkProvider, Source.Language, Source.Category)
		OUTPUT INSERTED.pkID, INSERTED.fkProjectID, INSERTED.ContentLinkID, INSERTED.ContentLinkWorkID, INSERTED.ContentLinkProvider, INSERTED.Language, INSERTED.Category;
END
