create database RDBMS;
show databases;
use RDBMS;
                                                    --  CREATE TABLES

create table Note(note_id int primary key, note_title varchar(20) not null, note_content varchar(50) not null, note_status varchar(5) not null, note_creation_date date not null);
create table Category(category_id int primary key, category_name varchar(20) , category_descr varchar(20) not null, category_creation_date date not null, category_creator varchar(20) not null);
create table Reminder(reminder_id int primary key, reminder_name varchar(20), reminder_descr varchar(20), reminder_type varchar(20), reminder_creation_date date, reminder_creator varchar(20));
create table NoteCategory( notecategory_id int primary key, note_id int, category_id int , foreign key(note_id) references Note(note_id), foreign key(category_id) references Category(category_id));
create table NoteReminder(  notereminder_id int primary key, note_id int, reminder_id int, foreign key(note_id) references Note(note_id), foreign key(reminder_id) references Reminder(reminder_id));
create table User(user_id int primary key, user_name varchar(20) unique not null, user_added_date date not null, user_password varchar(20) not null, user_mobile long not null);
create table Usernote(usernote_id int primary key, user_id int, note_id int, foreign key(user_id)references User(user_id), foreign key(note_id) references Note(note_id));

select * from Note;
select * from Category;
select * from Reminder;
select * from NoteCategory;
select * from NoteReminder;
select * from User;
select * from Usernote;                                               
																-- INSERT THE ROWS

insert into User values(1, 'anil', curdate(), 12345678, 8866553322);
insert into User values(2, 'amal', curdate(), 12545311, 9395444575);
insert into User values(3, 'PRANAY', curdate(), 12344478, 8866485322);
insert into User values(4, 'sagar', curdate(), 1256223, 9395678575);

insert into Note values(1, "Market", "go to shopping", "pass", CURDATE());
insert into Note values(2, "Tour", "visit to mussoorie", "fail", CURDATE());
insert into Note values(3, "Medicine", "go to doctor", "pass", CURDATE());
insert into Note values(4, "Sports", "go to ground", "pass", CURDATE());

insert into Category values(1, "Food", "eat to pizza", '2021-03-14', "JAY");
insert into Category values(2, "Vehicle", "buy car", '2021-03-15', "Ramesh");
insert into Category values(3, "Vegetables", "buy potatoes", '2021-03-16', "Deepak");
insert into Category values(4, "Fruits", "buy Apples", '2021-03-17', "sarita");

insert into Usernote values(1, 2, 1 );
insert into Usernote values(2, 3, 2 );
insert into Usernote values(3, 3, 2 );

insert into NoteCategory values(1, 2, 2);
insert into NoteCategory values(2, 3, 3);

insert into Reminder values(1, "Calendar", "woke up at morning", 'Alarm', '2021-03-14','ANIL');
insert into Reminder values(2, "Clock", "lunch at noon", 'Alert', '2021-03-18','Syed');
insert into Reminder values(3, "Person", "To do something", 'Call', '2021-03-20','Rahul');
insert into Reminder values(4, "Notes", "Go to study", 'Read', '2021-03-22','Rishabh');

insert into NoteReminder values(1, 2, 1);
insert into NoteReminder values(2, 3, 2);
insert into NoteReminder values(3, 4, 3);
                                                       --  SQL QUERIES

select * from User where user_id=3 AND user_password=12344478;

SELECT * FROM  Note WHERE  note_creation_date >= curdate(); 

select category_name AS Categoroies_Name from Category where category_creation_date>='2021-03-15'; 

select note_id from Usernote INNER JOIN User ON Usernote.user_id=User.user_id where user_name="amal";

update Note set note_title="Tourist place" where note_id=2;

SELECT Note.*
FROM ((Note
INNER JOIN Usernote ON Note.note_id = Usernote.note_id)
INNER JOIN User ON Usernote.user_id = User.user_id ) where User.user_name="amal";

SELECT Note.*
FROM ((Note
INNER JOIN NoteCategory ON Note.note_id = NoteCategory.note_id)
INNER JOIN Category ON NoteCategory.category_id = Category.category_id ) where Category.category_name="Vehicle";

SELECT Reminder.*
FROM ((Reminder
INNER JOIN NoteReminder ON Reminder.reminder_id = NoteReminder.reminder_id)
INNER JOIN Note ON NoteReminder.note_id = Note.note_id ) where Note.note_id=2;

select * from Reminder where reminder_id=2;

DELIMITER &&	
create procedure create_note()      
BEGIN
insert into Note values(5, "Capital", "go to delhi", "fail", CURDATE());
insert into Usernote values(4, 4, 3);
END &&
call create_note();

DELIMITER &&	
create procedure create_notecat()      
BEGIN
insert into Note values(6, "Wedding", "go to wedding party", "pass", CURDATE());
insert into NoteCategory values(3,4,4);
END &&
call create_notecat(); 

DELIMITER &&	
create procedure set_reminder(IN  remname varchar(20), remid int)      
BEGIN
update Reminder set reminder_name=remname where reminder_id=4;
update NoteReminder set reminder_id=remid where notereminder_id=3;
END &&
call set_reminder("New Notes", 4); 

DELIMITER &&	
create procedure delete_note(IN nid int, uid int)      
BEGIN
delete from Note where note_id=nid;
delete from Usernote where usernote_id=uid;
END &&
call delete_note(5,4); 

DELIMITER &&	
create procedure delete_anothernote(IN nid int, ncid int)      
BEGIN
delete from Note where note_id=nid;
delete from NoteCategory where notecategory_id=ncid;
END &&
call delete_anothernote(6,3); 

DELIMITER &&
create trigger on_delete
before delete ON Note for each row
BEGIN
delete from Usernote where note_id=old.note_id;
delete from NoteReminder where note_id=old.note_id;
delete from NoteCategory where note_id=old.note_id;
END &&
delete from Note where note_id=2;
 
 DELIMITER &&
 create trigger user_delete
 before delete ON User for each row
 BEGIN
 SET @nid= (select note_id from Usernote where user_id=old.user_id);
 delete from Usernote where note_id = @nid;
 delete from NoteReminder where note_id=@nid;
 delete from NoteCategory where note_id=@nid;
 END &&
 insert into Note values(8, "Home", "go to Delhi", "pass", CURDATE());
 insert into User values(7, 'sachin', curdate(), 1256244, 9395678555);
 insert into Usernote values(7,7,8 );
 insert into NoteReminder values(10, 8, 4);
 insert into NoteCategory values(10, 8, 4);
 delete from User where user_id=7;
 







 



