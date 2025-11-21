-- mariadb 서버에 터미널창으로 접속
-- db gui 툴로 접속시에는 커넥션 객체 생성하여 연결
mariadb -u root -p -- 엔터 후 비밀번호 별도 입력

-- 스키마(database) 생성
create database board;

-- 스키마 삭제
drop database board;

-- 스키마 목록 조회
show databases;

-- 스키마 선택
use 스키마명;


-- 문자 인코딩 세팅 조회(외울 필요 없음)
show variables like 'character_set_server';

-- 문자인코딩 변경
alter database board default character_set = utf8mb4;

-- 테이블 목록 조회
show tables;

-- sql문은 대문자관례이고, 시스템에서 대소문자를 구분하지는 않음.
-- 테이블명/칼럼명 등은 소문자가 관례이고, 대소문자 차이 있음.
-- 테이블 생성
create table author(id int primary key, name varchar(255), email varchar(255), password varchar(255));


-- 테이블 컬럼 정보 조회
describe author;

-- 테이블 데이터 전체 조회
select * from author;


-- 테이블 생성명령문 조회(안 중요)
show create table author;

-- posts테이블 신규 생성(id, title, contents, author_id)
create table posts(id int, title varchar(255), contents varchar(255), author_id int, primary key(id), foreign key(author_id) references author(id) );


-- 테이블 제약조건 조회
select * from information_schema.key_column_usage where table_name='posts';


-- 테이블 index 조회
show index from 테이블명;


-- alter : 테이블의 구조를 변경
-- 테이블의 이름 변경
alter table posts rename post;

-- 테이블의 컬럼 추가
alter table author add column age int;

-- 테이블의 컬럼 삭제
alter table author drop column age;

-- 테이블의 컬럼명 변경
alter table post change column content contents varchar(255);

-- 테이블 컬럼의 타입과 제약조건 변경
alter table post modify column content varchar(3000);
alter table author modify column email varchar(255) not null unique;


-- 실습1 . author 테이블에 address 컬럼을 추가(varcchar 255) name은 not null로 변경.
alter table author add column address varchar(255);
alter table author modify name varchar(255) not null;

-- 실습2. post 테이블에 title을 not null로 변경. content는 contents로 이름 변경.
alter table post modify column title varchar(255) not null;
alter table post change column content contents varchar(3000);


-- 테이블 삭제
drop table abc;

-- 일련의 쿼리를 실행시킬 때 특정 쿼리에서 에러가 나지 않도록 if exists를 많이 사용.
drop table if exists abc;



