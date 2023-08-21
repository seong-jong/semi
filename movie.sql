--  ���� ������Ʈ ��ȭ���� ����Ʈ ���̺�
-- 230612


---------------------------------------------------------------------------------
DROP TABLE MTICKETING;
DROP TABLE MSCHEDULE;
DROP TABLE MREVIEW;
DROP TABLE MMEMBER;
DROP TABLE MINFO;
DROP TABLE MTHEATER;

-- MEMBER ���̺�
CREATE TABLE MMEMBER(

    MBID        NVARCHAR2(20) PRIMARY KEY,  -- ȸ�� ���̵�
    MBPW        NVARCHAR2(60),              -- ȸ�� ��й�ȣ
    MBNAME      NVARCHAR2(5),               -- ȸ�� �̸�
    MBGENDER    NVARCHAR2(3),               -- ȸ�� ����
    MBBIRTH     NVARCHAR2(20),              -- ȸ�� �������
    MBADDR      NVARCHAR2(100),             -- ȸ�� �ּ�
    MBPHONE     NVARCHAR2(15),              -- ȸ�� ����ó
    MBEMAIL     NVARCHAR2(50)               -- ȸ�� �̸���
);

-- ��ȭ ���� ���̺�

CREATE TABLE MINFO(
    MINAME      NVARCHAR2(100) PRIMARY KEY, -- ��ȭ�̸�
    MIGENRE1    NVARCHAR2(10),             -- ��ȭ �帣
    MIGENRE2    NVARCHAR2(10),             -- ��ȭ �帣
    MIGENRE3    NVARCHAR2(10),             -- ��ȭ �帣
    MIDIRECTER  NVARCHAR2(20),             -- ��ȭ ����
    MIACTOR     NVARCHAR2(200),             -- ��ȭ ���
    MISYNOPSIS  NVARCHAR2(500),            -- ��ȭ �ٰŸ�
    MIAGE       NVARCHAR2(10),             -- ���� ���
    MIRUNTIME   NVARCHAR2(5),              -- �� �ð�
    MIPOSTER    NVARCHAR2(100),            -- ��ȭ ������
    MIRELEASE   NVARCHAR2(20),             -- ��ȭ ������
    MITEASER    NVARCHAR2(100),            -- ��ȭ ������
    MISTILLCUT1 NVARCHAR2(100),            -- ��ȭ ��ƿ��1
    MISTILLCUT2 NVARCHAR2(100),            -- ��ȭ ��ƿ��2
    MISTILLCUT3 NVARCHAR2(100),            -- ��ȭ ��ƿ��3
    MISTILLCUT4 NVARCHAR2(100),            -- ��ȭ ��ƿ��4
    MISTILLCUT5 NVARCHAR2(100),            -- ��ȭ ��ƿ��5
    MISTILLCUT6 NVARCHAR2(100)             -- ��ȭ ��ƿ��6
);



-- �󿵰� ���̺�

CREATE TABLE MTHEATER(
    MTTHEATER       NVARCHAR2(10) PRIMARY KEY,      -- �󿵰�
    MTKIND          NVARCHAR2(10),                  -- �󿵰� ����
    MTSEATS         NUMBER,                         -- �¼���
    MTCOMMON        NUMBER,                         -- ���� ����
    MTCHILD         NUMBER                          -- ��� ����
);

-- ��ȭ ������ ���̺�
CREATE TABLE MSCHEDULE(
    MSNUMBER    NUMBER PRIMARY KEY,        -- �������ȣ
    MSNAME      NVARCHAR2(100) CONSTRAINT MINA_MSNA_FK REFERENCES MINFO(MINAME),    -- ��ȭ ����
    MSSTARTTIME NVARCHAR2(30),              -- ���� �ð�
    MSENDTIME   NVARCHAR2(30),              -- ���� �ð�
    MSDATE      NVARCHAR2(30),                       -- ����
    MSTHEATER   NVARCHAR2(10) CONSTRAINT MTTH_MSTH_FK REFERENCES MTHEATER(MTTHEATER)  -- �󿵰�
);



-- ���� ���̺�

CREATE TABLE MREVIEW(
    MRNAME      NVARCHAR2(100) CONSTRAINT MINA_MRNA_FK REFERENCES MINFO(MINAME), -- ��ȭ ����
    MRREVIEW    NVARCHAR2(200),                                                 -- ��ȭ ����
    MRID        NVARCHAR2(20) CONSTRAINT MBID_MRID_FK REFERENCES MMEMBER(MBID), -- �ۼ���
    MRDATE      DATE
);


-- ��� ���̺�

DROP TABLE MTICKETING;
CREATE TABLE MTICKETING(
    MTNUMBER        NUMBER,             -- ���� ��ȣ
    MTSNUMBER       NUMBER CONSTRAINT MSNU_MTSN_FK REFERENCES MSCHEDULE(MSNUMBER),  -- ������ ��ȣ
    MTNAME          NVARCHAR2(100) CONSTRAINT MINA_MTNA_FK REFERENCES MINFO(MINAME),  -- ��ȭ ����
    MTSEAT          NVARCHAR2(30),             -- �¼�
    MTCOUNT         NUMBER,                    -- �ο� ��
    MTPRICE         NUMBER,                    -- �� ����
    MTPAYMENT       NVARCHAR2(10),             -- ���� ����
    MTID            NVARCHAR2(20)  CONSTRAINT MBID_MTID_FK REFERENCES MMEMBER(MBID) -- ȸ�� ���̵�
);

-- ������ ��ȣ ������
CREATE SEQUENCE SCHEDULE_SEQ START WITH 1 INCREMENT BY 1;

-- ������ �Խ��� ���̺�
CREATE TABLE MBOARD (
        BDNUM                    NUMBER      PRIMARY KEY,
        BDWRITER             NVARCHAR2 (20),
        BDTITLE                 NVARCHAR2 (50),
        BDCONTENT          NVARCHAR2 (1000),
        BDDATE                  DATE,
        CONSTRAINT FK_MBID FOREIGN KEY (BDWRITER) REFERENCES  MMEMBER (MBID)
);

 -- MBOARD_SEQ ������ ����
CREATE SEQUENCE MBOARD_SEQ START WITH 1 INCREMENT BY 1;
 
 -- MVBLIST �� ����
 CREATE VIEW MVBLIST AS 
 SELECT
            ROW_NUMBER() OVER(ORDER BY BDNUM DESC) AS RN,
            MBOARD.*
FROM MBOARD;

-- ���(COMMENT) ���̺� �����
CREATE TABLE COSCOMMENT (
        CMNUM                    NUMBER PRIMARY KEY,
        CMBNUM                 NUMBER,
        CMWRITER             NVARCHAR2(20),
        CMCONTENT          NVARCHAR2(200),   
        CMDATE                  DATE,
        
        CONSTRAINT FK_MBID_CMWRITER FOREIGN KEY (CMWRITER) REFERENCES  MMEMBER (MBID),
        CONSTRAINT FK_MBID_CMBNUM FOREIGN KEY (CMBNUM) REFERENCES  MBOARD (BDNUM)
);

 -- ��۹�ȣ CMNUM�� ���� ������ ����
CREATE SEQUENCE CMNUM_SEQ START WITH 1 INCREMENT BY 1;

-- ���� ��--
CREATE VIEW ADTICKETING AS SELECT ROW_NUMBER() OVER(ORDER BY MTNUMBER DESC) AS RN, a.*,b.* FROM MTICKETING a, MSCHEDULE b WHERE a.MTSNUMBER = b.MSNUMBER;

commit;