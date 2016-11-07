CREATE PROCEDURE [dbo].[netNotificationMessageInsert]
	@Recipient NVARCHAR(50),
	@Sender NVARCHAR(50),
	@Channel NVARCHAR(50) = NULL,
	@Type NVARCHAR(50) = NULL,
	@Subject NVARCHAR(255) = NULL,
	@Content NVARCHAR(MAX) = NULL,
	@Saved DATETIME2,
	@SendAt DATETIME2 = NULL,
	@Category NVARCHAR(255) = NULL
AS
BEGIN
	INSERT INTO tblNotificationMessage(Recipient, Sender, Channel, Type, Subject, Content, SendAt, Saved, Category)
	VALUES(@Recipient, @Sender, @Channel, @Type, @Subject, @Content, @SendAt, @Saved, @Category)
	SELECT SCOPE_IDENTITY()
END
