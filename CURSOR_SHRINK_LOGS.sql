DECLARE @dbname SYSNAME, @logname SYSNAME, @sql VARCHAR(300)

-- Seleciona os nomes dos arquivos de log
DECLARE cur_dbname CURSOR FOR 
select DB_NAME(database_id), name  from sys.master_files WHERE type = 1 
    AND DATABASEPROPERTYEX ( DB_NAME(database_id) , 'Status' ) = 'ONLINE' AND database_id NOT IN(1,3,4)
    AND DATABASEPROPERTYEX ( DB_NAME(database_id) , 'Updateability') <> 'READ_ONLY'

OPEN cur_dbname 
FETCH NEXT FROM cur_dbname INTO @dbname, @logname
WHILE @@FETCH_STATUS = 0
    BEGIN
    -- Executa SHRINK para todos arquivos de log
    SET @sql = 'USE [' + @dbname +']; DBCC SHRINKFILE (' + @logname + ',0)'
    EXEC (@sql)
    FETCH NEXT FROM cur_dbname INTO @dbname, @logname
    END
CLOSE cur_dbname
DEALLOCATE cur_dbname
