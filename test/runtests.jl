using Test, DataFrames, JSON, CoinbaseProExchange

errors = false
all_tests = false

# Run all tests when no arguments or "all" is specified
if isempty(ARGS) || "all" in ARGS
    all_tests = true
end

# Execute test in a try-catch block for each file
function execute_test(file::String, ARGS; all_tests::Bool, errors::Bool)

   if all_tests || file in ARGS
       try
           include(file)
           println("\t\033[1m\033[32mPASSED\033[0m: $(file)")
       catch e
           println("\t\033[1m\033[31mFAILED\033[0m: $(file)")
           errors = true
           showerror(stdout, e, backtrace())
           println()
       end
   end

   if errors
       @warn "Some tests have failed! Check the results summary above."
   end

end

################# All test groups #################

test_files = ["testpublic.jl", "testprivate.jl"]

###################################################


################# Execute tests ###################

@time for file in test_files
    execute_test(file, ARGS, all_tests = all_tests, errors = errors)    
end

###################################################