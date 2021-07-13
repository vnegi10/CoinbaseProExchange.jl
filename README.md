## CoinbaseProExchange

[![Build status (Github Actions)](https://github.com/vnegi10/CoinbaseProExchange.jl/workflows/CI/badge.svg)](https://github.com/vnegi10/CoinbaseProExchange.jl/actions)

This package provides an unofficial Julia wrapper for the Coinbase Pro REST API. I am in no way affiliated with Coinbase, so use it at your own risk.

**Disclaimer: This package is intended to be used ONLY for hobby projects related to automated trading, building bots and fetching historical data from Coinbase Pro. As with any piece of code, there is a possibility of undiscovered bugs. It goes without saying that you should avoid making large investments with this tool. There are professional platforms/services available for doing that.**

**Remember that cryptocurrency markets are highly volatile and you are likely to lose your investment. Please understand the risks and do your own research before you decide to trade in any of the available cryptocurrencies.**

## How to install?

* Press ']' to enter Pkg prompt
* add CoinbaseProExchange

## Coinbase Pro account

Public endpoints can be accessed without a Coinbase Pro account.

In order to use the private endpoints, you will need to register and create an account on [Coinbase](https://www.coinbase.com/). Please note that Coinbase Pro account is separate froom Coinbase, but they use the same login credentials. More information about the API can be found [here](https://docs.pro.coinbase.com/#api)

## API key permissions

You can restrict the functionality of API keys. Before creating the key, you must choose what permissions you would like the key to have. The permissions are:

* View - Allows a key read permissions. This includes all GET endpoints.
* Transfer - Allows a key to transfer currency on behalf of an account, including deposits and   withdraws. Enable with caution - API key transfers WILL BYPASS two-factor authentication.
* Trade - Allows a key to enter orders, as well as retrieve trade data. This includes POST /orders and several GET endpoints.

## Help

Some examples of available functions along with the expected output are shown below. Detailed usage information can also be obtained via REPL help:
* Press '?' to enter the help mode
* Type function name and press enter

### Available functions

show_historical_data, show_server_time, show_all_products, show_latest_trades, show_product_data, show_all_accounts, show_account_info, place_market_order, place_limit_order, show_open_orders, show_single_order, show_exchange_limits, show_fills, cancel_order, cancel_all_orders

### Public endpoints (Coinbase account is not necessary)

```julia
julia> show_server_time("iso")

"2021-07-06T22:09:17.231Z"
```

```julia
julia> show_historical_data("ETH-EUR", 3600)

300×6 DataFrame
 Row │ time                 low      high     open     close    volume  
     │ Any                  Any      Any      Any      Any      Any     
─────┼──────────────────────────────────────────────────────────────────
   1 │ 2021-06-24T11:00:00  1619.45  1650.91  1619.45  1648.84  407.623
   2 │ 2021-06-24T12:00:00  1644.02  1665.64  1648.05  1655.5   446.389
   3 │ 2021-06-24T13:00:00  1640.57  1658.99  1656.58  1651.13  295.881
   4 │ 2021-06-24T14:00:00  1639.84  1652.13  1652.13  1649.94  240.949
   5 │ 2021-06-24T15:00:00  1646.88  1692.83  1650.94  1666.79  1250.91
   6 │ 2021-06-24T16:00:00  1657.07  1694.52  1665.94  1693.9   659.553
```

**Check docs for more examples:** [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://vnegi10.github.io/CoinbaseProExchange.jl/stable)

### Private endpoints (Coinbase Pro account + API keys are needed)

Obtain your API key, API secret and passphrase from your Coinbase Pro account. Create an object **user_data** with type **UserInfo** to store your API data, as shown below:

```julia
julia> user_data = UserInfo("YOUR_API_KEY", "YOUR_SECRET", "YOUR_PASSPHRASE")
```

**Use with caution! Market orders are almost always filled immediately.**

```julia
julia> place_market_order("buy", "ETH-EUR", 15, "quote", user_data)

[ Info: Order placed
Dict{String, Any} with 14 entries:
  "created_at"      => "2021-07-04T21:54:09.895868Z"
  "stp"             => "dc"
  "product_id"      => "ETH-EUR"
  "settled"         => false
  "specified_funds" => "15"
  "status"          => "pending"
  "id"              => "d275ae2b-4f34-4ce9-98a7-1147bccf07ca"
  "executed_value"  => "0"
  "post_only"       => false
  "filled_size"     => "0"
  "side"            => "buy"
  "fill_fees"       => "0"
  "funds"           => "14.92537313"
  "type"            => "market"
```

```julia
julia> place_limit_order("sell", "BTC-EUR", 0.0005, 30000, user_data)

[ Info: Order placed
Dict{String, Any} with 15 entries:
  "created_at"     => "2021-07-04T21:59:11.083132Z"
  "price"          => "30000"
  "stp"            => "dc"
  "product_id"     => "BTC-EUR"
  "settled"        => false
  "status"         => "pending"
  "id"             => "cae9158e-1660-448e-bd9a-d368ce3fdc8a"
  "executed_value" => "0"
  "post_only"      => false
  "size"           => "0.0005"
  "filled_size"    => "0"
  "side"           => "sell"
  "time_in_force"  => "GTC"
  "fill_fees"      => "0"
  "type"           => "limit"
```

**Check docs for more examples:** [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://vnegi10.github.io/CoinbaseProExchange.jl/stable)













