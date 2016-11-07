CREATE TABLE [dbo].[tblSynchedUserRelations] (
    [fkSynchedUser] INT NOT NULL,
    [fkSynchedRole] INT NOT NULL,
    CONSTRAINT [PK_tblSynchedUserRelations] PRIMARY KEY CLUSTERED ([fkSynchedUser] ASC, [fkSynchedRole] ASC),
    CONSTRAINT [FK_tblSynchedUserRelations_Group] FOREIGN KEY ([fkSynchedRole]) REFERENCES [dbo].[tblSynchedUserRole] ([pkID]),
    CONSTRAINT [FK_tblSyncheduserRelations_User] FOREIGN KEY ([fkSynchedUser]) REFERENCES [dbo].[tblSynchedUser] ([pkID])
);

