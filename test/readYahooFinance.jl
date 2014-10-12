module TestDataset

using Base.Test
using EconDatasets
using Debug

dates = date(1960, 11, 26):date(2014, 7, 23)
ticker = "^GDAXI"

## read in single ticker
kk = readYahooFinance(dates, ticker, :w)

## read multiple ticker, complete data
ticker = ["^GDAXI", "^GSPC", "BMW.DE"]
kk = map((x) -> readYahooFinance(dates, x), ticker)

## read adjusted closing prices for multiple ticker symbols
dates = date(1960, 11, 26):date(2014, 7, 23)
ticker = ["^GDAXI", "^GSPC", "BMW.DE"]
tickerSymb = Symbol[symbol(tick) for tick in ticker]
vals = readYahooFinance(dates, ticker)

end
