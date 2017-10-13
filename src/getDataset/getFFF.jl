function getFFF()
    factorUrl =
        "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/F-F_Research_Data_Factors_daily_TXT.zip"
    (data, dataNames, varnames) = readFamaFrenchRaw(factorUrl)

    newVarnames = ["MktRf", "SMB", "HML", "RF"]
    finalData = TimeSeries.rename(data[1], newVarnames)

    fileName = joinpath(Pkg.dir("EconDatasets"), "data", "FFF.csv")
    writetimearray(finalData, fileName)
end
