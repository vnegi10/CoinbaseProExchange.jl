# Test cases for accessing market data

@testset verbose = true "Check if public market data is accessible" begin

    # Common input parameters for the tests
    pairs_1 = ["ETH-EUR", "LTC-EUR"]
    pairs_2 = ["BTC-USD", "LINK-EUR"]
    intervals_1 = [60, 3600]
    intervals_2 = [21600, 86400]
    fiat_currencies = ["USD", "EUR"]
    endpoints = [
        "24hr stats",
        "product info",
        "product ticker",
        "order book 1",
        "order book 2",
        "order book 3"
    ]

    @testset "show_server_time" begin
        time_types = ["epoch", "iso"]
        for time_type in time_types
            @test ~isempty(show_server_time(time_type))
        end
    end

    # Already covered when plotting calls are made during plot tests
    #=@testset "show_historical_data" begin
        for pair in pairs
            for interval in intervals
                @test ~isempty(show_historical_data(pair, interval))
            end
        end
    end=#

    @testset "show_all_products" begin
        for currency in fiat_currencies
            @test ~isempty(show_all_products(currency))
        end
    end

    @testset "show_latest_trades" begin
        for pair in pairs_1
            @test ~isempty(show_latest_trades(pair))
        end
    end

    @testset "show_product_data" begin
        for endpoint in endpoints
            if endpoint == "order book 2"
                @test_broken ~isempty(show_product_data("ETH-EUR", endpoint))
            else
                @test ~isempty(show_product_data("ETH-EUR", endpoint))
            end
        end
    end

    @testset "plot_historical_price" begin
        for pair in pairs_1
            for interval in intervals_1
                plt = plot_historical_price(pair, interval)
                @test sizeof(plt) > 0
            end
        end
    end

    @testset "plot_historical_vol" begin
        for pair in pairs_2
            for interval in intervals_2
                plt = plot_historical_vol(pair, interval)
                @test sizeof(plt) > 0
            end
        end
    end

end