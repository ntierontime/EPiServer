CREATE PROCEDURE [dbo].[netMappedIdentityMapContent]
	@Provider NVARCHAR(255),
	@ProviderUniqueId NVARCHAR(2048),
	@ExistingContentId INT,
	@ExistingCustomProvider BIT = NULL,
	@ContentGuid UniqueIdentifier
AS
BEGIN
	SET NOCOUNT ON;
	--Return 1 if already exist entry
	IF EXISTS(SELECT 1 FROM tblMappedIdentity WHERE Provider=@Provider AND ProviderUniqueId = @ProviderUniqueId)
	BEGIN
		RETURN 1
	END
	INSERT INTO tblMappedIdentity(Provider, ProviderUniqueId, ContentGuid, ExistingContentId, ExistingCustomProvider) 
		VALUES(@Provider, @ProviderUniqueId, @ContentGuid, @ExistingContentId, @ExistingCustomProvider)
	RETURN 0
END
