declare @db varchar(255)
declare c cursor for
select name from sys.databases where is_read_only=0 and state=0
  and name not in ('master','model','tempdb','msdb')
open c
fetch c into @db
while @@fetch_status=0
begin
  exec SP_dboption @db,'trunc. log on chkpt.','true' 
  DBCC shrinkdatabase (@db)
  fetch next from c into @db
end
close c
deallocate c