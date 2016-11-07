CREATE TABLE [dbo].[tblSiteDefinition] (
    [pkID]           INT              IDENTITY (1, 1) NOT NULL,
    [UniqueId]       UNIQUEIDENTIFIER NOT NULL,
    [Name]           NVARCHAR (255)   NOT NULL,
    [StartPage]      VARCHAR (255)    NULL,
    [SiteUrl]        VARCHAR (MAX)    NULL,
    [SiteAssetsRoot] VARCHAR (255)    NULL,
    CONSTRAINT [PK_tblSiteDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblSiteDefinition_UniqueId]
    ON [dbo].[tblSiteDefinition]([UniqueId] ASC);

