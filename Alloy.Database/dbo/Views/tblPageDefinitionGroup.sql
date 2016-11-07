CREATE VIEW [dbo].[tblPageDefinitionGroup]
AS
SELECT
	[pkID],
	[SystemGroup],
	[Access],
	[GroupVisible],
	[GroupOrder],
	[Name],
	[DisplayName]
FROM    dbo.tblPropertyDefinitionGroup
