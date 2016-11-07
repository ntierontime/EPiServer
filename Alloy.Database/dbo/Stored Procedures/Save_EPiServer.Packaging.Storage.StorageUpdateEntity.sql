create procedure [dbo].[Save_EPiServer.Packaging.Storage.StorageUpdateEntity]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@ServerId nvarchar(max) = NULL,
@UpdateDate datetime = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiServer.Packaging.Storage.StorageUpdateEntity')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01,DateTime01)
		values(@Id, 'EPiServer.Packaging.Storage.StorageUpdateEntity', 1, @ItemType ,@ServerId,@UpdateDate)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01,DateTime01)
		values(@Id, 'EPiServer.Packaging.Storage.StorageUpdateEntity', 1, @ItemType ,@ServerId,@UpdateDate)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		String01 = @ServerId,
		DateTime01 = @UpdateDate
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end