CREATE PROCEDURE [dbo].[netChangeLogGetRowsForwards]
(
	@from 	                 DATETIME = NULL,
	@to	                     DATETIME = NULL,
	@type 					 [nvarchar](255) = NULL,
	@action 				 INT = NULL,
	@changedBy				 [nvarchar](255) = NULL,
	@startSequence			 BIGINT = NULL,
	@maxRows				 BIGINT,
	@deleted				 BIT = 0
)
AS
BEGIN    
        SELECT top(@maxRows) *
        FROM [tblActivityLog] TCL
        WHERE 
        ((@startSequence IS NULL) OR (TCL.pkID >= @startSequence)) AND
		((@from IS NULL) OR (TCL.ChangeDate >= @from)) AND
		((@to IS NULL) OR (TCL.ChangeDate <= @to)) AND  
        ((@type IS NULL) OR (@type = TCL.Type)) AND
        ((@action IS NULL) OR (@action = TCL.Action)) AND
        ((@changedBy IS NULL) OR (@changedBy = TCL.ChangedBy)) AND
		((@deleted = 1) OR (TCL.Deleted = 0))
        
		ORDER BY TCL.pkID ASC
END
