
use cmqa
DECLARE @cur cursor, @objectid int, @blobsize int,  @blobdata varbinary(max), @extension varchar(32)

set @cur = cursor for
select * from [LA-ACM-PROD].cmstage.ms.[mediaitem]
open @cur
fetch next from @cur into @objectid, @blobsize, @blobdata, @extension
while @@FETCH_STATUS = 0
	BEGIN
		insert ms.mediaitem (objectid, blobsize, blobdata, extension) values (@objectid, @blobsize, @blobdata, @extension)
		fetch next from @cur into @objectid, @blobsize, @blobdata, @extension
	END
close @cur
deallocate @cur


  