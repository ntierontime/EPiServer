CREATE TABLE [dbo].[tblBigTableIdentity] (
    [pkId]      BIGINT           IDENTITY (1, 1) NOT NULL,
    [Guid]      UNIQUEIDENTIFIER CONSTRAINT [DF_tblBigTableIdentity_Guid] DEFAULT (newid()) NOT NULL,
    [StoreName] NVARCHAR (375)   NOT NULL,
    CONSTRAINT [PK_tblBigTableIdentity] PRIMARY KEY CLUSTERED ([pkId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTableIdentity_Guid]
    ON [dbo].[tblBigTableIdentity]([Guid] ASC);

