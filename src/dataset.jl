function dataset(dataset_name::String)
    basename = Pkg.dir("EconDatasets", "data")

    ## resolve key names and required package
    fileDict = ["SP500" => "all_sp500_clean_logRet_jl.csv", 
                "Sectors" => "sectorAffiliation.csv",
                ]

    ## get filename
    fname = fileDict[dataset_name]
    filename = joinpath(basename, fname)

    cmdDict = ["SP500" => :(readTimedata($filename)),
               "Sectors" => :(readtable($filename , separator = ' ')),
               ]

    cmd = cmdDict[dataset_name]
    
    if !isfile(filename)
        error("Unable to locate file $filename - try
getData($dataset_name)\n") 
    else
        completeCmd = Expr(:(=), :dataVals, cmd)
        eval(completeCmd)
        return dataVals
    end
end
