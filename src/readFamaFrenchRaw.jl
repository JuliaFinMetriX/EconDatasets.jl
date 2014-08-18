function readFamaFrenchRaw(url::ASCIIString)
    # download file, read it in as individual timematrices, delete all
    # downloaded files

    lines = downloadAndRemove(url)
    (startInd, endInd) = findDataBlocks(lines)
    (dataNames, varnames) = getDescriptionAndVariableName(lines, startInd)
    (vals, datesString) = splitOffDates(lines, startInd, endInd)
    valsArr = processValues(vals)
    dates = processDates(datesString)

    nDatasets = length(dates)
    data = Array(Any, nDatasets)
    for ii=1:nDatasets
        tm = Timematr(convert(DataFrame, valsArr[ii]), dates[ii])
        data[ii] = tm
    end

    return (data, dataNames, varnames)
end

function processDates(datesString)
    # transform from string to dates
    nDatasets = length(datesString)

    dates = Array(Any, nDatasets)
    for ii=1:nDatasets
        exampleDate = datesString[ii][1]

        if length(exampleDate) == 4
            dates[ii] = processYearlyDate(datesString[ii])
        elseif length(exampleDate) == 6
            dates[ii] = processMonthlyDate(datesString[ii])
        elseif length(exampleDate) == 8
            dates[ii] = processDailyDate(datesString[ii])
        end
    end
    return dates
end

function processDailyDate(datesArr)
    # 20030308 as string to date
    nObs = length(datesArr)
    dates = Array(Date, nObs)
    for ii=1:nObs
        yyyy = datesArr[ii][1:4]
        mm = datesArr[ii][5:6]
        dd = datesArr[ii][7:8]
        dates[ii] = Date(int(yyyy), int(mm), int(dd))
    end
    return dates
end

function processMonthlyDate(datesArr)
    # 200301 as string to date
    nObs = length(datesArr)
    dates = Array(Date, nObs)
    for ii=1:nObs
        yyyy = datesArr[ii][1:4]
        mm = datesArr[ii][5:6]
        datesBeginMonth = Date(int(yyyy), int(mm), 01)
        dd = lastdayofmonth(datesBeginMonth)
        dates[ii] = Date(int(yyyy), int(mm), dd)
    end
    return dates
end

function processYearlyDate(datesArr)
    # 2003 as string to date
    nObs = length(datesArr)
    dates = Array(Date, nObs)
    for ii=1:nObs
        dates[ii] = Date(int(datesArr[ii]), 12, 31)
    end
    return dates
end

function processValues(vals)
    # transform from Array(Any, nData) to matrix
    nDatasets = length(vals)
    nVariables = length(vals[1][1])

    valsAsArr = Array(Any, nDatasets)
    for ii=1:nDatasets
        nObs = length(vals[ii])
        valsArr = Array(Float64, nObs, nVariables)

        for jj=1:nObs
            valsArr[jj, :] = vals[ii][jj]
        end
        valsAsArr[ii] = valsArr
    end
    return valsAsArr
end

function splitOffDates(lines, startInd, endInd)
    # for individual dataset, split off dates and values 
    nDatasets = length(startInd)

    onlyDataLines = Array(Any, nDatasets)
    for ii=1:nDatasets
        onlyDataLines[ii] = lines[startInd[ii]:endInd[ii]]
    end
    
    vals = Array(Any, nDatasets)
    datesString = Array(Any, nDatasets)

    for jj=1:nDatasets
        
        data = onlyDataLines[jj]

        nObs = length(data)

        dats = Array(Union(ASCIIString,UTF8String), nObs)
        remainingPart = Array(Any, nObs) 
        for ii=1:nObs
            ## get first digits as dates
            m = match(r"^ *([0-9]{4,})[^0-9]", data[ii])

            remainingPart[ii] = data[ii][(length(m.match)+1):end] |> 
                                  strip |>
                                  x -> replace(x, r" +", ",") |> # replace
                                  # multiple whitespaces through
                                  # ","
                                  x -> split(x, ",") |>
                                  float64
        
            ## get matching dates
            dats[ii] = strip(m.match)
        end
        
        vals[jj] = remainingPart
        datesString[jj] = dats
    end

    return (vals, datesString)
end



function downloadAndRemove(url::ASCIIString)

    # get filename
    filepath = download(url)
    dirName = dirname(filepath)

    run(`unzip $filepath -d $dirName`)

    # get filename of unzipped file
    extInd = basename(url) |>
             x -> searchindex(x, ".")

    
    # read in file
    fnameLowCase = string(basename(url)[1:(extInd-1)], ".txt")
    completeFileName = joinpath(dirName, fnameLowCase)
    lines = []
    try
        fnameLowCase = string(basename(url)[1:(extInd-1)], ".txt")
        completeFileName = joinpath(dirName, fnameLowCase)
        lines = open(completeFileName) |>
    	         readlines
    catch
        fnameUpCase = string(basename(url)[1:(extInd-1)], ".TXT")
        completeFileName = joinpath(dirName, fnameUpCase)
        lines = open(completeFileName) |>
    	         readlines
    end

    # remove files from system again
    run(`rm $filepath`)
    run(`rm $completeFileName`)

    return lines
end

function findDataBlocks(lines)
    # split read in file into individual datasets
    nLines = length(lines)

    linesNoCharacters = Array(Bool, nLines)
    for ii=1:nLines
        linesNoCharacters[ii] = ismatch(r"^[ -.0-9]+\r\n$",  lines[ii])
    end

    # find first line of block of data values, and get respective name
    startInd = Array(Any, 0)
    endInd = Array(Any, 0)
    for ii=2:nLines
        # if false followed by true: data block start
        if linesNoCharacters[ii] & !(linesNoCharacters[ii-1])
            push!(startInd, ii)
        end

        # if true followed by false: data block end
        if !(linesNoCharacters[ii]) & linesNoCharacters[ii-1]
            push!(endInd, ii-1)
        end
    end

    # if no copyright at end of file and values right until the bottom 
    if linesNoCharacters[end] == true
        push!(endInd, nLines)
    end
        
    return (startInd, endInd)
end

function getDescriptionAndVariableName(lines, startInd)
    # is two or three lines before start an empty line?
    descriptionLinesAbove = 3
    
    if ismatch(r"^\r\n$", lines[startInd[1]-3])
        descriptionLinesAbove = 2
    end

    # there are files where only one line of variable names exists
    if ismatch(r"^\r\n$", lines[startInd[1]-2])
        descriptionLinesAbove = 2
    end

    # get dataset names
    nDatasets = length(startInd)
    dataNames = Array(Symbol, nDatasets)
    for ii=1:nDatasets
        dataName = startInd[ii] - descriptionLinesAbove |>
                   x -> lines[x] |>
                   symbol
        dataNames[ii] = dataName
    end

    # get variable names
    if descriptionLinesAbove == 3 # two lines of variable names
        varnames = lines[(startInd[1]-2):(startInd[1]-1)]
    else
        varnames = lines[(startInd[1]-1)]
    end

    return (dataNames, varnames)
end



