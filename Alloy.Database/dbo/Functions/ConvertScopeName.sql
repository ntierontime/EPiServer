CREATE FUNCTION [dbo].[ConvertScopeName]
(
	@ScopeName nvarchar(450),
	@OldDefinitionID int,
	@NewDefinitionID int	
)
RETURNS nvarchar(450)
AS
BEGIN
	DECLARE @ConvertedScopeName nvarchar(450)
	set @ConvertedScopeName = REPLACE(@ScopeName, 
						'.' + CAST(@OldDefinitionID as varchar) + '.', 
						'.'+ CAST(@NewDefinitionID as varchar) +'.')
	RETURN @ConvertedScopeName
END
