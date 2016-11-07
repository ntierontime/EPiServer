CREATE PROCEDURE [dbo].[netActivityLogCommentLoad]
(
	@Id	[bigint]
)
AS            
BEGIN
	SELECT * FROM [tblActivityLogComment]
		WHERE pkID = @Id
END
