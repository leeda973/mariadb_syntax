-- view : 실제 데이터를 참조만 하는 가상의 테이블. SELECT만 가능.(insert, update 등은 안됨.)
-- 사용목적: 1) 권한분리 2) 복잡한 쿼리를 사전 생성하여 쓰고 싶다.


-- view 생성
create view author_view as select name, email from author;
create view author_view2 as select p.title, a.name, a.email from post p inner join author a on p.author_id  = a.author_id;

-- view 조회(테이블 조회와 동일)
select * from author_view;

-- view에 대한 권한 부여
grant select on board.author_view to 'marketing'@'%';

-- view  삭제
drop view author_view;

-- 프로시저 생성
delimiter //
create procedure hello_procedure()
begin
    select "hello world";
end
// delimiter ;

-- 프로시저 호출
call hello_procedure();

-- 프로시저 삭제
drop procedure hello_procedure;


-- 회원목록조회 프로시저 생성 -> 한글명 프로시저 가능
delimiter //
create procedure 회원목록조회()
begin
    select * from author;
end
// delimiter ;


-- 회원상세조회 -> input(매개변수) 값 여러 개 사용 가능. -> 프로시저 호출 시 순서에 맞게 매개변수 입력.
delimiter //
create procedure 회원상세조회(in idInput bigint)
begin
    select * from author where id = idInput;

end
// delimiter ;


-- 전체 회원 수 조회 -> 변수 사용
delimiter //
create procedure 전체회원수조회()
begin
    -- 변수 선언
    declare authorCount bigint; 
    -- into를 통해 변수에 값 할당
    select count(*) into authorCount from author;
    -- 변수값 사용
    select authorCount;
end
// delimiter ;

-- 글쓰기
-- 사용자가 title, contents, 본인의 email값을 입력.
delimiter //
create procedure 글쓰기(in titleInput varchar(255), contentsInput varchar(255), emailInput varchar(255))
begin
    -- begin 밑에 declare를 통해 변수 선언
    declare findAuthorId bigint; 
    declare findPostId int;
    -- email로 회원ID 찾기
    -- into를 통해 변수에 값 할당
    select id into findAuthorId from author where email = emailInput;

    -- post 테이블에 insert
    insert into post(title, contents) values(titleInput, contentsInput);
    -- post 테이블에 insert된 id값 구하기
    select id into findPostId from post order by id desc limit 1;
    -- author_post_list 테이블에 insert하기(author_id, post_id 필요)
    insert into author_post_list(author_id, post_id) values(findAuthorId, findPostId);
end
// delimiter ;

-- 글쓰기(2) 트랜잭션ver.
-- 사용자가 title, contents, 본인의 email값을 입력.
delimiter //
create procedure 글쓰기(in titleInput varchar(255), contentsInput varchar(255), emailInput varchar(255))
begin
    declare findAuthorId bigint; 
    declare findPostId int;
    -- 아래 declare은 변수 선언과는 상관 없는 예외 관련 특수 문법.
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
        select id into findAuthorId from author where email = emailInput;
        insert into post(title, contents) values(titleInput, contentsInput);

        select id into findPostId from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(findAuthorId, findPostId);
    commit;
end
// delimiter ;


-- 글삭제 -> if else문
delimiter //
create procedure 글삭제(in postIdInput bigint, in authorIdInput bigint)
begin
    declare authorCount bigint;
    select count(*) into authorCount from author_post_list where post_id = postIdInput;
    if authorCount=1 then
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
        delete from post where id=postIdInput;
    else
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
    end if;
end
// delimiter ;

-- 대량글쓰기 -> while문을 통한 반복문
delimiter //
create procedure 글도배(in count bigint, in emailInput varchar(255))
begin
    declare findAuthorId bigint; 
    declare findPostId int;
    declare countValue bigint default 0;
    while countValue < count do
        select id into findAuthorId from author where email = emailInput;
        insert into post(title) values("안녕하세요");
        select id into findPostId from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(findAuthorId, findPostId);
        set countValue = countValue + 1;
    end while;
end
// delimiter ;


