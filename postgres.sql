----------------------------
-- 七周七数据库 PostgreSQL --
-- Day one                --
----------------------------


-- 创建表
create table countries (
       country_code char(2) primary key,
       country_name text unique
);





-- 插入个别数据
insert into countries (country_code, country_name)
values ('us', 'United States'),
       ('mx', 'Mexico'),
       ('au', 'Australia'),
       ('gb', 'United Kingdom'),
       ('de', 'Germany'),
       ('ll', 'Loompaland');

-- 插入全部数据
insert into countries
values ('uk', 'United Kingdom');


-- 选择数据
select *
from countries;


-- 删除数据
delete from countries
where country_code = 'll';


-- check: 保证括号内的约束成立
-- references: 外键约束, 保证插入的country_code都在coutries中
create table cities (
       name text not null,
       postal_code varchar(9) check (postal_code <> ''),
       -- 单个外键
       country_code char(2) references countries,
       primary key (country_code, postal_code)
);



insert into cities
values ('Toronto', 'M4C1B5', null);

insert into cities
values ('Portland', '87200', 'us');

-- 更新数据
update cities
set postal_code = '97205'
where name = 'Portland';

-- 内连接
select cities.*, country_name
from cities inner join countries
on cities.country_code = countries.country_code;


-- serial: auto increment
-- match full: 确保都存在或都为null
create table venues (
       venue_id serial primary key,
       name varchar(255),
       street_address text,
       type char(7) check ( type in ('public', 'private')) default 'public',
       postal_code varchar(9),
       country_code char(2),
       -- 复合外键
       foreign key (country_code, postal_code)
               references cities (country_code, postal_code) match full
);



insert into venues ( name, postal_code, country_code )
values ('Crystal Ballroom', '97205', 'us');


select v.venue_id, v.name, c.name
from venues v inner join cities c
on v.postal_code = c.postal_code and v.country_code = c.country_code;

insert into venues (name, postal_code, country_code)
values ('Voodoo Donuts', '97205', 'us') returning venue_id;

create table events (
       event_id serial primary key,
       title varchar(255),
       starts char(19) check ( starts <> ''),
       ends char(19) check (ends <> ''),
       venue_id int references venues
);

insert into events (title, starts, ends, venue_id)
values ('LARP Club', '2012-02-15 17:30:00', '2012-02-15 19:30', '2'),
       ('April Fools Day', '2012-04-01 00:00:00', '2012-04-01 23:59:00', null),
       ('Chrismas Day', '2012-12-25 00:00:00', '2012-12-25 23:59:00', null);

select e.title, v.name
from events e join venues v
on e.venue_id = v.venue_id;

-- 左外连接
select e.title, v.name
from events e left join venues v
on e.venue_id = v.venue_id;

-- 创建hash index
create index events_title
on events using hash (title);

-- 创建btree index
create index events_starts
on events using btree (starts);

-- 显示所有index
\di


-- 2.2.7 作业1, 不会


-- 2.2.7 作业2, 四级联查
select c.country_name, e.title
from countries as c join cities
on c.country_code = cities.country_code join venues
on cities.postal_code = venues.postal_code join events as e
on venues.venue_id = e.venue_id;

-- 作业3, 添加字段
alter table venues add active boolean default true;


-------------
-- Day two --
-------------

-- 插入中国, 插入动作只能使用单引号
insert into countries
values ('cn', 'China');

-- 插入呼和浩特
insert into cities
values ('Hohhot', '010010', 'cn');

-- 插入地点
insert into venues (name, street_address, postal_code, country_code)
values ('Eating', 'South Fengzhou Road', '010010', 'cn');

update venues
set name = 'Home'
where venue_id = 3;


-- 插入事件, 为聚合查找做准备
insert into events (title, starts, ends, venue_id)
values ('Moby', '2012-02-06 21:00:00', '2012-02-06 23:00:00',
        (select venue_id
         from venues
         where name = 'Crystal Ballroom'
        )
       );

insert into events (title, starts, ends, venue_id)
values ('Breakfast', '2016-08-13 08:00:00', '2016-08-13 08:30:00',
        (select venue_id
         from venues
         where name = 'Home'
        )
       );

insert into events (title, starts, ends, venue_id)
values ('Lunch', '2016-08-13 12:00:00', '2016-08-13 12:30:00',
(select venue_id
from venues
where name = 'Home'
)
);


insert into events (title, starts, ends, venue_id)
values ('Dinner', '2016-08-13 19:00:00', '2016-08-13 19:30:00',
(select venue_id
from venues
where name = 'Home'
)
);

insert into events (title, starts, ends, venue_id)
values ('Wedding', '2015-05-25 00:00:00', '2015-05-25 23:59:59',
(select venue_id
from venues
where name = 'Voodoo Donuts'
)
);

insert into events (title, starts, ends)
values ('Valentine''s Day', '2017-02-14 00:00:00', '2017-02-14 23:59:59');

-- 尝试聚合函数
select count(title)
from events
where title like '%Day%';

select min(starts), max(ends)
from events join venues
on events.venue_id = venues.venue_id
where venues.name = 'Crystal Ballroom';

-- 尝试分组
select venue_id, count(*)
from events
group by venue_id;

select venue_id, count(*)
from events
group by venue_id
having count(*) >= 2 and venue_id is not null;

select venue_id from events group by venue_id;
select distinct venue_id from events;

-- 尝试窗口函数
-- 下面的代码会报错, 很容易理解, 对venue_id进行分组, 如果有多个title对应一个venue_id, 那么就不明确要显示哪一个title, 因此会报错
select title, venue_id , count(*)
from events
group by venue_id;
-- 使用窗口函数就不会出现报错
select title, venue_id, count(*)
over (partition by venue_id)
from events
order by venue_id;

-- 尝试事物, 原子性操作
begin transaction;
  -- some opration
end;


-- 过程存储, 实际上是服务器端编程, 深入学习可见"postgresql服务器编程".
-- 采用pgsql语言, 存储于add_event.sql文件中
-- 查看已安装语言, 在命令提示符下, createlang book --list
-- 也可以使用createlang命令来添加语言
\i add_event.sql

select add_event('House Party', '2012-05-03 23:00:00', '2012-05-04 02:00:00', 'Run''s House', '97205', 'us');

-- 触发器
-- 使用pgsql语言, 在log_event.sql中存储, 一个记录的log的function和一个trigger
-- 创建一个logs表

create table logs (
  event_id integer,
  old_title varchar(255),
  old_starts  char(19),
  old_ends char(19),
  logged_at timestamp  default current_timestamp
);

\i log_events.sql

update events
set ends='2012-05-04 01:00'
where title='House Party';

-- 视图
create view holidays as
  select event_id as holiday_id, title as name, starts as date
  from events
  where title like '%Day%' and venue_id is null;

alter table events
add colors text array;

create or replace view holidays as
  select event_id as holiday_id, title as name, starts as date, colors
  from events
  where title like '%Day%' and venue_id is null;

update holidays set colors = '{"red", "green"}' where name = 'Christmas Day';


-- 规则
-- 存储在create_rule.sql中, 告诉PostgreSQL在update的时候做什么操作
-- 尝试一下添加delete rule
update holidays set colors = '{"blue", "green"}' where name = 'Christmas Day';

-- 联表分析
select extract (year from starts) as year,
  extract(month from starts) as month, count(*)
from events
group by year, month;

create temporary table month_count (month int);
insert into month_count
values (select * from generate_series(1,12));

select * from crosstab(
  'select extract (year from starts) as year,
   extract (month from starts) as month, count(*)
   from events
   group by year, month',
   'select * from month_count'
);

select * from crosstab(
'select extract (year from starts) as year,
extract (month from starts) as month, count(*)
from events
group by year, month',
'select * from month_count'
) as (
  year int,
  jan int, feb int, mar int, apr int, may int, jun int,
  jul int, aug int, sep int, oct int, nov int, dec int
) order by year;
