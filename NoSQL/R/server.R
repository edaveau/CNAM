shinyServer(function(input, output, session){
  
  #########################################################################
  ### Partie utilisée dans l'affichage du menu par profil d'utilisateur ###
  #########################################################################
  output$menu <- renderMenu({
    
    req(credentials()$user_auth)
    
    if(credentials()$info$user == "admin"){
      
      sidebarMenu(id = "tab",
                  menuItem(text = "Accueil", tabName = "home", icon = icon("home", lib = "font-awesome")),
                  menuItem(text = "Utilisateurs", tabName = "users", icon = icon("users", lib = "font-awesome"),
                           menuSubItem(text = "Popularité des utilisateurs", 
                                       tabName = "ensemble_users", 
                                       icon = icon("project-diagram", lib = "font-awesome")),
                           menuSubItem(text = "Listes des utilisateurs", 
                                       tabName = "users_list", 
                                       icon = icon("hand-holding-heart", lib = "font-awesome"))),
                  menuItem(text = "Ouvrages", tabName = "work", icon = icon("book-reader", lib = "font-awesome"),
                           menuSubItem(text = "Livres", 
                                       tabName = "books", 
                                       icon = icon("book", lib = "font-awesome")),
                           menuSubItem(text = "Jeux Vidéos", 
                                       tabName = "video_games", 
                                       icon = icon("gamepad", lib = "font-awesome")),
                           menuSubItem(text = "CDs Audio", 
                                       tabName = "cds", 
                                       icon = icon("compact-disc", lib = "font-awesome")),
                           menuSubItem(text = "Films", 
                                       tabName = "movies", 
                                       icon = icon("film", lib = "font-awesome"))))
      
    }else{
      sidebarMenu(id = "tab",
                  menuItem(text = "Accueil", 
                           tabName = "home", 
                           icon = icon("home", lib = "font-awesome")))
    }
    
  })

  ##################################  
  ### Afficher la page d'accueil ###
  ##################################  
  
  getPage<-function() {
    return(includeHTML("www/welcome_page.html"))
  }
  
  output$home<-renderUI({getPage()})
  
  ###################################################################
  ### Partie utilisée pour traiter les habilitations de connexion ###
  ###################################################################

  # Appel du module logout avec un déclenchement réactif de la visibilité
  logout_init <- callModule(shinyauthr::logout,
                            id = "logout",
                            active = reactive(credentials()$user_auth))
  
  # Appel du module login fournissant la dataframe, les colonnes
  # utilisateur et mot de passe ainsi que le déclenchement réactif
  credentials <- callModule(shinyauthr::login, 
                            id = "login", 
                            data = user_base,
                            user_col = user,
                            pwd_col = password,
                            log_out = reactive(logout_init()))
  
  # Retenir les informations utilisateur renvoyées par le module de login
  user_data <- reactive({credentials()$info})
  
  ###################################
  ### Ajout d'un petit calendrier ###
  ###################################
  output$date_selection <- renderUI({
    req(credentials()$user_auth)
    
    dateInput(inputId = "dateInput",
              label = textOutput("text_dateInput"),
              value = Sys.Date(),
              max = Sys.Date(),
              weekstart = 1,
              language = "fr")
  })
  
  output$text_dateInput <- renderText({
    selected_date <- input$dateInput
    selected_week <- format(as.Date(selected_date), "%V")
    paste0("Semaine actuelle : S", selected_week)
  })
  
  ##################################################
  ### Ajout des données utilisateurs et ouvrages ###
  ##################################################  
  df_users <- ref_users$find("{}", fields = "{}") %>%
    mutate(dob = ymd(dob)) %>%
    mutate(registration_date = ymd(registration_date))
  
  df_docs <- ref_docs$find("{}", fields = "{}")
  
  #########################################
  ### Données Utilisateurs et Followers ###
  #########################################
  
  output$users_social_network <- renderDT({
    
    req(credentials()$info$user == "admin")
    
    user_followed_by <- data.frame(table(unlist(df_users$follows))) %>%
      rename(user_id = Var1, followed_by = Freq) %>%
      mutate(user_id = as.character(user_id))
    
    users_sn <- df_users %>%
      mutate(nbr_followers = lengths(follows)) %>%
      left_join(user_followed_by, by = c("_id" = "user_id")) %>%
      select(name, nbr_followers, followed_by) %>%
      mutate_at(.vars = c("nbr_followers", "followed_by"), ~replace(., is.na(.), 0)) %>%
      rename(Utilisateur = name, 
             `Suit N personnes` = nbr_followers, 
             `Suivi par N personnes` = followed_by)
    
    datatable(users_sn, rownames = FALSE, options = list(
      pageLength = 20
    )) %>%
      formatStyle(columns = colnames(users_sn),
                  backgroundColor = "#282828", color = "white")
  
  })
  
  ########################################################
  ### Données des listes personnelles des utilisateurs ###
  ########################################################
  
  work_ref <- df_docs %>%
    mutate(titre = ifelse(test = is.na(titre), yes = album, no = titre)) %>%
    select(`_id`, titre)
  
  users_list <- df_users %>%
    unnest_longer(personalList) %>%
    left_join(work_ref, by = c("personalList" = "_id")) %>%
    select(name, titre) %>%
    arrange(name)
  
  ### Création du filtre
  
  output$users_list_filter <- renderUI({
    
    req(credentials()$info$user == "admin")
    
    selectInput("users_list",
                label = "Utilisateur :",
                choices = as.list(unique(users_list$name)))
    
  })
  
  output$work_list <- renderDT({
    
    liste_ouvrages <- users_list %>%
      rename(Utilisateur = name, `Nom de l'oeuvre` = titre) %>%
      filter(Utilisateur == input$users_list)
    
    datatable(liste_ouvrages, rownames = FALSE, options = list(
      pageLength = 20
    )) %>%
      formatStyle(columns = colnames(liste_ouvrages),
                  backgroundColor = "#282828", color = "white")
    
  })
  
  ############################  
  ### Affichage des livres ###
  ############################  

  output$books_collection <- renderDT({
    
    df_books <- df_docs %>%
      filter(type == "Livre") %>%
      select(titre, auteur, `sous-type`, categorie) %>%
      replace(is.na(.), "Non renseigné")
    
    datatable(df_books, rownames = FALSE, options = list(
      pageLength = 20
    )) %>%
      formatStyle(columns = colnames(df_books),
                  backgroundColor = "#282828", color = "white")
    
  })
  
  ##########################  
  ### Affichage des jeux ###
  ##########################  

  output$games_collection <- renderDT({
    
    df_games <- df_docs %>%
      filter(type == "Jeu video") %>%
      select(titre, `sous-type`, categorie) %>%
      replace(is.na(.), "Non renseigné")
    
    datatable(df_games, rownames = FALSE, options = list(
      pageLength = 20
    )) %>%
      formatStyle(columns = colnames(df_games),
                  backgroundColor = "#282828", color = "white")
    
  })
  
  #########################  
  ### Affichage des CDs ###
  #########################  
  
  output$cds_collection <- renderDT({
    
    df_cds <- df_docs %>%
      filter(type == "CD") %>%
      select(album, `Groupe(s)`, `sous-type`, categorie) %>%
      replace(is.na(.), "Non renseigné")
    
    datatable(df_cds, rownames = FALSE, options = list(
      pageLength = 20
    )) %>%
      formatStyle(columns = colnames(df_cds),
                  backgroundColor = "#282828", color = "white")
    
  })

  ###########################  
  ### Affichage des films ###
  ###########################  
  
  output$movies_collection <- renderDT({
    
    df_movies <- df_docs %>%
      filter(type == "Film") %>%
      select(titre, `sous-type`, categorie) %>%
      replace(is.na(.), "Non renseigné")
    
    datatable(df_movies, rownames = FALSE, options = list(
      pageLength = 20
    )) %>%
      formatStyle(columns = colnames(df_movies),
                  backgroundColor = "#282828", color = "white")
    
  })
  
    
})