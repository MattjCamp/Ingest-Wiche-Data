
# Reads WICHE metro data, combines each spreadsheet,
# reshapes to long and wide formats, cleans column names
# and generates a dataset without the race subgroups.
#
# Everything is stored in the SQL database named
# dashboard.db. 
#
# The metro totals are also exported as a csv file
# named metro_totals.csv

library(reshape)
library(stringr)
source(sprintf("%s/R-Code-Library/sql.data.source/sqlite.R",
               getwd()))
source("read.data.R")

data.sources <- sprintf("%s/data-sources/",
                        getwd())

df <- read.data()

db <- sqlite(sprintf("%s/dashboard.db", getwd()))

db$dropTable("raw_data")
db$saveTable(df = df, tablename = "raw_data")

d <- melt(data = df,
          id.vars = c(1:2),
          measure.vars = c(3:8)
          )

d <- d[order(d$Metro, d$Academic_Year), ]

db$dropTable(tablename = "raw_long")
db$saveTable(df = d, tablename = "raw_long")

d <- reshape(d, 
             timevar = "Academic_Year",
             times = "value",
             idvar = c("Metro", "variable"),
             direction = "wide")

d <- d[order(d$Metro), ]
names(d)[2] <- "Race"
names(d) <- str_replace_all(names(d), "value.", "AY")

db$dropTable(tablename = "cleaned_wide")
db$saveTable(df = d, tablename = "cleaned_wide")

d <- d[d$Race == "Total", c(1, 3:28)]
db$dropTable(tablename = "metro_totals")
db$saveTable(df = d, tablename = "metro_totals")

# EXPORT TO CSV

write.table(x = d, file = "metro_totals.csv", row.names = FALSE, sep = ",")

