## CoinbaseProExchange

[![Build status (Github Actions)](https://github.com/vnegi10/CoinbaseProExchange.jl/workflows/CI/badge.svg)](https://github.com/vnegi10/CoinbaseProExchange.jl/actions)

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://vnegi10.github.io/CoinbaseProExchange.jl/stable)

This package provides an unofficial Julia wrapper for the Coinbase Pro REST API. I am in no way affiliated with Coinbase, so use it at your own risk.

**Disclaimer: This package is intended to be used as a tool for automated trading, and fetching historical price information from Coinbase Pro. You are free to use it as you wish. However, remember that cryptocurrency markets are highly volatile and you are likely to lose your investment. Please understand the risks and do your own research before you decide to trade in any of the available cryptocurrencies.**

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

## Examples

Examples of available functions along with expected output are shown below. Detailed usage information can also be obtained via REPL help:
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

```julia
julia> show_all_products("EUR")

40-element Vector{String}:
 "ETC-EUR"
 "SNX-EUR"
 "NMR-EUR"
 "SOL-EUR"
 "SKL-EUR"
 "NU-EUR"
 "XTZ-EUR"
 "UMA-EUR"
```

```julia
julia> show_latest_trades("ETH-EUR")

1000×5 DataFrame
  Row │ time                      price    side    size        trade_id 
      │ Any                       Float64  String  Float64     Int64    
──────┼─────────────────────────────────────────────────────────────────
    1 │ 2021-07-06T22:23:54.963Z  1949.03  sell    0.101       22822595
    2 │ 2021-07-06T22:23:53.612Z  1948.85  sell    0.0187214   22822594
    3 │ 2021-07-06T22:23:42.616Z  1948.83  sell    0.0018276   22822593
    4 │ 2021-07-06T22:23:32.605Z  1949.17  sell    0.00285893  22822592
    5 │ 2021-07-06T22:23:32.605Z  1949.07  sell    0.006588    22822591
    6 │ 2021-07-06T22:23:29.299Z  1948.8   sell    0.0540009   22822590
```

```julia
julia> show_product_data("BTC-EUR", "24hr stats")

1×6 DataFrame
 Row │ high      last      low       open      volume         volume_30day   
     │ String    String    String    String    String         String         
─────┼───────────────────────────────────────────────────────────────────────
   1 │ 29620.29  28740.89  28362.27  28642.14  1058.30490447  57346.67861744
```

### Private endpoints (Coinbase Pro account + API keys are needed)

Obtain your API key, API secret and passphrase from your Coinbase Pro account. Create a user_data type as shown below:

```julia
user_data = UserInfo("YOUR_API_KEY", "YOUR_SECRET", "YOUR_PASSPHRASE")
```

```julia
julia> show_all_accounts(user_data, ["LTC", "XTZ"])

2×7 DataFrame
 Row │ currency  balance  profile_id                         trading_enabled  id                                 hold  ⋯
     │ String    Float64  String                             Bool             String                             Float ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ LTC           0.0  4617f329-2709-453b-b95d-d14727cb…             true  eed5095d-848e-490c-8738-2f2073e7…      0 ⋯
   2 │ XTZ           0.0  4617f329-2709-453b-b95d-d14727cb…             true  21f6c731-91f7-44bf-ad9e-97cc2dfb…      0
```

```julia
julia> show_account_info(user_data, "ETH", "history")

2×8 DataFrame
 Row │ amount               balance             created_at                   order_id                           produc ⋯
     │ String               String              String                       String                             String ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ -0.0248430100000000  0.0000000000000000  2021-05-09T00:56:06.877638Z  561bd042-9bd8-412f-a905-2a231e77…  ETH-EU ⋯
   2 │ 0.0248430100000000   0.0248430100000000  2021-05-08T23:52:37.666196Z  496f1b74-5a66-45dd-9f6e-817da994…  ETH-EU
                                                                                                       4 columns omitted
```

```julia
julia> show_open_orders(user_data)

1×15 DataFrame
 Row │ created_at                   executed_value      fill_fees           filled_size  id                            ⋯
     │ String                       String              String              String       String                        ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 2021-07-04T22:15:03.793256Z  0.0000000000000000  0.0000000000000000  0.00000000   5591e17e-5f79-41f0-93d5-b455e ⋯
                                                                                                      11 columns omitted
```

```julia
julia> show_single_order("14c0db51-ca17-4a8d-9d2c-aa633e703358", user_data)

1×15 DataFrame
 Row │ created_at                 executed_value      fill_fees           filled_size  id                              ⋯
     │ String                     String              String              String       String                          ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 2021-07-04T23:11:02.0001Z  0.0000000000000000  0.0000000000000000  0.00000000   14c0db51-ca17-4a8d-9d2c-aa633e7 ⋯
                                                                                                      11 columns omitted
```

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

```julia
julia> cancel_order("5591e17e-5f79-41f0-93d5-b455ec552ecc", user_data)

"5591e17e-5f79-41f0-93d5-b455ec552ecc"
```

```julia
julia> cancel_all_orders(user_data)

1-element Vector{Any}:
 "35fa8e19-f204-40c0-b995-eb2e4e168e01"
```

```julia
julia> show_exchange_limits(user_data, "ETH")

5×4 DataFrame
 Row │ payment_method     max         period_in_days  remaining  
     │ String             Float64     Int64           Float64    
─────┼───────────────────────────────────────────────────────────
   1 │ ideal_deposit       14.6423                 1   14.6423
   2 │ exchange_withdraw  146.423                  1  146.423
   3 │ secure3d_buy         1.75707                7    1.75707
   4 │ credit_debit_card    0.585691               7    0.585691
   5 │ paypal_withdrawal   11.7138                 1   11.7138
```

```julia
julia> show_fills(user_data, "ETH-EUR")

7×13 DataFrame
 Row │ created_at                fee                 liquidity  order_id                           price   ⋯
     │ String                    String              String     String                             String  ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 2021-07-04T21:54:09.902Z  0.0746268391200000  T          d275ae2b-4f34-4ce9-98a7-1147bccf…  2003.90 ⋯
   2 │ 2021-07-04T15:43:54.115Z  0.0733968750000000  T          7a019bf8-bee8-4001-bb34-e3d6f3e6…  1957.25
   3 │ 2021-07-04T15:42:35.808Z  0.0597014279730000  T          2a8814f1-76d3-4fa2-bb0a-6f25e050…  1956.42
   4 │ 2021-07-04T15:28:06.005Z  0.0599999776075000  T          9971744a-d308-4481-950d-e2ada197…  1953.35
```











