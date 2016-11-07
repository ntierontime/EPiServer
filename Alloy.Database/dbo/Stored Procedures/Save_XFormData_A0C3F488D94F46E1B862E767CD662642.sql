create procedure [dbo].[Save_XFormData_A0C3F488D94F46E1B862E767CD662642]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@Charity nvarchar(max) = NULL,
@Meta_ChannelOptions int = NULL,
@Meta_DatePosted datetime = NULL,
@Meta_FormId uniqueidentifier = NULL,
@Meta_PageGuid uniqueidentifier = NULL,
@Meta_UserName nvarchar(450) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'XFormData_A0C3F488D94F46E1B862E767CD662642')

		select @Id = SCOPE_IDENTITY()
				insert into [tblXFormData] (pkId, StoreName, Row, ItemType,String01,ChannelOptions,DatePosted,FormId,PageGuid,UserName)
		values(@Id, 'XFormData_A0C3F488D94F46E1B862E767CD662642', 1, @ItemType ,@Charity,@Meta_ChannelOptions,@Meta_DatePosted,@Meta_FormId,@Meta_PageGuid,@Meta_UserName)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblXFormData] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblXFormData] (pkId, StoreName, Row, ItemType,String01,ChannelOptions,DatePosted,FormId,PageGuid,UserName)
		values(@Id, 'XFormData_A0C3F488D94F46E1B862E767CD662642', 1, @ItemType ,@Charity,@Meta_ChannelOptions,@Meta_DatePosted,@Meta_FormId,@Meta_PageGuid,@Meta_UserName)

		end
		else begin
				update [tblXFormData] set 
		ItemType = @ItemType,
		String01 = @Charity,
		ChannelOptions = @Meta_ChannelOptions,
		DatePosted = @Meta_DatePosted,
		FormId = @Meta_FormId,
		PageGuid = @Meta_PageGuid,
		UserName = @Meta_UserName
                from [tblXFormData]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end