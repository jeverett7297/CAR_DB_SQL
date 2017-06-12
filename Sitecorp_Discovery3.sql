SELECT DISTINCT ms.cr_obj.objectid, ms.cr_obj.name, ms.cr_obj.t_objecttypeid, ms.cr_obj.statusid, 
	ms.cr_obj.updatedate, ms.usr.name, ms.objtype.linkable, 0, 0, ms.cr_obj.hostid, 0, 
	ms.cr_obj.contentref, ms.cr_obj.sectionid, ms.cr_obj.deleted,
	ms.cr_obj.t_deleted, ms.cr_obj.simplename,
	(
		SELECT COUNT(*)
		FROM ms.link l, ms.cr_obj o
		WHERE l.parentid = ms.cr_obj.objectid
		AND l.linktypeid IN ( 0, 1 )
		AND o.objectid = l.childid
		AND o.deleted = 0
		AND o.t_deleted = 0
		AND o.cureditable = 1
		AND o.contentref IN ( 0, 2 )
	),
	(
		SELECT COUNT(*)
		FROM ms.link b, ms.obj o
		WHERE b.parentid = ms.cr_obj.objectid
		AND b.linktypeid = 0
		AND b.linksubtypeid = 0
		AND o.objectid = b.childid
		AND o.deleted = 0
	), 0, ms.cr_obj.origobjectid
FROM ms.cr_obj, ms.objtype, ms.usr
--WHERE ms.cr_obj.objectid =  404669 
where ms.cr_obj.deleted = 0
AND ms.cr_obj.t_deleted = 0
AND ms.cr_obj.cureditable = 1
AND ms.cr_obj.contentref IN( 0, 2 )
--AND NOT EXISTS
--(
--	SELECT 'X'
--	FROM ms.link
--	WHERE ms.link.childid = ms.cr_obj.objectid
--	AND ms.link.linktypeid = 0
--)
AND usr.userid = ms.cr_obj.authorid
AND objtype.objecttypeid = ms.cr_obj.objecttypeid