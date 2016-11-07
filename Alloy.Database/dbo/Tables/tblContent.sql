CREATE TABLE [dbo].[tblContent] (
    [pkID]                     INT              IDENTITY (1, 1) NOT NULL,
    [fkContentTypeID]          INT              NOT NULL,
    [fkParentID]               INT              NULL,
    [ArchiveContentGUID]       UNIQUEIDENTIFIER NULL,
    [CreatorName]              NVARCHAR (255)   NULL,
    [ContentGUID]              UNIQUEIDENTIFIER CONSTRAINT [DF__tblContent__ContentGUID] DEFAULT (newid()) NOT NULL,
    [VisibleInMenu]            BIT              CONSTRAINT [DF__tblContent__Visible__2E06CDA9] DEFAULT ((1)) NOT NULL,
    [Deleted]                  BIT              CONSTRAINT [DF__tblContent__Deleted__2EFAF1E2] DEFAULT ((0)) NOT NULL,
    [ChildOrderRule]           INT              CONSTRAINT [DF__tblContent__ChildOr__35A7EF71] DEFAULT ((1)) NOT NULL,
    [PeerOrder]                INT              CONSTRAINT [DF__tblContent__PeerOrd__369C13AA] DEFAULT ((100)) NOT NULL,
    [ContentAssetsID]          UNIQUEIDENTIFIER NULL,
    [ContentOwnerID]           UNIQUEIDENTIFIER NULL,
    [DeletedBy]                NVARCHAR (255)   NULL,
    [DeletedDate]              DATETIME         NULL,
    [fkMasterLanguageBranchID] INT              CONSTRAINT [DF__tblContent__fkMasterLangaugeBranchID] DEFAULT ((1)) NOT NULL,
    [ContentPath]              VARCHAR (900)    NOT NULL,
    [ContentType]              INT              CONSTRAINT [DF_tblContent_ContentType] DEFAULT ((0)) NOT NULL,
    [IsLeafNode]               BIT              CONSTRAINT [DF_tblContent_IsLeafNode] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblContent] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblContent_tblContent] FOREIGN KEY ([fkParentID]) REFERENCES [dbo].[tblContent] ([pkID]),
    CONSTRAINT [FK_tblContent_tblContentType] FOREIGN KEY ([fkContentTypeID]) REFERENCES [dbo].[tblContentType] ([pkID]),
    CONSTRAINT [FK_tblContent_tblLanguageBranch] FOREIGN KEY ([fkMasterLanguageBranchID]) REFERENCES [dbo].[tblLanguageBranch] ([pkID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_fkParentID]
    ON [dbo].[tblContent]([fkParentID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContent_ContentGUID]
    ON [dbo].[tblContent]([ContentGUID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_ContentType]
    ON [dbo].[tblContent]([ContentType] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_ArchiveContentGUID]
    ON [dbo].[tblContent]([ArchiveContentGUID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_ContentPath]
    ON [dbo].[tblContent]([ContentPath] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContent_fkContentTypeID]
    ON [dbo].[tblContent]([fkContentTypeID] ASC);

