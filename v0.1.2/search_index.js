var documenterSearchIndex = {"docs":
[{"location":"#CoinbaseProExchange.jl","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.jl","text":"","category":"section"},{"location":"","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.jl","text":"","category":"page"},{"location":"#Available-functions","page":"CoinbaseProExchange.jl","title":"Available functions","text":"","category":"section"},{"location":"#Public-endpoints-(Coinbase-account-is-not-necessary)","page":"CoinbaseProExchange.jl","title":"Public endpoints (Coinbase account is not necessary)","text":"","category":"section"},{"location":"","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.jl","text":"show_server_time(time_type::String)\n\nshow_historical_data(pair::String, interval::Int64)\n\nshow_all_products(currency::String)\n\nshow_latest_trades(pair::String)\n\nshow_product_data(pair::String, endpoint::String)","category":"page"},{"location":"#CoinbaseProExchange.show_server_time-Tuple{String}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_server_time","text":"show_server_time(time_type::String)\n\nGet the API server time.\n\nArguments\n\ntime_type::String : \"iso\" (default) or \"epoch\" (represents decimal seconds since Unix epoch)\n\nExample\n\njulia> show_server_time(\"iso\")\n\"2021-07-06T22:09:17.231Z\"\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_historical_data-Tuple{String, Int64}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_historical_data","text":"show_historical_data(pair::String, interval::Int64)\n\nFetch historic rates for a product.\n\nArguments\n\npair::String : Specify currency pair, for example \"ETH-EUR\" \ninterval::Int64 : Rates are returned in grouped buckets based on specified interval.                      Choose one from [60, 300 (default), 900, 3600, 21600, 86400], all in seconds.\n\nExample\n\njulia> show_historical_data(\"ETH-EUR\", 3600)\n300×6 DataFrame\n Row │ time                 low      high     open     close    volume  \n     │ Any                  Any      Any      Any      Any      Any     \n─────┼──────────────────────────────────────────────────────────────────\n   1 │ 2021-06-24T11:00:00  1619.45  1650.91  1619.45  1648.84  407.623\n   2 │ 2021-06-24T12:00:00  1644.02  1665.64  1648.05  1655.5   446.389\n   3 │ 2021-06-24T13:00:00  1640.57  1658.99  1656.58  1651.13  295.881\n   4 │ 2021-06-24T14:00:00  1639.84  1652.13  1652.13  1649.94  240.949\n   5 │ 2021-06-24T15:00:00  1646.88  1692.83  1650.94  1666.79  1250.91\n   6 │ 2021-06-24T16:00:00  1657.07  1694.52  1665.94  1693.9   659.553\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_all_products-Tuple{String}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_all_products","text":"show_all_products(currency::String)\n\nFetch list of all available products for a given currency.\n\nArguments\n\ncurrency::String : \"EUR\", \"USD\" (default), \"GBP\" etc.\n\nExample\n\njulia> show_all_products(\"EUR\")\n40-element Vector{String}:\n \"ETC-EUR\"\n \"SNX-EUR\"\n \"NMR-EUR\"\n \"SOL-EUR\"\n \"SKL-EUR\"\n \"NU-EUR\"\n \"XTZ-EUR\"\n \"UMA-EUR\"\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_latest_trades-Tuple{String}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_latest_trades","text":"show_latest_trades(pair::String)\n\nFetch list of latest trades for a given product.\n\nArguments\n\npair::String : Specify currency pair, for example \"ETH-EUR\" \n\nExample\n\njulia> show_latest_trades(\"ETH-EUR\")\n1000×5 DataFrame\n  Row │ time                      price    side    size        trade_id \n      │ Any                       Float64  String  Float64     Int64    \n──────┼─────────────────────────────────────────────────────────────────\n    1 │ 2021-07-06T22:23:54.963Z  1949.03  sell    0.101       22822595\n    2 │ 2021-07-06T22:23:53.612Z  1948.85  sell    0.0187214   22822594\n    3 │ 2021-07-06T22:23:42.616Z  1948.83  sell    0.0018276   22822593\n    4 │ 2021-07-06T22:23:32.605Z  1949.17  sell    0.00285893  22822592\n    5 │ 2021-07-06T22:23:32.605Z  1949.07  sell    0.006588    22822591\n    6 │ 2021-07-06T22:23:29.299Z  1948.8   sell    0.0540009   22822590\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_product_data-Tuple{String, String}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_product_data","text":"show_product_data(pair::String, endpoint::String)\n\nFetch product data based on the selected endpoint.\n\nArguments\n\npair::String : Specify currency pair, for example \"ETH-EUR\" \nendpoint::String : Select one from [\"24hr stats\" (default), \"product info\", \"product ticker\",                                        \"order book 1\", \"order book 2\", \"order book 3\"]\n\nExample\n\njulia> show_product_data(\"BTC-EUR\", \"24hr stats\")\n1×6 DataFrame\n Row │ high      last      low       open      volume         volume_30day   \n     │ String    String    String    String    String         String         \n─────┼───────────────────────────────────────────────────────────────────────\n   1 │ 29620.29  28740.89  28362.27  28642.14  1058.30490447  57346.67861744\n\n\n\n\n\n","category":"method"},{"location":"#Private-endpoints-(Coinbase-Pro-account-API-keys-are-needed)","page":"CoinbaseProExchange.jl","title":"Private endpoints (Coinbase Pro account + API keys are needed)","text":"","category":"section"},{"location":"","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.jl","text":"show_all_accounts(user_data::UserInfo, currencies::Vector{String})\n\nshow_account_info(user_data::UserInfo, currency::String, info_type::String)\n\nshow_open_orders(user_data::UserInfo)\n\nshow_single_order(order_ID::String, user_data::UserInfo)\n\ncancel_order(order_id::String, user_data::UserInfo)\n\ncancel_all_orders(user_data::UserInfo)\n\nshow_exchange_limits(user_data::UserInfo, currency::String)\n\nshow_fills(user_data::UserInfo, pair::String)","category":"page"},{"location":"#CoinbaseProExchange.show_all_accounts-Tuple{UserInfo, Vector{String}}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_all_accounts","text":"show_all_accounts(user_data::UserInfo, currencies::Vector{String})\n\nFetch summary of all cryptocurrency accounts associated with the given API key.\n\nArguments\n\nuser_data::UserInfo : API data\ncurrencies::Vector{String} : Can be set to [\"all\"] or a specific set, for example [\"LTC\", \"XTZ\"]\n\nExample\n\njulia> show_all_accounts(user_data, [\"LTC\", \"XTZ\"])\n2×7 DataFrame\n Row │ currency  balance  profile_id                         trading_enabled  id                                 hold  ⋯\n     │ String    Float64  String                             Bool             String                             Float ⋯\n─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────\n   1 │ LTC           0.0  4617f329-2709-453b-b95d-d14727cb…             true  eed5095d-848e-490c-8738-2f2073e7…      0 ⋯\n   2 │ XTZ           0.0  4617f329-2709-453b-b95d-d14727cb…             true  21f6c731-91f7-44bf-ad9e-97cc2dfb…      0\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_account_info-Tuple{UserInfo, String, String}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_account_info","text":"show_account_info(user_data::UserInfo, currency::String, info_type::String)\n\nFetch account information for a single cryptocurrency associated with the given API key.\n\nArguments\n\nuser_data::UserInfo : API data\ncurrency::String : Select one, for example [\"ETH\"]\ninfo_type::String : Select one from \"info\", \"history\" or \"holds\"\n\nExample\n\njulia> show_account_info(user_data, \"ETH\", \"history\")\n2×8 DataFrame\n Row │ amount               balance             created_at                   order_id                           produc ⋯\n     │ String               String              String                       String                             String ⋯\n─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────\n   1 │ -0.0248430100000000  0.0000000000000000  2021-05-09T00:56:06.877638Z  561bd042-9bd8-412f-a905-2a231e77…  ETH-EU ⋯\n   2 │ 0.0248430100000000   0.0248430100000000  2021-05-08T23:52:37.666196Z  496f1b74-5a66-45dd-9f6e-817da994…  ETH-EU\n                                                                                                       4 columns omitted\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_open_orders-Tuple{UserInfo}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_open_orders","text":"show_open_orders(user_data::UserInfo)\n\nFetch list of open orders associated with the given API key.\n\nExample\n\njulia> show_open_orders(user_data)\n1×15 DataFrame\n Row │ created_at                   executed_value      fill_fees           filled_size  id                            ⋯\n     │ String                       String              String              String       String                        ⋯\n─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────\n   1 │ 2021-07-04T22:15:03.793256Z  0.0000000000000000  0.0000000000000000  0.00000000   5591e17e-5f79-41f0-93d5-b455e ⋯\n                                                                                                      11 columns omitted\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_single_order-Tuple{String, UserInfo}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_single_order","text":"show_single_order(order_ID::String, user_data::UserInfo)\n\nFetch order information for a given order ID.\n\nArguments\n\norder_id::String : Order ID, can be obtained via \n\nshow_open_orders(user_data)\n\nuser_data::UserInfo : API data\n\nExample\n\njulia> show_single_order(\"14c0db51-ca17-4a8d-9d2c-aa633e703358\", user_data)\n1×15 DataFrame\n Row │ created_at                 executed_value      fill_fees           filled_size  id                              ⋯\n     │ String                     String              String              String       String                          ⋯\n─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────\n   1 │ 2021-07-04T23:11:02.0001Z  0.0000000000000000  0.0000000000000000  0.00000000   14c0db51-ca17-4a8d-9d2c-aa633e7 ⋯\n                                                                                                      11 columns omitted\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.cancel_order-Tuple{String, UserInfo}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.cancel_order","text":"cancel_order(order_id::String, user_data::UserInfo)\n\nCancel an order with a given order ID.\n\nArguments\n\norder_id::String : Order ID, can be obtained via \n\nshow_open_orders(user_data)\n\nuser_data::UserInfo : API data\n\nExample\n\njulia>cancel_order(\"5591e17e-5f79-41f0-93d5-b455ec552ecc\", user_data)\n\"5591e17e-5f79-41f0-93d5-b455ec552ecc\"\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.cancel_all_orders-Tuple{UserInfo}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.cancel_all_orders","text":"cancel_all_orders(user_data::UserInfo)\n\nCancel all open orders from the profile associated with the API key.\n\nExample\n\njulia>cancel_all_orders(user_data)\n1-element Vector{Any}:\n \"35fa8e19-f204-40c0-b995-eb2e4e168e01\"\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_exchange_limits-Tuple{UserInfo, String}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_exchange_limits","text":"show_exchange_limits(user_data::UserInfo, currency::String)\n\nFetch information on the payment method transfer limit for a given currency.\n\nArguments\n\nuser_data::UserInfo : API data\ncurrency::String : \"ETH, \"BTC\", \"XTZ\" etc.\n\nExample\n\njulia> show_exchange_limits(user_data, \"ETH\")\n5×4 DataFrame\n Row │ payment_method     max         period_in_days  remaining  \n     │ String             Float64     Int64           Float64    \n─────┼───────────────────────────────────────────────────────────\n   1 │ ideal_deposit       14.6423                 1   14.6423\n   2 │ exchange_withdraw  146.423                  1  146.423\n   3 │ secure3d_buy         1.75707                7    1.75707\n   4 │ credit_debit_card    0.585691               7    0.585691\n   5 │ paypal_withdrawal   11.7138                 1   11.7138\n\n\n\n\n\n","category":"method"},{"location":"#CoinbaseProExchange.show_fills-Tuple{UserInfo, String}","page":"CoinbaseProExchange.jl","title":"CoinbaseProExchange.show_fills","text":"show_fills(user_data::UserInfo, pair::String)\n\nGet a list of recent fills of the API key's profile for a given pair.\n\nArguments\n\nuser_data::UserInfo : API data\npair::String : \"ETH-EUR\" etc.\n\nExample\n\njulia> show_fills(user_data, \"ETH-EUR\")\n7×13 DataFrame\n Row │ created_at                fee                 liquidity  order_id                           price   ⋯\n     │ String                    String              String     String                             String  ⋯\n─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────\n   1 │ 2021-07-04T21:54:09.902Z  0.0746268391200000  T          d275ae2b-4f34-4ce9-98a7-1147bccf…  2003.90 ⋯\n   2 │ 2021-07-04T15:43:54.115Z  0.0733968750000000  T          7a019bf8-bee8-4001-bb34-e3d6f3e6…  1957.25\n   3 │ 2021-07-04T15:42:35.808Z  0.0597014279730000  T          2a8814f1-76d3-4fa2-bb0a-6f25e050…  1956.42\n   4 │ 2021-07-04T15:28:06.005Z  0.0599999776075000  T          9971744a-d308-4481-950d-e2ada197…  1953.35\n\n\n\n\n\n","category":"method"}]
}