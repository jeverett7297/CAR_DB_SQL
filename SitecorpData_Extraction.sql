--SELECT DISTINCT mediatype FROM ms.objtype o

--  SELECT * from ms.obj WHERE objecttypeid = 230

--truncate table ms.XCentium_Output
-- drop table ms.XCentium_Output

select o.ObjectID, NULL [ParentObjectID], t.MediaType, t.name [ActualType], o.name [Name], o.SimpleName, 
o.path [Path], o.UpdateDate, m.BlobSize, m.BlobData, m.Extension,
fn.name [Title], fn.variable [ShortDescription], f.stringvalue [BodyText], u.name [Author Name], fn.Searchable, 
NULL [ShowNavigation], null [Keyword], g.GroupName,ms.StatusName
--into ms.XCentium_Output
from ms.obj (nolock) o 
outer apply( select top 1 msa.* from ms.objaudit (nolock) msa
where msa.objectid = o.objectid
order by msa.actiondate desc) x
left join ms.objtype (nolock) t on o.objecttypeid = t.objecttypeid and o.siteid = t.siteid
left join ms.mediaitem (nolock) m on m.objectid = o.objectid
left join ms.fieldvalue (nolock) f on f.objectid = o.objectid
left join ms.fieldname (nolock) fn on fn.fieldid = f.fieldid

outer apply( select top 1 cro.* from ms.cr_obj (nolock) cro
where cro.objectid = o.objectid
order by cro.searchid desc) y

--left join ms.cr_obj (nolock) cro on cro.objectid = o.objectid

left join ms.usr (nolock) u on u.userid = y.authorid
left join ms.usergroup (nolock) ug on ug.userid = u.userid
left join ms.grp (nolock) g on g.groupid = ug.groupid
left join ms.grpstatus (nolock) gs on gs.groupid = g.groupid
left join ms.status (nolock) ms on ms.statusid = gs.statusid

where o.objectid = 878945
and ms.statusname = 'Published'
--order by g.GroupName

select * from ms.cr_object where objectid = 878945



























