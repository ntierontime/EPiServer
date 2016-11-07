CREATE TABLE [dbo].[tblSiteConfig] (
    [pkID]          INT            IDENTITY (1, 1) NOT NULL,
    [SiteID]        VARCHAR (250)  NOT NULL,
    [PropertyName]  VARCHAR (250)  NOT NULL,
    [PropertyValue] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_tblSiteConfig] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblSiteConfig]
    ON [dbo].[tblSiteConfig]([SiteID] ASC, [PropertyName] ASC);

