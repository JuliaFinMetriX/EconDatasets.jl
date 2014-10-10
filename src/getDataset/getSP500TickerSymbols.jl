using Gumbo

url = "http://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
htmlContent = download(url) |>
open |>
readall |>
parsehtml

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
