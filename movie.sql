--  세미 프로젝트 영화예매 사이트 테이블
-- 230612


---------------------------------------------------------------------------------
DROP TABLE MTICKETING;
DROP TABLE MSCHEDULE;
DROP TABLE MREVIEW;
DROP TABLE MMEMBER;
DROP TABLE MINFO;
DROP TABLE MTHEATER;

-- MEMBER 테이블
CREATE TABLE MMEMBER(

    MBID        NVARCHAR2(20) PRIMARY KEY,  -- 회원 아이디
    MBPW        NVARCHAR2(60),              -- 회원 비밀번호
    MBNAME      NVARCHAR2(5),               -- 회원 이름
    MBGENDER    NVARCHAR2(3),               -- 회원 성별
    MBBIRTH     NVARCHAR2(20),              -- 회원 생년월일
    MBADDR      NVARCHAR2(100),             -- 회원 주소
    MBPHONE     NVARCHAR2(15),              -- 회원 연락처
    MBEMAIL     NVARCHAR2(50)               -- 회원 이메일
);

-- 영화 정보 테이블

CREATE TABLE MINFO(
    MINAME      NVARCHAR2(100) PRIMARY KEY, -- 영화이름
    MIGENRE1    NVARCHAR2(10),             -- 영화 장르
    MIGENRE2    NVARCHAR2(10),             -- 영화 장르
    MIGENRE3    NVARCHAR2(10),             -- 영화 장르
    MIDIRECTER  NVARCHAR2(20),             -- 영화 감독
    MIACTOR     NVARCHAR2(200),             -- 영화 배우
    MISYNOPSIS  NVARCHAR2(500),            -- 영화 줄거리
    MIAGE       NVARCHAR2(10),             -- 관람 등급
    MIRUNTIME   NVARCHAR2(5),              -- 상영 시간
    MIPOSTER    NVARCHAR2(100),            -- 영화 포스터
    MIRELEASE   NVARCHAR2(20),             -- 영화 개봉일
    MITEASER    NVARCHAR2(100),            -- 영화 예고편
    MISTILLCUT1 NVARCHAR2(100),            -- 영화 스틸컷1
    MISTILLCUT2 NVARCHAR2(100),            -- 영화 스틸컷2
    MISTILLCUT3 NVARCHAR2(100),            -- 영화 스틸컷3
    MISTILLCUT4 NVARCHAR2(100),            -- 영화 스틸컷4
    MISTILLCUT5 NVARCHAR2(100),            -- 영화 스틸컷5
    MISTILLCUT6 NVARCHAR2(100)             -- 영화 스틸컷6
);



-- 상영관 테이블

CREATE TABLE MTHEATER(
    MTTHEATER       NVARCHAR2(10) PRIMARY KEY,      -- 상영관
    MTKIND          NVARCHAR2(10),                  -- 상영관 종류
    MTSEATS         NUMBER,                         -- 좌석수
    MTCOMMON        NUMBER,                         -- 성인 가격
    MTCHILD         NUMBER                          -- 어린이 가격
);

-- 영화 스케쥴 테이블
CREATE TABLE MSCHEDULE(
    MSNUMBER    NUMBER PRIMARY KEY,        -- 스케쥴번호
    MSNAME      NVARCHAR2(100) CONSTRAINT MINA_MSNA_FK REFERENCES MINFO(MINAME),    -- 영화 제목
    MSSTARTTIME NVARCHAR2(30),              -- 시작 시간
    MSENDTIME   NVARCHAR2(30),              -- 종료 시간
    MSDATE      NVARCHAR2(30),                       -- 상영일
    MSTHEATER   NVARCHAR2(10) CONSTRAINT MTTH_MSTH_FK REFERENCES MTHEATER(MTTHEATER)  -- 상영관
);



-- 리뷰 테이블

CREATE TABLE MREVIEW(
    MRNAME      NVARCHAR2(100) CONSTRAINT MINA_MRNA_FK REFERENCES MINFO(MINAME), -- 영화 제목
    MRREVIEW    NVARCHAR2(200),                                                 -- 영화 리뷰
    MRID        NVARCHAR2(20) CONSTRAINT MBID_MRID_FK REFERENCES MMEMBER(MBID), -- 작성자
    MRDATE      DATE
);


-- 얘매 테이블

DROP TABLE MTICKETING;
CREATE TABLE MTICKETING(
    MTNUMBER        NUMBER,             -- 예매 번호
    MTSNUMBER       NUMBER CONSTRAINT MSNU_MTSN_FK REFERENCES MSCHEDULE(MSNUMBER),  -- 스케쥴 번호
    MTNAME          NVARCHAR2(100) CONSTRAINT MINA_MTNA_FK REFERENCES MINFO(MINAME),  -- 영화 제목
    MTSEAT          NVARCHAR2(30),             -- 좌석
    MTCOUNT         NUMBER,                    -- 인원 수
    MTPRICE         NUMBER,                    -- 총 가격
    MTPAYMENT       NVARCHAR2(10),             -- 결제 여부
    MTID            NVARCHAR2(20)  CONSTRAINT MBID_MTID_FK REFERENCES MMEMBER(MBID) -- 회원 아이디
);

-- 스케줄 번호 시퀀스
CREATE SEQUENCE SCHEDULE_SEQ START WITH 1 INCREMENT BY 1;

-- 고객센터 게시판 테이블
CREATE TABLE MBOARD (
        BDNUM                    NUMBER      PRIMARY KEY,
        BDWRITER             NVARCHAR2 (20),
        BDTITLE                 NVARCHAR2 (50),
        BDCONTENT          NVARCHAR2 (1000),
        BDDATE                  DATE,
        CONSTRAINT FK_MBID FOREIGN KEY (BDWRITER) REFERENCES  MMEMBER (MBID)
);

 -- MBOARD_SEQ 시퀀스 생성
CREATE SEQUENCE MBOARD_SEQ START WITH 1 INCREMENT BY 1;
 
 -- MVBLIST 뷰 생성
 CREATE VIEW MVBLIST AS 
 SELECT
            ROW_NUMBER() OVER(ORDER BY BDNUM DESC) AS RN,
            MBOARD.*
FROM MBOARD;

-- 댓글(COMMENT) 테이블 만들기
CREATE TABLE COSCOMMENT (
        CMNUM                    NUMBER PRIMARY KEY,
        CMBNUM                 NUMBER,
        CMWRITER             NVARCHAR2(20),
        CMCONTENT          NVARCHAR2(200),   
        CMDATE                  DATE,
        
        CONSTRAINT FK_MBID_CMWRITER FOREIGN KEY (CMWRITER) REFERENCES  MMEMBER (MBID),
        CONSTRAINT FK_MBID_CMBNUM FOREIGN KEY (CMBNUM) REFERENCES  MBOARD (BDNUM)
);

 -- 댓글번호 CMNUM에 대한 시퀀스 생성
CREATE SEQUENCE CMNUM_SEQ START WITH 1 INCREMENT BY 1;

-- 조인 뷰--
CREATE VIEW ADTICKETING AS SELECT ROW_NUMBER() OVER(ORDER BY MTNUMBER DESC) AS RN, a.*,b.* FROM MTICKETING a, MSCHEDULE b WHERE a.MTSNUMBER = b.MSNUMBER;

commit;