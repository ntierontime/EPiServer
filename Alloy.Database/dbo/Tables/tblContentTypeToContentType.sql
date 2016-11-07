CREATE TABLE [dbo].[tblContentTypeToContentType] (
    [fkContentTypeParentID] INT NOT NULL,
    [fkContentTypeChildID]  INT NOT NULL,
    [Access]                INT CONSTRAINT [DF_tblContentTypeToContentType_Access] DEFAULT ((20)) NOT NULL,
    [Availability]          INT CONSTRAINT [DF_tblContentTypeToContentType_Availability] DEFAULT ((0)) NOT NULL,
    [Allow]                 BIT NULL,
    CONSTRAINT [PK_tblContentTypeToContentType] PRIMARY KEY CLUSTERED ([fkContentTypeParentID] ASC, [fkContentTypeChildID] ASC),
    CONSTRAINT [FK_tblContentTypeToContentType_tblContentType] FOREIGN KEY ([fkContentTypeParentID]) REFERENCES [dbo].[tblContentType] ([pkID]),
    CONSTRAINT [FK_tblContentTypeToContentType_tblContentType1] FOREIGN KEY ([fkContentTypeChildID]) REFERENCES [dbo].[tblContentType] ([pkID])
);

