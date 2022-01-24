########## Functions to access private endpoints ##########

function get_all_accounts(auth_data::CoinbaseProAuth, 
    currencies::Vector{String})

    account_dict = get_data_dict(auth_data::CoinbaseProAuth)

    df_account = DataFrame(
        currency = String[],
        balance = Float64[],
        profile_id = String[],
        trading_enabled = Bool[],
        id = String[],
        hold = Float64[],
        available = Float64[]
    )

    for i in eachindex(account_dict)

        currency = account_dict[i]["currency"]
        balance = parse(Float64, account_dict[i]["balance"])
        profile_id = account_dict[i]["profile_id"]
        trading = account_dict[i]["trading_enabled"]
        id = account_dict[i]["id"]
        hold = parse(Float64, account_dict[i]["hold"])
        avail = parse(Float64, account_dict[i]["available"])

        push!(df_account, [currency balance profile_id trading id hold avail])
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

    account_dict = get_data_dict(auth_data::CoinbaseProAuth)

    if info_type == "info"
        return DataFrame(account_dict)
    elseif info_type == "holds"
        return vcat(DataFrame.(account_dict)...)
    else
        if ~isempty(account_dict)
            df_hist = vcat(DataFrame.(account_dict)...)
            df_details = vcat(DataFrame.(df_hist[!, :details])...)
            insertcols!(df_hist, 4,
                :order_id => df_details[!, :order_id],
                :product_id => df_details[!, :product_id],
                :trade_id => df_details[!, :trade_id],
            )
            select!(df_hist, Not(:details))
            return df_hist
        else
            return DataFrame(account_dict)
        end
    end
end

function get_open_orders(auth_data::CoinbaseProAuth)

    account_dict = get_data_dict(auth_data::CoinbaseProAuth)

    if auth_data.end_point == "/orders"
        return vcat(DataFrame.(account_dict)...)
    else
        return DataFrame(account_dict)
    end
end

function get_exchange_limits(auth_data::CoinbaseProAuth, currency::String)

    account_dict = get_data_dict(auth_data::CoinbaseProAuth)

    df_limits = DataFrame(
        payment_method = String[],
        max = Float64[],
        period_in_days = Int64[],
        remaining = Float64[]
    )

    for key in keys(account_dict["transfer_limits"])
        currency_dict = account_dict["transfer_limits"][key][currency]

        max = parse(Float64, currency_dict["max"])
        period = currency_dict["period_in_days"]
        remaining = parse(Float64, currency_dict["remaining"])

        push!(df_limits, [key max period remaining])
    end

    return df_limits
end

function get_common_df(auth_data::CoinbaseProAuth)

    account_dict = get_data_dict(auth_data::CoinbaseProAuth)

    return vcat(DataFrame.(account_dict)...)
end

function get_fees(auth_data::CoinbaseProAuth)

    account_dict = get_data_dict(auth_data::CoinbaseProAuth)

    return DataFrame(account_dict)
end