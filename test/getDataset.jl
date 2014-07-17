module TestGetDatasets

using EconDatasets
using Base.Test
using DataFrames

println("\n Running getDataset tests:")

println("\n   test getting FFF\n")
println("--------------------------------")
println("--------------------------------\n")
getDataset("FFF")

println("\n   test getting UMD\n")
println("--------------------------------")
println("--------------------------------\n")
getDataset("UMD")

end
