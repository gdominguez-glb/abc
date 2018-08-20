SamlIdp.configure do |config|
  base = "http://#{ENV['DOMAIN']}"

  config.x509_certificate = <<-CERT
-----BEGIN CERTIFICATE-----
MIIDXDCCAkQCCQCl4Tk2YHKSrzANBgkqhkiG9w0BAQsFADBwMQswCQYDVQQGEwJV
UzEdMBsGA1UECAwURGlzdHJpY3Qgb2YgQ29sdW1iaWExEzARBgNVBAcMCldhc2hp
bmd0b24xFDASBgNVBAoMC0dyZWF0IE1pbmRzMRcwFQYDVQQDDA5ncmVhdG1pbmRz
Lm9yZzAeFw0xODA4MjAwMTA1MDFaFw0yODA4MTcwMTA1MDFaMHAxCzAJBgNVBAYT
AlVTMR0wGwYDVQQIDBREaXN0cmljdCBvZiBDb2x1bWJpYTETMBEGA1UEBwwKV2Fz
aGluZ3RvbjEUMBIGA1UECgwLR3JlYXQgTWluZHMxFzAVBgNVBAMMDmdyZWF0bWlu
ZHMub3JnMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7XwPEmKMnIK5
EIbun4gQerz3DZEtdJh/HJnBCbabElEaISKUpse6BJtzYhl70bJhjGOfAZAmecXb
ATU8iE0NkgOTX5E8uN2AoMJFlF86W/UFLN3NrpOeyeJMh/lDUqFLyKM2PE9DjzyN
Jb7VBIsHV++55hLc7VRfAMzsarHB8VdE21AC2VQZ3KZKHdI54PZoXNvgmP2Rn2IH
51cE8fUwR3aVRseWG5PveAE46xvmK4m1vTeFdOltXoAnjdW5wVJeqpX/KL3Wkq4b
mf9sjltTEiIEUWI07WsgYfubmnEtvl9xojCfKKG2rk/vAph75y3KQaw2WzGeYUAx
63RgieyQXQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQA6NP2K76pNkgWbDWGChxzR
L4vedsHZBw5fK1Gys/5dQD7JEMQ9jOY6gxYbH3BOffIlqsBbdZ+9m2P5XiyIP3Mf
17ugpY3pgRmLW7GrO3VfJuO0ya5diyAY1Ec/8KCR/Pp/GNkccKMxvRsHKuVBvVTJ
1t+PYfg1hnLJpF8avR84Eo2MsXM4qazMtIE7Go+ZDsSfggJT2NJ9p2/HI2LoYnPl
4kALNdV4b/VhHt40xqivsvVS4BZfbVlQK7CKAT9SQ3vytc+a0r/C8wwevoJIKziV
oPWMWfNNwEHSnRKhKMzJdWbXA/n9t3MK46hilaE0ybkSkfIz7knEkZDh/VGFeKY6
-----END CERTIFICATE-----
  CERT
  config.secret_key = ENV["SAML_SECRET_KEY"]

  config.organization_name = "Greatminds"
  config.organization_url = "https://greatminds.org"

  config.name_id.formats = {
    email_address: -> (principal) { principal.email },
    transient: -> (principal) { principal.id },
    persistent: -> (p) { p.id },
  }

end
