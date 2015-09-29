function getUMD()
    umdUrl = "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/F-F_Momentum_Factor_daily_TXT.zip"
    (data, dataNames, varnames) = readFamaFrenchRaw(umdUrl)

    newVarnames = [:UMD]
    rename!(data[1].vals, names(data[1].vals), newVarnames)

    fileName = joinpath(Pkg.dir("EconDatasets"), "data", "UMD.csv")
    writeTimedata(fileName, data[1])

end
