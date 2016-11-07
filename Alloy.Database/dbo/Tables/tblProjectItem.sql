CREATE TABLE [dbo].[tblProjectItem] (
    [pkID]                INT            IDENTITY (1, 1) NOT NULL,
    [fkProjectID]         INT            NOT NULL,
    [ContentLinkID]       INT            NOT NULL,
    [ContentLinkWorkID]   INT            NOT NULL,
    [ContentLinkProvider] NVARCHAR (255) NOT NULL,
    [Language]            VARCHAR (17)   NOT NULL,
    [Category]            NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_tblProjectItem] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblProjectItem_tblProject] FOREIGN KEY ([fkProjectID]) REFERENCES [dbo].[tblProject] ([pkID])
);


GO
CREATE NONCLUSTERED INDEX [IX_tblProjectItem_ContentLink]
    ON [dbo].[tblProjectItem]([ContentLinkID] ASC, [ContentLinkProvider] ASC, [ContentLinkWorkID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblProjectItem_fkProjectID]
    ON [dbo].[tblProjectItem]([fkProjectID] ASC, [Category] ASC, [Language] ASC);

