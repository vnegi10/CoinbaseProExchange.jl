# CoinbaseProExchange.jl
---

### Available functions

#### Public endpoints (Coinbase account is not necessary)

```@docs
show_server_time(time_type::String)

show_historical_data(pair::String, interval::Int64)

show_all_products(currency::String)

show_latest_trades(pair::String)

show_product_data(pair::String, endpoint::String)
```

#### Private endpoints (Coinbase Pro account + API keys are needed)

```@docs
show_all_accounts(user_data::UserInfo, currencies::Vector{String})

show_account_info(user_data::UserInfo, currency::String, info_type::String)

show_open_orders(user_data::UserInfo)

show_single_order(order_ID::String, user_data::UserInfo)

cancel_order(order_id::String, user_data::UserInfo)

cancel_all_orders(user_data::UserInfo)

show_exchange_limits(user_data::UserInfo, currency::String)
```






