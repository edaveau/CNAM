# Chargement des packages
# A noter : L'installation de shinyauthr nécessite d'installer la librairie ilbsodium-dev
# Commande d'installation Unix : sudo apt-get install -y libsodium-dev
# Puis installer devtools sous R avec : install.packages("devtools")
# Et enfin toujours sur R : devtools::install_github("paulc91/shinyauthr")

library(dplyr)
library(shiny)
library(DT)
library(ggplot2)
library(shinythemes)
library(htmltools)
library(mongolite)
library(lubridate)
library(tidyr)
library(shinyauthr)
library(shinyjs)
library(shinydashboard)

# Dataframe contenant les utilisateurs
user_base <- data.frame(
  user = c("admin", "guest"),
  password = c("admin", "guest"),
  permissions = c("admin", "standard"),
  name = c("Administrateur", "Invité"),
  stringsAsFactors = FALSE,
  row.names = NULL
)

# Appel aux données MongoDB
ref_users <- mongo(collection = "users_ref", db = "Mediatheque", url = "mongodb://127.0.0.1:27017")
ref_docs <- mongo(collection = "ouvrages_ref", db = "Mediatheque", url = "mongodb://127.0.0.1:27017")
