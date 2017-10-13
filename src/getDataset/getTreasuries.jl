function getTreasuries()
    (intRates, metaData) = EconDatasets.readUSTreasuries()

    ## save on disk
    fileName = joinpath(Pkg.dir("EconDatasets"), "data", "Treasuries.csv")
    writetimearray(intRates, fileName)
end
