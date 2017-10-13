# U.S. government securities/Treasury constant maturities/Nominal
function readUSTreasuries()

    ## set url
    url = "https://www.federalreserve.gov/datadownload/Output.aspx?rel=H15&series=bf17364827e38702b42a58cf8eaa3f78&lastobs=&from=&to=&filetype=csv&label=include&layout=seriescolumn&type=package"

    ## download and format data
    filename = download(url)
    data = readtable(filename, skipstart = 5,
                     nastrings = ["", "ND"])
    dats = Date[Date(data[ii, 1]) for ii=1:size(data, 1)]

    nObs, nCols = size(data)
    vals = zeros(Float64, nObs, nCols - 1)
    for ii=1:(nCols-1)
        xx = data[:, ii+1]
        thisvals = xx.data
        thisvals[xx.na] = NaN
        vals[:, ii] = thisvals
    end

    nams = names(data[:, 2:end])
    nams = [String(thisNam) for thisNam in nams]
    intRates = TimeSeries.TimeArray(dats, vals, nams)

    ## get metadata
    metaData = readtable(filename, nrows = 6, header = false,
                         nastrings = ["", "ND"])
    metaDf = EconDatasets.formatMetaData(metaData)

    return (intRates, metaDf)
end

function convertFedDate(dat::Date)
    yyyy = String(Dates.year(dat))
    m = String(Dates.month(dat))
    if length(m) == 1
        m = String("0", m)
    end
    d = String(Dates.day(dat))
    if length(d) == 1
        d = String("0", d)
    end
    return String(m, "/", d, "/", yyyy)
end

function formatMetaData(metaData::DataFrame)
    nVars = size(metaData, 2)-1
    nMeta = size(metaData, 1)
    varNames = Symbol[Symbol(metaData[ii, 1]) for ii=1:nMeta]
    df = DataFrame()
    for ii=nMeta:-1:1
        vals = DataArray(typeof(metaData[ii, 2]), nVars)
        for jj=1:nVars
            vals[jj] = metaData[ii, jj+1]
        end
        df[varNames[ii]] = vals
    end
    return df
end
