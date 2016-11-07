CREATE TABLE [dbo].[tblProjectMember] (
    [pkID]        INT            IDENTITY (1, 1) NOT NULL,
    [fkProjectID] INT            NOT NULL,
    [Name]        NVARCHAR (255) NOT NULL,
    [Type]        SMALLINT       NOT NULL,
    CONSTRAINT [PK_tblProjectMember] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblProjectMember_tblProject] FOREIGN KEY ([fkProjectID]) REFERENCES [dbo].[tblProject] ([pkID])
);


GO
CREATE NONCLUSTERED INDEX [IX_tblProjectMember_fkProjectID]
    ON [dbo].[tblProjectMember]([fkProjectID] ASC);

