class Cypher
  def self.encrypt(text)
    text = text.to_s unless text.is_a? String

    crypt = ActiveSupport::MessageEncryptor.new secret_key
    crypt.encrypt_and_sign text
  end

  def self.decrypt(text)
    crypt = ActiveSupport::MessageEncryptor.new secret_key
    crypt.decrypt_and_verify text
  end

  def self.secret_key
    Rails.application.secrets.secret_key_base[0..31]
  end
end
