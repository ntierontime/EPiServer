CREATE TABLE [dbo].[tblSynchedUser] (
    [pkID]             INT            IDENTITY (1, 1) NOT NULL,
    [UserName]         NVARCHAR (255) NOT NULL,
    [LoweredUserName]  NVARCHAR (255) NOT NULL,
    [Email]            NVARCHAR (255) NULL,
    [GivenName]        NVARCHAR (255) NULL,
    [LoweredGivenName] NVARCHAR (255) NULL,
    [Surname]          NVARCHAR (255) NULL,
    [LoweredSurname]   NVARCHAR (255) NULL,
    [Metadata]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblWindowsUser] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblWindowsUser_Unique]
    ON [dbo].[tblSynchedUser]([LoweredUserName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblWindowsUser_Email]
    ON [dbo].[tblSynchedUser]([Email] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblWindowsUser_LoweredGivenName]
    ON [dbo].[tblSynchedUser]([LoweredGivenName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblWindowsUser_LoweredSurname]
    ON [dbo].[tblSynchedUser]([LoweredSurname] ASC);

