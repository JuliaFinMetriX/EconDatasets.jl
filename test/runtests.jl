## module TestEconDatasets

using EconDatasets
using Base.Test
using DataFrames
using Dates

# write your own tests here
tests = [
         "readYahooFinance.jl",
         "runtests_ijulia.jl",
         "getDataset.jl", # time consuming
         "dataset.jl"
         ]

println("Running EconDatasets tests:")

for t in tests
    include(string(Pkg.dir("EconDatasets"), "/test/", t))
end

## end
