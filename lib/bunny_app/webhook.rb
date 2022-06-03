require 'openssl'
require 'base64'

module BunnyApp
  class Webhook
    def self.verify(signature, payload, signing_key)
      digest = OpenSSL::Digest.new('sha1')
      hash = OpenSSL::HMAC.hexdigest(digest, signing_key, payload)

      OpenSSL.secure_compare(hash, signature)
    end
  end
end
