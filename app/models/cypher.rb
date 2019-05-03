class Cypher
  def self.encrypt(text)
    text = text.to_s unless text.is_a? String

    crypt = ActiveSupport::MessageEncryptor.new Rails.application.secrets.secret_key_base
    crypt.encrypt_and_sign text
  end

  def self.decrypt(text)
    crypt = ActiveSupport::MessageEncryptor.new Rails.application.secrets.secret_key_base
    crypt.decrypt_and_verify text
  end
end
