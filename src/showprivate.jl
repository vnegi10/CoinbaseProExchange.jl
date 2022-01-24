########## Show private account data ##########

"""
    show_all_accounts(user_data::UserInfo, currencies::Vector{String})

Fetch summary of all cryptocurrency accounts associated with the given API key.

# Arguments
- `user_data::UserInfo` : API data
- `currencies::Vector{String}` : Can be set to ["all"] or a specific set, 
                                 for example ["LTC", "XTZ"]

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

    auth_data = CoinbaseProAuth(
        "/accounts",
        user_data.api_key,
        user_data.secret_key,
        user_data.passphrase,
        "GET",
        ""
    )

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
function show_account_info(
    user_data::UserInfo,
    currency::String,
    info_type::String
    )

    account_ID = show_all_accounts(user_data, [currency])[!, :id][1]

    end_point = ""

    if info_type == "info"
        end_point = "/accounts/$(account_ID)"
    elseif info_type == "history"
        end_point = "/accounts/$(account_ID)/ledger"
    elseif info_type == "holds"
        end_point = "/accounts/$(account_ID)/holds"
    end

    auth_data = CoinbaseProAuth(
        end_point,
        user_data.api_key,
        user_data.secret_key,
        user_data.passphrase,
        "GET",
        ""
    )

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

    auth_data = CoinbaseProAuth(
        "/orders",
        user_data.api_key,
        user_data.secret_key,
        user_data.passphrase,
        "GET",
        ""
    )

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

    auth_data = CoinbaseProAuth(
        "/orders/$(order_ID)",
        user_data.api_key,
        user_data.secret_key,
        user_data.passphrase,
        "GET",
        ""
    )

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


"""
    show_exchange_limits(user_data::UserInfo, currency::String)

Fetch information on the payment method transfer limit for a given currency.

# Arguments
- `user_data::UserInfo` : API data
- `currency::String` : "ETH, "BTC", "XTZ" etc.

# Example
```julia-repl
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
"""
function show_exchange_limits(user_data::UserInfo, currency::String)

    auth_data = CoinbaseProAuth(
        "/users/self/exchange-limits",
        user_data.api_key,
        user_data.secret_key,
        user_data.passphrase,
        "GET",
        ""
    )

    df_limits = DataFrame()
    try
        df_limits = get_exchange_limits(auth_data, currency)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found - Check if the input data is valid"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_limits
end


"""
    show_fills(user_data::UserInfo, pair::String)

Get a list of recent fills of the API key's profile for a given pair.

# Arguments
- `user_data::UserInfo` : API data
- `pair::String` : "ETH-EUR" etc.

# Example
```julia-repl
julia> show_fills(user_data, "ETH-EUR")
7×13 DataFrame
 Row │ created_at                fee                 liquidity  order_id                           price   ⋯
     │ String                    String              String     String                             String  ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 2021-07-04T21:54:09.902Z  0.0746268391200000  T          d275ae2b-4f34-4ce9-98a7-1147bccf…  2003.90 ⋯
   2 │ 2021-07-04T15:43:54.115Z  0.0733968750000000  T          7a019bf8-bee8-4001-bb34-e3d6f3e6…  1957.25
```
"""
function show_fills(user_data::UserInfo, pair::String)
    return do_try_catch("/fills?product_id=$(pair)", user_data, get_common_df)
end


"""
    show_transfers(user_data::UserInfo, deposit_type::String="deposit")

Get a list of deposits/withdrawals from the profile of the API key, in descending order by created time.

# Arguments
- `user_data::UserInfo` : API data
- `deposit_type::String` : "deposit" (default), "internal_deposit" (transfer between portfolios), "withdraw" or "internal_withdraw"

# Example
```julia-repl
julia> show_transfers(user_data, "internal_deposit")
4×7 DataFrame
 Row │ account_id                         amount                created_at                     curren ⋯
     │ String                             String                String                         String ⋯
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 6defb94d-80e3-45b4-a6bf-0420cc5f…  10.0000000000000000   2021-07-16 11:10:10.253255+00  EUR    ⋯
   2 │ 6defb94d-80e3-45b4-a6bf-0420cc5f…  10.0000000000000000   2021-07-16 11:07:48.003446+00  EUR
```
"""
function show_transfers(user_data::UserInfo, transfer_type::String = "deposit")

    return do_try_catch(
        "/transfers?type=$(transfer_type)",
        user_data,
        get_common_df
    )
end


"""
    show_fees(user_data::UserInfo)

Get current maker & taker fee rates, as well as your 30-day trailing volume.

# Arguments
- `user_data::UserInfo` : API data

# Example
```julia-repl
julia> show_fees(user_data_default)
1×3 DataFrame
 Row │ maker_fee_rate  taker_fee_rate  usd_volume 
     │ String          String          String     
─────┼────────────────────────────────────────────
   1 │ 0.0050          0.0050          117.09
```
"""
function show_fees(user_data::UserInfo)

    auth_data = CoinbaseProAuth(
        "/fees",
        user_data.api_key,
        user_data.secret_key,
        user_data.passphrase,
        "GET",
        ""
    )

    df_fees = DataFrame()

    try
        df_fees = get_fees(auth_data)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found/403 Forbidden - Check if the input data is valid"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return df_fees
end


"""
    show_profiles(user_data::UserInfo)

Get a list of all user profiles/portfolios.

# Arguments
- `user_data::UserInfo` : API data

# Example
```julia-repl
julia> show_profiles(user_data_default)
6×6 DataFrame
 Row │ active  created_at                   id                                 is_default  name       ⋯
     │ Bool    String                       String                             Bool        String     ⋯
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────
   1 │   true  2019-06-23T00:19:33.647283Z  dc06c753-2e85-4e2f-b281-3a78bc7b…        true  default    ⋯
   2 │   true  2021-05-07T21:10:07.037681Z  4617f329-2709-453b-b95d-d14727cb…       false  Julia Bot
```
"""
function show_profiles(user_data::UserInfo)    
    return do_try_catch("/profiles", user_data, get_common_df)
end