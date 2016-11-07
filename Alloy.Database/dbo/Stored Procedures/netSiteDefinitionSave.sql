CREATE PROCEDURE [dbo].[netSiteDefinitionSave]
(
	@UniqueId uniqueidentifier = NULL OUTPUT,
	@Name nvarchar(255),
	@SiteUrl varchar(MAX),
	@StartPage varchar(255),
	@SiteAssetsRoot varchar(255) = NULL,
	@Hosts dbo.HostDefinitionTable READONLY
)
AS
BEGIN
	DECLARE @SiteID int
	
	IF (@UniqueId IS NULL OR @UniqueId = CAST(0x0 AS uniqueidentifier))
		SET @UniqueId = NEWID()
	ELSE -- If UniqueId is set we must first check if it has been saved before
		SELECT @SiteID = pkID FROM tblSiteDefinition WHERE UniqueId = @UniqueId
	IF (@SiteID IS NULL) 
	BEGIN
		INSERT INTO tblSiteDefinition 
		(
			UniqueId,
			Name,
			SiteUrl,
			StartPage,
			SiteAssetsRoot
		) 
		VALUES
		(
			@UniqueId,
			@Name,
			@SiteUrl,
			@StartPage,
			@SiteAssetsRoot
		)
		SET @SiteID = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE tblSiteDefinition SET 
			UniqueId=@UniqueId,
			Name = @Name,
			SiteUrl = @SiteUrl,
			StartPage = @StartPage,
			SiteAssetsRoot = @SiteAssetsRoot
		WHERE 
			pkID = @SiteID
		
	END
	-- Site hosts
	MERGE tblHostDefinition AS Target
    USING @Hosts AS Source
    ON (Target.Name = Source.Name AND Target.fkSiteID=@SiteID)
    WHEN MATCHED THEN 
        UPDATE SET fkSiteID = @SiteID, Name = Source.Name, Type = Source.Type, Language = Source.Language, Https = Source.Https
	WHEN NOT MATCHED BY Source AND Target.fkSiteID = @SiteID THEN
		DELETE
	WHEN NOT MATCHED BY Target THEN
		INSERT (fkSiteID, Name, Type, Language, Https)
		VALUES (@SiteID, Source.Name, Source.Type, Source.Language, Source.Https);
END
