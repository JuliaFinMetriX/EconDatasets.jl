## module TestGetDatasets # no module because of parallel computing

using EconDatasets
using Base.Test
using DataFrames
using Dates

## try to get all data sets
println("\n Running getDataset tests:")

println("\n   test getting FFF\n")
println("--------------------------------")
println("--------------------------------\n")
getDataset("FFF")

println("\n   test getting UMD\n")
println("--------------------------------")
println("--------------------------------\n")
getDataset("UMD")

println("\n   test getting Treasury rates\n")
println("--------------------------------")
println("--------------------------------\n")
getDataset("Treasuries")

println("\n   test getting DieboldLi\n")
println("--------------------------------")
println("--------------------------------\n")
getDataset("DieboldLi")

println("\n   test getting SP500Ticker\n")
println("--------------------------------")
println("--------------------------------\n")
getDataset("SP500Ticker")

println("\n   test getting SP500Industries\n")
println("--------------------------------")
println("--------------------------------\n")
getDataset("SP500Industries")

println("\n   test getting index prices\n")
println("--------------------------------")
println("--------------------------------\n")
## include(joinpath(Pkg.dir("EconDatasets"), "src/getDataset/",
                 ## "getIndices.jl"))
getDataset("Indices")


println("\n   test getting SP500\n")
println("--------------------------------")
println("--------------------------------\n")
include(joinpath(Pkg.dir("EconDatasets"), "src/getDataset/", "getSP500.jl"))


## end
