use master
EXEC sys.sp_configure N'max server memory (MB)', N'17000'
GO
RECONFIGURE WITH OVERRIDE
GO

WAITFOR DELAY '00:02:00';
go


use tempdb
GO

DBCC FREEPROCCACHE -- clean cache
DBCC DROPCLEANBUFFERS -- clean buffers
DBCC FREESYSTEMCACHE ('ALL') -- clean system cache
DBCC FREESESSIONCACHE -- clean session cache
dbcc shrinkfile ('tempdev') -- shrink db file
dbcc shrinkfile ('templog') -- shrink log file
GO


use master
EXEC sys.sp_configure N'max server memory (MB)', N'25000'
GO
RECONFIGURE WITH OVERRIDE
GO
