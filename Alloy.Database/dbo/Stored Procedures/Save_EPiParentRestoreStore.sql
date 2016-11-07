create procedure [dbo].[Save_EPiParentRestoreStore]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@ParentLink nvarchar(max) = NULL,
@SourceLink nvarchar(max) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiParentRestoreStore')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01,String02)
		values(@Id, 'EPiParentRestoreStore', 1, @ItemType ,@ParentLink,@SourceLink)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01,String02)
		values(@Id, 'EPiParentRestoreStore', 1, @ItemType ,@ParentLink,@SourceLink)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		String01 = @ParentLink,
		String02 = @SourceLink
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end