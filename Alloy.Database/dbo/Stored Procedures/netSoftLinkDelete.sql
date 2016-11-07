CREATE PROCEDURE dbo.netSoftLinkDelete
(
	@OwnerContentID	INT,
	@LanguageBranch nchar(17) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @LangBranchID INT
	IF NOT @LanguageBranch IS NULL
	BEGIN
		SELECT @LangBranchID = pkID FROM tblLanguageBranch WHERE LanguageID=@LanguageBranch
		IF @LangBranchID IS NULL
		BEGIN
			RAISERROR (N'netSoftLinkDelete: LanguageBranchID is null, possibly empty table tblLanguageBranch', 16, 1)
			RETURN 0
		END
	END
	DELETE FROM tblContentSoftlink WHERE fkOwnerContentID = @OwnerContentID AND (@LanguageBranch IS NULL OR OwnerLanguageID=@LangBranchID)
END
