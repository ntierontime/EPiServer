CREATE TABLE [dbo].[tblBigTableReference] (
    [pkId]             BIGINT           NOT NULL,
    [Type]             INT              NOT NULL,
    [PropertyName]     NVARCHAR (75)    NOT NULL,
    [CollectionType]   NVARCHAR (2000)  NULL,
    [ElementType]      NVARCHAR (2000)  NULL,
    [ElementStoreName] NVARCHAR (375)   NULL,
    [IsKey]            BIT              NOT NULL,
    [Index]            INT              CONSTRAINT [tblBigTableReference_Index] DEFAULT ((1)) NOT NULL,
    [BooleanValue]     BIT              NULL,
    [IntegerValue]     INT              NULL,
    [LongValue]        BIGINT           NULL,
    [DateTimeValue]    DATETIME         NULL,
    [GuidValue]        UNIQUEIDENTIFIER NULL,
    [FloatValue]       FLOAT (53)       NULL,
    [StringValue]      NVARCHAR (MAX)   NULL,
    [BinaryValue]      VARBINARY (MAX)  NULL,
    [RefIdValue]       BIGINT           NULL,
    [ExternalIdValue]  BIGINT           NULL,
    [DecimalValue]     DECIMAL (18, 3)  NULL,
    CONSTRAINT [PK_tblBigTableReference] PRIMARY KEY CLUSTERED ([pkId] ASC, [PropertyName] ASC, [IsKey] ASC, [Index] ASC),
    CONSTRAINT [CH_tblBigTableReference_Index] CHECK ([Index]>=(-1)),
    CONSTRAINT [FK_tblBigTableReference_RefId_tblBigTableIdentity] FOREIGN KEY ([RefIdValue]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId]),
    CONSTRAINT [FK_tblBigTableReference_tblBigTableIdentity] FOREIGN KEY ([pkId]) REFERENCES [dbo].[tblBigTableIdentity] ([pkId])
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblBigTableReference_RefIdValue]
    ON [dbo].[tblBigTableReference]([RefIdValue] ASC);

