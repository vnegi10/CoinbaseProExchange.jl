########## Show public market data ##########

"""
    show_server_time(time_type::String)

Get the API server time.

# Arguments
- `time_type::String` : "iso" (default) or "epoch" (represents decimal seconds since Unix epoch)

# Example
```julia-repl
julia> show_server_time("iso")
"2021-07-06T22:09:17.231Z"
```
"""
function show_server_time(time_type::String = "iso")

    server_time = Dict()

    try
        server_time = get_server_time()
    catch
        @info "Unable to retrieve API server time"
    end

    return server_time[time_type]
end


"""
    show_historical_data(pair::String, interval::Int64)

Fetch historic rates for a product.

# Arguments
- `pair::String` : Specify currency pair, for example "ETH-EUR" 
- `interval::Int64` : Rates are returned in grouped buckets based on specified interval. 
                      Choose one from [60, 300 (default), 900, 3600, 21600, 86400], all in seconds.

# Example
```julia-repl
julia> show_historical_data("ETH-EUR", 3600)
300×6 DataFrame
 Row │ time                 low      high     open     close    volume  
     │ Any                  Any      Any      Any      Any      Any     
─────┼──────────────────────────────────────────────────────────────────
   1 │ 2021-06-24T11:00:00  1619.45  1650.91  1619.45  1648.84  407.623
   2 │ 2021-06-24T12:00:00  1644.02  1665.64  1648.05  1655.5   446.389
```
"""
function show_historical_data(pair::String, interval::Int64 = 300)

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


"""
    show_all_products(currency::String)

Fetch list of all available products for a given currency.

# Arguments
- `currency::String` : "EUR", "USD" (default), "GBP" etc.

# Example
```julia-repl
julia> show_all_products("EUR")
40-element Vector{String}:
 "ETC-EUR"
 "SNX-EUR"
```
"""
function show_all_products(currency::String = "USD")

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


"""
    show_product_data(pair::String, endpoint::String)

Fetch product data based on the selected endpoint.

# Arguments
- `pair::String` : Specify currency pair, for example "ETH-EUR" 
- `endpoint::String` : Select one from ["24hr stats" (default), "product info", "product ticker", 
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
function show_product_data(pair::String, endpoint::String = "24hr stats")

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