function readFamaFrenchRaw(url::String)
    # download file, read it in as individual timematrices, delete all
    # downloaded files

    lines = downloadAndRemove(url)
    (startInd, endInd) = findDataBlocks(lines)
    (dataNames, varnames) = getDescriptionAndVariableName(lines, startInd)
    (vals, datesString) = splitOffDates(lines, startInd, endInd)
    valsArr = processValues(vals)
    dates = processDates(datesString)

    nDatasets = length(dates)
    data = Array{Any}(nDatasets)
    for ii=1:nDatasets
        data[ii] = TimeSeries.TimeArray(dates[ii], valsArr[ii])
    end

    return (data, dataNames, varnames)
end

function processDates(datesString)
    # transform from string to dates
    nDatasets = length(datesString)

    dates = Array{Any}(nDatasets)
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
    dates = Array{Date}(nObs)
    for ii=1:nObs
        yyyy = datesArr[ii][1:4]
        mm = datesArr[ii][5:6]
        dd = datesArr[ii][7:8]
        dates[ii] = Date(parse(Int, yyyy), parse(Int, mm), parse(Int, dd))
    end
    return dates
end

function processMonthlyDate(datesArr)
    # 200301 as string to date
    nObs = length(datesArr)
    dates = Array{Date}(nObs)
    for ii=1:nObs
        yyyy = datesArr[ii][1:4]
        mm = datesArr[ii][5:6]
        datesBeginMonth = Date(parse(Int, yyyy), parse(Int, mm), 01)
        ## dd = lastdayofmonth(datesBeginMonth)
        ## dates[ii] = Date(int(yyyy), int(mm), dd)
        dates[ii] = lastdayofmonth(datesBeginMonth)
    end
    return dates
end

function processYearlyDate(datesArr)
    # 2003 as string to date
    nObs = length(datesArr)
    dates = Array{Date}(nObs)
    for ii=1:nObs
        dates[ii] = Date(int(datesArr[ii]), 12, 31)
    end
    return dates
end

function processValues(vals)
    # transform from Array(Any, nData) to matrix
    nDatasets = length(vals)
    nVariables = length(vals[1][1])

    valsAsArr = Array{Any}(nDatasets)
    for ii=1:nDatasets
        nObs = length(vals[ii])
        valsArr = Array{Float64}(nObs, nVariables)

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

    onlyDataLines = Array{Any}(nDatasets)
    for ii=1:nDatasets
        onlyDataLines[ii] = lines[startInd[ii]:endInd[ii]]
    end

    vals = Array{Any}(nDatasets)
    datesString = Array{Any}(nDatasets)

    for jj=1:nDatasets

        data = onlyDataLines[jj]

        nObs = length(data)

        dats = Array{String}(nObs)
        remainingPart = Array{Any}(nObs)
        for ii=1:nObs
            ## get first digits as dates
            m = match(r"^ *([0-9]{4,})[^0-9]", data[ii])

            dataAsStringArray = data[ii][(length(m.match)+1):end] |>
                                  strip |>
                                  x -> replace(x, r" +", ",") |> # replace
                                  # multiple whitespaces through ","
                                  x -> split(x, ",")

            remainingPart[ii] = [parse(Float64, substr) for substr in dataAsStringArray]

            ## get matching dates
            dats[ii] = strip(m.match)
        end

        vals[jj] = remainingPart
        datesString[jj] = dats
    end

    return (vals, datesString)
end



function downloadAndRemove(url::String)

    # get filename
    filepath = download(url)
    dirName = dirname(filepath)

    run(`unzip $filepath -d $dirName`)

    # get filename of unzipped file; cut off _TXT from filename
    extInd = basename(url) |>
             x -> searchindex(x, ".") |>
  				 x -> x - 4


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
        try
            fnameUpCase = string(basename(url)[1:(extInd-1)], ".TXT")
            completeFileName = joinpath(dirName, fnameUpCase)
            lines = open(completeFileName) |>
            readlines
        catch
            fnameLowCase = string(basename(url)[1:(extInd-1)], ".txt")
            fnameLargeDaily = replace(fnameLowCase, "_daily", "_Daily")

            completeFileName = joinpath(dirName, fnameLargeDaily)
            lines = open(completeFileName) |>
            readlines

        end
    end

    # remove files from system again
    run(`rm $filepath`)
    run(`rm $completeFileName`)

    return lines
end

function findDataBlocks(lines)
    # split read in file into individual datasets
    nLines = length(lines)

    linesNoCharacters = Array{Bool}(nLines)
    for ii=1:nLines
        # match lines starting with 6 digits (date of observation) and containing
        # only digits, "-" signs or decimal dots
        linesNoCharacters[ii] = ismatch(r"^\d{6}[ -.0-9]+$",  lines[ii]) | ismatch(r"^\d{6}[ -.0-9]+\r",  lines[ii])
    end

    # find first line of block of data values, and get respective name
    startInd = Array{Int}(0)
    endInd = Array{Int}(0)
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

    if ismatch(r"^$", lines[startInd[1]-3])
        descriptionLinesAbove = 2
    end

    # there are files where only one line of variable names exists
    if ismatch(r"^$", lines[startInd[1]-2])
        descriptionLinesAbove = 2
    end

    # get dataset names
    nDatasets = length(startInd)
    dataNames = Array{String}(nDatasets)
    for ii=1:nDatasets
        dataName = startInd[ii] - descriptionLinesAbove |>
                   x -> lines[x]
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
