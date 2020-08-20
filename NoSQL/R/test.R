pacman::p_load(mongolite, dplyr, lubridate)

ref_users <- mongo(collection = "users_ref", db = "Mediatheque", url = "mongodb://127.0.0.1:27017")
ref_docs <- mongo(collection = "ouvrages_ref", db = "Mediatheque", url = "mongodb://127.0.0.1:27017")

df_users <- ref_users$find("{}", fields = "{}") %>%
  mutate(dob = ymd(dob)) %>%
  mutate(registration_date = ymd(registration_date))
  
df_docs <- ref_docs$find("{}", fields = "{}")

######### Social Network

user_followed_by <- data.frame(table(unlist(df_users$follows))) %>%
  rename(user_id = Var1, followed_by = Freq) %>%
  mutate(user_id = as.character(user_id))

users_sn <- df_users %>%
  mutate(nbr_followers = lengths(follows)) %>%
  left_join(user_followed_by, by = c("_id" = "user_id")) %>%
  select(name, nbr_followers, followed_by) %>%
  mutate_at(.vars = c("nbr_followers", "followed_by"), ~replace(., is.na(.), 0)) %>%
  rename(Utilisateur = name, 
         `Nb Utilisateurs Suivis` = nbr_followers, 
         `Nb Utilisateurs Suivi par` = followed_by)

datatable(users_sn, rownames = FALSE, options = list(
  pageLength = 20
)) %>%
  formatStyle(columns = colnames(users_sn),
              backgroundColor = "#282828", color = "white")

######### Ouvrages favoris

work_ref <- df_docs %>%
  mutate(titre = ifelse(test = is.na(titre), yes = album, no = titre)) %>%
  select(`_id`, titre)

users_list <- df_users %>%
  unnest_longer(personalList) %>%
  left_join(work_ref, by = c("personalList" = "_id")) %>%
  select(name, titre)

edition <- df_docs$edition

df_books <- df_docs %>%
  filter(type == "Livre") %>%
  select(titre, auteur, `sous-type`, categorie) %>%
  bind_cols(edition$Nombre_de_pages) %>%
  replace_na("Non renseigné")

  