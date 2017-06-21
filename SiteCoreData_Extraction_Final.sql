use cmqa
if not exists (select * from sysobjects where name='dbo.aTemp' and xtype='U')
    create table dbo.aTemp (
        ID int identity(1,1) not null,
		sdata nvarchar(max) null
    ) on [primary] textimage_on [primary]
go

truncate table dbo.SiteCoreData
truncate table aTemp

insert SiteCoreData
select o.ObjectID, o.ObjectTypeID, ot.name [ObjectType_Description], o.t_ObjectID, o.t_ObjectTypeID, ot2.name [t_ObjectType_Description], 
NULL [ParentObjectID], NULL [t_ParentObjectID], o.name [Name], o.SimpleName, 
o.path [Path], o.UpdateDate, m.BlobSize, m.BlobData, m.Extension,
NULL [Title], NULL [ShortDescription], NULL [ItemDate], NULL [BodyText], o.AuthorID, u.name [AuthorName], NULL [Searchable],  
NULL [ShowNavigation], NULL [Keyword], NULL [Group], max(contentref) [ContentRef] 
from ms.cr_obj (nolock) o 
left join ms.objtype (nolock) ot on ot.objecttypeid = o.objecttypeid
left join ms.objtype (nolock) ot2 on ot2.objecttypeid = o.t_objecttypeid
left join ms.mediaitem (nolock) m on m.objectid = o.objectid
left join ms.usr (nolock) u on u.userid = o.authorid

where o.cureditable = 1 and o.deleted = 0 and o.t_statusid = 104 and o.statusid = 104 --and o.objecttypeid in(153522, 243, 107, 112)
--where o.cureditable = 1 and o.deleted = 0 and o.t_statusid = 104 and o.statusid = 104 and o.objecttypeid in(153522, 243, 107)--, 112)
--and o.objecttypeid <> o.t_objecttypeid

group by o.objectid, o.objecttypeid, ot.name,  o.t_objectid, o.t_objecttypeid, ot2.name,
o.name, o.simplename, o.path, o.updatedate, m.blobsize, m.blobdata, m.extension,
o.authorid, u.name

-- First pass update

update sitecoredata set statusid = o.statusid
from sitecoredata scd join ms.cr_obj o on scd.objectid = o.objectid

update sitecoredata set t_statusid = o.t_statusid
from sitecoredata scd join ms.cr_obj o on scd.t_objectid = o.t_objectid

update sitecoredata set [status] = m.statusname
from sitecoredata scd join ms.status m on scd.statusid = m.statusid

update sitecoredata set [t_status] = m.statusname
from sitecoredata scd join ms.status m on scd.t_statusid = m.statusid

-- How to get Title, Short Description, Body Text, Date, Searchable, Show Navigation, Keyword and Group

update d
set d.Title = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Title'

update d
set d.ShortDescription = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Short Description'

update d
set d.BodyText = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Body Text'

update d
set d.[ItemDate] = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Date' and fv.value is not null

update d
set d.[AuthorName]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Author'

update d
set d.[Searchable]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Searchable'

update d
set d.[ShowNavigation]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Show Navigation'

update d
set d.[Keyword]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Keyword'

update d
set d.[Group]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Group'

-- Pass 4

update d
set d.[StartDate]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Start Date'

update d
set d.[EndDate]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'End Date'

update d
set d.[ExpiryDate]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Expiry Date'

update d
set d.[EventType]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Event Type'

update d
set d.[InPerson]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'In Person'

update d
set d.[Location]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Location'

update d
set d.[Topic]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Topic'











