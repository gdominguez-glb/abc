Aws::CF::Signer.configure do |config|
  config.key_path = Rails.root.join('config/pk-APKAJHJV4Q37CWDLBWFA.pem.txt')
  # or config.key = ENV.fetch('PRIVATE_KEY')
  config.key_pair_id  = 'APKAJHJV4Q37CWDLBWFA'
  config.default_expires = 3600
end
