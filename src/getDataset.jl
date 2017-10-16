function getDataset(dataset_name::String)
    pathToScripts = joinpath(Pkg.dir("EconDatasets"), "src/getDataset/")

    ## resolve key names and required package
    fileDict = Dict("FFF" => :(EconDatasets.getFFF()),
                "UMD" => :(EconDatasets.getUMD()),
                "SP500" => :(include(string($pathToScripts,
                                            "getSP500.jl"))),
                "SP500Ticker" => :(include(string($pathToScripts,
                                                  "getSP500TickerSymbols.jl"))),
                "SP500Industries" => :(include(string($pathToScripts,
                                                      "getSP500TickerSymbols.jl"))),
                "Indices" => :(EconDatasets.getIndices()),
                "Treasuries" => :(EconDatasets.getTreasuries()),
                "DieboldLi" => :(EconDatasets.getDieboldLi()),
                "IndustryPfs" => :(EconDatasets.getIndustryPortfolios())
                )

    downloadFunc = fileDict[dataset_name]
    eval(downloadFunc)
end
