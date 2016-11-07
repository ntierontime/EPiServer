CREATE PROCEDURE [dbo].[netActivityLogCommentList]
(
	@EntryId	[bigint]
)
AS            
BEGIN
	SELECT * FROM [tblActivityLogComment]
		WHERE [EntryId] = @EntryId
	ORDER BY pkID DESC
END
