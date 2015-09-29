using Gumbo # can not be loaded inside of function => use script
using DataFrames

## hardcoded number of constituents
nAss = 505

url = "http://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
htmlContent = download(url) |>
open |>
readall |>
parsehtml

## tableHeaders = [kk.root[2][3][4][4][7][1][1][1][1][1].text,
##                 kk.root[2][3][4][4][7][1][1][2][1].text,
##                 kk.root[2][3][4][4][7][1][1][3][1][1].text,
##                 kk.root[2][3][4][4][7][1][1][4][1][1].text,
##                 kk.root[2][3][4][4][7][1][1][5][1].text,
##                 kk.root[2][3][4][4][7][1][1][6][1].text,
##                 kk.root[2][3][4][4][7][1][1][7][1].text,
##                 kk.root[2][3][4][4][7][1][1][8][1][1].text]

function accessTableEntry(htmlContent::HTMLDocument, ii::Int)
    # old wikipedia page settings
    # return htmlContent.root[2][3][4][4][7][1][ii+1][1][1][1].text
    tickSymb = htmlContent.root[2][3][5][4][7][1][ii+1][1][1][1].text
    sector = htmlContent.root[2][3][5][4][7][1][ii+1][4][1].text
    subindustry = htmlContent.root[2][3][5][4][7][1][ii+1][5][1].text
    return (tickSymb, sector, subindustry)
end

companies = UTF8String[]
sectors = UTF8String[]
subindustries = UTF8String[]
for ii=1:nAss
    try
        tickSymb, sector, subindustry = accessTableEntry(htmlContent, ii)
        push!(companies, tickSymb)
        push!(sectors, sector)
        push!(subindustries, subindustry)
    catch
    end
end

pathToStore = joinpath(Pkg.dir("EconDatasets"), "data",
                       "SP500TickerSymbols.csv")

pathToStoreConsituents = joinpath(Pkg.dir("EconDatasets"), "data",
                                  "SP500Industries.csv")

df = DataFrame(TickerSymbol = companies, Sector = sectors,
               SubIndustry = subindustries)

writecsv(pathToStore, companies)
writetable(pathToStoreConsituents, df)
