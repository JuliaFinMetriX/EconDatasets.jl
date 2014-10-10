function getFFF()
    factorUrl =
        "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/F-F_Research_Data_Factors_daily.zip"
    (data, dataNames, varnames) = readFamaFrenchRaw(factorUrl)

    newVarnames = [:MktRf, :SMB, :HML, :RF]
    rename!(data[1].vals, names(data[1].vals), newVarnames)

    fileName = joinpath(Pkg.dir("EconDatasets"), "data", "FFF.csv")
    writeTimedata(fileName, data[1])
end
