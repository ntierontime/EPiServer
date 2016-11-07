CREATE PROCEDURE [dbo].[netChangeLogGetCountBackwards]
(
	@from 	                 DATETIME = NULL,
	@to	                     DATETIME = NULL,
	@type 					 [nvarchar](255) = NULL,
	@action 				 INT = 0,
	@changedBy				 [nvarchar](255) = NULL,
	@startSequence			 BIGINT = 0,
	@deleted				 BIT =  0,	
	@count                   BIGINT = 0 OUTPUT)
AS
BEGIN    
        SELECT @count = count(*)
        FROM [tblActivityLog] TCL
        WHERE 
        (TCL.pkID <= @startSequence) AND
		((@from IS NULL) OR (TCL.ChangeDate >= @from)) AND
		((@to IS NULL) OR (TCL.ChangeDate <= @to)) AND  
        ((@type IS NULL) OR (@type = TCL.Type)) AND
        ((@action = 0) OR (@action = TCL.Action)) AND
        ((@changedBy IS NULL) OR (@changedBy = TCL.ChangedBy)) AND
		((@deleted = 1) OR (TCL.Deleted = 0))
		
END
