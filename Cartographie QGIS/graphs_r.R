# Import des packages
pacman::p_load(gridExtra, mapview, sf, tidyverse)

# Import des fichiers
files_dir <- "../data/Projet types d'agriculture"
agri <- list.files(path = files_dir, pattern = "*.gpkg")

for (i in 1:length(agri)) assign(gsub("\\..*", "", agri)[i], 
                                 st_read(paste0(files_dir, "/", agri[i])) %>% 
                                   st_set_crs(3857))

limite_commune <- st_read(dsn = "data/limites le loroux bottereau.gpkg") %>%
  st_set_crs(3857)

surface_llb <- as.numeric(as.character(st_area(limite_commune)))

# Création d'une dataframe simple sur laquelle effectuer les opérations :
df <- data.frame("annee_agricole"=c("donnees_agricoles_1949", "donnees_agricoles_1999", "donnees_agricoles_2004",
                                    "donnees_agricoles_2009", "donnees_agricoles_2012", "donnees_agricoles_2016"), 
                 "area"=c(sum(st_area(donnees_agricoles_1949)), sum(st_area(donnees_agricoles_1999)),
                                      sum(st_area(donnees_agricoles_2004)), sum(st_area(donnees_agricoles_2009)),
                                      sum(st_area(donnees_agricoles_2012)), sum(st_area(donnees_agricoles_2016))))

# Nettoyage de la dataframe
df$surface_parcelle <- as.numeric(as.character(df$area))

# Calcul des surfaces
df <- df %>%
  mutate(pourc_terrain_agri = (.$surface_parcelle/surface_llb)*100)

export_table <- data.frame("Année"=c("Surface agricole 1949", "Surface agricole 1999", "Surface agricole 2004",
                                                                 "Surface agricole 2009", "Surface agricole 2012", "Surface agricole 2016"), 
                           "Pourcentage_Commune"=df$pourc_terrain_agri)

export_table$Pourcentage_Commune <- round(export_table$Pourcentage_Commune, 2)
export_table$Pourcentage_Commune <- paste0(export_table$Pourcentage_Commune, " %")

### Partie 1 - Mise en page de l'évolution des terrains agricoles au fil du temps

# Calcul de la différence avec l'année précédente
df <- df %>%
  mutate(perc_change = (surface_parcelle/lag(surface_parcelle)-1)*100)

df$perc_change <- df$perc_change %>%
  replace_na(0)

# Création du ggplot
ggplot(df, aes(x = fct_rev(annee_agricole), y = perc_change)) +
  scale_x_discrete(labels = c("Surface en 2016", "Surface en 2012", "Surface en 2009",
                              "Surface en 2004", "Surface en 1999", "Surface en 1949")) +
  coord_flip() +
  geom_col(fill = "#1f679c", colour = "black", size = 0.72) +
  ylab("\nDifférence avec l'année précédente (en %)") +
  ggtitle("Différence de surface agricole\navec la dernière année mesurée, exprimée en pourcentages") +
  theme(axis.title.y = element_blank(),
        plot.title = element_text(hjust = 0.5)) +
  geom_hline(yintercept = 0, size = 1.2) +
  scale_y_continuous(breaks = seq(round(min(df$perc_change)-1, digits = 0), 
                                  round(max(df$perc_change)+2, digits = 0), 
                                  by = 1))

### Partie 2 - Mise en page de l'évolution du type de cultures agricoles au fil du temps

# Création des dataframes d'intérêt

type_agri_1999 <- donnees_agricoles_1999 %>%
  group_by(l_3) %>%
  tally() %>%
  mutate(annee = 1999) %>%
  mutate(area = st_area(.))

type_agri_2004 <- donnees_agricoles_2004 %>%
  group_by(l_3) %>%
  tally() %>%
  mutate(annee = 2004) %>%
  mutate(area = st_area(.))

type_agri_2009 <- donnees_agricoles_2009 %>%
  group_by(l_3) %>%
  tally() %>%
  mutate(annee = 2009) %>%
  mutate(area = st_area(.))

type_agri_2012 <- donnees_agricoles_2012 %>%
  group_by(l_3) %>%
  tally() %>%
  mutate(annee = 2012) %>%
  mutate(area = st_area(.))

type_agri_2016 <- donnees_agricoles_2016 %>%
  group_by(l_3) %>%
  tally() %>%
  mutate(annee = 2016) %>%
  mutate(area = st_area(.))

# Concaténation des dataframes

df2 <- rbind(type_agri_1999, type_agri_2004, type_agri_2009, type_agri_2012, type_agri_2016)

rm(type_agri_1999, type_agri_2004, type_agri_2009, type_agri_2012, type_agri_2016)

# donnees_agricoles_2012 %>% group_by(l_3) %>% mapview(zcol = "l_3")

# Préparation des données en vue de leur mise en graphique

complete_df2 <- df2 %>%
  mutate(area_num = as.numeric(as.character(area))) %>%
  mutate(area_ha = area_num/10000) %>%
  group_by(l_3) %>%
  arrange(annee) %>%
  mutate(perc_change = (area_ha/lag(area_ha)-1)*100) %>%
  mutate(mult_factor = (area_ha/lag(area_ha))) %>%
  mutate(annee = as.factor(annee))

complete_df2$l_3 <- factor(complete_df2$l_3, labels=c("Arboriculture et autres", "Terres labourées",
                                                      "Prairies", "Vignoble"))

type_agri <- ggplot(data = complete_df2 %>% filter(!is.na(perc_change)), 
             aes(x = annee, y = perc_change, color = l_3, group = l_3)) +
  geom_line(size = 1.2) +
  geom_point(color = "black") +
  geom_hline(yintercept = 0, size = 0.5,  linetype="dashed") +
  scale_color_manual(values = c("#d8d200", "#aa6300", "#7bce37", "#b32650")) +
  xlab("Année") +
  ylab("Evolution par rapport à l'année précédente (en %)") + 
  guides(colour=guide_legend(title="Type d'agriculture")) +
  ggtitle("Evolution temporelle de la surface agricole\n par type d'agriculture sur la commune du Loroux Bottereau") +
  theme(plot.title = element_text(hjust = 0.5))

# Graphique sur les données brutes par type d'agriculture

arbo_plot <- ggplot(complete_df2 %>% filter(l_3 == "Arboriculture et autres"), 
                    aes(x = annee, y = area_ha)) +
  geom_col(fill = "#ffd046", color = "black") +
  xlab("Année") +
  ylab("Surface totale sur la commune (en ha)") +
  ggtitle("Surface totale de la commune employée à l'arboriculture,\nau maraîchage, pépinières et à l'horticulture") +
  geom_text(aes(label = round(area_ha, 2)), size = 3, color = "black", position = position_dodge(width = .9), vjust = -1) +
  theme(plot.title = element_text(hjust = 0.5))

labour_plot <- ggplot(complete_df2 %>% filter(l_3 == "Terres labourées"), 
                      aes(x = annee, y = area_ha)) +
  geom_col(fill = "#aa6300", color = "black") +
  xlab("Année") +
  ylab("Surface totale sur la commune (en ha)") +
  ggtitle("Surface totale de la commune employée aux terres en labour")+
  geom_text(aes(label = round(area_ha, 2)), size = 3, color = "black", position = position_dodge(width = .9), vjust = -1) +
  theme(plot.title = element_text(hjust = 0.5))

prairies_plot <- ggplot(complete_df2 %>% filter(l_3 == "Prairies"), 
                      aes(x = annee, y = area_ha)) +
  geom_col(fill = "#7bce37", color = "black") +
  xlab("Année") +
  ylab("Surface totale sur la commune (en ha)") +
  ggtitle("Surface totale de la commune employée aux terres aux prairies")+
  geom_text(aes(label = round(area_ha, 2)), size = 3, color = "black", position = position_dodge(width = .9), vjust = -1) +
  theme(plot.title = element_text(hjust = 0.5))

vignoble_plot <- ggplot(complete_df2 %>% filter(l_3 == "Vignoble"), 
                      aes(x = annee, y = area_ha)) +
  geom_col(fill = "#b32650", color = "black") +
  xlab("Année") +
  ylab("Surface totale sur la commune (en ha)") +
  ggtitle("Surface totale de la commune employée aux vignobles")+
  geom_text(aes(label = round(area_ha, 2)), size = 3, color = "black", position = position_dodge(width = .9), vjust = -1) +
  theme(plot.title = element_text(hjust = 0.5))

type_agri
arbo_plot
labour_plot
prairies_plot
vignoble_plot

### Partie 3 - Fermes biologiques

fermes_bio <-  st_read(dsn = "../data/import mobile/zone agriculture biologique.shp") %>%
  st_set_crs(3857)

sum(st_area(fermes_bio))

sum(st_area(fermes_bio)) / sum(st_area(donnees_agricoles_2016)) * 100

# Total de surface
temp <- df2 %>% 
  filter(annee == 2016)

temp$l_3 <- factor(temp$l_3, labels=c("Arboriculture et autres", "Terres labourées",
                                                      "Prairies", "Vignoble"))
temp$geom <- NULL
temp$perc <- (as.numeric(as.character(temp$area))/sum(as.numeric(as.character(temp$area))))*100

ggplot(temp, aes(x = fct_rev(l_3), y = perc, fill = l_3)) + 
  geom_col() +
  scale_fill_viridis_d() + 
  coord_flip() +
  xlab("") +
  ylab("Pourcentage") +
  ggtitle("Surface agricole du Loroux Bottereau par type d'agriculture\n") +
  theme(legend.position="bottom",
        plot.title = element_text(hjust = 0.5))

pres_surf <- temp[, c("l_3","perc")]
pres_surf$perc <- paste0(round(pres_surf$perc, 2), " %")
colnames(pres_surf) <- c("Type d'agriculture", "Pourcentage de surface agricole")
export <- data.table(pres_surf)

as.numeric(as.character(sum(st_area(temp))))/as.numeric(as.character(sum(st_area(limite_commune))))*100
