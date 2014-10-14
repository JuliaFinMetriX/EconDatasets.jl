using Gumbo # can not be loaded inside of function => use script

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
    return htmlContent.root[2][3][4][4][7][1][ii+1][1][1][1].text
end

companies = UTF8String[]
for ii=1:505
    try
        companyName = accessTableEntry(htmlContent, ii)
        push!(companies, companyName)
    catch
    end
end

pathToStore = joinpath(Pkg.dir("EconDatasets"), "data", "SP500TickerSymbols.csv")

writecsv(pathToStore, companies)
