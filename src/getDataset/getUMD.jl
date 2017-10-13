function getUMD()
    umdUrl = "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/F-F_Momentum_Factor_daily_TXT.zip"
    (data, dataNames, varnames) = readFamaFrenchRaw(umdUrl)

    newVarnames = ["UMD"]
    finalData = TimeSeries.rename(data[1], newVarnames)

    fileName = joinpath(Pkg.dir("EconDatasets"), "data", "UMD.csv")
    writetimearray(finalData, fileName)

end
