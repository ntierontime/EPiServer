CREATE PROCEDURE [dbo].[sp_GetDateTimeKind]
AS
	-- 0 === Unspecified  
	-- 1 === Local time 
	-- 2 === UTC time 
	RETURN 2
