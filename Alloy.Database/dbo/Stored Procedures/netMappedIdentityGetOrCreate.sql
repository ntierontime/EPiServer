CREATE PROCEDURE [dbo].[netMappedIdentityGetOrCreate]
	@ExternalIds dbo.UriPartsTable READONLY,
	@CreateIfMissing BIT
AS
BEGIN
	SET NOCOUNT ON;
	--Create first missing entries
	IF @CreateIfMissing = 1
	BEGIN
		MERGE tblMappedIdentity AS TARGET
		USING @ExternalIds AS Source
		ON (Target.Provider = Source.Host AND Target.ProviderUniqueId = Source.Path)
		WHEN NOT MATCHED BY Target THEN
			INSERT (Provider, ProviderUniqueId)
			VALUES (Source.Host, Source.Path);
	END
	SELECT MI.pkID AS ContentId, MI.Provider, MI.ProviderUniqueId, MI.ContentGuid, MI.ExistingContentId, MI.ExistingCustomProvider
	FROM tblMappedIdentity AS MI INNER JOIN @ExternalIds AS EI ON MI.ProviderUniqueId = EI.Path
	WHERE MI.Provider = EI.Host
END
