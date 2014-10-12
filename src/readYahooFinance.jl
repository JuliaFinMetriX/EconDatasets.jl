function readYahooAdjClose(dates::StepRange,
                          ticker::Array{ASCIIString, 1},
                          freq=:d)

    ## parallelized version for multiple stocks
    
    nStocks = length(ticker)
    allStocks = @parallel (joinSortedIdx_outer) for ii=1:nStocks
        getAdjClose(dates, ticker[ii], freq)
    end
        
    return allStocks
end

function getAdjClose(dates::StepRange,
                            ticker::ASCIIString,
                            freq=:d)
    stock = readYahooFinance(dates, ticker, freq)

    ## refine stock
    if isequal(stock, NA)
        adjClose = Timenum(DataFrame(Adj_Close = NA), [dates[end]])
    else
        adjClose = stock[:Adj_Close]
    end
    names!(adjClose.vals, [symbol(ticker)])

    return adjClose
end

function readYahooFinance(dates::StepRange,
                          ticker::ASCIIString,
                          freq=:d)
    
    #############################
    ## get download parameters ##
    #############################
    
    ## get download urls
    urls = getUrls(dates, [ticker], freq)
    
    ###################
    ## download data ##
    ###################

    try
        filepath = download(urls[1])
        td = readTimedata(filepath)
        vals = flipud(td)
    catch
        vals = NA
    end
end

function getUrls(dates::StepRange,
                 ticker::Array{ASCIIString, 1},
                 freq)
    nStocks = length(ticker)
    
    urls = Array(ASCIIString, nStocks)
    (bd, bm, by, ed, em, ey) = getDates(dates)
    
    for ii=1:nStocks
        urls[ii] = string("http://real-chart.finance.yahoo.com/table.csv?s=",
                          ticker[ii],
                          "&a=",bm,"&b=",bd,"&c=",by,
                          "&d=",em,"&e=",ed,"&f=",ey,
                          "&g=",freq,"&ignore=.csv")
    end
    urls
end

function getDates(dates::StepRange)
    ## get start and end date
    startDate = dates[1]
    endDate = dates[end]
    
    ## decompose dates
    (bd, bm, by) = (day(startDate), month(startDate), year(startDate))
    (ed, em, ey) = (day(endDate), month(endDate), year(endDate))
    
    (lpad(string(bd-1), 2, "0"),
     lpad(string(bm-1), 2, "0"),
     string(by),
     lpad(string(ed-1), 2, "0"),
     lpad(string(em-1), 2, "0"),
     string(ey))
end



################
## test cases ##
################



## one function that returns complete data for single ticker
## this function can be applied to each element of ticker array
##
## another function that returns adj_closing prices for array of
## ticker symbols in one large


