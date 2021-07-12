using Test, DataFrames, JSON, CoinbaseProExchange

# Test cases for accessing market data

@testset "Check if market data is accessible" begin

time = show_server_time("epoch")
@test typeof(time) == Float64

df_history = show_historical_data("BTC-EUR", 3600)
@test isa(df_history, DataFrame)

all_products = show_all_products("EUR")
@test isa(all_products, Vector{String})

df_trades = show_latest_trades("BTC-EUR")
@test isa(df_trades, DataFrame)

df_24hr_stats = show_product_data("BTC-EUR", "24hr stats")
@test isa(df_24hr_stats, DataFrame)

df_order_book2 = show_product_data("BTC-EUR", "order book 2")
@test isa(df_order_book2, DataFrame)

end


#= Test cases for accessing private data, which needs user API information. Hence, this set 
   is run only locally. =#

#= @testset "Check if private data is accessible" begin

input_params = JSON.parsefile("/home/vikas/Documents/Input_JSON/VNEG_user_data.json")
user_data = UserInfo(input_params["api_key"], input_params["api_secret"], input_params["api_passphrase"])

df_all_accounts = show_all_accounts(user_data, ["ETH", "BTC", "LTC"])
@test isa(df_all_accounts, DataFrame)

df_account_info = show_account_info(user_data, "ETH", "info")
@test isa(df_account_info, DataFrame)

df_account_history = show_account_info(user_data, "ETH", "history")
@test isa(df_account_history, DataFrame)

df_limits = show_exchange_limits(user_data, "ETH")
@test isa(df_limits, DataFrame)

df_fills = show_fills(user_data, "ETH-EUR")
@test isa(df_fills, DataFrame)

end =#



