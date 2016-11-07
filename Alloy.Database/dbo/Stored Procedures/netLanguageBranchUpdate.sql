CREATE PROCEDURE dbo.netLanguageBranchUpdate
(
	@ID INT,
	@Name NVARCHAR(255) = NULL,
	@LanguageID NCHAR(17),
	@SortIndex INT,
	@SystemIconPath NVARCHAR(255) = NULL,
	@URLSegment NVARCHAR(255) = NULL,
	@Enabled BIT,
	@ACL NVARCHAR(MAX) = NULL
)
AS
BEGIN
	UPDATE
		tblLanguageBranch
	SET
		[Name] = @Name,
		LanguageID = @LanguageID,
		SortIndex = @SortIndex,
		SystemIconPath = @SystemIconPath,
		URLSegment = @URLSegment,
		Enabled = @Enabled,
		ACL = @ACL
	WHERE
		pkID = @ID
END
