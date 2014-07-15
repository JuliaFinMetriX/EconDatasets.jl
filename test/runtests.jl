using EconDatasets
using Base.Test

# write your own tests here
tests = ["dataset.jl"]

println("Running EconDatasets tests:")

for t in tests
    include(string(Pkg.dir("EconDatasets"), "/test/", t))
end

