CREATE TABLE [dbo].[tblContentTypeDefault] (
    [pkID]                    INT            IDENTITY (1, 1) NOT NULL,
    [fkContentTypeID]         INT            NOT NULL,
    [fkContentLinkID]         INT            NULL,
    [fkFrameID]               INT            NULL,
    [fkArchiveContentID]      INT            NULL,
    [Name]                    NVARCHAR (255) NULL,
    [VisibleInMenu]           BIT            CONSTRAINT [DF_tblContentTypeDefault_VisibleInMenu] DEFAULT ((1)) NOT NULL,
    [StartPublishOffsetValue] INT            NULL,
    [StartPublishOffsetType]  NCHAR (1)      NULL,
    [StopPublishOffsetValue]  INT            NULL,
    [StopPublishOffsetType]   NCHAR (1)      NULL,
    [ChildOrderRule]          INT            CONSTRAINT [DF_tblContentTypeDefault_ChildOrderRule] DEFAULT ((1)) NOT NULL,
    [PeerOrder]               INT            CONSTRAINT [DF_tblContentTypeDefault_PeerOrder] DEFAULT ((100)) NOT NULL,
    [StartPublishOffset]      INT            NULL,
    [StopPublishOffset]       INT            NULL,
    CONSTRAINT [PK_tblContentTypeDefault] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblContentTypeDefault_tblContentType] FOREIGN KEY ([fkContentTypeID]) REFERENCES [dbo].[tblContentType] ([pkID])
);

