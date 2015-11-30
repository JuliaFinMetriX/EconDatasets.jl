function getIndices()
    dates = Date(1920,1,1):Date(2015,9,25)

    ## measure time
    t0 = time()

    ## procIds = addprocs(3)
    
    ## @everywhere using DataFrames
    ## @everywhere using TimeData
    ## @everywhere using EconDatasets

indexSymb = ["^DJI",
"^DJT",
"^DJU",
"^DJA",
"^TV.N",
"^NYA",
"^NUS",
"^NIN",
"^NWL",
"^NTM",
"^IXIC",
"^TV.O",
"^NDX",
"^IXBK",
"^IXFN",
"^IXF",
"^IXID",
"^IXIS",
"^IXK",
"^IXTR",
"^IXUT",
"^NBI",
"^GSPC",
"^OEX",
"^MID",
"^SML",
"^SPSUPX",
"^XAX",
"^IIX",
"^NWX",
"^XMI",
"^PSE",
"^SOXX",
"^RUI",
"^RUT",
"^RUA",
"^DOT",
"^DWC",
"^BATSK",
"^TYX",
"^TNX",
"^FVX",
"^IRX",
"^DJC",
"^XAU",
"^NSEBANK",
"^CRSLDX",
"^CNXIT",
"^CRSMID",
"^NSEI",
"^NSMIDCP",
"^AORD",
"^SSEC",
"^HSI",
"^BSESN",
"^JKSE",
"^KLSE",
"^N225",
"^NZ50",
"^STI",
"^KS11",
"^TWII",
"^ATX",
"^BFX",
"^FCHI",
"^GDAXI",
"^OSEAX",
"^MIBTEL",
"^SSMI",
"^FTSE",
"FPXAA.PR",
"MICEXINDEXCF.ME",
"GD.AT",
"^CCSI",
"^TA100",
"^MERV",
"^BVSP",
"^GSPTSE",
"^MXX",
"^GSPC",
"BSE-100.BO",
"BSE-200.BO",
"BSE-500.BO",
"BSE-AUTO.BO",
"BSE-BANK.BO",
"BSE-CD.BO",
"BSE-FMCG.BO",
"BSE-HC.BO",
"BSE-IT.BO",
"BSE-METAL.BO",
"BSE-MIDCAP.BO",
"BSE-OILGAS.BO",
"^BSESN",
"BSE-SMLCAP.BO",
    "BSE-TECK.BO"]

## download indices
indexPrices = readYahooAdjClose(dates, indexSymb)
    
valsTn = convert(Timenum, indexPrices)

## delete columns without observations
##------------------------------------

onlyNAs = x -> all(isna(x))

## find columns without observations
onlyNANames = Symbol[]
for col in eachcol(valsTn.vals)
    if onlyNAs(col[2])
        push!(onlyNANames, col[1])
    end
end

## delete columns
for nam in onlyNANames
    delete!(valsTn.vals, nam)
end

## save result
##------------

pathToStore = joinpath(Pkg.dir("EconDatasets"), "data", "Indices.csv")
writeTimedata(pathToStore, valsTn)

## rmprocs(procIds)

t1 = time()
elapsedTime = t1-t0
mins, secs = divrem(elapsedTime, 60)

println("elapsed time: ", int(mins), " minutes, ", ceil(secs), "
seconds")

end
