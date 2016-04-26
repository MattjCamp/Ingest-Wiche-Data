
source(sprintf("%s/R-Code-Library/sql.data.source/sqlite.R",
               getwd()))

data.sources <- sprintf("%s/data-sources/",
                        getwd())

source("read.data.R")

df <- read.data()

db <- sqlite(sprintf("%s/dashboard.db", getwd()))

db$saveTable(df = df, tablename = "df")
