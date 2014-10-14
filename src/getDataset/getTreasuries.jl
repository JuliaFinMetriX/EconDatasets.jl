function getTreasuries()
    dates = Date(1910,1,1):Date(2014,9,30)
    (intRates, metaData) = EconDatasets.readUSTreasuries(dates)

    ## save on disk
    fileName = joinpath(Pkg.dir("EconDatasets"), "data", "Treasuries.csv")
    writeTimedata(fileName, intRates)
end
