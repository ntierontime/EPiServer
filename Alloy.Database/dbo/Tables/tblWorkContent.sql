CREATE TABLE [dbo].[tblWorkContent] (
    [pkID]               INT              IDENTITY (1, 1) NOT NULL,
    [fkContentID]        INT              NOT NULL,
    [fkMasterVersionID]  INT              NULL,
    [ContentLinkGUID]    UNIQUEIDENTIFIER NULL,
    [fkFrameID]          INT              NULL,
    [ArchiveContentGUID] UNIQUEIDENTIFIER NULL,
    [ChangedByName]      NVARCHAR (255)   NOT NULL,
    [NewStatusByName]    NVARCHAR (255)   NULL,
    [Name]               NVARCHAR (255)   NULL,
    [URLSegment]         NVARCHAR (255)   NULL,
    [LinkURL]            NVARCHAR (255)   NULL,
    [BlobUri]            NVARCHAR (255)   NULL,
    [ThumbnailUri]       NVARCHAR (255)   NULL,
    [ExternalURL]        NVARCHAR (255)   NULL,
    [VisibleInMenu]      BIT              NOT NULL,
    [LinkType]           INT              CONSTRAINT [DF__tblWorkPa__LinkT__48BAC3E5] DEFAULT ((0)) NOT NULL,
    [Created]            DATETIME         NOT NULL,
    [Saved]              DATETIME         NOT NULL,
    [StartPublish]       DATETIME         NULL,
    [StopPublish]        DATETIME         NULL,
    [ChildOrderRule]     INT              CONSTRAINT [DF__tblWorkPa__Child__4B973090] DEFAULT ((1)) NOT NULL,
    [PeerOrder]          INT              CONSTRAINT [DF__tblWorkPa__PeerO__4C8B54C9] DEFAULT ((100)) NOT NULL,
    [ChangedOnPublish]   BIT              CONSTRAINT [DF__tblWorkPa__Chang__4E739D3B] DEFAULT ((0)) NOT NULL,
    [RejectComment]      NVARCHAR (2000)  NULL,
    [fkLanguageBranchID] INT              CONSTRAINT [DF__tblWorkPa__fkLan__4258C320] DEFAULT ((1)) NOT NULL,
    [CommonDraft]        BIT              CONSTRAINT [DF_tblWorkContent_CommonDraft] DEFAULT ((0)) NOT NULL,
    [Status]             INT              DEFAULT ((2)) NOT NULL,
    [DelayPublishUntil]  DATETIME         NULL,
    CONSTRAINT [PK_tblWorkContent] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblWorkContent_tblContent] FOREIGN KEY ([fkContentID]) REFERENCES [dbo].[tblContent] ([pkID]),
    CONSTRAINT [FK_tblWorkContent_tblFrame] FOREIGN KEY ([fkFrameID]) REFERENCES [dbo].[tblFrame] ([pkID]),
    CONSTRAINT [FK_tblWorkContent_tblLanguageBranch] FOREIGN KEY ([fkLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID]),
    CONSTRAINT [FK_tblWorkContent_tblWorkContent2] FOREIGN KEY ([fkMasterVersionID]) REFERENCES [dbo].[tblWorkContent] ([pkID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_fkContentID]
    ON [dbo].[tblWorkContent]([fkContentID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_ChangedByName]
    ON [dbo].[tblWorkContent]([ChangedByName] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_StatusFields]
    ON [dbo].[tblWorkContent]([Status] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_ArchiveContentGUID]
    ON [dbo].[tblWorkContent]([ArchiveContentGUID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_ContentLinkGUID]
    ON [dbo].[tblWorkContent]([ContentLinkGUID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_fkMasterVersionID]
    ON [dbo].[tblWorkContent]([fkMasterVersionID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblWorkContent_fkLanguageBranchID]
    ON [dbo].[tblWorkContent]([fkLanguageBranchID] ASC);

