
exec sp_executesql N'SELECT Last_Name,First_Name,Middle_Initial,Member_Number,NRDS_ID,Member_Office_Name,Office_Number,Full_Name,Nickname,
Personal_Fax_Area,Personal_Fax_Phone,MLS_ID,Social_Security_Number,Birth_Date,Alternate_ID,Preferred_Mail,Billing_Preference,
License_Number,License_Type,License_Expire_Date,Charge_Authorization,Phone_Extension,Password,IMS_Login,Care_of,Street_Address,
City,State,Home_Zip_Code,Home_Zip_Plus_4,Home_Phone_Area,Home_Phone_Number,Contact_Phone_1,Contact_Addl_Phone_Type_1,
Contact_Phone_2,Contact_Addl_Phone_Type_2,Contact_Phone_3,Contact_Addl_Phone_Type_3 FROM rapdata.dbo.Member 
WHERE License_Number = @P1    ORDER BY License_Number ASC ,Member_Number ASC ',N'@P1 char(11)','01389734   '

exec sp_executesql N'SELECT Member_Number,Primary_Indicator,Association_ID,Bill_Type_Code,Member_Type_Code,Status,Status_Date,
Member_Join_Date,Orientation_Date FROM rapdata.dbo.Member_Association WHERE Member_Number = @P1 AND Association_ID = @P2    
ORDER BY Member_Number ASC ,Primary_Indicator ASC ,Status_Date DESC',N'@P1 int,@P2 char(4)',160006390,'0084'

select  * from member_association where member_number = 959347161
order by status_date desc

select * into tblJoe_Backup from tbljoe

UPDATE
    tblJoe 
SET
    NRDSID = m.nrds_id
FROM
    tblJoe j
INNER JOIN
    member m
ON 
    j.[bre license#] = m.license_number

	select * from tbljoe

/* This is the update code:  */

declare @cur cursor, @nrdsid varchar(50), @date varchar(20)
select @date = replace(CONVERT(VARCHAR(10), GETDATE(), 120),'-','')
set @cur = cursor for
select nrdsid from tbljoe
open @cur
fetch next from @cur into @nrdsid
while @@FETCH_STATUS = 0
	BEGIN
		
		INSERT INTO rapdata.dbo.List_Maker_File (Member_Office , Member_Office_Number , List_Category , 
		List_Group_Code , Comment , Status , Date , Amount ) VALUES(
		'M',@nrdsid, 'XMPT', 'COM','Auto','A', @date, 0)

		fetch next from @cur into @nrdsid
	END

close @cur
deallocate @cur


/* Update code end */


exec sp_executesql N'INSERT INTO rapdata.dbo.List_Maker_File (Member_Office , Member_Office_Number , List_Category , 
List_Group_Code , Comment , Status , Date , Amount ) VALUES ( @P1 , @P2, @P3, @P4, @P5, @P6, @P7, @P8) ',
N'@P1 char(1),@P2 int,@P3 char(4),@P4 char(3),@P5 varchar(1),@P6 char(1),@P7 char(8),@P8 numeric(9,2)','M',959108502,'XMPT','COM',' ','A','20170619',0

INSERT INTO rapdata.dbo.List_Maker_File (Member_Office , Member_Office_Number , List_Category , 
List_Group_Code , Comment , Status , Date , Amount ) 
VALUES('M',959108502,'XMPT','COM',' ','A','20170619',0)

select * from List_Maker_File  --where member_office <> 'M' 
order by [date] desc

select member_number, count(*) [Count] from
Member_Association group by member_number having count(member_number) > 1


