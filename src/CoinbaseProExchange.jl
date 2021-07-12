module CoinbaseProExchange

export show_historical_data, show_server_time, show_all_products, 
       show_latest_trades, show_product_data, show_all_accounts,
       show_account_info, place_market_order, place_limit_order,
       show_open_orders, show_single_order, show_exchange_limits,
       cancel_order, cancel_all_orders, UserInfo

using DataFrames, HTTP, JSON, CSV, Dates, Statistics, Query, Base64, Nettle

const URL = "https://api.pro.coinbase.com"
const GRANULARITY = [60, 300, 900, 3600, 21600, 86400]
const ENDPOINTS = ["24hr stats", "product info", "product ticker", 
                   "order book 1", "order book 2", "order book 3"]

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

include("GetDataFunctions.jl")
include("ShowDataFunctions.jl")
include("AuthenticationFunctions.jl")
include("OrderFunctions.jl")








end # module
