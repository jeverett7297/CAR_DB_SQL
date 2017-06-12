SELECT obj2.version, objaudit.revision, obj2.objectid, status.statusname, usr.name, usr.userid,  
objaudit.actiondate, objaudit.description, obj.origobjectid 
FROM ms.obj, ms.obj obj2, ms.objaudit, ms.usr, 
ms.objtypestatus, ms.status WHERE obj.objectid =  404669   AND obj.origobjectid = obj2.origobjectid  
AND obj2.objectid = objaudit.objectid  AND objaudit.authorid = usr.userid  AND 
objaudit.objecttypestatusid = objtypestatus.objecttypestatusid  AND objtypestatus.statusid = status.statusid 
ORDER BY obj2.version DESC, objaudit.revision DESC, objaudit.actiondate DESC

select u.name, u.userid, o.* from ms.objaudit a
join ms.obj o on a.objectid = o.objectid
left join ms.usr u on u.userid = a.authorid

