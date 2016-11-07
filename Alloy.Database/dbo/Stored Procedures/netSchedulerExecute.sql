CREATE PROCEDURE dbo.netSchedulerExecute
(
	@pkID     uniqueidentifier,
	@nextExec datetime,
	@utcnow datetime,
	@pingSeconds int
)
as
begin
	set nocount on
	
	
	/**
	 * is the scheduled nextExec still valid? 
	 * (that is, no one else has already begun executing it?)
	 */
	if exists( select * from tblScheduledItem with (rowlock,updlock) where pkID = @pkID and NextExec = @nextExec and Enabled = 1 and (IsRunning <> 1 OR (GETUTCDATE() > DATEADD(second, @pingSeconds, LastPing))) )
	begin
	
		/**
		 * ya, calculate and set nextexec for the item 
		 * (or set to null if not recurring)
		 */
		update tblScheduledItem set NextExec =  case when coalesce(Interval,0) > 0 and [DatePart] is not null then 
		
															case [DatePart] when 'ms' then dateadd( ms, Interval, case when dateadd( ms, Interval, NextExec ) < @utcnow then @utcnow else NextExec end )
																			when 'ss' then dateadd( ss, Interval, case when dateadd( ss, Interval, NextExec ) < @utcnow then @utcnow else NextExec end )
																			when 'mi' then dateadd( mi, Interval, case when dateadd( mi, Interval, NextExec ) < @utcnow then @utcnow else NextExec end )
																			when 'hh' then dateadd( hh, Interval, case when dateadd( hh, Interval, NextExec ) < @utcnow then @utcnow else NextExec end )
																			when 'dd' then dateadd( dd, Interval, case when dateadd( dd, Interval, NextExec ) < @utcnow then @utcnow else NextExec end )
																			when 'wk' then dateadd( wk, Interval, case when dateadd( wk, Interval, NextExec ) < @utcnow then @utcnow else NextExec end )
																			when 'mm' then dateadd( mm, Interval, case when dateadd( mm, Interval, NextExec ) < @utcnow then @utcnow else NextExec end )
																			when 'yy' then dateadd( yy, Interval, case when dateadd( yy, Interval, NextExec ) < @utcnow then @utcnow else NextExec end )
																			
															end
													
													 else null
									            end
		from   tblScheduledItem
		
		where  pkID = @pkID
		
		
		/**
		 * now retrieve all detailed data (type, assembly & instance) 
		 * for the job
		 */
		select	tblScheduledItem.MethodName,
				tblScheduledItem.fStatic,
				tblScheduledItem.TypeName,
				tblScheduledItem.AssemblyName,
				tblScheduledItem.InstanceData
		
		from	tblScheduledItem
		
		where	pkID = @pkID
		
	end
	
end
