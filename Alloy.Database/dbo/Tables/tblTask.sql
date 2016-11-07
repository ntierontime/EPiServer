CREATE TABLE [dbo].[tblTask] (
    [pkID]               INT             IDENTITY (1, 1) NOT NULL,
    [Subject]            NVARCHAR (255)  NOT NULL,
    [Description]        NVARCHAR (2000) NULL,
    [DueDate]            DATETIME        NULL,
    [OwnerName]          NVARCHAR (255)  NOT NULL,
    [AssignedToName]     NVARCHAR (255)  NOT NULL,
    [AssignedIsRole]     BIT             NOT NULL,
    [fkPlugInID]         INT             NULL,
    [Status]             INT             CONSTRAINT [DF_tblTask_Status] DEFAULT ((0)) NOT NULL,
    [Activity]           NVARCHAR (MAX)  NULL,
    [State]              NVARCHAR (MAX)  NULL,
    [Created]            DATETIME        NOT NULL,
    [Changed]            DATETIME        NOT NULL,
    [WorkflowInstanceId] NVARCHAR (36)   NULL,
    [EventActivityName]  NVARCHAR (255)  NULL,
    CONSTRAINT [PK_tblTask] PRIMARY KEY CLUSTERED ([pkID] ASC),
    CONSTRAINT [FK_tblTask_tblPlugIn] FOREIGN KEY ([fkPlugInID]) REFERENCES [dbo].[tblPlugIn] ([pkID])
);

