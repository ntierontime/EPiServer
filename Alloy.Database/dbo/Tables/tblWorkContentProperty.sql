CREATE TABLE [dbo].[tblWorkContentProperty] (
    [pkID]                   INT              IDENTITY (1, 1) NOT NULL,
    [fkPropertyDefinitionID] INT              NOT NULL,
    [fkWorkContentID]        INT              NOT NULL,
    [ScopeName]              NVARCHAR (450)   NULL,
    [guid]                   UNIQUEIDENTIFIER CONSTRAINT [DF__tblWorkContentProperty_guid] DEFAULT (newid()) NOT NULL,
    [Boolean]                BIT              CONSTRAINT [DF__tblWorkPr__Boole__55209ACA] DEFAULT ((0)) NOT NULL,
    [Number]                 INT              NULL,
    [FloatNumber]            FLOAT (53)       NULL,
    [ContentType]            INT              NULL,
    [ContentLink]            INT              NULL,
    [Date]                   DATETIME         NULL,
    [String]                 NVARCHAR (450)   NULL,
    [LongString]             NVARCHAR (MAX)   NULL,
    [LinkGuid]               UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_tblWorkProperty] PRIMARY KEY NONCLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblWorkContentProperty_tblContent] FOREIGN KEY ([ContentLink]) REFERENCES [dbo].[tblContent] ([pkID]),
    CONSTRAINT [FK_tblWorkContentProperty_tblContentType] FOREIGN KEY ([ContentType]) REFERENCES [dbo].[tblContentType] ([pkID]),
    CONSTRAINT [FK_tblWorkContentProperty_tblPropertyDefinition] FOREIGN KEY ([fkPropertyDefinitionID]) REFERENCES [dbo].[tblPropertyDefinition] ([pkID]),
    CONSTRAINT [FK_tblWorkContentProperty_tblWorkContent] FOREIGN KEY ([fkWorkContentID]) REFERENCES [dbo].[tblWorkContent] ([pkID])
);


GO
CREATE CLUSTERED INDEX [IX_tblWorkContentProperty_fkWorkContentID]
    ON [dbo].[tblWorkContentProperty]([fkWorkContentID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContentProperty_ContentLink]
    ON [dbo].[tblWorkContentProperty]([ContentLink] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContentProperty_ScopeName]
    ON [dbo].[tblWorkContentProperty]([ScopeName] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContentProperty_ContentTypeID]
    ON [dbo].[tblWorkContentProperty]([ContentType] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContentProperty_fkPropertyDefinitionID]
    ON [dbo].[tblWorkContentProperty]([fkPropertyDefinitionID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblWorkContentProperty_guid]
    ON [dbo].[tblWorkContentProperty]([guid] ASC);

