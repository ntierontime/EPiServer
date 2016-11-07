CREATE PROCEDURE [dbo].[netSiteConfigSet]
	@SiteID VARCHAR(250),
	@PropertyName VARCHAR(250),
	@PropertyValue NVARCHAR(max)
AS
BEGIN
	DECLARE @Id AS INT
	SELECT @Id = pkID FROM tblSiteConfig WHERE SiteID = @SiteID AND PropertyName = @PropertyName
	IF @Id IS NOT NULL
	BEGIN
		-- Update
		UPDATE tblSiteConfig SET PropertyValue = @PropertyValue WHERE pkID = @Id
	END
	ELSE
	BEGIN
		INSERT INTO tblSiteConfig(SiteID, PropertyName, PropertyValue) VALUES(@SiteID, @PropertyName, @PropertyValue)
	END
END
