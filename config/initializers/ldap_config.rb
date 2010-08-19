require 'net/ldap'

LDAP_CONFIG = YAML.load_file("#{Rails.root}/config/ldap_config.yml")[Rails.env]