CREATE PROCEDURE dbo.netRemoteSiteLoad
(
	@ID INT
)
AS
BEGIN
	SELECT pkID,Name,Url,IsTrusted,UserName,[Password],Domain,AllowUrlLookup
	FROM tblRemoteSite
	WHERE pkID=@ID
END
