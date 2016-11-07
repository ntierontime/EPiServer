CREATE TABLE [dbo].[tblBigTableStoreConfig] (
    [pkId]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [StoreName]    NVARCHAR (375) NOT NULL,
    [TableName]    NVARCHAR (128) NULL,
    [EntityTypeId] INT            NULL,
    [DateTimeKind] INT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblBigTableStoreConfig] PRIMARY KEY CLUSTERED ([pkId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTableStoreConfig_StoreName]
    ON [dbo].[tblBigTableStoreConfig]([StoreName] ASC);

