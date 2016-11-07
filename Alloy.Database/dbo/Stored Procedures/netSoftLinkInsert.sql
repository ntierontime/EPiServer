CREATE PROCEDURE dbo.netSoftLinkInsert
(
	@OwnerContentID	INT,
	@ReferencedContentGUID uniqueidentifier,
	@LinkURL	NVARCHAR(2048),
	@LinkType	INT,
	@LinkProtocol	NVARCHAR(10),
	@ContentLink	NVARCHAR(255),
	@LastCheckedDate datetime,
	@FirstDateBroken datetime,
	@HttpStatusCode int,
	@LinkStatus int,
	@OwnerLanguageID int,
	@ReferencedLanguageID int
)
AS
BEGIN
	INSERT INTO tblContentSoftlink
		(fkOwnerContentID,
		fkReferencedContentGUID,
	    OwnerLanguageID,
		ReferencedLanguageID,
		LinkURL,
		LinkType,
		LinkProtocol,
		ContentLink,
		LastCheckedDate,
		FirstDateBroken,
		HttpStatusCode,
		LinkStatus)
	VALUES
		(@OwnerContentID,
		@ReferencedContentGUID,
		@OwnerLanguageID,
		@ReferencedLanguageID,
		@LinkURL,
		@LinkType,
		@LinkProtocol,
		@ContentLink,
		@LastCheckedDate,
		@FirstDateBroken,
		@HttpStatusCode,
		@LinkStatus)
END
