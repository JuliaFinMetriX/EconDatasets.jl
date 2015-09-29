module TestDataset

using Base.Test
using EconDatasets
using Dates

println("\n Running dataset tests\n")

## try to load all data sets

## testing non existent key
@test_throws KeyError EconDatasets.dataset("sdlkfj")

## try loading sector data
sectors = EconDatasets.dataset("Sectors")

## try loading fama french data
umd = EconDatasets.dataset("UMD")
fff = EconDatasets.dataset("FFF")

## try loading treasury rates
intRates = EconDatasets.dataset("Treasuries")

## try loading Diebold-Li interest rates
yields = EconDatasets.dataset("DieboldLi")

## try loading sp500 data
ticker = EconDatasets.dataset("SP500Ticker")
industries = EconDatasets.dataset("SP500Industries")
sp500 = EconDatasets.dataset("SP500")


end
