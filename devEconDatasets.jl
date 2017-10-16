# development script for EconDatasets

using DynAssMgmt
using EconDatasets
using TimeSeries

cd("/home/chris/scalable/julia/EconDatasets.jl/")

# download data
getDataset("IndustryPfs")

# load data
xxRets = dataset("IndustryPfs")

# store with information regarding the return type
retType = ReturnType(true, false, Dates.Day(1), false)
rets = Returns(xxRets, retType)

# derive associated prices
synthPrices = rets2prices(rets, 1.0, true)
logSynthPrices = getLogPrices(synthPrices)

function getLogPrices(prices::TimeSeries.TimeArray)
    return TimeSeries.TimeArray(prices.timestamp, log.(prices.values), prices.colnames)
end

# plot prices over time
DynAssMgmt.tsPlot(logSynthPrices)

# visualize universe
ewmaEstimator = EWMA(1, 1)
thisUniv = apply(ewmaEstimator, rets)
Plots.plot(thisUniv, rets.data.colnames)


## define efficient frontier / diversfication frontier strategies
DynAssMgmt.getUnivExtrema(thisUniv)
sigTargets = [linspace(1., 1.2, 15)...]

# get efficient frontier
effFrontStrats = EffFront(10)
effFrontWgts = apply(effFrontStrats, thisUniv)

# get as strategy types
diversTarget = 0.8
divFrontStrats = DivFront(diversTarget, sigTargets)
divFrontWgts = apply(divFrontStrats, thisUniv)

## mu/sigma results for full series of portfolios
DynAssMgmt.vizPfSpectrum(thisUniv, effFrontWgts[:])
DynAssMgmt.vizPfSpectrum!(thisUniv, divFrontWgts[:])

##
DynAssMgmt.wgtsOverStrategies(divFrontWgts)
