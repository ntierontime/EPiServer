create procedure [dbo].[Save_EPiServer.Shell.Search.SearchProviderSetting]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@FullName nvarchar(max) = NULL,
@IsEnabled bit = NULL,
@SortIndex int = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiServer.Shell.Search.SearchProviderSetting')

		select @Id = SCOPE_IDENTITY()
				insert into [tblBigTable] (pkId, StoreName, Row, ItemType,String01,Boolean01,Integer01)
		values(@Id, 'EPiServer.Shell.Search.SearchProviderSetting', 1, @ItemType ,@FullName,@IsEnabled,@SortIndex)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblBigTable] (pkId, StoreName, Row, ItemType,String01,Boolean01,Integer01)
		values(@Id, 'EPiServer.Shell.Search.SearchProviderSetting', 1, @ItemType ,@FullName,@IsEnabled,@SortIndex)

		end
		else begin
				update [tblBigTable] set 
		ItemType = @ItemType,
		String01 = @FullName,
		Boolean01 = @IsEnabled,
		Integer01 = @SortIndex
                from [tblBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end