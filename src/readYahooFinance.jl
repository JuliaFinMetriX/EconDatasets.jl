function readYahooFinance(dates::DateRange{ISOCalendar},
                          ticker::Array{ASCIIString, 1},
                          freq=:d)
    
    #############################
    ## get download parameters ##
    #############################
    
    ## get number of tickers
    nStocks = length(ticker)
    
    ## get download urls
    urls = getUrls(dates, ticker, freq)
    
    ###################
    ## download data ##
    ###################
    
    vals = Array(AbstractTimenum, nStocks)
    
    for ii=1:nStocks
        
        filepath = download(urls[ii])
        td = readTimedata(filepath)
        
        vals[ii] = flipud(td)
    end
    vals
end

function readYahooFinance(dates::DateRange{ISOCalendar},
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
    
    filepath = download(urls[1])
    td = readTimedata(filepath)
    vals = flipud(td)
end

function getUrls(dates::DateRange{ISOCalendar},
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

function getDates(dates::DateRange{ISOCalendar})
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

dates = date(1960, 11, 26):date(2014, 7, 23)
ticker = "^GDAXI"
ticker = ["^GDAXI", "^GSPC", "BMW.DE"]

kk = readYahooFinance(dates, ticker, :w)


## one function that returns complete data for single ticker
## this function can be applied to each element of ticker array
##
## another function that returns adj_closing prices for array of
## ticker symbols in one large

kk = map((x) -> readYahooFinance(dates, [x]), ticker)
