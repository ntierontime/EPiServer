CREATE VIEW [dbo].[tblPageType]
AS
SELECT
  [pkID],
  [ContentTypeGUID] AS PageTypeGUID,
  [Created],
  [DefaultWebFormTemplate],
  [DefaultMvcController],
  [Filename],
  [ModelType],
  [Name],
  [DisplayName],
  [Description],
  [IdString],
  [Available],
  [SortOrder],
  [MetaDataInherit],
  [MetaDataDefault],
  [WorkflowEditFields],
  [ACL],
  [ContentType]
FROM    dbo.tblContentType
