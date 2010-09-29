-- Register Portal for Application
INSERT INTO T_SECURITY_APPLICATIONS
(
  PORTAL
, DESCRIPTION
, SUMMARY
, PARENT_PORTAL
, KEY
)
VALUES
(
  'ClearCATS'
, 'ClearCATS'
, null
, null
, null
)

-- Create Security Groups for Application
INSERT INTO T_SECURITY_GROUPS
(
  GROUP_NAME
, GROUP_DESCRIPTION
, PORTAL
, SUMMARY
)
VALUES
(
  'Admin'
, 'Administrator'
, 'ClearCATS'
, null
)

INSERT INTO T_SECURITY_GROUPS
(
  GROUP_NAME
, GROUP_DESCRIPTION
, PORTAL
, SUMMARY
)
VALUES
(
  'Faculty'
, 'Faculty Member'
, 'ClearCATS'
, null
)

INSERT INTO T_SECURITY_GROUPS
(
  GROUP_NAME
, GROUP_DESCRIPTION
, PORTAL
, SUMMARY
)
VALUES
(
  'User'
, 'ClearCATS User'
, 'ClearCATS'
, null
)