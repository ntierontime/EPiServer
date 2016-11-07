CREATE PROCEDURE [dbo].[netMappedIdentityGetById]
	@InternalIds dbo.ContentReferenceTable READONLY
AS
BEGIN
	SET NOCOUNT ON;
	SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, MI.ExistingContentId, MI.ExistingCustomProvider
	FROM tblMappedIdentity AS MI 
	INNER JOIN @InternalIds AS EI ON (MI.pkID = EI.ID AND MI.Provider = EI.Provider)
	UNION (SELECT MI2.pkID AS ContentId, MI2.Provider, MI2.ProviderUniqueId, MI2.ContentGuid, MI2.ExistingContentId, MI2.ExistingCustomProvider
		FROM tblMappedIdentity AS MI2
		INNER JOIN @InternalIds AS EI2 ON (MI2.ExistingContentId = EI2.ID)
		WHERE ((MI2.ExistingCustomProvider = 1 AND MI2.Provider = EI2.Provider) OR (MI2.ExistingCustomProvider IS NULL AND EI2.Provider IS NULL)))
	END
