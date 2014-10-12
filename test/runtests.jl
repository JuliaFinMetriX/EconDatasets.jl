## module TestEconDatasets

using EconDatasets
using Base.Test
using DataFrames

# write your own tests here
tests = [
         "getDataset.jl",
         "dataset.jl",
         "readYahooFinance.jl",
         "runtests_ijulia.jl"]

println("Running EconDatasets tests:")

for t in tests
    include(string(Pkg.dir("EconDatasets"), "/test/", t))
end

## end
