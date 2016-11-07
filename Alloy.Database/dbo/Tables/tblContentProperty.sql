CREATE TABLE [dbo].[tblContentProperty] (
    [pkID]                   INT              IDENTITY (1, 1) NOT NULL,
    [fkPropertyDefinitionID] INT              NOT NULL,
    [fkContentID]            INT              NOT NULL,
    [fkLanguageBranchID]     INT              CONSTRAINT [DF__tblProper__fkLan__29B609E9] DEFAULT ((1)) NOT NULL,
    [ScopeName]              NVARCHAR (450)   NULL,
    [guid]                   UNIQUEIDENTIFIER CONSTRAINT [DF__tblPropert__guid__43F60EC8] DEFAULT (newid()) NOT NULL,
    [Boolean]                BIT              CONSTRAINT [DF__tblProper__Boole__44EA3301] DEFAULT ((0)) NOT NULL,
    [Number]                 INT              NULL,
    [FloatNumber]            FLOAT (53)       NULL,
    [ContentType]            INT              NULL,
    [ContentLink]            INT              NULL,
    [Date]                   DATETIME         NULL,
    [String]                 NVARCHAR (450)   NULL,
    [LongString]             NVARCHAR (MAX)   NULL,
    [LongStringLength]       INT              NULL,
    [LinkGuid]               UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_tblContentProperty] PRIMARY KEY NONCLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblContentProperty_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]),
    CONSTRAINT [FK_tblContentProperty_tblContent2] FOREIGN KEY ([ContentLink]) REFERENCES [dbo].[tblContent] ([pkID]),
    CONSTRAINT [FK_tblContentProperty_tblLanguageBranch] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]),
    CONSTRAINT [FK_tblContentProperty_tblPropertyDefinition] FOREIGN KEY ([fkPropertyDefinitionID]) REFERENCES [dbo].[tblPropertyDefinition] ([pkID])
);


GO
CREATE CLUSTERED INDEX [IDX_tblContentProperty_fkContentID]
    ON [dbo].[tblContentProperty]([fkContentID] ASC, [fkLanguageBranchID] ASC, [fkPropertyDefinitionID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentProperty_fkPropertyDefinitionID]
    ON [dbo].[tblContentProperty]([fkPropertyDefinitionID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentProperty_ScopeName]
    ON [dbo].[tblContentProperty]([ScopeName] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentProperty_ContentLink]
    ON [dbo].[tblContentProperty]([ContentLink] ASC, [LinkGuid] ASC)
    INCLUDE([fkPropertyDefinitionID], [fkContentID], [fkLanguageBranchID]);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentProperty_ContentTypeID]
    ON [dbo].[tblContentProperty]([ContentType] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblContentProperty_guid]
    ON [dbo].[tblContentProperty]([guid] ASC);

