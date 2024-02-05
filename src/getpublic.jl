########## Functions to access public market data ##########

function get_historical_data(pair::String, interval::Int64)

    @assert interval in GRANULARITY

    # Fetch data via Coinbase Pro API for a given time interval
    CP_candles_response = HTTP.request(
        "GET",
        URL * "/products/$(pair)/candles?granularity=$(interval)";
        verbose = 0,
        retries = 2
    )
    candles_text = String(CP_candles_response.body)
    candles_dict = JSON.parse(candles_text)

    # Convert to DataFrame
    df_candles = DataFrame(
        time   = DateTime[],
        low    = Float64[],
        high   = Float64[],
        open   = Float64[],
        close  = Float64[],
        volume = Float64[]
    )

    for i in eachindex(candles_dict)

        time = Dates.unix2datetime(candles_dict[i][1])
        low  = candles_dict[i][2]
        high = candles_dict[i][3]
        open = candles_dict[i][4]
        close = candles_dict[i][5]
        volume = candles_dict[i][6]

        push!(df_candles, [time low high open close volume])
    end

    sort!(df_candles, :time)

    return df_candles
end

function get_server_time()

    time_response = HTTP.request("GET", URL * "/time"; verbose = 0, retries = 2)
    time_text = String(time_response.body)
    time_dict = JSON.parse(time_text)

    return time_dict
end

function get_all_products(currency::String)

    CP_product_response =
        HTTP.request("GET", URL * "/products/"; verbose = 0, retries = 2)
    product_text = String(CP_product_response.body)
    product_dict = JSON.parse(product_text)

    filter_product_dict =
        filter(p -> (p["quote_currency"] == currency), product_dict)

    products = String[]
    for i in eachindex(filter_product_dict)
        push!(products, filter_product_dict[i]["id"])
    end

    return products
end

function get_latest_trades(pair::String)

    CP_trade_response = HTTP.request(
        "GET",
        URL * "/products/$(pair)/trades";
        verbose = 0,
        retries = 2
    )
    trade_text = String(CP_trade_response.body)
    trade_dict = JSON.parse(trade_text)

    # Convert to DataFrame
    df_trades = DataFrame(
        time  = Any[],
        price = Float64[],
        side  = String[],
        size  = Float64[],
        trade_id = Int64[]
    )

    for i in eachindex(trade_dict)

        time  = trade_dict[i]["time"]
        price = parse(Float64, trade_dict[i]["price"])
        side  = trade_dict[i]["side"]
        size  = parse(Float64, trade_dict[i]["size"])
        trade_id = trade_dict[i]["trade_id"]

        push!(df_trades, [time price side size trade_id])
    end

    return df_trades
end

function get_url(pair::String, endpoint::String)

    url_dict = Dict(
               "24hr stats" => URL * "/products/$(pair)/stats",
               "product info" => URL * "/products/$(pair)",
               "product ticker" => URL * "/products/$(pair)/ticker",
               )
    
    if occursin("order book", endpoint)
        return URL * "/products/$(pair)/book?level=$(parse(Int64, endpoint[end]))"
    else
        return url_dict[endpoint]
    end
end

function get_product_data(pair::String, endpoint::String)

    @assert endpoint in ENDPOINTS

    url = get_url(pair, endpoint)

    CP_product_response = HTTP.request("GET", url; verbose = 0, retries = 2)
    product_text = String(CP_product_response.body)
    product_dict = JSON.parse(product_text)

    if endpoint == "order book 3"
        mismatch =
            abs(length(product_dict["bids"]) - length(product_dict["asks"]))

        if mismatch > 0
            if length(product_dict["bids"]) < length(product_dict["asks"])
                for i in 1:mismatch
                    push!(product_dict["bids"], missing)
                end
            else
                for i in 1:mismatch
                    push!(product_dict["asks"], missing)
                end
            end
        else
            # do nothing
        end
    end

    return DataFrame(product_dict)
end