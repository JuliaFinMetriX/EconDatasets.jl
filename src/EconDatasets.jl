## list packages that shall be automatically loaded
using DataFrames
using Base.Dates
using TimeData

module EconDatasets


using DataFrames
using Base.Dates
using TimeData

export dataset,
	getDataset,
	readFamaFrenchRaw,
   readYahooAdjClose,
   readYahooFinance

include("dataset.jl")
include("getDataset.jl")
include("readFamaFrenchRaw.jl")
include("readYahooFinance.jl")
include("getDataset/getIndices.jl")
include("getDataset/getFFF.jl")
include("getDataset/getUMD.jl")
## include("getDataset/getSP500.jl")

end # module
