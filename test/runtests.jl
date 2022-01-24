using Test, DataFrames, JSON, CoinbaseProExchange

# Test cases for accessing market data

@testset "Check if market data is accessible" begin

time = show_server_time("epoch")
@test typeof(time) == Float64

df_history = show_historical_data("BTC-EUR", 3600)
@test ~isempty(df_history)

all_products = show_all_products("EUR")
@test ~isempty(all_products)

df_trades = show_latest_trades("BTC-EUR")
@test ~isempty(df_trades)

df_24hr_stats = show_product_data("BTC-EUR", "24hr stats")
@test ~isempty(df_24hr_stats)

df_order_book2 = show_product_data("BTC-EUR", "order book 1")
@test ~isempty(df_order_book2)

end

#= Test cases for accessing private data, which needs user API information. Hence, this set 
   is run only locally. =#

@testset "Check if private data is accessible" begin

input_params = JSON.parsefile("/home/vikas/Documents/Input_JSON/VNEG_user_data_default_view.json")
user_data = UserInfo(input_params["api_key"], input_params["api_secret"], input_params["api_passphrase"])

df_all_accounts = show_all_accounts(user_data, ["ETH", "BTC", "LTC"])
@test ~isempty(df_all_accounts)

df_account_info = show_account_info(user_data, "ETH", "info")
@test ~isempty(df_account_info)

# TODO
# df_account_history = show_account_info(user_data, "ETH", "history")
# @test isa(df_account_history, DataFrame)

df_limits = show_exchange_limits(user_data, "ETH")
@test ~isempty(df_limits)

df_fills = show_fills(user_data, "ETH-EUR")
@test ~isempty(df_fills)

df_deposit = show_transfers(user_data, "deposit")
@test ~isempty(df_deposit)

df_withdraw = show_transfers(user_data, "withdraw")
@test ~isempty(df_withdraw)

df_fees = show_fees(user_data::UserInfo)
@test ~isempty(df_fees)

df_profiles = show_profiles(user_data::UserInfo)
@test ~isempty(df_profiles)

end 