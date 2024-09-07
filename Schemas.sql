-- SCHEMA OF Netflix Project --

DROP TABLE IF EXISTS Netflix ;
CREATE TABLE IF NOT EXISTS Netflix (
  show_id varchar(6), 
  type 	  varchar(10), 
  title   varchar(150), 
  director varchar(208), 
  casts     varchar(1000), 
  country   varchar(150), 
  date_added varchar(50), 
  release_year int, 
  rating    varchar(10), 
  duration  varchar(15), 
  listed_in varchar(100), 
  description varchar(250)
);

SELECT * FROM Netflix ;