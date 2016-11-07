CREATE TABLE [dbo].[tblBigTableStoreInfo] (
    [fkStoreId]       BIGINT          NOT NULL,
    [PropertyName]    NVARCHAR (75)   NOT NULL,
    [PropertyMapType] NVARCHAR (64)   NOT NULL,
    [PropertyIndex]   INT             NOT NULL,
    [PropertyType]    NVARCHAR (2000) NOT NULL,
    [Active]          BIT             NOT NULL,
    [Version]         INT             NOT NULL,
    [ColumnName]      NVARCHAR (128)  NULL,
    [ColumnRowIndex]  INT             NULL,
    CONSTRAINT [PK_tblBigTableStoreInfo] PRIMARY KEY CLUSTERED ([fkStoreId] ASC, [PropertyName] ASC),
    CONSTRAINT [FK_tblBigTableStoreInfo_tblBigTableStoreConfig] FOREIGN KEY ([fkStoreId]) REFERENCES [dbo].[tblBigTableStoreConfig] ([pkId])
);

