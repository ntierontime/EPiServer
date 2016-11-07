CREATE PROCEDURE [dbo].[netActivityLogCommentSave]
(
	@Id			BIGINT = 0 OUTPUT,
	@EntryId	BIGINT, 
    @Author		NVARCHAR(255) = NULL, 
    @Created	DATETIME, 
    @LastUpdated DATETIME, 
    @Message	NVARCHAR(max)
)
AS            
BEGIN
	IF (@Id = 0)
	BEGIN
		INSERT INTO [tblActivityLogComment] VALUES(@EntryId, @Author, @Created, @Created, @Message)
		SET @Id = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE [tblActivityLogComment] SET
			[EntryId] = @EntryId,
			[Author] = @Author,
			[LastUpdated] = @LastUpdated,
			[Message] = @Message
		WHERE pkID = @Id
	END
END
