########## Functions to access public market data ##########

function get_historical_data(pair::String, interval::Int64)

    @assert interval in GRANULARITY
	
	# Fetch data via Coinbase Pro API for a given time interval
	CP_candles_response = HTTP.request("GET", URL * "/products/$(pair)/candles?granularity=$(interval)"; verbose = 0, retries = 2)
	candles_text = String(CP_candles_response.body)
	candles_dict = JSON.parse(candles_text)	
	
	# Convert to DataFrame
	df_candles = DataFrame(time = Any[], low = Any[] , high = Any[], open = Any[], close = Any[], volume = Any[])
	
	for i = 1:length(candles_dict)
		push!(df_candles, [Dates.unix2datetime(candles_dict[i][1]) candles_dict[i][2] candles_dict[i][3] candles_dict[i][4] candles_dict[i][5] candles_dict[i][6]])
	end	
	
	sort!(df_candles, :time)
	
	return df_candles
end	

function get_server_time()
	time_response = HTTP.request("GET", URL * "/time"; verbose = 0, retries = 2);
	time_text = String(time_response.body)
	time_dict = JSON.parse(time_text)
	return time_dict
end

function get_all_products(currency::String)
    CP_product_response = HTTP.request("GET", URL * "/products/"; verbose = 0, retries = 2)	
	product_text = String(CP_product_response.body)
	product_dict = JSON.parse(product_text)	

    filter_product_dict = filter(p -> (p["quote_currency"] == currency), product_dict)

    products = String[]
    for i = 1:length(filter_product_dict)
        push!(products, filter_product_dict[i]["id"])
    end

    return products
end

function get_latest_trades(pair::String)

    CP_trade_response = HTTP.request("GET", URL * "/products/$(pair)/trades"; verbose = 0, retries = 2)	
	trade_text = String(CP_trade_response.body)
	trade_dict = JSON.parse(trade_text)	

    # Convert to DataFrame
	df_trades = DataFrame(time = Any[], price = Float64[], side = String[], size = Float64[], trade_id = Int64[])

    for i = 1:length(trade_dict)
        push!(df_trades, [ trade_dict[i]["time"] parse(Float64, trade_dict[i]["price"]) trade_dict[i]["side"] parse(Float64, trade_dict[i]["size"]) trade_dict[i]["trade_id"] ])
    end

    return df_trades
end

function get_url(pair::String, endpoint::String)

    url = ""
    if endpoint == "24hr stats"
        url = URL * "/products/$(pair)/stats"
    elseif endpoint == "product info"
        url = URL * "/products/$(pair)"
    elseif endpoint == "product ticker"
        url = URL * "/products/$(pair)/ticker"
    elseif occursin("order book", endpoint)
        level = parse(Int64, endpoint[end])
        url = URL * "/products/$(pair)/book?level=$(level)"
    end

    return url
end

function get_product_data(pair::String, endpoint::String)

    @assert endpoint in ENDPOINTS
    
    url = get_url(pair, endpoint)

    CP_product_response = HTTP.request("GET", url; verbose = 0, retries = 2)
    product_text = String(CP_product_response.body)
	product_dict = JSON.parse(product_text)	

    if endpoint == "order book 3"

        mismatch = abs(length(product_dict["bids"]) - length(product_dict["asks"]))

        if mismatch > 0
            
            if length(product_dict["bids"]) < length(product_dict["asks"])
                for i = 1:mismatch
                    push!(product_dict["bids"], missing)
                end
            else
                for i = 1:mismatch
                    push!(product_dict["asks"], missing)
                end
            end
        else
            # do nothing
        end
    end

    return DataFrame(product_dict)
end

########## Functions to access private endpoints, requires authentication using Coinbase Pro API key ##########

function get_all_accounts(auth_data::CoinbaseProAuth, currencies::Vector{String})
	
	url = URL * auth_data.end_point
	
	headers = generate_auth_headers(auth_data)
	body = auth_data.body
	
	# Use GET request to fetch list of all trading accounts
	account_response = HTTP.request(auth_data.method, url, headers, body; verbose = 0, retries = 2)
	account_text = String(account_response.body)
	account_dict = JSON.parse(account_text)
	
	df_account = DataFrame(currency = String[], balance = Float64[], profile_id = String[], trading_enabled = Bool[], id = String[], hold = Float64[], available = Float64[])
	
	for i = 1:length(account_dict)
		push!(df_account, [account_dict[i]["currency"] parse(Float64, account_dict[i]["balance"]) account_dict[i]["profile_id"] account_dict[i]["trading_enabled"] account_dict[i]["id"] parse(Float64, account_dict[i]["hold"]) parse(Float64, account_dict[i]["available"])])
	end
	
	if "all" in currencies
		df_output = df_account
	else
		df_output = df_account |> @filter(_.currency in currencies) |> DataFrame
	end

    return df_output		
end

function get_account_info(auth_data::CoinbaseProAuth, info_type::String)

    @assert info_type in ["info", "history", "holds"]

    url = URL * auth_data.end_point
	
	headers = generate_auth_headers(auth_data)
	body = auth_data.body
	
	# Use GET request to fetch information for a single account
	account_response = HTTP.request(auth_data.method, url, headers, body; verbose = 0, retries = 2)
	account_text = String(account_response.body)
	account_dict = JSON.parse(account_text)

    if info_type == "info"
        return DataFrame(account_dict)
    elseif info_type == "holds"
        return vcat(DataFrame.(account_dict)...)        
    else
        if ~isempty(account_dict)
            df_hist = vcat(DataFrame.(account_dict)...)
            df_details = vcat(DataFrame.(df_hist[!, :details])...)
            insertcols!(df_hist, 4, :order_id => df_details[!, :order_id], 
                       :product_id => df_details[!, :product_id], :trade_id => df_details[!, :trade_id])
            select!(df_hist, Not(:details))
            return df_hist
        else
            return DataFrame(account_dict)
        end
    end
end

function get_open_orders(auth_data::CoinbaseProAuth)
    url = URL * auth_data.end_point
	
	headers = generate_auth_headers(auth_data)
	body = auth_data.body
	
	# Use GET request to fetch information for a single account
	account_response = HTTP.request(auth_data.method, url, headers, body; verbose = 0, retries = 2)
	account_text = String(account_response.body)
	account_dict = JSON.parse(account_text)
    
    if auth_data.end_point == "/orders"
        return vcat(DataFrame.(account_dict)...)
    else
        return DataFrame(account_dict)
    end
end




	













