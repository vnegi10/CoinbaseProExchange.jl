using Documenter
using CoinbaseProExchange

makedocs(
    sitename = "CoinbaseProExchange",
    format = Documenter.HTML(),
    modules = [CoinbaseProExchange]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/vnegi10/CoinbaseProExchange.jl.git",
    devbranch = "main"
)
