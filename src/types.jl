mutable struct CoinbaseProAuth
    end_point::String
    api_key::String
    secret_key::String
    passphrase::String
    method::String
    body::String
end

mutable struct UserInfo
    api_key::String
    secret_key::String
    passphrase::String
end

IntOrFloat = Union{Int64, Float64}