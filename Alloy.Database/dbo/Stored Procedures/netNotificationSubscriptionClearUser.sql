CREATE PROCEDURE [dbo].[netNotificationSubscriptionClearUser]
	@UserName [nvarchar](50)
AS
BEGIN
	DELETE FROM [dbo].[tblNotificationSubscription] WHERE UserName = @UserName
END
