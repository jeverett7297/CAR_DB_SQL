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

where o.cureditable = 1 and o.deleted = 0 and t_statusid = 104 and statusid = 104 and o.objecttypeid = 153522
and o.objecttypeid <> o.t_objecttypeid

group by o.objectid, o.objecttypeid, ot.name,  o.t_objectid, o.t_objecttypeid, ot2.name,
o.name, o.simplename, o.path, o.updatedate, m.blobsize, m.blobdata, m.extension,
o.authorid, u.name

--select count(*) from dbo.SiteCoreData  -- 45,883
--select * from dbo.SiteCoreData where path like '%469969%'
--select * from sitecoredata where objectid = 469969

-- How to get Title, Short Description, Body Text, Date, Searchable, Show Navigation, Keyword and Group

/*
	1) For each SiteCoreData record grab the t_objectid and t_objecttypeid
	2) For that t_objecttypeid join to ms.fieldname and grab the fieldid where ms.fieldname.name = 'Title'
	3) Take fieldid from step 2 and the t_objectid from step 1 and join to ms.fieldvalue.  Read the ms.fieldvalue.value contents and place it in the TITLE column
	   of SiteCoreData.
	   
	REPEAT for ShortDescription, BodyText, DateValue, Searchable, ShowNavigation, Keyword and Group 
	
*/

-- Example (To see all the parts):

--select * from ms.cr_obj where objectid = 462632
--select * from ms.fieldname where objecttypeid = 1061
--select * from ms.fieldvalue where objectid = 66931

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


select * from SiteCoreData where objectid = 276894		-- parent is 100782
select * from SiteCoreData where path = '/3550/pdf/'	-- /pdf = 100782  parent is 3550
select * from SiteCoreData where path = '/3550/'		-- /3550 = 3550  parent is blank

select * from SiteCoreData where objectid <> t_objectid

select * 
from (
select sdata as d, row_number() over (partition by sdata order by id desc) as rownum
from @temp) sd
where rownum = 2











