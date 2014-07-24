module TestEconDatasets

using EconDatasets
using Base.Test
using DataFrames

# write your own tests here
tests = [
         "getDataset.jl",
         "dataset.jl"]

println("Running EconDatasets tests:")

for t in tests
    include(string(Pkg.dir("EconDatasets"), "/test/", t))
end


#############################################
## test documentation application examples ##
#############################################

ijuliaFileNames = [readFamaFrenchRaw]

println("Running documentation application tests:\n")
println(" Converting ijulia notebooks to test scripts\n")
println("--------------------------------")
println("--------------------------------\n")

currentPath = pwd()
ijuliaPath = joinpath(Pkg.dir("EconDatasets"), "ijulia")
cd(ijuliaPath)

ipythonInstalled = true
try
    for f in ijuliaFileNames
        run(`ipython nbconvert $(f).ipynb --to python`)
        run(`mv $(f).py ../test/$(f).jl`)
    end
catch
    println("no ipython installed")
    ipythonInstalled = false
end

if ipythonInstalled
    for f in ijuliaFileNames
        println("\n Running $f test\n")
        println("--------------------------------")
        println("--------------------------------\n")
        include("$f.jl")
    end
end

cd(currentPath)

end
