CREATE TABLE [dbo].[tblHostDefinition] (
    [pkID]     INT           IDENTITY (1, 1) NOT NULL,
    [fkSiteID] INT           NOT NULL,
    [Name]     VARCHAR (MAX) NOT NULL,
    [Type]     INT           DEFAULT ((0)) NOT NULL,
    [Language] VARCHAR (50)  NULL,
    [Https]    BIT           NULL,
    CONSTRAINT [PK_tblHostDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblHostDefinition_tblSiteDefinition] FOREIGN KEY ([fkSiteID]) REFERENCES [dbo].[tblSiteDefinition] ([pkID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_tblHostDefinition_fkID]
    ON [dbo].[tblHostDefinition]([fkSiteID] ASC);

