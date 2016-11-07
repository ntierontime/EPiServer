CREATE PROCEDURE [dbo].[netDynamicPropertiesLoad]
(
	@PageID INT
)
AS
BEGIN
	/* 
	Return dynamic properties for this page with edit-information
	*/
	SET NOCOUNT ON
	DECLARE @PropCount INT
	
	CREATE TABLE #tmpprop
	(
		fkPageID		INT NULL,
		fkPageDefinitionID	INT,
		fkPageDefinitionTypeID	INT,
		fkLanguageBranchID	INT NULL
	)
	/*Make sure page exists before starting*/
	IF NOT EXISTS(SELECT * FROM tblPage WHERE pkID=@PageID)
		RETURN 0
	SET @PropCount = 0
	/* Get all common dynamic properties */
	INSERT INTO #tmpprop
		(fkPageDefinitionID,
		fkPageDefinitionTypeID,
		fkLanguageBranchID)
	SELECT
		tblPageDefinition.pkID,
		fkPageDefinitionTypeID,
		1
	FROM
		tblPageDefinition
	WHERE
		fkPageTypeID IS NULL
	AND
		LanguageSpecific < 3
	/* Remember how many properties we have */
	SET @PropCount = @PropCount + @@ROWCOUNT
	/* Get all language specific dynamic properties */
	INSERT INTO #tmpprop
		(fkPageDefinitionID,
		fkPageDefinitionTypeID,
		fkLanguageBranchID)
	SELECT
		tblPageDefinition.pkID,
		fkPageDefinitionTypeID,
		tblLanguageBranch.pkID
	FROM
		tblPageDefinition
	CROSS JOIN
		tblLanguageBranch
	WHERE
		fkPageTypeID IS NULL
	AND
		LanguageSpecific > 2
	AND
		tblLanguageBranch.Enabled = 1
	ORDER BY
		tblLanguageBranch.pkID
	
	/* Remember how many properties we have */
	SET @PropCount = @PropCount + @@ROWCOUNT
	/* Get page references for all properties (if possible) */
	WHILE (@PropCount > 0 AND @PageID IS NOT NULL)
	BEGIN
	
		/* Update properties that are defined for this page */
		UPDATE #tmpprop
		SET fkPageID=@PageID
		FROM #tmpprop
		INNER JOIN tblProperty ON #tmpprop.fkPageDefinitionID=tblProperty.fkPageDefinitionID
		WHERE 				
			tblProperty.fkPageID=@PageID AND 
			#tmpprop.fkPageID IS NULL
		AND
			#tmpprop.fkLanguageBranchID = tblProperty.fkLanguageBranchID
		OR
			#tmpprop.fkLanguageBranchID IS NULL
			
		/* Remember how many properties we have left */
		SET @PropCount = @PropCount - @@ROWCOUNT
		
		/* Go up one step in the tree */
		SELECT @PageID = fkParentID FROM tblPage WHERE pkID = @PageID
	END
	
	/* Include all property rows */
	SELECT
		#tmpprop.fkPageDefinitionID,
		#tmpprop.fkPageID,
		PD.Name AS PropertyName,
		LanguageSpecific,
		RTRIM(LB.LanguageID) AS BranchLanguageID,
		ScopeName,
		CONVERT(INT,Boolean) AS Boolean,
		Number AS IntNumber,
		FloatNumber,
		PageType, 
		PageLink AS ContentLink,
		LinkGuid,
		Date AS DateValue, 
		String, 
		LongString
	FROM
		#tmpprop
	LEFT JOIN
		tblLanguageBranch AS LB
	ON
		LB.pkID = #tmpprop.fkLanguageBranchID
	LEFT JOIN
		tblPageDefinition AS PD
	ON
		PD.pkID = #tmpprop.fkPageDefinitionID
	LEFT JOIN
		tblProperty AS P
	ON
		P.fkPageID = #tmpprop.fkPageID
	AND
		P.fkPageDefinitionID = #tmpprop.fkPageDefinitionID
	AND
		P.fkLanguageBranchID = #tmpprop.fkLanguageBranchID
	ORDER BY
		LanguageSpecific,
		#tmpprop.fkLanguageBranchID,
		FieldOrder
	DROP TABLE #tmpprop
	RETURN 0
END
