CREATE TABLE [dbo].[tblContentSoftlink] (
    [pkID]                    INT              IDENTITY (1, 1) NOT NULL,
    [fkOwnerContentID]        INT              NOT NULL,
    [fkReferencedContentGUID] UNIQUEIDENTIFIER NULL,
    [OwnerLanguageID]         INT              NULL,
    [ReferencedLanguageID]    INT              NULL,
    [LinkURL]                 NVARCHAR (2048)  NOT NULL,
    [LinkType]                INT              NOT NULL,
    [LinkProtocol]            NVARCHAR (10)    NULL,
    [ContentLink]             NVARCHAR (255)   NULL,
    [LastCheckedDate]         DATETIME         NULL,
    [FirstDateBroken]         DATETIME         NULL,
    [HttpStatusCode]          INT              NULL,
    [LinkStatus]              INT              NULL,
    CONSTRAINT [PK_tblContentSoftlink] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblContentSoftlink_tblContent] FOREIGN KEY ([fkOwnerContentID]) REFERENCES [dbo].[tblContent] ([pkID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentSoftlink_fkContentID]
    ON [dbo].[tblContentSoftlink]([fkOwnerContentID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblContentSoftlink_fkReferencedContentGUID]
    ON [dbo].[tblContentSoftlink]([fkReferencedContentGUID] ASC);

