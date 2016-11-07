CREATE PROCEDURE [dbo].[netActivityLogCommentListMany]
(
	@EntryIds AS LongParameterTable READONLY
)
AS            
BEGIN
	SELECT alc.* FROM [tblActivityLogComment] alc
	JOIN @EntryIds ids ON alc.EntryId = ids.Id
	ORDER BY alc.pkID DESC
END
