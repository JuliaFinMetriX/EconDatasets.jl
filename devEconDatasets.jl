# development script for EconDatasets

using DynAssMgmt
using EconDatasets
using TimeSeries

cd("/home/chris/scalable/julia/EconDatasets.jl/")

url = "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/38_Industry_Portfolios_daily_TXT.zip"

dataArray, descriptions, varnames = readFamaFrenchRaw(url)

varnames


data = dataArray[1]
rename(data, split(varnames))

dataVals = data.values
dataVals[dataVals .== -99.99] = 0

cleanData = TimeSeries.TimeArray(data.timestamp, dataVals, split(varnames))

fieldnames(ReturnType())






retType = ReturnType(true, false, Dates.Day(1), false)
rets = Returns(cleanData, retType)

aggrPerfs = aggregateReturns(rets, true)

aggrLogPerfs = TimeSeries.TimeArray(aggrPerfs.timestamp, log.(aggrPerfs.values + 1), aggrPerfs.colnames)

DynAssMgmt.tsPlot(aggrLogPerfs)

ewmaEstimator = EWMA(0.95, 0.99)

thisUniv = apply(ewmaEstimator, rets)

Plots.plot(thisUniv, rets.data.colnames)


xx = dataset("Sectors")
xx = dataset("UMD")
