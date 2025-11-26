-- case1 : author inner join post
-- 글쓴 적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 출력
select * from author inner join post on author.id = post.author_id;
select * from author a inner join post p on a.id = p.author_id;
select a.*, p.* from author a inner join post p on a.id = p.author_id;
-- 글쓴 적이 있는 사용자만 조회해라.
select a.* from author a inner join post p on a.id = p.author_id;


-- case2 : post inner join author
-- 글쓴이가 있는 글과 해당 글의 글쓴이를 조회
select * from post p inner join author a on p.author_id = a.id;
-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
select p.*, a.email from post p inner join author a on p.author_id = a.id;

-- case3 : author left join post
-- 글쓴이는 모두 조회하되, 만약 쓴 글이 있다면 글도 함께 조회
select * from author a left join post p on a.id = p.author_id;


-- case4 : post left joi author
-- 글을 모두 조회하되, 글쓴이가 있다면 글쓴이도 함께 조회
select * from post p left join author a on p.author_id= a.id;


-- 실습1) 글쓴이가 있는 글 중에서 글의 제목, 저자의 email, 저자의 나이를 출력하되, 
-- 저자의 나이가 30세 이상인 글만 출력.
select p.title, a.email, a.age from post p inner join author a on a.id = p.author_id where a.age >=30;

-- 실습2) 글의 저자의 이름이 빈 값(null) 이 아닌 글목록만을 출력.
select p.* from post p from post p inner join author a on a.id = p.author_id where a.name is not null;

-- 프로그래머스) 조건에 맞는 도서와 저자 리스트 출력
SELECT b.BOOK_ID, a.AUTHOR_NAME, 
DATE_FORMAT(PUBLISHED_DATE, "%Y-%m-%d") AS PUBLISHED_DATE 
FROM BOOK b INNER JOIN AUTHOR a ON a.AUTHOR_ID = b.AUTHOR_ID
WHERE b.CATEGORY = '경제' ORDER BY b.PUBLISHED_DATE;

-- 프로그래머스) 없어진 기록 찾기
SELECT o.ANIMAL_ID,o.NAME FROM ANIMAL_OUTS o LEFT JOIN ANIMAL_INS i
ON o.ANIMAL_ID = i.ANIMAL_ID WHERE i.ANIMAL_ID is null;

-- union : 두 테이블의 select 결과를 횡으로 결합(밑으로)
-- union 시킬 때, 칼럼의 개수와 칼럼의 타입이 같아야 함.
select name, email from author union select title, contents from post;
-- union은 기본적으로 distinct 적용. 중복 허용하려면 union all 사용.
select name, email from author union all select title, contents from post;


-- 서브쿼리 : select문 안에 또 다른 select문을 서브쿼리라 함
-- where절 안에 서브쿼리
-- 한 번이라도 글을 쓴 author의 목록 조회(중복 제거)
select distinct a.* from author a inner join post p on a.id = p.author_id;
-- null 값은 in조건절에서 자동으로 제외된다.
select * from author where id in (select author_id from post);

-- 컬럼 위치에 서브쿼리
-- 회원별로 본인의 쓴 글의 개수를 출력
-- join 보다는 서브쿼리 성능이 더 안 좋다.
select email, (select count(*) from post p where p.author_id=a.id) as count 
from author a order by count;

select from author a left join post p on a.id = p.author_id group by author_id;

-- from절 위치에 서브쿼리
select a.* from (select * from author) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화 하여, 하나의 행(row) 처럼 취급
-- 글 쓴 글쓴이의 종류 출력.
select author_id from post group by author_id;
-- 글 안 쓴 사람의 개수는 안 나옴. null은 null끼리 grouping 된다.
select author_id, count(*) from post group by author_id;
-- 회원별로 본인의 쓴 글의 개수를 출력(left join으로 풀이)
select a.email, count(p.author_id) as post_count 
from author a left join post p on p.author_id = a.id group by a.email;

-- 집계함수
select count(*) from author;
select sum(age) from author;
select avg(age) from author;
-- 소수점 3번째 자리에서 반올림
select round(avg(age), 3) from author;

-- group by와 집계함수
-- 회원의 이름별 숫자를 출력하고, 이름별 나이의 평균값을 출력하라.
select name, count(*) as count, avg(age) as age from author group by name;


-- where와 groupby
-- 날짜 값이 null인 데이터는 제외하고, 날짜별 post 글의 개수 출력.
select date_format(created_time,'%Y-%m-%d') as date, count(*) as count 
from post 
where created_time is not null group by date_format(created_time,'%Y-%m-%d')
order by date;


-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
SELECT CAR_TYPE, COUNT(*) AS CARS FROM CAR_RENTAL_COMPANY_CAR 
WHERE OPTIONS LIKE "%통풍시트%" OR OPTIONS LIKE "%열선시트%" OR OPTIONS LIKE "%가죽시트%"
GROUP BY CAR_TYPE 
ORDER BY CAR_TYPE;

-- 입양 시각 구하기(1)
SELECT CAST(date_format(DATETIME,'%H')AS UNSIGNED) AS HOUR, COUNT(*) AS COUNT
FROM ANIMAL_OUTS
WHERE date_format(DATETIME,'%H') >= 9 and date_format(DATETIME,'%H') <20
GROUP BY HOUR
ORDER BY HOUR;

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 2번 이상 쓴 사람 id찾기
select author_id, count(*) from post group by author_id having count(*) >= 2;


-- 지금까지 배운거 다쓰는 법  코테에서 이정도는 나온다. 
select aa,count(*) from A inner join B on where bb='xx' xx 
group by aa having count()>=2 order by yy limit 1;

-- 프로그래머스) 동명 동물 수 찾기 --> having
SELECT NAME, COUNT(*) AS COUNT FROM ANIMAL_INS WHERE NAME IS NOT NULL
GROUP BY NAME HAVING COUNT(*) >= 2 ORDER BY NAME;

-- 프로그래머스) 카테고리 별 도서 판매량 집계하기 -> 다나옴
SELECT b.CATEGORY, SUM(s.SALES) AS TOTAL_SALES
FROM BOOK b LEFT JOIN BOOK_SALES s ON b.BOOK_ID = s.BOOK_ID
WHERE s.SALES_DATE >='2022-01-01' AND s.SALES_DATE <= '2022-01-31'
GROUP BY CATEGORY ORDER BY CATEGORY;

-- 프로그래머스) 조건에 맞는 사용자의 총 거래금액 조회하기 -> 다나옴
SELECT USER_ID, NICKNAME, SUM(PRICE) AS TOTAL_SALES
FROM USED_GOODS_USER u LEFT JOIN USED_GOODS_BOARD b ON u.USER_ID = b.WRITER_ID
WHERE b.STATUS = 'DONE' GROUP BY USER_ID HAVING TOTAL_SALES >= 700000
ORDER BY TOTAL_SALES;

-- 다중열 group byf
-- group by 첫번째 컬럼, 두 번째 컬럼 : 첫 번째 컬럼으로 grouping 이후에 두 번째 컬럼으로 grouping
-- post 테이블에서 작성자별로 구분하여 같은 제목의 글의 개수를 출력하시오.
select author_id, title, count(*) from post group by author_id, title;

-- 프로그래머스) 재구매가 일어난 상품과 회원 리스트 구하기
SELECT USER_ID, PRODUCT_ID FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(*) >= 2
ORDER BY USER_ID, PRODUCT_ID DESC;

-- grouping 하는 요소랑 조건 요소가 같으면 having, 다르면 where 조건


