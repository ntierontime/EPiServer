create procedure [dbo].[Save_EPiServer.Core.PropertySettings.PropertySettingsWrapper]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@Description nvarchar(max) = NULL,
@DisplayName nvarchar(max) = NULL,
@IsDefault bit = NULL,
@IsGlobal bit = NULL,
@TypeFullName nvarchar(max) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiServer.Core.PropertySettings.PropertySettingsWrapper')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01,String02,Boolean01,Boolean02,String03)
		values(@Id, 'EPiServer.Core.PropertySettings.PropertySettingsWrapper', 1, @ItemType ,@Description,@DisplayName,@IsDefault,@IsGlobal,@TypeFullName)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01,String02,Boolean01,Boolean02,String03)
		values(@Id, 'EPiServer.Core.PropertySettings.PropertySettingsWrapper', 1, @ItemType ,@Description,@DisplayName,@IsDefault,@IsGlobal,@TypeFullName)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		String01 = @Description,
		String02 = @DisplayName,
		Boolean01 = @IsDefault,
		Boolean02 = @IsGlobal,
		String03 = @TypeFullName
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end