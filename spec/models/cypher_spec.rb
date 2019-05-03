require 'rails_helper'

RSpec.describe Cypher, type: :model do
  describe '#encrypt' do
    it 'Encrypts the text' do
      text = Cypher.encrypt 'encrypted text'

      expect(text).not_to be_empty
    end
  end

  describe '#decrypt' do
    it 'decrypt the text' do
      text = Cypher.encrypt 'encrypted text'

      expect(Cypher.decrypt text).to eq 'encrypted text'
    end

    it 'raise exception decrypting wrong text' do
      expect { Cypher.decrypt 'invalid text' }.to raise_error ActiveSupport::MessageVerifier::InvalidSignature
    end
  end
end
