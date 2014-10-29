module TestTreasuryRates

using Base.Test
using EconDatasets
using Dates

@test convertFedDate(Date(2014, 10,23)) == "10/23/2014"

end
