CREATE PROCEDURE [dbo].[netSiteDefinitionDelete]
(
	@UniqueId		uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON
	DELETE FROM tblSiteDefinition WHERE UniqueId = @UniqueId
END
