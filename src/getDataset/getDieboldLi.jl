function getDieboldLi()
    ## download data as string array
    rawData = "http://www.ssc.upenn.edu/~fdiebold/papers/paper49/FBFITTED.txt" |>
        download |>
        open |>
        readlines

    ## get lines with digits, space or point only
    criterion = r"^[0-9]*[\s0123456789\.]+$"
    metadataRemoved = [ismatch(criterion, line) for line in rawData] |>
        x -> rawData[x]

    ## extract values from each pair of successive lines
    nObs = length(metadataRemoved)
    valsArr = [processDoubleLine(metadataRemoved[ii:ii+1]) for
               ii=1:2:nObs]

    ## format resulting values
    dats = Date[x[1] for x in valsArr]
    vals = vcat(transpose([x[2] for x in valsArr])...)

    nams = ["m1",
            "m3",
            "m6",
            "m9",
            "m12",
            "m15",
            "m18",
            "m21",
            "m24",
            "m30",
            "m36",
            "m48",
            "m60",
            "m72",
            "m84",
            "m96",
            "m108",
            "m120" ]

    tm = TimeSeries.TimeArray(dats, vals, nams)

    fileName = joinpath(Pkg.dir("EconDatasets"), "data", "DieboldLi.csv")
    writetimearray(tm, fileName)

end

function processDoubleLine(dataStr::Array)
    ## return date and vector of values
    dateEntry = string(dataStr[1], " ", dataStr[2])

    ## split into individual entries
    indEntries = split(dateEntry, " ", limit=1000, keep=false)

    ## process date
    datStr = String(indEntries[1])
    dat = Date(*(datStr[1:4], "-", datStr[5:6], "-",
                      datStr[7:8]))

    ## get values for other entries
    vals = Float64[parse(Float64, indEntries[ii]) for
                   ii=2:length(indEntries)]

    return dat, vals
end
