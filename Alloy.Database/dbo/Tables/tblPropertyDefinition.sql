CREATE TABLE [dbo].[tblPropertyDefinition] (
    [pkID]                       INT              IDENTITY (1, 1) NOT NULL,
    [fkContentTypeID]            INT              NULL,
    [fkPropertyDefinitionTypeID] INT              NULL,
    [FieldOrder]                 INT              NULL,
    [Name]                       NVARCHAR (100)   NOT NULL,
    [Property]                   INT              NOT NULL,
    [Required]                   BIT              NULL,
    [Advanced]                   INT              NULL,
    [Searchable]                 BIT              NULL,
    [EditCaption]                NVARCHAR (255)   NULL,
    [HelpText]                   NVARCHAR (2000)  NULL,
    [ObjectProgID]               NVARCHAR (255)   NULL,
    [DefaultValueType]           INT              CONSTRAINT [DF_tblPropertyDefinition_DefaultValueType] DEFAULT ((0)) NOT NULL,
    [LongStringSettings]         INT              CONSTRAINT [DF_tblPropertyDefinition_LongStringSettings] DEFAULT ((-1)) NOT NULL,
    [SettingsID]                 UNIQUEIDENTIFIER NULL,
    [LanguageSpecific]           INT              CONSTRAINT [DF_tblPropertyDefinition_CommonLang] DEFAULT ((0)) NOT NULL,
    [DisplayEditUI]              BIT              NULL,
    [ExistsOnModel]              BIT              CONSTRAINT [DF_tblPropertyDefinition_ExistsOnModel] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblPropertyDefinition] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblPropertyDefinition_tblContentType] FOREIGN KEY ([fkContentTypeID]) REFERENCES [dbo].[tblContentType] ([pkID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_tblPropertyDefinition_ContentTypeAndName]
    ON [dbo].[tblPropertyDefinition]([fkContentTypeID] ASC, [Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblPropertyDefinition_fkContentTypeID]
    ON [dbo].[tblPropertyDefinition]([fkContentTypeID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblPropertyDefinition_Name]
    ON [dbo].[tblPropertyDefinition]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblPropertyDefinition_fkPropertyDefinitionTypeID]
    ON [dbo].[tblPropertyDefinition]([fkPropertyDefinitionTypeID] ASC);

