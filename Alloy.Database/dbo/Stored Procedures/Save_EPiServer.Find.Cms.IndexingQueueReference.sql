create procedure [dbo].[Save_EPiServer.Find.Cms.IndexingQueueReference]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@Action int = NULL,
@Cascade bit = NULL,
@EnableLanguageFilter bit = NULL,
@Item nvarchar(max) = NULL,
@Language nvarchar(max) = NULL,
@TimeStamp datetime = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiServer.Find.Cms.IndexingQueueReference')

		select @Id = SCOPE_IDENTITY()
				insert into [tblBigTable] (pkId, StoreName, Row, ItemType,Integer01,Boolean01,Boolean02,String01,String02,DateTime01)
		values(@Id, 'EPiServer.Find.Cms.IndexingQueueReference', 1, @ItemType ,@Action,@Cascade,@EnableLanguageFilter,@Item,@Language,@TimeStamp)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblBigTable] (pkId, StoreName, Row, ItemType,Integer01,Boolean01,Boolean02,String01,String02,DateTime01)
		values(@Id, 'EPiServer.Find.Cms.IndexingQueueReference', 1, @ItemType ,@Action,@Cascade,@EnableLanguageFilter,@Item,@Language,@TimeStamp)

		end
		else begin
				update [tblBigTable] set 
		ItemType = @ItemType,
		Integer01 = @Action,
		Boolean01 = @Cascade,
		Boolean02 = @EnableLanguageFilter,
		String01 = @Item,
		String02 = @Language,
		DateTime01 = @TimeStamp
                from [tblBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end