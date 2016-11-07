create procedure [dbo].[Save_EPiServer.Shell.Storage.PersonalizedViewSettingsStorage]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@UserName nvarchar(450) = NULL,
@ViewName nvarchar(450) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiServer.Shell.Storage.PersonalizedViewSettingsStorage')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Indexed_String01,Indexed_String02)
		values(@Id, 'EPiServer.Shell.Storage.PersonalizedViewSettingsStorage', 1, @ItemType ,@UserName,@ViewName)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Indexed_String01,Indexed_String02)
		values(@Id, 'EPiServer.Shell.Storage.PersonalizedViewSettingsStorage', 1, @ItemType ,@UserName,@ViewName)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		Indexed_String01 = @UserName,
		Indexed_String02 = @ViewName
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end