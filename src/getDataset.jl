function getDataset(dataset_name::String)

        ## resolve key names and required package
    fileDict = ["FFF" => :(EconDatasets.getFFF()),
                "UMD" => :(EconDatasets.getUMD())
                ]

    downloadFunc = fileDict[dataset_name]
    eval(downloadFunc)
end
