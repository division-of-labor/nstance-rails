if Rails.env.development? || Rails.env.test?
  Nstance.log.level = :debug
end

if ENV["DOCKER_HOST_CERT"]
  Docker.url = ENV["DOCKER_HOST"]
  Docker.options = {
    client_cert_data: Base64.decode64(ENV["DOCKER_HOST_CERT"]),
    client_key_data: Base64.decode64(ENV["DOCKER_HOST_KEY"]),
    ssl_verify_peer: false,
    scheme: "https"
  }
end
