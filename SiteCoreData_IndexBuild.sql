alter table dbo.sitecoredata alter column objectid int not null;
alter table dbo.sitecoredata alter column t_objectid int not null;

alter table dbo.sitecoredata alter column updatedate nvarchar(max) not null;
alter table dbo.sitecoredata alter column updatedate datetime not null;
alter table dbo.sitecoredata add ID int IDENTITY(1,1) not null

alter table dbo.sitecoredata add primary key (objectid, ID)

--select objectid, count(*) from dbo.sitecoredata
--group by objectid having count(objectid) > 1

--select * from sitecoredata where objectid in(
--select objectid from dbo.sitecoredata
--group by objectid having count(objectid) > 1)
--order by objectid, t_objectid

create nonclustered index IX_NC_ObjectID
on dbo.sitecoredata (objectid)

create nonclustered index IX_NC_ObjectTypeID
on dbo.sitecoredata (ObjectTypeID)

create nonclustered index IX_NC_ParentObjectID
on dbo.sitecoredata (ParentObjectID)

create nonclustered index IX_NC_tObjectTypeID
on dbo.sitecoredata (t_ObjectTypeID)
