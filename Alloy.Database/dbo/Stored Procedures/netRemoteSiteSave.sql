CREATE PROCEDURE dbo.netRemoteSiteSave
(
	@ID				INT OUTPUT,
	@Name			NVARCHAR(100),
	@Url			NVARCHAR(255),
	@IsTrusted		BIT = 0,
	@UserName		NVARCHAR(50) = NULL,
	@Password		NVARCHAR(50) = NULL,
	@Domain			NVARCHAR(50) = NULL,
	@AllowUrlLookup BIT = 0
)
AS
BEGIN
	IF @ID=0
	BEGIN
		INSERT INTO tblRemoteSite(Name,Url,IsTrusted,UserName,Password,Domain,AllowUrlLookup) VALUES(@Name,@Url,@IsTrusted,@UserName,@Password,@Domain,@AllowUrlLookup)
		SET @ID =  SCOPE_IDENTITY() 
	END
	ELSE
		UPDATE tblRemoteSite SET Name=@Name,Url=@Url,IsTrusted=@IsTrusted,UserName=@UserName,Password=@Password,Domain=@Domain,AllowUrlLookup=@AllowUrlLookup WHERE pkID=@ID
END
