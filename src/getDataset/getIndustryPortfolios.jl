function getIndustryPortfolios()
    # download data
    dataUrl = "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/30_Industry_Portfolios_daily_TXT.zip"
    (data, dataNames, varnames) = readFamaFrenchRaw(dataUrl)

    # pick value weighted sub-part
    selectedData = data[1]

    # get correct column names
    TimeSeries.rename(selectedData, split(varnames))

    # fix encoding of missing values
    dataVals = selectedData.values
    dataVals[dataVals .== -99.99] = 0

    cleanData = TimeSeries.TimeArray(selectedData.timestamp, dataVals, split(varnames))

    fileName = joinpath(Pkg.dir("EconDatasets"), "data", "IndustryPfs.csv")
    writetimearray(cleanData, fileName)
end
