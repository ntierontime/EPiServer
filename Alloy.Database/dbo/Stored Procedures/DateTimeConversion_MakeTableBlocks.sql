CREATE PROCEDURE [dbo].[DateTimeConversion_MakeTableBlocks]
(
	@TableName NVARCHAR(MAX), 
	@DateTimeColumn NVARCHAR(MAX),
	@StoreName NVARCHAR(MAX), 
	@BlockSize INT, 
	@Print INT)
AS
BEGIN	
	-- Format
	SET @TableName = REPLACE(REPLACE(REPLACE(@TableName,'[',''),']',''),'dbo.','')
	SET @DateTimeColumn = REPLACE(REPLACE(@DateTimeColumn,']',''),'[','')
	-- CHECK tblBigTableReference
	IF (@StoreName IS NOT NULL)
	BEGIN
		DECLARE @BigTableReferenceCount INT
		SELECT @BigTableReferenceCount = COUNT(*) FROM tblBigTableReference r
		JOIN tblBigTableIdentity i ON r.pkId = i.pkId WHERE i.StoreName = @StoreName AND DateTimeValue IS NOT NULL
		IF(@BigTableReferenceCount > 0)
		BEGIN
			DECLARE @BigTableReferenceSql NVARCHAR(MAX) = 
				'UPDATE tbl SET tbl.[DateTimeValue] = CAST([DateTimeValue] AS DATETIME) + dtc.OffSet FROM tblBigTableReference tbl ' +
				'INNER JOIN [dbo].[tblDateTimeConversion_Offset] dtc ON tbl.[DateTimeValue] >= dtc.IntervalStart AND tbl.[DateTimeValue] < dtc.IntervalEnd ' +
				'INNER JOIN [dbo].[tblBigTableIdentity] bti ON bti.StoreName = ''' + @StoreName + ''' AND tbl.pkId = bti.pkId ' +
				'WHERE tbl.[DateTimeValue] IS NOT NULL '
			INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, [Sql], BlockRank,BlockCount) 
			SELECT TableName = 'tblBigTableReference', ColName = 'DateTimeValue', @StoreName, [Sql] = @BigTableReferenceSql , BlockRank = 0, BlockCount = @BigTableReferenceCount
		END
	END
	-- Get primary keys
	DECLARE @Keys TABLE(Data NVARCHAR(100)) 
	INSERT INTO @Keys
	SELECT i.COLUMN_NAME
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE i
	WHERE OBJECTPROPERTY(OBJECT_ID(i.CONSTRAINT_NAME), 'IsPrimaryKey') = 1
	AND i.TABLE_NAME = @TableName
	IF ((SELECT COUNT(*) FROM @Keys) = 0 )
	BEGIN
		INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, [Sql],Converted,BlockRank,BlockCount) 
		SELECT TableName = @TableName, ColName = @DateTimeColumn, @StoreName, [Sql] = NULL, Converted = 1, BlockRank = -1, BlockCount = 0 
		RETURN		
	END
	-- Get total number of primary keys
	DECLARE @TotalPrimaryKeys INT  
	SELECT @TotalPrimaryKeys = COUNT(*) FROM @Keys
	-- Get number of integer primary keys
	DECLARE @IntegerPrimaryKeys INT  
	SELECT @IntegerPrimaryKeys = COUNT(*)
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE i
	JOIN INFORMATION_SCHEMA.COLUMNS c on i.COLUMN_NAME = c.COLUMN_NAME AND i.TABLE_NAME = c.TABLE_NAME
	WHERE OBJECTPROPERTY(OBJECT_ID(i.CONSTRAINT_NAME), 'IsPrimaryKey') = 1 AND c.DATA_TYPE IN ('bigint','int')
	AND i.TABLE_NAME = @TableName
	-- Non integer primary keys handling
	IF (@TotalPrimaryKeys > @IntegerPrimaryKeys)
	BEGIN
		DECLARE @NonIntegerSql NVARCHAR(MAX) = 'UPDATE tbl SET tbl.[' + @DateTimeColumn + '] = CAST('+ @DateTimeColumn +' AS DATETIME) + dtc.OffSet FROM ' + @TableName + ' tbl INNER JOIN [dbo].[tblDateTimeConversion_Offset] dtc ON tbl.[' + @DateTimeColumn + '] >= dtc.IntervalStart AND tbl.[' + @DateTimeColumn + '] < dtc.IntervalEnd WHERE tbl.[' + @DateTimeColumn + '] IS NOT NULL '
		INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, Sql, BlockRank,BlockCount) 
		SELECT TableName = @TableName, ColName = @DateTimeColumn, @StoreName, Sql = @NonIntegerSql , BlockRank = -2, BlockCount = 0
		RETURN 
	END
	DECLARE @storeCondition NVARCHAR(MAX) = CASE WHEN @storeName IS NULL THEN ' ' ELSE ' AND storeName = ''' + @storeName + ''' ' END 	 
	-- Zero count handling
	DECLARE @sSQL nvarchar(500) = N'SELECT @retvalOUT = COUNT(*) FROM (SELECT TOP ' + CAST((@BlockSize + 1) AS NVARCHAR(10)) + ' * FROM ' + @TableName + ' WHERE [' + @DateTimeColumn + '] IS NOT NULL ' + @storeCondition + ') X'  
	DECLARE @ParmDefinition nvarchar(500) = N'@retvalOUT int OUTPUT'
	DECLARE @retval int   
	EXEC sp_executesql @sSQL, @ParmDefinition, @retvalOUT=@retval OUTPUT
	IF (@retval = 0)
	BEGIN
		INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, Sql,Converted,BlockRank,BlockCount) 
		SELECT TableName = @TableName, ColName = @DateTimeColumn, @StoreName, Sql = NULL, Converted = 1, BlockRank = 0, BlockCount = 0 
		RETURN
	END
	-- Create formatted list of keys for use in queries
	DECLARE @Values_List NVARCHAR(MAX) = ''
	SELECT @Values_List = @Values_List + '[' + Data + '], ' FROM @Keys
	SET @Values_List = Substring(@Values_List, 1, len(@Values_List) - 1)
	DECLARE @Values_List2 NVARCHAR(MAX) = ''
	SELECT @Values_List2 = @Values_List2 + 'tbl.[' + Data + '], ' FROM @Keys
	SET @Values_List2 = Substring(@Values_List2, 1, len(@Values_List2) - 1)
	DECLARE @Values_RowId NVARCHAR(MAX) = ''
	SELECT @Values_RowId = @Values_RowId + ' REPLACE(STR([' + Data + '], 16), '' '' , ''0'') +' FROM @Keys
	SET @Values_RowId = Substring(@Values_RowId, 1, len(@Values_RowId) - 1)
	DECLARE @Values_RowId2 NVARCHAR(MAX) = ''
	SELECT @Values_RowId2 = @Values_RowId2 + ' REPLACE(STR(tbl.[' + Data + '], 16), '''' '''' , ''''0'''') +' FROM @Keys
	SET @Values_RowId2 = Substring(@Values_RowId2, 1, len(@Values_RowId2) - 1)
	
	DECLARE @Values_MinMaxList NVARCHAR(MAX) = ''
	SELECT @Values_MinMaxList = @Values_MinMaxList + ' [Min' + Data + '], [Max' + Data + '], ' FROM @Keys
	SET @Values_MinMaxList = Substring(@Values_MinMaxList, 1, len(@Values_MinMaxList) - 1)
	
	DECLARE @Values_MinMaxSet NVARCHAR(MAX) = ''
	SELECT @Values_MinMaxSet = @Values_MinMaxSet + ' [Min' + Data + '] = MIN(' + Data + '), [Max' + Data + '] = MAX(' + Data + '),' FROM @Keys
	SET @Values_MinMaxSet = Substring(@Values_MinMaxSet, 1, len(@Values_MinMaxSet) - 1)
	
	DECLARE @Values_Declare NVARCHAR(MAX) = ''
	SELECT @Values_Declare = @Values_Declare + ' [Min' + Data + '] INT NOT NULL, ' + ' [Max' + Data + '] INT NOT NULL, ' FROM @Keys
	
	DECLARE @Values_Condition NVARCHAR(MAX) = ''
	SELECT @Values_Condition = ' [Min' + @Values_Condition + Data + ',' FROM @Keys
	SET @Values_Condition = Substring(@Values_Condition, 1, len(@Values_Condition) - 1)
	DECLARE @Values_Declare2 NVARCHAR(MAX) = ''
	SELECT @Values_Declare2 = @Values_Declare2 + ' [' + Data + '] INT NOT NULL, ' FROM @Keys
	DECLARE @Values_Condition2 NVARCHAR(MAX) = ''
	SELECT @Values_Condition2 = @Values_Condition2 + ' tbl.['+Data+'] = t.['+Data+'] AND' FROM @Keys
	SET @Values_Condition2 = Substring(@Values_Condition2, 1, len(@Values_Condition2) - 3)
	
	DECLARE @SQL NVARCHAR(MAX) = ''
		+ 'DECLARE @DATA AS TABLE( '
		+ '	[MIN] DATETIME NULL, '
		+ '	[MAX] DATETIME NULL, '
		+ '	BlockRank INT NOT NULL, ' 
		+ '	BlockCount INT NOT NULL, '
		+ @Values_Declare
		+ '	IntervalStart VARCHAR(50) NULL, '
		+ '	IntervalEnd	VARCHAR(50) NULL, '
		+ '	ConditionSql NVARCHAR(MAX) NULL, '
		+ '	UpdateSql NVARCHAR(MAX) NULL, '
		+ '	Converted BIT NOT NULL DEFAULT 0 '
		+ ') '
		+ ' '
		+ 'DECLARE @BLOCK AS TABLE([MIN] DATETIME NULL, [MAX] DATETIME NULL, BlockRank INT NOT NULL, ' + @Values_Declare + 'BlockCount INT NOT NULL) '
		+ 'DECLARE @BLOCKROW1000 AS TABLE(BlockRank INT NOT NULL, RowId NVARCHAR(' + CAST(@IntegerPrimaryKeys * 16 AS NVARCHAR(10)) + ') NOT NULL) '
		+ ' '
		+ 'INSERT INTO @BLOCK '
		+ 'SELECT [MIN] = MIN(DT), [MAX] = MAX(DT), BlockRank = ([RANK] - 1) / ' + CAST((@BlockSize) AS NVARCHAR(10)) + ', ' + @Values_MinMaxSet + ', BlockCount = COUNT(*) '
		+ 'FROM ( '
		+ '    SELECT DT = [' + @DateTimeColumn + '], [Rank] = DENSE_RANK() OVER (ORDER BY ' + @Values_List + '), ' + @Values_List + ' '
		+ '    FROM ' + @TableName + ' WITH(NOLOCK) '
		+ '    WHERE [' + @DateTimeColumn + '] IS NOT NULL ' + @storeCondition
		+ '    ) AS RowNr '
		+ 'GROUP BY ((([Rank]) - 1) / ' + CAST((@BlockSize) AS NVARCHAR(10)) + ') '
		+ ' '
		+ 'INSERT INTO @BLOCKROW1000 '
		+ 'SELECT BlockRank = (DENSE_RANK() OVER (ORDER BY [RowID]) - 1), RowID FROM ( '
		+ '    SELECT RowID = ' + @Values_RowId + ' '
		+ '    FROM ( '
		+ '        SELECT ' + @Values_List + ', DENSE_RANK() OVER (ORDER BY ' + @Values_List + ') AS rownum '
		+ '	       FROM ' + @TableName + ' WITH(NOLOCK) '
		+ '        WHERE [' + @DateTimeColumn + '] IS NOT NULL ' + @storeCondition
		+ '        ) AS RowNr '
		+ '    WHERE RowNr.rownum % ' + CAST((@BlockSize) AS NVARCHAR(10)) + ' = 0   '  
		+ '    ) AS Row1000 '
		+ ' '
		+ 'INSERT INTO @DATA '
		+ 'SELECT [MIN], [MAX], Block.BlockRank, BlockCount, ' + @Values_MinMaxList + ', IntervalStart = NULL, IntervalEnd = RowID, ConditionSql = NULL, UpdateSql = NULL, Converted = 0 '
		+ 'FROM @BLOCK Block '
		+ 'LEFT JOIN @BLOCKROW1000	BlockRow1000 '
		+ 'ON Block.BlockRank = BlockRow1000.BlockRank '
		+ 'ORDER BY Block.BlockRank   '
		+ ' '
		+ 'UPDATE d1 SET d1.IntervalStart = d2.IntervalEnd FROM @DATA d1 JOIN @DATA d2 ON d1.BlockRank = d2.BlockRank + 1 '
		+ 'UPDATE @DATA SET IntervalStart = ''' + REPLICATE('0', 16 * @IntegerPrimaryKeys) + ''' WHERE BlockRank = (SELECT MIN(BlockRank) from @DATA) '
		+ 'UPDATE @DATA SET IntervalEnd = ''' + REPLICATE('9', 16 * @IntegerPrimaryKeys) + ''' WHERE BlockRank = (SELECT MAX(BlockRank) from @DATA) '
		+ 'UPDATE @Data SET ConditionSql = '' [' + @DateTimeColumn + '] IS NOT NULL ' + REPLACE(@storeCondition,'''','''''') + ' '' '
	SELECT @SQL = @SQL + ' + '' AND tbl.['+Data+'] >= ''+CAST([Min'+Data+'] AS NVARCHAR(20))+'' AND tbl.['+Data+'] <= ''+CAST([Max'+Data+'] AS NVARCHAR(20))+'' '' ' FROM @Keys v
	IF (@TotalPrimaryKeys>1)
		SET @SQL = @SQL +' + '' AND '+ @Values_RowId2 + ' > '''''' + IntervalStart + '''''' AND ' + @Values_RowId2 + ' <= '''''' + IntervalEnd + '''''' '' '
	DECLARE @UPDATESQL NVARCHAR(MAX) ='
		DECLARE @OffsetTEMP AS TABLE( [IntervalStart] DATETIME NOT NULL,[IntervalEnd] DATETIME NOT NULL, [Offset] FLOAT NOT NULL) 
		DECLARE @MIN DATETIME = ''''[[MIN]]'''', @MAX DATETIME = ''''[[MAX]]'''' 
		INSERT INTO @OffsetTEMP 
		SELECT c.IntervalStart, c.IntervalEnd, c.Offset 
		FROM tblDateTimeConversion_Offset c WITH (NOLOCK)  
		WHERE c.IntervalStart-1 >= @MIN AND c.IntervalEnd+1 <= @MAX OR @MIN between c.IntervalStart-1 and c.IntervalEnd+1 OR @MAX between c.IntervalStart-1 and c.IntervalEnd+1
	
		DECLARE @'+@TableName+'TEMP AS TABLE('+@Values_Declare2+' [' + @DateTimeColumn + '] DATETIME NOT NULL,PRIMARY KEY('+@Values_List+')) 
		INSERT INTO @'+@TableName+'TEMP 
		SELECT '+@Values_List2+', [' + @DateTimeColumn + '] = tbl.[' + @DateTimeColumn + '] + CAST(c.OffSet AS DATETIME)  
		FROM  @OffsetTEMP c
		JOIN ['+@TableName+'] tbl WITH(NOLOCK) ON tbl.[' + @DateTimeColumn + ']>=c.IntervalStart AND tbl.[' + @DateTimeColumn + ']<c.IntervalEnd 
		WHERE [[CONDITION]] 
		OPTION (LOOP JOIN) 
	
		DECLARE @StartTimeStamp DATETIME = SYSDATETIME() 
	
		UPDATE tbl 
		SET tbl.[' + @DateTimeColumn + '] = t.[' + @DateTimeColumn + '] 
		FROM @'+@TableName+'TEMP t 
		JOIN ['+@TableName+'] tbl WITH(ROWLOCK) ON '+@Values_Condition2 + '
		OPTION (LOOP JOIN) 
	
		DECLARE @EndTimeStamp DATETIME = SYSDATETIME() 
		SET @UpdateTimeRETURN = DATEDIFF(MS,@StartTimeStamp,@EndTimeStamp) '
	SET @SQL = @SQL 
		+ 'DECLARE @UpdateSql NVARCHAR(MAX) '
		+ 'SET @UpdateSql = ''' + @UPDATESQL + ' '' '
		+ 'UPDATE @Data SET UpdateSql = @UpdateSql '
		+ 'INSERT INTO [dbo].[tblDateTimeConversion_Block](TableName, ColName, StoreName, Sql,Priority,BlockRank,BlockCount) SELECT TableName = ''' + @TableName + ''', ColName = ''' + @DateTimeColumn + ''', StoreName= ' + COALESCE('''' + @StoreName + '''', 'NULL') + ', Sql = REPLACE(REPLACE(REPLACE(UpdateSql,''[[CONDITION]]'',ConditionSql),''[[MIN]]'',[MIN]),''[[MAX]]'',[MAX]), Priority = BlockRank, BlockRank = d.BlockRank,BlockCount=d.BlockCount FROM @DATA d '
	EXEC (@SQL)
	UPDATE tbl 
	SET [Priority] = f.maxrank-tbl.blockrank + 1
	FROM tblDateTimeConversion_Block tbl 
	JOIN (SELECT * FROM (
		SELECT TableName, MaxRank = MAX(BlockRank) 
		FROM tblDateTimeConversion_Block 
		WHERE Converted = 0 and [Sql] IS NOT NULL 
		GROUP BY TableName) x 
	WHERE MaxRank >= 0) f ON f.TableName = tbl.TableName 
	WHERE tbl.TableName = @TableName AND tbl.ColName = @DateTimeColumn 
END
