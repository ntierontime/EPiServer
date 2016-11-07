CREATE TABLE [dbo].[tblTree] (
    [fkParentID]   INT      NOT NULL,
    [fkChildID]    INT      NOT NULL,
    [NestingLevel] SMALLINT NOT NULL,
    CONSTRAINT [PK_tblTree] PRIMARY KEY CLUSTERED ([fkParentID] ASC, [fkChildID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblTree_fkChildID]
    ON [dbo].[tblTree]([fkChildID] ASC);

