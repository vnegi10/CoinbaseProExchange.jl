function generate_auth_headers(auth_data::CoinbaseProAuth)
		
    # Get authentication data
    request_path = auth_data.end_point
    api_key = auth_data.api_key
    secret_key = auth_data.secret_key
    passphrase = auth_data.passphrase
    method = auth_data.method
    body = auth_data.body
    timestamp = "$(show_server_time("epoch"))"
    
    # Prehash string
    message = timestamp*method*request_path*body
    
    # Base64-decode the alphanumeric secret string
    hmac_key = Base64.base64decode(secret_key)
    
    # Create a SHA256 HMAC
    signature = digest("sha256", hmac_key, message)
    
    # Base64-encode the digest output
    signature_b64 = Base64.base64encode(signature)
    
    headers = ["CB-ACCESS-SIGN" => signature_b64, "CB-ACCESS-TIMESTAMP" => timestamp, "CB-ACCESS-KEY" => api_key, "CB-ACCESS-PASSPHRASE" => passphrase]
    
    return headers
end

# Market order 
function generate_order_auth(side::String, pair::String, amount::IntOrFloat, amount_type::String, api_key::String, api_secret::String, api_passphrase::String)
	
    param = ""
    if amount_type == "base"
        param = "size"
    else
        param = "funds"
    end

	# Generate order body
	body_dict = Dict("type" => "market", "side" => "$(side)", "product_id" => "$(pair)", param => "$(amount)")
		
	body = JSON.json(body_dict)
	
	# Input for order API authetication
	order_auth = CoinbaseProAuth("/orders", api_key, api_secret, api_passphrase, "POST", body)
	
	return order_auth
end	

# Limit order using amount in base currency
function generate_order_auth(side::String, pair::String, amount::IntOrFloat, price::IntOrFloat, api_key::String, api_secret::String, api_passphrase::String)
	
	# Generate order body
	body_dict = Dict("type" => "limit", "side" => "$(side)", "product_id" => "$(pair)", "size" => "$(amount)", "price" => "$(price)")
		
	body = JSON.json(body_dict)
	
	# Input for order API authetication
	order_auth = CoinbaseProAuth("/orders", api_key, api_secret, api_passphrase, "POST", body)
	
	return order_auth
end