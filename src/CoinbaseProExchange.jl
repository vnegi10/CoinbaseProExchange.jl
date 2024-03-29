module CoinbaseProExchange

export plot_historical_price,
    plot_historical_vol,
    show_historical_data,
    show_server_time,
    show_all_products,
    show_latest_trades,
    show_product_data,
    show_all_accounts,
    show_account_info,
    place_market_order,
    place_limit_order,
    show_open_orders,
    show_single_order,
    show_exchange_limits,
    show_fills,
    show_transfers,
    show_fees,
    show_profiles,
    cancel_order,
    cancel_all_orders,
    UserInfo,
    IntOrFloat

using DataFrames, HTTP, JSON
using Dates, Statistics, Query
using Base64, Nettle
using UnicodePlots

include("types.jl")
include("constants.jl")
include("helper.jl")

include("getpublic.jl")
include("getprivate.jl")

include("showpublic.jl")
include("showprivate.jl")

include("plotpublic.jl")

include("authentication.jl")
include("order.jl")

end # module