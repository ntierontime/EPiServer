CREATE PROCEDURE dbo.netSynchedUserList
(
	@UserNameToMatch NVARCHAR(255) = NULL,
	@StartIndex	INT,
	@MaxCount	INT
)
AS
BEGIN
	SET @UserNameToMatch = LOWER(@UserNameToMatch);
	WITH MatchedSynchedUsersCTE
	AS
	(
		SELECT 
		ROW_NUMBER() OVER (ORDER BY UserName) AS RowNum, UserName, Email, GivenName, Surname
		FROM
		(	
			SELECT
				pkID, UserName, GivenName, Surname, Email
			FROM
				[tblSynchedUser]
			WHERE
				(@UserNameToMatch IS NULL) OR 
				(	([tblSynchedUser].LoweredUserName LIKE @UserNameToMatch + '%') OR 
					([tblSynchedUser].Email LIKE @UserNameToMatch + '%') OR
					([tblSynchedUser].LoweredGivenName LIKE @UserNameToMatch + '%') OR
					([tblSynchedUser].LoweredSurname LIKE @UserNameToMatch + '%')
				)
		)
		AS Result
	)
	SELECT TOP(@MaxCount) UserName, GivenName, Surname, Email, (SELECT COUNT(*) FROM MatchedSynchedUsersCTE) AS 'TotalCount'
		FROM MatchedSynchedUsersCTE 
		WHERE RowNum BETWEEN (@StartIndex - 1) * @MaxCount + 1 AND @StartIndex * @MaxCount 
		ORDER BY UserName
END
