
use cmqa
truncate table dbo.aTemp
DECLARE @cur cursor, @path nvarchar(max), @objectid int, @t_objectid int,  
@x int, @y nvarchar(max), @parent_objectid int, @parent_t_objectid int, @id int, @data nvarchar(max)

set @cur = cursor for
select objectid, t_objectid, [path] from SiteCoreData -- where objectid = 276894  -- testing
open @cur
fetch next from @cur into @objectid, @t_objectid, @path
while @@FETCH_STATUS = 0
	BEGIN
		insert aTemp (sdata)
		select * from dbo.fnSplitString(@path,'/') where splitdata <> ''

		-- select * from aTemp END
		/*
		ID	sdata
		1	3550
		2	pdf
		3	276894
		*/

		select @id = max(id) from aTemp

		--select @id
		/*
		3
		*/

		IF @id > 1
			BEGIN
				set @x = 1
				set @y = '/'
				while @x < @id
					BEGIN
						select @y = @y + sdata from aTemp where ID = @x 
						select @y = @y + '/'
						set @x = @x + 1
					END
				select @parent_objectid = objectid, @parent_t_objectid = t_objectid from SiteCoreData where path = @y
				update SiteCoreData set ParentObjectID = @parent_objectid, t_ParentObjectID = @parent_t_objectid where objectid = @objectid and t_objectid = @t_objectid
			END

		truncate table aTemp
		fetch next from @cur into @objectid,  @t_objectid, @path
	END

close @cur
deallocate @cur


  