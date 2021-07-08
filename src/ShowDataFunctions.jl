########## Show public market data ##########

"""
    show_server_time(time_type::String)

Get the API server time.

# Arguments
- `time_type::String` : "iso" or "epoch" (represents decimal seconds since Unix epoch)

# Example
```julia-repl
julia> show_server_time("iso")
"2021-07-06T22:09:17.231Z"
```
"""
function show_server_time(time_type::String)

    server_time = Dict()
    
    try 
        server_time = get_server_time()
    catch
        @info "Unable to retrieve API server time"
    end

    return server_time[time_type]
end

#----------------------------------------------------------------------------------------#

"""
    show_historical_data(pair::String, interval::Int64)

Fetch historic rates for a product.

# Arguments
- `pair::String` : Specify currency pair, for example "ETH-EUR" 
- `interval::Int64` : Rates are returned in grouped buckets based on specified interval. 
                      Choose one from [60, 300, 900, 3600, 21600, 86400], all in seconds.

# Example
```julia-repl
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
"""
function show_historical_data(pair::String, interval::Int64)

    df_candles = DataFrame()
    
    try
        df_candles = get_historical_data(pair::String, interval::Int64)        
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the pair ID is valid"
        elseif isa(e, AssertionError)
            @info "Granularity is NOK, choose only from {60, 300, 900, 3600, 21600, 86400}."
        else
            @info "Could not retrieve historical data, try again!"
        end
    end

    return df_candles
end

#----------------------------------------------------------------------------------------#

"""
    show_all_products(currency::String)

Fetch list of all available products for a given currency.

# Arguments
- `currency::String` : "EUR" or "USD"

# Example
```julia-repl
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
"""
function show_all_products(currency::String)
    products = String[]
    try
        products = get_all_products(currency)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    if isempty(products)
        @info "No products exist for the given currency, try something else!"
    else
        return products
    end    
end

#----------------------------------------------------------------------------------------#

"""
    show_latest_trades(pair::String)

Fetch list of latest trades for a given product.

# Arguments
- `pair::String` : Specify currency pair, for example "ETH-EUR" 

# Example
```julia-repl
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
"""
function show_latest_trades(pair::String)

    df_trades = DataFrame()
      
    try
        df_trades = get_latest_trades(pair)      
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the pair ID is valid"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_trades
end

#----------------------------------------------------------------------------------------#

"""
    show_product_data(pair::String, endpoint::String)

Fetch product data based on the selected endpoint.

# Arguments
- `pair::String` : Specify currency pair, for example "ETH-EUR" 
- `endpoint::String` : Select one from ["24hr stats", "product info", "product ticker", 
                                        "order book 1", "order book 2", "order book 3"]

# Example
```julia-repl
julia> show_product_data("BTC-EUR", "24hr stats")
1×6 DataFrame
 Row │ high      last      low       open      volume         volume_30day   
     │ String    String    String    String    String         String         
─────┼───────────────────────────────────────────────────────────────────────
   1 │ 29620.29  28740.89  28362.27  28642.14  1058.30490447  57346.67861744
```
"""
function show_product_data(pair::String, endpoint::String)

    df_product = DataFrame() 

    try
        df_product = get_product_data(pair, endpoint)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the pair ID is valid"
        elseif isa(e, AssertionError)
            @info "Endpoint is NOK, choose only one from {24hr stats, product info, product ticker, order book 1,
            order book 2, order book 3}."
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_product
end



########## Show private data, requires authentication using Coinbase Pro API key ##########

"""
    show_all_accounts(user_data::UserInfo, currencies::Vector{String})

Fetch summary of all cryptocurrency accounts associated with the given API key.

# Arguments
- `user_data::UserInfo` : API data
- `currencies::Vector{String}` : Can be set to ["all"] or a specific set, for example ["LTC", "XTZ"]

# Example
```julia-repl
julia> show_all_accounts(user_data, ["LTC", "XTZ"])
2×7 DataFrame
 Row │ currency  balance  profile_id                         trading_enabled  id                                 hold  ⋯
     │ String    Float64  String                             Bool             String                             Float ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ LTC           0.0  4617f329-2709-453b-b95d-d14727cb…             true  eed5095d-848e-490c-8738-2f2073e7…      0 ⋯
   2 │ XTZ           0.0  4617f329-2709-453b-b95d-d14727cb…             true  21f6c731-91f7-44bf-ad9e-97cc2dfb…      0
```
"""
function show_all_accounts(user_data::UserInfo, currencies::Vector{String})

    auth_data = CoinbaseProAuth("/accounts", user_data.api_key, user_data.secret_key, user_data.passphrase, "GET", "")
    
    df_account = DataFrame() 
    try
        df_account = get_all_accounts(auth_data, currencies)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input data is valid"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_account
end

#----------------------------------------------------------------------------------------#

"""
    show_account_info(user_data::UserInfo, currency::String, info_type::String)

Fetch account information for a single cryptocurrency associated with the given API key.

# Arguments
- `user_data::UserInfo` : API data
- `currency::String` : Select one, for example ["ETH"]
- `info_type::String` : Select one from "info", "history" or "holds"

# Example
```julia-repl
julia> show_account_info(user_data, "ETH", "history")
2×8 DataFrame
 Row │ amount               balance             created_at                   order_id                           produc ⋯
     │ String               String              String                       String                             String ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ -0.0248430100000000  0.0000000000000000  2021-05-09T00:56:06.877638Z  561bd042-9bd8-412f-a905-2a231e77…  ETH-EU ⋯
   2 │ 0.0248430100000000   0.0248430100000000  2021-05-08T23:52:37.666196Z  496f1b74-5a66-45dd-9f6e-817da994…  ETH-EU
                                                                                                       4 columns omitted
```
"""
function show_account_info(user_data::UserInfo, currency::String, info_type::String)

    account_ID = show_all_accounts(user_data, [currency])[!, :id][1]
    
    end_point = ""

    if info_type == "info"
        end_point = "/accounts/$(account_ID)"
    elseif info_type == "history"
        end_point = "/accounts/$(account_ID)/ledger"
    elseif info_type == "holds"
        end_point = "/accounts/$(account_ID)/holds"
    end

    auth_data = CoinbaseProAuth(end_point, user_data.api_key, user_data.secret_key, user_data.passphrase, "GET", "")

    df_account = DataFrame()
    try
        df_account = get_account_info(auth_data, info_type)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input data is valid"
        elseif isa(e, AssertionError)
            @info "End point is NOK, choose only from {info, history, holds}."
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_account
end

#----------------------------------------------------------------------------------------#

"""
    show_open_orders(user_data::UserInfo)

Fetch list of open orders associated with the given API key.

# Example
```julia-repl
julia> show_open_orders(user_data)
1×15 DataFrame
 Row │ created_at                   executed_value      fill_fees           filled_size  id                            ⋯
     │ String                       String              String              String       String                        ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 2021-07-04T22:15:03.793256Z  0.0000000000000000  0.0000000000000000  0.00000000   5591e17e-5f79-41f0-93d5-b455e ⋯
                                                                                                      11 columns omitted
```
"""
function show_open_orders(user_data::UserInfo)

    auth_data = CoinbaseProAuth("/orders", user_data.api_key, user_data.secret_key, user_data.passphrase, "GET", "")

    df_orders = DataFrame()
    try
        df_orders = get_open_orders(auth_data)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input data is valid"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_orders
end

#----------------------------------------------------------------------------------------#

"""
    show_single_order(order_ID::String, user_data::UserInfo)

Fetch order information for a given order ID.

# Arguments
- `order_id::String` : Order ID, can be obtained via 
```show_open_orders(user_data)```
- `user_data::UserInfo` : API data

# Example
```julia-repl
julia> show_single_order("14c0db51-ca17-4a8d-9d2c-aa633e703358", user_data)
1×15 DataFrame
 Row │ created_at                 executed_value      fill_fees           filled_size  id                              ⋯
     │ String                     String              String              String       String                          ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 2021-07-04T23:11:02.0001Z  0.0000000000000000  0.0000000000000000  0.00000000   14c0db51-ca17-4a8d-9d2c-aa633e7 ⋯
                                                                                                      11 columns omitted
```
"""
function show_single_order(order_ID::String, user_data::UserInfo)
    auth_data = CoinbaseProAuth("/orders/$(order_ID)", user_data.api_key, user_data.secret_key, user_data.passphrase, "GET", "")

    df_orders = DataFrame()
    try
        df_orders = get_open_orders(auth_data)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input data is valid"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_orders
end














