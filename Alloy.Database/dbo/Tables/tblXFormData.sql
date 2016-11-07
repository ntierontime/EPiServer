CREATE TABLE [dbo].[tblXFormData] (
    [pkId]             BIGINT           NOT NULL,
    [Row]              INT              CONSTRAINT [DF_tblXFormData_Row] DEFAULT ((1)) NOT NULL,
    [StoreName]        NVARCHAR (375)   NOT NULL,
    [ItemType]         NVARCHAR (2000)  NOT NULL,
    [ChannelOptions]   INT              NULL,
    [DatePosted]       DATETIME         NULL,
    [FormId]           UNIQUEIDENTIFIER NULL,
    [PageGuid]         UNIQUEIDENTIFIER NULL,
    [UserName]         NVARCHAR (450)   NULL,
    [String01]         NVARCHAR (MAX)   NULL,
    [String02]         NVARCHAR (MAX)   NULL,
    [String03]         NVARCHAR (MAX)   NULL,
    [String04]         NVARCHAR (MAX)   NULL,
    [String05]         NVARCHAR (MAX)   NULL,
    [String06]         NVARCHAR (MAX)   NULL,
    [String07]         NVARCHAR (MAX)   NULL,
    [String08]         NVARCHAR (MAX)   NULL,
    [String09]         NVARCHAR (MAX)   NULL,
    [String10]         NVARCHAR (MAX)   NULL,
    [String11]         NVARCHAR (MAX)   NULL,
    [String12]         NVARCHAR (MAX)   NULL,
    [String13]         NVARCHAR (MAX)   NULL,
    [String14]         NVARCHAR (MAX)   NULL,
    [String15]         NVARCHAR (MAX)   NULL,
    [String16]         NVARCHAR (MAX)   NULL,
    [String17]         NVARCHAR (MAX)   NULL,
    [String18]         NVARCHAR (MAX)   NULL,
    [String19]         NVARCHAR (MAX)   NULL,
    [String20]         NVARCHAR (MAX)   NULL,
    [Indexed_String01] NVARCHAR (450)   NULL,
    [Indexed_String02] NVARCHAR (450)   NULL,
    [Indexed_String03] NVARCHAR (450)   NULL,
    CONSTRAINT [PK_tblXFormData] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC),
    CONSTRAINT [CH_tblXFormData] CHECK ([Row]>=(1)),
    CONSTRAINT [FK_tblXFormData_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblXFormData_String01]
    ON [dbo].[tblXFormData]([Indexed_String01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblXFormData_String02]
    ON [dbo].[tblXFormData]([Indexed_String02] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblXFormData_String03]
    ON [dbo].[tblXFormData]([Indexed_String03] ASC);

