## list packages that shall be automatically loaded
module EconDatasets

using DataFrames
using TimeSeries
using Base.Dates

export dataset,
	getDataset,
	readFamaFrenchRaw,
	readUSTreasuries,
	readYahooAdjClose,
	readYahooFinance

## load interactive functions
include("readFamaFrenchRaw.jl")
include("readYahooFinance.jl")
include("readTreasuryRates.jl")

include("dataset.jl")
include("getDataset.jl")

## calls to interactive functions with fixed inputs
include("getDataset/getIndices.jl")
include("getDataset/getFFF.jl")
include("getDataset/getUMD.jl")
include("getDataset/getTreasuries.jl")
include("getDataset/getDieboldLi.jl")
include("getDataset/getIndustryPortfolios.jl")

# don't include: script would run on each startup!
## include("getDataset/getSP500.jl")
## include("getDataset/getSP500TickerSymbols.jl")

end # module
