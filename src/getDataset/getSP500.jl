dates = Date(1960,1,1):Date(2015,9,25)

procIds = addprocs(3)

@everywhere using DataFrames
@everywhere using TimeSeries
@everywhere using EconDatasets

    println("\nData will be downloaded starting ", dates[1], " and ending ",
            dates[end], ".\n\n",
            "In order to change the time period,",
            " simply update the first line of \nfunction getSP500 ",
            "in getDataset/getSP500 according to your needs.\n",
            "Per default, getSP500 makes use of Julia's parallel ",
            "processing \ncapabilities and uses 3 cores to ",
            "download and process the data. \nIn order to change ",
            "this setting, simply modify the command addprocs(3).\n\n",
            "You can also find a detailed description of the ",
            "downloading procedure at\n",
            "http://grollchristian.wordpress.com/2014/09/05/sp500-data-download-julia/")

## load WikiPedia stock ticker symbols
constituents = readcsv(joinpath(Pkg.dir("EconDatasets"), "data",
                                "SP500TickerSymbols.csv"))

tickerSymb = String[ticker for ticker in constituents]

## measure time
t0 = time()

@time vals = readYahooAdjClose(dates, tickerSymb, :d)

t1 = time()
elapsedTime = t1-t0
mins, secs = divrem(elapsedTime, 60)

valsTn = convert(Timenum, vals)
pathToStore = joinpath(Pkg.dir("EconDatasets"), "data", "SP500.csv")
writetimearray(valsTn, pathToStore)

println("elapsed time: ", int(mins), " minutes, ", ceil(secs), " seconds")

rmprocs(procIds)
