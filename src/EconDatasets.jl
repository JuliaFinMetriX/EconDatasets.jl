## list packages that shall be automatically loaded
using DataFrames
using Datetime
using TimeData

module EconDatasets


using DataFrames
using Datetime
using TimeData

export dataset,
	## getDataset,
	readFamaFrenchRaw

include("dataset.jl")
include("readFamaFrenchRaw.jl")

end # module
