CREATE TABLE [dbo].[tblContentType] (
    [pkID]                   INT              IDENTITY (1, 1) NOT NULL,
    [ContentTypeGUID]        UNIQUEIDENTIFIER CONSTRAINT [DF_tblContentType_ContentTypeGUID] DEFAULT (newid()) NOT NULL,
    [Created]                DATETIME         NOT NULL,
    [DefaultWebFormTemplate] NVARCHAR (1024)  NULL,
    [DefaultMvcController]   NVARCHAR (1024)  NULL,
    [DefaultMvcPartialView]  NVARCHAR (255)   NULL,
    [Filename]               NVARCHAR (255)   NULL,
    [ModelType]              NVARCHAR (1024)  NULL,
    [Name]                   NVARCHAR (50)    NOT NULL,
    [DisplayName]            NVARCHAR (50)    NULL,
    [Description]            NVARCHAR (255)   NULL,
    [IdString]               NVARCHAR (50)    NULL,
    [Available]              BIT              NULL,
    [SortOrder]              INT              NULL,
    [MetaDataInherit]        INT              CONSTRAINT [DF_tblContentType_MetaDataInherit] DEFAULT ((0)) NOT NULL,
    [MetaDataDefault]        INT              CONSTRAINT [DF_tblContentType_MetaDataDefault] DEFAULT ((0)) NOT NULL,
    [WorkflowEditFields]     BIT              NULL,
    [ACL]                    NVARCHAR (MAX)   NULL,
    [ContentType]            INT              CONSTRAINT [DF_tblContentType_ContentType] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblContentType] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContentType_ContentTypeGUID]
    ON [dbo].[tblContentType]([ContentTypeGUID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblContentType_Name]
    ON [dbo].[tblContentType]([Name] ASC);

