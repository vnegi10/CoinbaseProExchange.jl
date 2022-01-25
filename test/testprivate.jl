#= Test cases for accessing private data, which needs user API information. Hence, this set 
   is run only locally. =#

@testset verbose = true "Check if private account data is accessible" begin

    input_params = JSON.parsefile(
        "/home/vikas/Documents/Input_JSON/VNEG_user_data_default_view.json"
    )

    user_data = UserInfo(
        input_params["api_key"],
        input_params["api_secret"],
        input_params["api_passphrase"]
    )

    coins = ["ETH", "LTC"]
    pairs = ["ETH-EUR", "LTC-EUR"]

    @testset "show_all_accounts" begin
        @test ~isempty(show_all_accounts(user_data, ["ETH", "BTC", "LTC"]))
    end

    @testset "show_account_info" begin
        info_types = ["info", "history", "holds"]

        for coin in coins
            for info in info_types
                if info == "history"
                    @test_broken ~isempty(
                        show_account_info(user_data, coin, info)
                    )

                elseif info == "holds"
                    # Assuming there are no holds currently
                    @test isempty(show_account_info(user_data, coin, info))

                else
                    @test ~isempty(show_account_info(user_data, coin, info))
                end
            end
        end
    end

    @testset "show_open_orders" begin
        # Assuming there are currently no open orders
        @test isempty(show_open_orders(user_data))
    end

    @testset "show_exchange_limits" begin
        for coin in coins
            @test ~isempty(show_exchange_limits(user_data, coin))
        end
    end

    @testset "show_fills" begin
        for pair in pairs
            @test ~isempty(show_fills(user_data, pair))
        end
    end

    @testset "show_transfers" begin
        deposits =
            ["deposit", "internal_deposit", "withdraw", "internal_withdraw"]

        for deposit in deposits
            @test ~isempty(show_transfers(user_data, deposit))
        end
    end

    @testset "show_fees" begin
        @test ~isempty(show_fees(user_data))
    end

    @testset "show_profiles" begin
        @test ~isempty(show_profiles(user_data))
    end
end