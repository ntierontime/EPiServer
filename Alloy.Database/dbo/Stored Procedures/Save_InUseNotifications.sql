create procedure [dbo].[Save_InUseNotifications]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@AddedManually bit = NULL,
@ContentGuid uniqueidentifier = NULL,
@CreateTime datetime = NULL,
@LanguageBranch nvarchar(450) = NULL,
@Modified datetime = NULL,
@User nvarchar(450) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'InUseNotifications')

		select @Id = SCOPE_IDENTITY()
				insert into [tblBigTable] (pkId, StoreName, Row, ItemType,Boolean01,Indexed_Guid01,DateTime01,Indexed_String01,DateTime02,Indexed_String02)
		values(@Id, 'InUseNotifications', 1, @ItemType ,@AddedManually,@ContentGuid,@CreateTime,@LanguageBranch,@Modified,@User)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblBigTable] (pkId, StoreName, Row, ItemType,Boolean01,Indexed_Guid01,DateTime01,Indexed_String01,DateTime02,Indexed_String02)
		values(@Id, 'InUseNotifications', 1, @ItemType ,@AddedManually,@ContentGuid,@CreateTime,@LanguageBranch,@Modified,@User)

		end
		else begin
				update [tblBigTable] set 
		ItemType = @ItemType,
		Boolean01 = @AddedManually,
		Indexed_Guid01 = @ContentGuid,
		DateTime01 = @CreateTime,
		Indexed_String01 = @LanguageBranch,
		DateTime02 = @Modified,
		Indexed_String02 = @User
                from [tblBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end