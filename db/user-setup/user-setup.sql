
SELECT * FROM T_SECURITY_LOGINS WHERE PORTAL = 'ClearCATS'
SELECT * FROM T_SECURITY_GROUP_MEMBERS WHERE PORTAL = 'ClearCATS'

-- add logins for portal

INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'pfr957', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )


INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'mns521', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )


INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'cmix', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )


INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'wakibbe', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )


INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'aco454', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )

---

INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'skk958', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )

INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'jab155', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )

INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'hjf799', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )

INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'ltr435', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )

INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'bfs326', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )

INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'tha209', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )

INSERT INTO T_SECURITY_LOGINS
( USERNAME, PORTAL, CHALLENGE, EXPIRE_ON, ENTERED_BY, ENTERED_IP, ENTERED_DATE )
VALUES
( 'pcm777', 'ClearCATS', null, null, 'pfr957', '165.124.223.127', sysdate )

---
-- assign personnel to groups -- ensure affiliate_id matches that in institutional affiliates
---

INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'pfr957', 'Admin', 555, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'cmix', 'Admin', 555, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'mns521', 'Admin', 5002, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'wakibbe', 'Admin', 5001, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'aco454', 'Admin', 5001, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );

-- 10/25

INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'jab155', 'Admin', 5006, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'hjf799', 'Admin', 5008, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'ltr435', 'Admin', 5008, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'bfs326', 'Admin', 5004, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'tha209', 'Admin', 5004, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );


INSERT INTO T_SECURITY_GROUP_MEMBERS
( SGM_ID, USERNAME, GROUP_NAME, AFFILIATE_ID, PORTAL, entered_by, entered_ip, entered_date )
VALUES
( SGM_ID_SEQ.nextval, 'pcm777', 'Admin', 5005, 'ClearCATS', 'pfr957', '165.124.223.127', sysdate );

-- select * from T_INSTITUTIONAL_AFFILIATES where parent_id = 555
-- select * from t_security_group_members where portal = 'ClearCATS'
-- select * from t_security_logins where portal = 'ClearCATS'
