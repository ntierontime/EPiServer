CREATE PROCEDURE [dbo].[netMappedIdentityDelete]
	@Provider NVARCHAR(255),
	@ProviderUniqueId NVARCHAR(2048)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE
	FROM tblMappedIdentity
	WHERE tblMappedIdentity.Provider = @Provider AND tblMappedIdentity.ProviderUniqueId = @ProviderUniqueId
END
