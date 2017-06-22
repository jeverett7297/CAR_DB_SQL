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
NULL [ShowNavigation], NULL [Keyword], NULL [Group], max(contentref) [ContentRef], NULL [Status], NULL [t_Status],
NULL StatusID, NULL t_StatusID, NULL StartDate, NULL EndDate, NULL ExpiryDate, NULL EventType, NULL InPerson,
NULL [Location], NULL Topic, Null SearchTerms, NULL Category, NULL ScriptLocation, NULL SpecialScript, NULL OCT_BannerType,
NULL Video, NULL VideoPlayer, Null PopUpScript, NULL IssueSummary, NULL NextIssueSummary, NULL NextIssueMonth,
NULL NextIssueArrivalDate, NULL NextIssueMailDate, NULL LinkOfDigitalEdition, NULL [Date], NULL [Year], NULL [Description],
NULL SectionBucket, NULL ThumbNailImage_ObjectID, NULL FeatureImage_ObjectID,  NULL InfographicsImage_ObjectID, 
NULL GIFImage_ObjectID, NULL BannerImage_ObjectID
from ms.cr_obj (nolock) o 
left join ms.objtype (nolock) ot on ot.objecttypeid = o.objecttypeid
left join ms.objtype (nolock) ot2 on ot2.objecttypeid = o.t_objecttypeid
left join ms.mediaitem (nolock) m on m.objectid = o.objectid
left join ms.usr (nolock) u on u.userid = o.authorid

where o.cureditable = 1 and o.deleted = 0 and o.t_statusid = 104 and o.statusid = 104 
and o.t_objecttypeid in(1061, 225, 243, 1031950) --and o.objecttypeid <> o.t_objecttypeid 

and o.objecttypeid in(153522, 243, 107, 112)
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

update d
set d.[SearchTerms]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Search Terms'

update d
set d.[Category]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Category'

update d
set d.[ScriptLocation]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Script Location'

update d
set d.[SpecialScript]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Special Script'

update d
set d.[OCT_BannerType]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'OCT Banner Type'

update d
set d.[Video]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Video'

update d
set d.[VideoPlayer]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'VideoPlayer'

update d
set d.[PopUpScript]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Popup Script'

------------------

update d
set d.[IssueSummary]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Issue Summary'

update d
set d.[NextIssueSummary]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Next Issue Summary'

update d
set d.[NextIssueMonth]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Next Issue Month'

update d
set d.[NextIssueArrivalDate]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Next Issue Arrival Date'

update d
set d.[NextIssueMailDate]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Next Issue Mail Date'

update d
set d.[LinkOfDigitalEdition]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Link Of Digital Edition'

update d
set d.[Date]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Date'

update d
set d.[Year]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Year'

update d
set d.[Description]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Description'

update d
set d.[SectionBucket]  = fv.value
from SiteCoreData d
join ms.fieldname (nolock) fn on d.t_objecttypeid = fn.objecttypeid
join ms.fieldvalue (nolock) fv on fv.fieldid = fn.fieldid and fv.objectid = d.t_objectid
where fn.name = 'Section Bucket'





update d
set d.ThumbNailImage_ObjectID = l.childid
from SiteCoreData d
left join ms.link l on d.t_objectid = l.parentid
where l.linktypeid = 3 and   


select * from ms.objtype where name like 'Thumb%' -- 1256 thumbnail
select * from ms.objtype where name like 'Feat%'  -- 1287 Feature Image

select * from ms.link l join ms.cr_obj o on l.parentid = o.t_objectid
where l.linktypeid = 3 and o.objecttypeid = 1256

select * from ms.cr_obj
select * from ms.cr_obj where objectid = 1030805
select * from ms.objtype where objecttypeid = 1256









