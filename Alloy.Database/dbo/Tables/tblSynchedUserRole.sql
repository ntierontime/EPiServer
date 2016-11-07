CREATE TABLE [dbo].[tblSynchedUserRole] (
    [pkID]            INT            IDENTITY (1, 1) NOT NULL,
    [RoleName]        NVARCHAR (255) NOT NULL,
    [LoweredRoleName] NVARCHAR (255) NOT NULL,
    [Enabled]         BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblSynchedUserRole] PRIMARY KEY CLUSTERED ([pkID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblSynchedUserRole_Unique]
    ON [dbo].[tblSynchedUserRole]([LoweredRoleName] ASC);

