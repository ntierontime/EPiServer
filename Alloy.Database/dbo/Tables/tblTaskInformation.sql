CREATE TABLE [dbo].[tblTaskInformation] (
    [pkId]               BIGINT           NOT NULL,
    [Row]                INT              CONSTRAINT [tblTaskInformation_Row] DEFAULT ((1)) NOT NULL,
    [StoreName]          NVARCHAR (375)   NOT NULL,
    [ItemType]           NVARCHAR (2000)  NOT NULL,
    [Boolean01]          BIT              NULL,
    [Boolean02]          BIT              NULL,
    [Integer01]          INT              NULL,
    [Long01]             BIGINT           NULL,
    [DateTime01]         DATETIME         NULL,
    [Guid01]             UNIQUEIDENTIFIER NULL,
    [Float01]            FLOAT (53)       NULL,
    [String01]           NVARCHAR (MAX)   NULL,
    [Indexed_Integer01]  INT              NULL,
    [Indexed_DateTime01] DATETIME         NULL,
    [Indexed_DateTime02] DATETIME         NULL,
    [Indexed_Guid01]     UNIQUEIDENTIFIER NULL,
    [Indexed_String01]   NVARCHAR (450)   NULL,
    [Indexed_String02]   NVARCHAR (450)   NULL,
    CONSTRAINT [PK_tblTaskInformation] PRIMARY KEY CLUSTERED ([pkId] ASC, [Row] ASC),
    CONSTRAINT [CH_tblTaskInformation] CHECK ([Row]>=(1)),
    CONSTRAINT [FK_tblTaskInformation_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_StoreName]
    ON [dbo].[tblTaskInformation]([StoreName] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_Integer01]
    ON [dbo].[tblTaskInformation]([Indexed_Integer01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_DateTime01]
    ON [dbo].[tblTaskInformation]([Indexed_DateTime01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_DateTime02]
    ON [dbo].[tblTaskInformation]([Indexed_DateTime02] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_Guid01]
    ON [dbo].[tblTaskInformation]([Indexed_Guid01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_String01]
    ON [dbo].[tblTaskInformation]([Indexed_String01] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTaskInformation_Indexed_String02]
    ON [dbo].[tblTaskInformation]([Indexed_String02] ASC);

