function create_new_order(auth_data::CoinbaseProAuth)	
	
	url = URL * auth_data.end_point
	
	headers = generate_auth_headers(auth_data)
	push!(headers, "Content-Type" => "application/json")
	body = auth_data.body
	
	# Use POST request to place an order	
	order_response = HTTP.request(auth_data.method, url, headers, body; verbose = 0, retries = 2)		
	order_text = String(order_response.body)
	order_dict = JSON.parse(order_text)	
	
	return order_dict
end	

#----------------------------------------------------------------------------------------#

"""
    place_market_order(side::String, pair::String, amount::IntOrFloat, amount_type::String, user_data::UserInfo)

Place a market order using the information provided.

# Arguments
- `side::String` : "buy" or "sell"
- `pair::String` : Specify currency pair, for example "ETH-EUR"
- `amount::IntOrFloat` : Specify amount in base currency (ETH, BTC etc.) or quote currency (EUR, USD etc.)
- `amount_type::String` : Select either "base" or "quote" based on the amount entered
- `user_data::UserInfo` : API data

# Example
```julia-repl
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
"""
function place_market_order(side::String, pair::String, amount::IntOrFloat, amount_type::String, user_data::UserInfo)
	
    @assert amount_type in ["base", "quote"]

    order_auth = generate_order_auth(side, pair, amount, amount_type, user_data.api_key, user_data.secret_key, user_data.passphrase)

    order_dict = Dict()

    try
        order_dict = create_new_order(order_auth)
        @info "Order placed"        
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input is valid"
        else
            @info "Could not place order, try again!"
        end
    end

	return order_dict	
end	

#----------------------------------------------------------------------------------------#

"""
    place_limit_order(side::String, pair::String, amount::IntOrFloat, price::IntOrFloat, user_data::UserInfo)

Place a limit order using the information provided.

# Arguments
- `side::String` : "buy" or "sell"
- `pair::String` : Specify currency pair, for example "ETH-EUR"
- `amount::IntOrFloat` : Specify amount in base currency (ETH, BTC etc.) 
- `user_data::UserInfo` : API data

# Example
```julia-repl
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
"""
function place_limit_order(side::String, pair::String, amount::IntOrFloat, price::IntOrFloat, user_data::UserInfo)
	
	order_auth = generate_order_auth(side, pair, amount, price, user_data.api_key, user_data.secret_key, user_data.passphrase)

    order_dict = Dict()

    try
        order_dict = create_new_order(order_auth)
        @info "Order placed"        
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input is valid"
        else
            @info "Could not place order, try again!"
        end
    end

	return order_dict	
end

#----------------------------------------------------------------------------------------#

"""
    cancel_order(order_id::String, user_data::UserInfo)

Cancel an order with a given order ID.

# Arguments
- `order_id::String` : Order ID, can be obtained via 
```show_open_orders(user_data)```
- `user_data::UserInfo` : API data

# Example
```julia-repl
julia>cancel_order("5591e17e-5f79-41f0-93d5-b455ec552ecc", user_data)
"5591e17e-5f79-41f0-93d5-b455ec552ecc"
```
"""
function cancel_order(order_id::String, user_data::UserInfo)

    # Use DELETE request to delete the specified order
    auth_data = CoinbaseProAuth("/orders/$(order_id)", user_data.api_key, user_data.secret_key, user_data.passphrase, "DELETE", "")

    url = URL * auth_data.end_point
	
	headers = generate_auth_headers(auth_data)
	body = auth_data.body
    order_dict = Dict()

    try
        order_response = HTTP.request(auth_data.method, url, headers, body; verbose = 0, retries = 2)		
	    order_text = String(order_response.body)
	    order_dict = JSON.parse(order_text)	        
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input is valid"
        else
            @info "Could not delete order, try again!"
        end
    end	

    return order_dict
end

#----------------------------------------------------------------------------------------#

"""
    cancel_all_orders(user_data::UserInfo)

Cancel all open orders from the profile associated with the API key.

# Example
```julia-repl
julia>cancel_all_orders(user_data)
1-element Vector{Any}:
 "35fa8e19-f204-40c0-b995-eb2e4e168e01"
```
"""
function cancel_all_orders(user_data::UserInfo)

    # Use DELETE request to delete all open orders
    auth_data = CoinbaseProAuth("/orders", user_data.api_key, user_data.secret_key, user_data.passphrase, "DELETE", "")

    url = URL * auth_data.end_point
	
	headers = generate_auth_headers(auth_data)
	body = auth_data.body
    order_dict = Dict()

    try
        order_response = HTTP.request(auth_data.method, url, headers, body; verbose = 0, retries = 2)		
	    order_text = String(order_response.body)
	    order_dict = JSON.parse(order_text)	        
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input is valid"
        else
            @info "Could not delete order, try again!"
        end
    end	

    return order_dict
end

