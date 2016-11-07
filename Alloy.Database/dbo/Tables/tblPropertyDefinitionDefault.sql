CREATE TABLE [dbo].[tblPropertyDefinitionDefault] (
    [pkID]                   INT              IDENTITY (1, 1) NOT NULL,
    [fkPropertyDefinitionID] INT              NOT NULL,
    [Boolean]                BIT              CONSTRAINT [DF_tblPropertyDefault_Boolean] DEFAULT ((0)) NOT NULL,
    [Number]                 INT              NULL,
    [FloatNumber]            FLOAT (53)       NULL,
    [ContentType]            INT              NULL,
    [ContentLink]            INT              NULL,
    [Date]                   DATETIME         NULL,
    [String]                 NVARCHAR (450)   NULL,
    [LongString]             NVARCHAR (MAX)   NULL,
    [LinkGuid]               UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_tblPropertyDefinitionDefault] PRIMARY KEY CLUSTERED ([pkID] ASC)
);

