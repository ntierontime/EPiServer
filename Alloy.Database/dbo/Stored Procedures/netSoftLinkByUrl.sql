CREATE PROCEDURE dbo.netSoftLinkByUrl
(
	@LinkURL NVARCHAR(2048),
	@ExactMatch INT = 1
)
AS
BEGIN
	SET NOCOUNT ON
	SELECT 
		pkID,
		fkOwnerContentID AS OwnerContentID,
		fkReferencedContentGUID AS ReferencedContentGUID,
		OwnerLanguageID,
		ReferencedLanguageID,
		LinkURL,
		LinkType,
		LinkProtocol,
		LastCheckedDate,
		FirstDateBroken,
		HttpStatusCode,
		LinkStatus
	FROM tblContentSoftlink 
	WHERE (@ExactMatch=1 AND LinkURL LIKE @LinkURL) OR (@ExactMatch=0 AND LinkURL LIKE (@LinkURL + '%'))
END
