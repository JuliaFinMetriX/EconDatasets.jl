########################
## test ijulia tutorials
########################

ijuliaFileNames = [readFamaFrenchRaw]

println("Running ijulia tutorial tests:\n")
println(" Converting ijulia notebooks to test scripts\n")
println("--------------------------------")
println("--------------------------------\n")

currentPath = pwd()
ijuliaPath = joinpath(Pkg.dir("EconDatasets"), "ijulia_tutorials")
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
        include(string("../test/", "$f.jl"))
    end
end

cd(currentPath)
