CREATE PROCEDURE [dbo].[netMappedIdentityGetByGuid]
	@ContentGuids dbo.GuidParameterTable READONLY
AS
BEGIN
	SET NOCOUNT ON;
	SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, MI.ExistingContentId, MI.ExistingCustomProvider
	FROM tblMappedIdentity AS MI INNER JOIN @ContentGuids AS EI ON MI.ContentGuid = EI.Id
END
