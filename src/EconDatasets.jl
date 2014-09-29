## list packages that shall be automatically loaded
using DataFrames
using Dates
using TimeData

module EconDatasets


using DataFrames
using Dates
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
include("getFamaFrench.jl")

end # module
