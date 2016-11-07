CREATE TABLE [dbo].[AspNetUsers] (
    [Id]                   NVARCHAR (128) NOT NULL,
    [IsApproved]           BIT            NOT NULL,
    [IsLockedOut]          BIT            NOT NULL,
    [Comment]              NVARCHAR (MAX) NULL,
    [CreationDate]         DATETIME2 (7)  NOT NULL,
    [LastLoginDate]        DATETIME2 (7)  NULL,
    [LastLockoutDate]      DATETIME2 (7)  NULL,
    [Email]                NVARCHAR (256) NULL,
    [EmailConfirmed]       BIT            NOT NULL,
    [PasswordHash]         NVARCHAR (MAX) NULL,
    [SecurityStamp]        NVARCHAR (MAX) NULL,
    [PhoneNumber]          NVARCHAR (MAX) NULL,
    [PhoneNumberConfirmed] BIT            NOT NULL,
    [TwoFactorEnabled]     BIT            NOT NULL,
    [LockoutEndDateUtc]    DATETIME       NULL,
    [LockoutEnabled]       BIT            NOT NULL,
    [AccessFailedCount]    INT            NOT NULL,
    [UserName]             NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([UserName] ASC);

