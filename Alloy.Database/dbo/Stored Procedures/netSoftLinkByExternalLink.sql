Create PROCEDURE [dbo].[netSoftLinkByExternalLink]
(
	@ContentLink NVARCHAR(255),
	@ContentGuid uniqueidentifier = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT 
		pkID,
		fkOwnerContentID AS OwnerID,
		fkReferencedContentGUID AS ReferencedGUID,
		NULL AS OwnerName,
		NULL AS ReferencedName,
		OwnerLanguageID,
		ReferencedLanguageID,
		LinkURL,
		LinkType as ReferenceType ,
		LinkProtocol,
		LastCheckedDate,
		FirstDateBroken,
		HttpStatusCode,
		LinkStatus
	FROM tblContentSoftlink 
	WHERE [fkReferencedContentGUID] = @ContentGuid OR [ContentLink] = @ContentLink
END
