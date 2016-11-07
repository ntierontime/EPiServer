CREATE PROCEDURE dbo.netSynchedUserInsertOrUpdate 
(
	@UserName NVARCHAR(255),
	@GivenName NVARCHAR(255) = NULL,
	@Surname NVARCHAR(255) = NULL,
	@Email NVARCHAR(255) = NULL,
	@Metadata NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @UserID INT
	DECLARE @LoweredName NVARCHAR(255)
	SET @LoweredName=LOWER(@UserName)
	SET @UserID = (SELECT pkID FROM [tblSynchedUser] WHERE LoweredUserName=@LoweredName)
	IF (@UserID IS NOT NULL)
	BEGIN
		UPDATE [tblSynchedUser] SET
			UserName = @UserName,
			LoweredUserName = @LoweredName,
			Email =  LOWER(@Email),
			GivenName = @GivenName,
			LoweredGivenName = LOWER(@GivenName),
			Surname = @Surname,
			LoweredSurname = LOWER(@Surname),
			Metadata = @Metadata
		WHERE 
			pkID = @UserID
	END
	ELSE
	BEGIN
		INSERT INTO [tblSynchedUser] 
			(UserName, LoweredUserName, Email, GivenName, LoweredGivenName, Surname, LoweredSurname, Metadata) 
		SELECT 
			@UserName, 
			@LoweredName,
			Lower(@Email),
			@GivenName,
			Lower(@GivenName),
			@Surname,
			Lower(@Surname),
			@Metadata
		SET @UserID= SCOPE_IDENTITY()
	END
	SELECT @UserID
END
