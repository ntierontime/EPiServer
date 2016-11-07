CREATE PROCEDURE dbo.netRemoteSiteList
AS
BEGIN
SELECT pkID,Name,Url,IsTrusted,UserName,[Password],Domain,AllowUrlLookup
FROM tblRemoteSite
ORDER BY Name ASC
END
