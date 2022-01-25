# Test cases for accessing market data

@testset verbose = true "Check if public market data is accessible" begin

    pairs = ["ETH-EUR", "LTC-EUR"]
    intervals = [60, 3600]
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

    @testset "show_historical_data" begin
        for pair in pairs
            for interval in intervals
                @test ~isempty(show_historical_data(pair, interval))
            end
        end
    end

    @testset "show_all_products" begin
        for currency in fiat_currencies
            @test ~isempty(show_all_products(currency))
        end
    end

    @testset "show_latest_trades" begin
        for pair in pairs
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
end