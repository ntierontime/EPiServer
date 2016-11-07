CREATE TABLE [dbo].[tblUserPermission] (
    [pkID]       INT            IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (255) NOT NULL,
    [IsRole]     INT            CONSTRAINT [DF_tblUserPermission_IsRole] DEFAULT ((1)) NOT NULL,
    [Permission] NVARCHAR (150) NOT NULL,
    [GroupName]  NVARCHAR (150) NOT NULL,
    CONSTRAINT [PK_tblUserPermission] PRIMARY KEY NONCLUSTERED ([pkID] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_tblUserPermission_Permission_GroupName]
    ON [dbo].[tblUserPermission]([Permission] ASC, [GroupName] ASC);

