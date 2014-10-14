# U.S. government securities/Treasury constant maturities/Nominal
function readUSTreasuries(dates::StepRange, )

    ## compose url
    url1 =
        "http://www.federalreserve.gov/datadownload/Output.aspx?rel=H15&series=bf17364827e38702b42a58cf8eaa3f78&lastObs=&from="
    url2 = "&to="
    url3 = "&filetype=csv&label=include&layout=seriescolumn"
    dat1 = EconDatasets.convertFedDate(dates[1])
    dat2 = EconDatasets.convertFedDate(dates[end])
    url = string(url1, dat1, url2, dat2, url3)

    ## download and format data
    filename = download(url)
    data = readtable(filename, skipstart = 5,
                     nastrings = ["", "ND"])
    dats = Date[Date(data[ii, 1]) for ii=1:size(data, 1)]
    intRates = Timenum(data[:, 2:end], dats)
    
    ## get metadata
    metaData = readtable(filename, nrows = 6, header = false,
                         nastrings = ["", "ND"])
    metaDf = EconDatasets.formatMetaData(metaData)

    return (intRates, metaDf)
end

function convertFedDate(dat::Date)
    yyyy = string(Dates.year(dat))
    m = string(Dates.month(dat))
    if length(m) == 1
        m = string("0", m)
    end
    d = string(Dates.day(dat))
    if length(d) == 1
        d = string("0", d)
    end
    return string(m, "/", d, "/", yyyy)
end

function formatMetaData(metaData::DataFrame)
    nVars = size(metaData, 2)-1
    nMeta = size(metaData, 1)
    varNames = Symbol[symbol(metaData[ii, 1]) for ii=1:nMeta]
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
