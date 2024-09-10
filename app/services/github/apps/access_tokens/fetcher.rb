# INFO: Read more here
# https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-json-web-token-jwt-for-a-github-app#example-using-ruby-to-generate-a-jwt
module Github
  module Apps
    module AccessTokens
      class Fetcher
        CACHE_KEY_PREFIX = 'github_app_installation_access_tokens'.freeze

        def initialize(client_id: , private_key:, installation_id:)
          @client_id = client_id
          @private_key = private_key
          @installation_id = installation_id
        end

        def perform
          token = read_from_cache

          return token if token

          access_token = create_access_token
          save_to_cache(access_token)
          access_token[:token]
        end

        private

        def read_from_cache
          ::Rails.cache.read(cache_key)
        end

        def save_to_cache(access_token)
          Rails.cache.write(
            cache_key,
            access_token[:token],
            expires_at: access_token[:expires_at]
          )
        end

        def jwt_payload
          {
            # issued at time, 60 seconds in the past to allow for clock drift
            iat: Time.now.to_i - 60,
            # JWT expiration time (10 minute maximum)
            exp: Time.now.to_i + (10 * 60),
            # GitHub App's client ID
            iss: @client_id
          }
        end

        def jwt_token
          JWT.encode(jwt_payload, @private_key, 'RS256')
        end

        def octokit_client
          Octokit::Client.new(bearer_token: jwt_token)
        end

        def create_access_token
          octokit_client.create_app_installation_access_token(@installation_id)
        end

        def cache_key
          [CACHE_KEY_PREFIX, @client_id, @installation_id].join(':')
        end
      end
    end
  end
end