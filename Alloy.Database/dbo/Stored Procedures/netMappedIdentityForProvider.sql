CREATE PROCEDURE [dbo].[netMappedIdentityForProvider]
	@Provider NVARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, Mi.ExistingContentId, MI.ExistingCustomProvider
	FROM tblMappedIdentity AS MI
	WHERE MI.Provider = @Provider
END
