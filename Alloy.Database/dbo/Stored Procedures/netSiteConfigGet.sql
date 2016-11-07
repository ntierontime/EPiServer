CREATE PROCEDURE [dbo].[netSiteConfigGet]
	@SiteID VARCHAR(250) = NULL,
	@PropertyName VARCHAR(250)
AS
BEGIN
	IF @SiteID IS NULL
	BEGIN
		SELECT * FROM tblSiteConfig WHERE PropertyName = @PropertyName
	END
	ELSE
	BEGIN
		SELECT * FROM tblSiteConfig WHERE SiteID = @SiteID AND PropertyName = @PropertyName
	END
END
