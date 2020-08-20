dashboardPage(
  
  # Entête du dashboard
  dashboardHeader(title = "Médiathèque",
                  # Partie réservée à la connexion shinyauthr
                  tags$li(class = "dropdown", 
                          style = "padding: 8px;",
                          shinyauthr::logoutUI("logout"))),
  
  # Barre latérale du dashboard
  dashboardSidebar(
    sidebarMenuOutput("menu")
  ),
  
  # Contenu du dashboard
  dashboardBody(
    
    # Icône utilisée par le dashboard
    tags$head(tags$link(rel = "shortcut icon", href = "favicon.ico")),
    
    # On active shinyjs
    useShinyjs(),
    # On ajoute le bouton de logout
    div(class = "pull-right", logoutUI(id = "logout")),
    # On ajoute le bouton de login
    loginUI(id = "login"),
    
    # On ajoute enfin les éléments du body
    fluidRow(
      column(width = 10,
             tabItems(
               tabItem(tabName = "home", htmlOutput("home")),
               tabItem(tabName = "ensemble_users", dataTableOutput("users_social_network")),
               tabItem(tabName = "users_list", uiOutput("users_list_filter"), dataTableOutput("work_list")),
               tabItem(tabName = "books", dataTableOutput("books_collection")),
               tabItem(tabName = "video_games", dataTableOutput("games_collection")),
               tabItem(tabName = "cds", dataTableOutput("cds_collection")),
               tabItem(tabName = "movies", dataTableOutput("movies_collection"))
             )),
      column(width = 2,
             fluidRow(
               uiOutput("date_selection")
             ))
    )
    
  )
  
)