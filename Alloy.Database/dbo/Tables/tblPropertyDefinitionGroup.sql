CREATE TABLE [dbo].[tblPropertyDefinitionGroup] (
    [pkID]         INT            IDENTITY (100, 1) NOT NULL,
    [SystemGroup]  BIT            CONSTRAINT [DF_tblPropertyDefinitionGroup_SystemGroup] DEFAULT ((0)) NOT NULL,
    [Access]       INT            CONSTRAINT [DF_tblPropertyDefinitionGroup_Access] DEFAULT ((10)) NOT NULL,
    [GroupVisible] BIT            CONSTRAINT [DF_tblPropertyDefinitionGroup_DefaultVisible] DEFAULT ((1)) NOT NULL,
    [GroupOrder]   INT            CONSTRAINT [DF_tblPropertyDefinitionGroup_GroupOrder] DEFAULT ((1)) NOT NULL,
    [Name]         NVARCHAR (100) NULL,
    [DisplayName]  NVARCHAR (100) NULL,
    CONSTRAINT [PK_tblPropertyDefinitionGroup] PRIMARY KEY CLUSTERED ([pkID] ASC)
);

