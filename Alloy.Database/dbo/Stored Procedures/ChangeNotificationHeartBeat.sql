CREATE PROCEDURE [dbo].[ChangeNotificationHeartBeat]
    @connectionId uniqueidentifier
as
begin
    begin try
        begin transaction
        exec dbo.ChangeNotificationAccessConnectionWorker @connectionId
        commit transaction
    end try
    begin catch
        declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()
        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
