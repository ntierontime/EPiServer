CREATE TABLE [dbo].[Roles] (
    [RoleId]        UNIQUEIDENTIFIER NOT NULL,
    [ApplicationId] UNIQUEIDENTIFIER NOT NULL,
    [RoleName]      NVARCHAR (256)   NOT NULL,
    [Description]   NVARCHAR (256)   NULL,
    PRIMARY KEY CLUSTERED ([RoleId] ASC),
    CONSTRAINT [RoleEntity_Application] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Applications] ([ApplicationId])
);

