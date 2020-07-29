REM DBMS project

drop table Attendees;
drop table Members;
drop table Announcement;
drop table Event;
drop table Club;
drop table Student;

create table Student ( 
	StudentID varchar2(5) constraint student_pk primary key , 
	Name varchar2(20) constraint chkstudent_n_nn not null, 
	Branch varchar2(5) constraint chkstudent_b check (Branch in ( 'CSE', 'IT','MECH', 'BME', 'ECE', 'EEE', 'CIVIL', 'CHEM')), 
	Year number(1) constraint chkstudent_year check (Year in (1,2,3,4)),
	Password varchar(20) constraint student_pw_nn not null
);

create table Club ( 
	ClubID varchar2(5) constraint club_pk primary key, 
	ClubName varchar2(20) constraint chkclub_n_nn not null , 
	ClubHead varchar2(5) constraint club_fk references Student(StudentID) , 
	MemberCount number(4) constraint chkclub_m check (MemberCount >= 10)
);

create table Event ( 
	EventID varchar2(5) constraint event_pk primary key, 
	ClubID varchar2(5) constraint event_fk references Club(ClubID) , 
	EventName varchar2(20), 
	Description varchar2(100), 
	EventDate date constraint chkevent_d check ( extract(year from EventDate)>=2020 ), 
	EventTime varchar2(4) constraint chkevent_t check (EventTime between 0600 and 2100), 
	Venue varchar2(20),
	AttendeesCount number(5)
);

create table Announcement (
	AnnouncementID varchar2(5) constraint announc_pk primary key, 
	ClubID varchar2(5) constraint announc_fk references Club(ClubID), 
	AName varchar2(20), 
	Description varchar2(100)
);

create table Members (
	ClubID varchar2(5) constraint members_c_fk references Club(ClubID), 
	StudentID varchar2(5) constraint members_s_fk references Student(StudentID),
	constraint members_pk primary key (ClubID, StudentID)
);

create table Attendees ( 
	EventID varchar2(5) constraint attend_e_fk references Event(EventID) , 
	StudentID varchar2(5) constraint attend_s_fk references Student(StudentID), 
	constraint attend_pk primary key (EventID, StudentID)
);

insert into Student values ('S1001', 'A', 'CSE', 4);
insert into Student values ('S4002', 'B', 'MECH', 3);	


select ClubName,ClubID from Club where ClubID in (select i.ClubID from Club i where i.ClubHead=?)

select c.ClubName,e.EventName,e.Description,e.EventDate,e.EventTime,e.Venue from Event e,Club c where c.ClubID=e.ClubID and e.EventID in (select EventID from Attendees where StudentID=?)

select a.AnnouncementID,c.ClubName,a.AName,a.Description from Announcement a,Club c where c.ClubID=a.ClubID and a.ClubID in (select ClubID from Members where StudentID=?);