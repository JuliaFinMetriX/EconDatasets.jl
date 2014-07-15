module TestDataset

using Base.Test
using EconDatasets

println("\n Running dataset tests\n")

## testing non existent key
@test_throws KeyError EconDatasets.dataset("sdlkfj")

## testing not yet loaded data
@test_throws Exception EconDatasets.dataset("SP500")

end
