-- Test against mysql
-- use run the specs you must first run this against mysql
-- mysql -u root < create.sql

drop database if exists ar_importer_test;

create database ar_importer_test;
	
use ar_importer_test;	
	
create table people_data
(
  id  int auto_increment,
	first varchar(50),
	last varchar(50),
	age		  int,
	primary key(id)
);