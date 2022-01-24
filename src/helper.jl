##################### Helper function #####################

function get_data_dict(auth_data::CoinbaseProAuth)

    url = URL * auth_data.end_point

    headers = generate_auth_headers(auth_data)
    body = auth_data.body

    # Make HTTP request
    data_response = HTTP.request(
        auth_data.method,
        url,
        headers,
        body;
        verbose = 0,
        retries = 2
    )
    data_text = String(data_response.body)
    data_dict = JSON.parse(data_text)

    return data_dict
end

function do_try_catch(endpoint::String, user_data::UserInfo, get_common_df)

    auth_data = CoinbaseProAuth(endpoint, user_data.api_key, user_data.secret_key, user_data.passphrase, "GET", "")

    df_data = DataFrame()

    try
        df_data = get_common_df(auth_data)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found/403 Forbidden - Check if the input data is valid"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_data
end