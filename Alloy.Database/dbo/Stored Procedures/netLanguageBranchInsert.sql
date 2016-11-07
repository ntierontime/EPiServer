CREATE PROCEDURE dbo.netLanguageBranchInsert
(
	@ID INT OUTPUT,
	@Name NVARCHAR(50) = NULL,
	@LanguageID NCHAR(17),
	@SortIndex INT = 0,
	@SystemIconPath NVARCHAR(255) = NULL,
	@URLSegment NVARCHAR(255) = NULL,
	@Enabled BIT,
	@ACL NVARCHAR(MAX) = NULL
)
AS
BEGIN
	INSERT INTO tblLanguageBranch
	(
		LanguageID,
		[Name],
		SortIndex,
		SystemIconPath,
		URLSegment,
		Enabled,
		ACL
	)
	VALUES
	(
		@LanguageID,
		@Name,
		@SortIndex,
		@SystemIconPath,
		@URLSegment,
		@Enabled,
		@ACL
	)
	SET @ID	=  SCOPE_IDENTITY() 
END
