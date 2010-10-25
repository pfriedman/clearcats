
-- add logins for portal

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
  'pfr957'
, 'ClearCATS'
, null
, null
, 'pfr957'
, '165.124.223.127'
, sysdate
)

-- skk958, aco454

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
  'mns521'
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
  'cmix'
, 'ClearCATS'
, null
, null
, 'pfr957'
, '165.124.223.127'
, sysdate
)

-- assign personnel to groups -- ensure affiliate_id matches that in institutional affiliates

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
, 'pfr957'
, 'Admin'
, 555 --- (SELECT AFFILIATE_ID FROM T_INSTITUTIONAL_AFFILIATES WHERE NAME_ABBREV = 'NUCATS') 
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
, 'cmix'
, 'Admin'
, 555 
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
, 'mns521'
, 'Admin'
, 5002
, 'ClearCATS'
, 'pfr957'
, '165.124.223.127'
,  sysdate
);