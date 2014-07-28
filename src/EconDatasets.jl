## list packages that shall be automatically loaded
using DataFrames
using Datetime
using TimeData

module EconDatasets


using DataFrames
using Datetime
using TimeData

export dataset,
	getDataset,
	readFamaFrenchRaw

include("dataset.jl")
include("getDataset.jl")
include("readFamaFrenchRaw.jl")
include("readYahooFinance.jl")
include("getFamaFrench.jl")

end # module
