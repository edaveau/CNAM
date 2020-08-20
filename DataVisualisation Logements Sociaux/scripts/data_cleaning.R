library(DBI)
library(RSQLite)
con <- dbConnect(SQLite(), "C:/sqlite/datavis/datavis.db")

as.data.frame(dbListTables(con))
