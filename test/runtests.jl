module TestEconDatasets

using EconDatasets
using Base.Test
using DataFrames

# write your own tests here
tests = ["dataset.jl"]

println("Running EconDatasets tests:")

for t in tests
    include(string(Pkg.dir("EconDatasets"), "/test/", t))
end


#############################################
## test documentation application examples ##
#############################################

ijuliaFileNames = [readFamaFrenchRaw]

println("Running documentation application tests:")
println()
println(" Converting ijulia notebooks to test scripts")
println()
println("--------------------------------")
println("--------------------------------")
println()

currentPath = pwd()
ijuliaPath = joinpath(Pkg.dir("EconDatasets"), "ijulia")
cd(ijuliaPath)

for f in ijuliaFileNames
    run(`ipython nbconvert $(f).ipynb --to python`)
    run(`mv $(f).py ../test/$(f).jl`)
end

for f in ijuliaFileNames
    println()
    println(" Running $f test")
    println()
    println("--------------------------------")
    println("--------------------------------")
    println()
    include("$f.jl")
end

cd(currentPath)

end
