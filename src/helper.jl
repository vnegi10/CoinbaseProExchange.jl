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