"""
"""
function plot_historical_price(pair::String, interval::Int64 = 300)

    df_candles = show_historical_data(pair, interval)

    currency = split(pair, "-")[2]

    plt = lineplot(
        df_candles[!, :time],
        df_candles[!, :close],
        title  = "Closing price for $(pair) in intervals of $(interval) seconds",
        xlabel = "Time",
        ylabel = "Closing price [$(currency)]",
        xticks = true,
        yticks = true,
        border = :bold,
        color = :cyan,
        canvas = BrailleCanvas,
        width = 75,
        height = 15,
        grid = true
    )

    return plt

end

"""
"""
function plot_historical_vol(pair::String, interval::Int64 = 300)

    df_candles = show_historical_data(pair, interval)

    coin = split(pair, "-")[1]

    plt = lineplot(
        df_candles[!, :time],
        df_candles[!, :volume],
        title  = "Volume for $(pair) in intervals of $(interval) seconds",
        xlabel = "Time",
        ylabel = "Number of coins [$(coin)]",
        xticks = true,
        yticks = true,
        border = :bold,
        color = :red,
        canvas = BrailleCanvas,
        width = 75,
        height = 15,
        grid = true
    )

    return plt

end