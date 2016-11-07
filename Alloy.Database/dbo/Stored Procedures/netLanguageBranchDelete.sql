CREATE PROCEDURE dbo.netLanguageBranchDelete
(
	@ID INT
)
AS
BEGIN
	DELETE FROM tblLanguageBranch WHERE pkID = @ID
END
