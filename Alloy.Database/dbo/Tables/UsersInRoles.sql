CREATE TABLE [dbo].[UsersInRoles] (
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [RoleId] UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
    CONSTRAINT [UsersInRole_Role] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([RoleId]),
    CONSTRAINT [UsersInRole_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
);

