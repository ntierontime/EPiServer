Create PROCEDURE [dbo].[netSoftLinkByPageLink]
(
	@PageLink NVARCHAR(255)
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
	WHERE [ContentLink] = @PageLink
END
