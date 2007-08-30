drop database if exists data_loader_test;

create database data_loader_test;
	
use data_loader_test;	
	
create table people_data
(
	first varchar(50),
	last varchar(50),
	age		  int
);