create procedure [dbo].[Save_EPiServer.MirroringService.MirroringData]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@AdminMailaddress nvarchar(max) = NULL,
@ContentTypeChangingState int = NULL,
@ContinueOnError bit = NULL,
@DestinationRoot nvarchar(max) = NULL,
@DestinationUri nvarchar(max) = NULL,
@Enabled bit = NULL,
@FromPageGuid uniqueidentifier = NULL,
@ImpersonateUserName nvarchar(max) = NULL,
@IncludeRoot bit = NULL,
@InitialMirroringDone bit = NULL,
@LastChangeLoqSequenceRead bigint = NULL,
@LastExecutionUTC datetime = NULL,
@LastMailMessageUTC datetime = NULL,
@LastState int = NULL,
@LastStatus nvarchar(max) = NULL,
@Name nvarchar(max) = NULL,
@Params nvarchar(max) = NULL,
@SendMailMessage bit = NULL,
@TransferAction int = NULL,
@UseDefaultMirroringAddress bit = NULL,
@ValidationContext int = NULL,
@VisitorGroupChangingState int = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiServer.MirroringService.MirroringData')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01,Integer01,Boolean01,String02,String03,Boolean02,Guid01,String04,Boolean03,Boolean04,Long01,DateTime01,DateTime02,Integer02,String05,String06,String07,Boolean05,Integer03,Integer04,Integer05)
		values(@Id, 'EPiServer.MirroringService.MirroringData', 1, @ItemType ,@AdminMailaddress,@ContentTypeChangingState,@ContinueOnError,@DestinationRoot,@DestinationUri,@Enabled,@FromPageGuid,@ImpersonateUserName,@IncludeRoot,@InitialMirroringDone,@LastChangeLoqSequenceRead,@LastExecutionUTC,@LastMailMessageUTC,@LastState,@LastStatus,@Name,@Params,@SendMailMessage,@TransferAction,@ValidationContext,@VisitorGroupChangingState)

				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Boolean01)
		values(@Id, 'EPiServer.MirroringService.MirroringData', 2, @ItemType ,@UseDefaultMirroringAddress)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01,Integer01,Boolean01,String02,String03,Boolean02,Guid01,String04,Boolean03,Boolean04,Long01,DateTime01,DateTime02,Integer02,String05,String06,String07,Boolean05,Integer03,Integer04,Integer05)
		values(@Id, 'EPiServer.MirroringService.MirroringData', 1, @ItemType ,@AdminMailaddress,@ContentTypeChangingState,@ContinueOnError,@DestinationRoot,@DestinationUri,@Enabled,@FromPageGuid,@ImpersonateUserName,@IncludeRoot,@InitialMirroringDone,@LastChangeLoqSequenceRead,@LastExecutionUTC,@LastMailMessageUTC,@LastState,@LastStatus,@Name,@Params,@SendMailMessage,@TransferAction,@ValidationContext,@VisitorGroupChangingState)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		String01 = @AdminMailaddress,
		Integer01 = @ContentTypeChangingState,
		Boolean01 = @ContinueOnError,
		String02 = @DestinationRoot,
		String03 = @DestinationUri,
		Boolean02 = @Enabled,
		Guid01 = @FromPageGuid,
		String04 = @ImpersonateUserName,
		Boolean03 = @IncludeRoot,
		Boolean04 = @InitialMirroringDone,
		Long01 = @LastChangeLoqSequenceRead,
		DateTime01 = @LastExecutionUTC,
		DateTime02 = @LastMailMessageUTC,
		Integer02 = @LastState,
		String05 = @LastStatus,
		String06 = @Name,
		String07 = @Params,
		Boolean05 = @SendMailMessage,
		Integer03 = @TransferAction,
		Integer04 = @ValidationContext,
		Integer05 = @VisitorGroupChangingState
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		if(@rows < 2) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,Boolean01)
		values(@Id, 'EPiServer.MirroringService.MirroringData', 2, @ItemType ,@UseDefaultMirroringAddress)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		Boolean01 = @UseDefaultMirroringAddress
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=2
		end
		commit transaction
	end
end