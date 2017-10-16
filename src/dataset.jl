function dataset(dataset_name::String)
    basename = Pkg.dir("EconDatasets", "data")

    ## resolve key names and required package
    fileDict = Dict("SP500" => "SP500.csv",
                "Sectors" => "sectorAffiliation.csv",
                "UMD" => "UMD.csv",
                "FFF" => "FFF.csv",
                "SP500Ticker" => "SP500TickerSymbols.csv",
                "SP500Industries" => "SP500Industries.csv",
                "Indices" => "Indices.csv",
                "Treasuries" => "Treasuries.csv",
                "DieboldLi" => "DieboldLi.csv",
                "IndustryPfs" => "IndustryPfs.csv"
                )

    ## get filename
    fname = fileDict[dataset_name]
    filename = joinpath(basename, fname)

    cmdDict = Dict("SP500" => :(readTimedata($filename)),
               "Sectors" => :(readtable($filename , separator = ' ')),
               "UMD" => :(readTimedata($filename)),
               "FFF" => :(readtimearray($filename)),
               "SP500Ticker" => :(readcsv($filename)),
               "SP500Industries" => :(readtable($filename)),
               "Indices" => :(readTimedata($filename)),
               "Treasuries" => :(readtimearray($filename)),
               "DieboldLi" => :(readtimearray($filename)),
               "IndustryPfs" => :(readtimearray($filename))
               )

    cmd = cmdDict[dataset_name]

    if !isfile(filename)
        error(string("Unable to locate file $filename - ",
                     "try getDataset(\"$dataset_name\") instead \n"))
    else
        completeCmd = Expr(:(=), :dataVals, cmd)
        eval(completeCmd)
        return dataVals
    end
end
