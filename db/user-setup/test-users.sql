-- Add personnel if necessary
INSERT INTO T_PERSONNEL
(
  PERSONNEL_ID
, USERNAME
, LAST_NAME
, FIRST_NAME
, entered_by
, entered_ip
, entered_date
)
VALUES
(
  PERSONNEL_ID_SEQ.nextval
, 'cc_admin'
, 'Administrator'
, 'CC'
, 'pfr957'
, '165.124.223.127'
, sysdate
)

update T_PERSONNEL
set password = encrypt_password('cc_admin')
where username = 'cc_admin'


INSERT INTO T_PERSONNEL
(
  PERSONNEL_ID
, USERNAME
, LAST_NAME
, FIRST_NAME
, entered_by
, entered_ip
, entered_date
)
VALUES
(
  PERSONNEL_ID_SEQ.nextval
, 'cc_user'
, 'User'
, 'CC'
, 'pfr957'
, '165.124.223.127'
, sysdate
)

update T_PERSONNEL
set password = encrypt_password('cc_user')
where username = 'cc_user'


-- Add into logins for portal

SELECT * FROM T_SECURITY_LOGINS WHERE PORTAL = 'ClearCATS'

INSERT INTO T_SECURITY_LOGINS
(
  USERNAME
, PORTAL
, CHALLENGE
, EXPIRE_ON
, ENTERED_BY
, ENTERED_IP
, ENTERED_DATE
)
VALUES
(
  'cc_admin'
, 'ClearCATS'
, null
, null
, 'pfr957'
, '165.124.223.127'
, sysdate
)

INSERT INTO T_SECURITY_LOGINS
(
  USERNAME
, PORTAL
, CHALLENGE
, EXPIRE_ON
, ENTERED_BY
, ENTERED_IP
, ENTERED_DATE
)
VALUES
(
  'cc_user'
, 'ClearCATS'
, null
, null
, 'pfr957'
, '165.124.223.127'
, sysdate
)

-- Add users into groups for portal

SELECT * FROM T_SECURITY_GROUP_MEMBERS WHERE PORTAL = 'ClearCATS'

INSERT INTO T_SECURITY_GROUP_MEMBERS
(
  SGM_ID
, USERNAME
, GROUP_NAME
, AFFILIATE_ID
, PORTAL
, entered_by
, entered_ip
, entered_date
)
VALUES
(
  SGM_ID_SEQ.nextval
, 'cc_admin'
, 'Admin'
, (SELECT AFFILIATE_ID FROM T_INSTITUTIONAL_AFFILIATES WHERE NAME_ABBREV = 'NUCATS')
, 'ClearCATS'
, 'pfr957'
, '165.124.223.127'
,  sysdate
);

INSERT INTO T_SECURITY_GROUP_MEMBERS
(
  SGM_ID
, USERNAME
, GROUP_NAME
, AFFILIATE_ID
, PORTAL
, entered_by
, entered_ip
, entered_date
)
VALUES
(
  SGM_ID_SEQ.nextval
, 'cc_user'
, 'User'
, (SELECT AFFILIATE_ID FROM T_INSTITUTIONAL_AFFILIATES WHERE NAME_ABBREV = 'NUCATS')
, 'ClearCATS'
, 'pfr957'
, '165.124.223.127'
,  sysdate
);
