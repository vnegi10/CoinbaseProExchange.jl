# User Guide
---

## Overview
CoinbaseProExchange.jl provides a Julia wrapper for the Coinbase Pro REST API. Available endpoints are implemented in the form of callable functions. Depending on the operation, a function can return data (either as a DataFrame or Dict) or the associated HTTP response (Dict).

## Available functions
```@index
```

## Public endpoints (Coinbase Pro account is not necessary)
```@docs
show_server_time(time_type::String="iso")

show_historical_data(pair::String, interval::Int64=300)

show_all_products(currency::String="USD")

show_latest_trades(pair::String)

show_product_data(pair::String, endpoint::String="24hr stats")
```

## Private endpoints (Coinbase Pro account + API keys are needed)

### API key should have "trade" or "view" permission 
```@docs
show_all_accounts(user_data::UserInfo, currencies::Vector{String})

show_account_info(user_data::UserInfo, currency::String, info_type::String)

show_exchange_limits(user_data::UserInfo, currency::String)

show_fills(user_data::UserInfo, pair::String)

show_transfers(user_data::UserInfo, transfer_type::String="deposit")

show_fees(user_data::UserInfo)

show_profiles(user_data::UserInfo)
```

### API key should have "trade" permission
```@docs
place_market_order(side::String, pair::String, amount::IntOrFloat, amount_type::String, user_data::UserInfo)

place_limit_order(side::String, pair::String, amount::IntOrFloat, price::IntOrFloat, user_data::UserInfo)

show_open_orders(user_data::UserInfo)

show_single_order(order_ID::String, user_data::UserInfo)

cancel_order(order_id::String, user_data::UserInfo)

cancel_all_orders(user_data::UserInfo)
```








