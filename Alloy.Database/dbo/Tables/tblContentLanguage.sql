CREATE TABLE [dbo].[tblContentLanguage] (
    [fkContentID]        INT              NOT NULL,
    [fkLanguageBranchID] INT              NOT NULL,
    [ContentLinkGUID]    UNIQUEIDENTIFIER NULL,
    [fkFrameID]          INT              NULL,
    [CreatorName]        NVARCHAR (255)   NULL,
    [ChangedByName]      NVARCHAR (255)   NULL,
    [ContentGUID]        UNIQUEIDENTIFIER CONSTRAINT [DF__tblContentLanguage__ContentGUID] DEFAULT (newid()) NOT NULL,
    [Name]               NVARCHAR (255)   NULL,
    [URLSegment]         NVARCHAR (255)   NULL,
    [LinkURL]            NVARCHAR (255)   NULL,
    [BlobUri]            NVARCHAR (255)   NULL,
    [ThumbnailUri]       NVARCHAR (255)   NULL,
    [ExternalURL]        NVARCHAR (255)   NULL,
    [AutomaticLink]      BIT              CONSTRAINT [DF__tblContentLanguage__Automatic] DEFAULT ((1)) NOT NULL,
    [FetchData]          BIT              CONSTRAINT [DF__tblContentLanguage__FetchData] DEFAULT ((0)) NOT NULL,
    [Created]            DATETIME         NOT NULL,
    [Changed]            DATETIME         NOT NULL,
    [Saved]              DATETIME         NOT NULL,
    [StartPublish]       DATETIME         NULL,
    [StopPublish]        DATETIME         NULL,
    [Version]            INT              NULL,
    [Status]             INT              DEFAULT ((2)) NOT NULL,
    [DelayPublishUntil]  DATETIME         NULL,
    CONSTRAINT [PK_tblContentLanguage] PRIMARY KEY CLUSTERED ([fkContentID] ASC, [fkLanguageBranchID] ASC),
    CONSTRAINT [FK_tblContentLanguage_tblContent2] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]),
    CONSTRAINT [FK_tblContentLanguage_tblFrame] FOREIGN KEY ([fkFrameID]) REFERENCES [dbo].[tblFrame] ([pkID]),
    CONSTRAINT [FK_tblContentLanguage_tblLanguageBranch] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]),
    CONSTRAINT [FK_tblContentLanguage_tblWorkContent] FOREIGN KEY ([Version]) REFERENCES [dbo].[tblWorkContent] ([pkID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContentLanguage_ContentGUID]
    ON [dbo].[tblContentLanguage]([ContentGUID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_Name]
    ON [dbo].[tblContentLanguage]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_ExternalURL]
    ON [dbo].[tblContentLanguage]([ExternalURL] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_URLSegment]
    ON [dbo].[tblContentLanguage]([URLSegment] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_ContentLinkGUID]
    ON [dbo].[tblContentLanguage]([ContentLinkGUID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentLanguage_Version]
    ON [dbo].[tblContentLanguage]([Version] ASC);

