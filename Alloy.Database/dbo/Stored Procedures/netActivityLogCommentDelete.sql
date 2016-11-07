CREATE PROCEDURE [dbo].[netActivityLogCommentDelete]
(
	@Id  BIGINT
)
AS            
BEGIN
	DELETE FROM [tblActivityLogComment] WHERE [pkID] = @Id
END
