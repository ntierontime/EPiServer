CREATE PROCEDURE [dbo].[ChangeNotificationTrySetValid]
    @connectionId uniqueidentifier
as
begin
    begin try
        begin transaction
        declare @processorId uniqueidentifier
        declare @processorStatus nvarchar(30)
        declare @processorStatusTable table (ProcessorId uniqueidentifier, ProcessorStatus nvarchar(30), LastConsistentDbUtc datetime)
        insert into @processorStatusTable (ProcessorId, ProcessorStatus, LastConsistentDbUtc)
        exec ChangeNotificationAccessConnectionWorker @connectionId
        select @processorId = ProcessorId, @processorStatus = ProcessorStatus
        from @processorStatusTable
        declare @result bit
        if (@processorStatus = 'recovering')
        begin
            update tblChangeNotificationProcessor
            set ProcessorStatus = 'valid'
            where ProcessorId = @processorId
            set @result = 1
        end
        else
        begin
            set @result = 0
        end
        commit transaction
        select @result as StateChanged
    end try
    begin catch
    declare @msg nvarchar(4000), @sev int, @stt int
        select @msg = ERROR_MESSAGE(), @sev = ERROR_SEVERITY(), @stt = ERROR_STATE()
        rollback transaction
        raiserror(@msg, @sev, @stt)
    end catch
end
