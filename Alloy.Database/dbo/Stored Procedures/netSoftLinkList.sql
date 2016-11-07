CREATE PROCEDURE dbo.netSoftLinkList
(
	@ReferenceGUID	uniqueidentifier,
	@Reversed INT = 0
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF @Reversed = 1
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
		WHERE fkReferencedContentGUID=@ReferenceGUID
	ELSE
		SELECT 
			SoftLink.pkID,
			Content.pkID AS OwnerContentID,
			SoftLink.fkReferencedContentGUID AS ReferencedContentGUID,
			SoftLink.OwnerLanguageID,
			SoftLink.ReferencedLanguageID,
			SoftLink.LinkURL,
			SoftLink.LinkType,
			SoftLink.LinkProtocol,
			SoftLink.LastCheckedDate,
			SoftLink.FirstDateBroken,
			SoftLink.HttpStatusCode,
			SoftLink.LinkStatus
		FROM tblContentSoftlink AS SoftLink
		INNER JOIN tblContent as Content ON SoftLink.fkOwnerContentID = Content.pkID
		WHERE Content.ContentGUID=@ReferenceGUID
END
