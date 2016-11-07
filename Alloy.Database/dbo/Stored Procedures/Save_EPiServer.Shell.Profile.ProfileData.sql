create procedure [dbo].[Save_EPiServer.Shell.Profile.ProfileData]
@Id bigint output,
@UniqueId uniqueidentifier,
@ItemType nvarchar(2048),
@UserName nvarchar(max) = NULL
as
begin
declare @pkId bigint
	select @pkId = pkId from tblBigTableIdentity where [Guid] = @UniqueId
	if @pkId IS NULL
	begin
		begin transaction
		insert into [tblBigTableIdentity]([Guid], [StoreName]) values(@UniqueId, 'EPiServer.Shell.Profile.ProfileData')

		select @Id = SCOPE_IDENTITY()
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01)
		values(@Id, 'EPiServer.Shell.Profile.ProfileData', 1, @ItemType ,@UserName)

		commit transaction
	end
	else
	begin
		begin transaction
		select @Id = @pkId
		DECLARE @rows int
		select @rows = count(*) from [tblSystemBigTable] where pkId = @Id
		if(@rows < 1) begin
				insert into [tblSystemBigTable] (pkId, StoreName, Row, ItemType,String01)
		values(@Id, 'EPiServer.Shell.Profile.ProfileData', 1, @ItemType ,@UserName)

		end
		else begin
				update [tblSystemBigTable] set 
		ItemType = @ItemType,
		String01 = @UserName
                from [tblSystemBigTable]
                where pkId=@pkId
                and Row=1
		end
		commit transaction
	end
end