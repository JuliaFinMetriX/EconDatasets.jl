module TestDataset

using Base.Test
using EconDatasets
using Dates

dates = Date(1960, 11, 26):Date(2014, 7, 23)
ticker = "^GDAXI"

## read in single ticker
kk = readYahooFinance(dates, ticker, :w)

## read multiple ticker, complete data
ticker = ["^GDAXI", "^GSPC", "BMW.DE"]
kk = map((x) -> readYahooFinance(dates, x), ticker)

## read adjusted closing prices for multiple ticker symbols
dates = Date(1960, 11, 26):Date(2014, 7, 23)
ticker = ["^GDAXI", "^GSPC", "BMW.DE"]
vals = readYahooAdjClose(dates, ticker)

end
