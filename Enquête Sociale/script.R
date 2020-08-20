# Chargement des librairies
library(webshot)
library(sjPlot)
library(sjmisc)
library(dplyr)
library(data.table)
library(lubridate)
library(ggplot2)
library(gtsummary)
library(tidyr)
library(forcats)
library(DT)

# Import des données
df <- fread("data/df.csv")

############################
#### Data Preprocessing ####
############################

# Création des futurs noms de colonnes
column_names <- c("timestamp", "participation", "bloc1_q1", "bloc1_q2", "bloc1_q3",
                  "bloc1_q4", "bloc1_q5", "bloc1_q6", "bloc2_q1", "bloc2_q2", 
                  "bloc2_q3", "bloc2_q4", "bloc2_q5", "bloc2_q6", "bloc3_q1", 
                  "bloc3_q2", "bloc3_q3", "bloc3_q4", "bloc3_q5", "bloc3_q6", 
                  "bloc3_q7", "bloc4_q1", "bloc5_q1", "bloc5_q2", "bloc5_q3", 
                  "bloc5_q4", "bloc6_q1", "bloc6_q2", "bloc6_q3", "qcm_q1", 
                  "bloc7_q1", "bloc7_q2", "yob", "gender", "french_maternal",
                  "french_practice", "french_residence", "occupation", "medical_worker",
                  "coronavirus", "diploma")

# Renommage des noms de colonnes
names(df) <- column_names

# Une erreur d'encodage a fait que les premières réponses ne contenaient pas les chiffres
# Les lignes ci-dessous résolvent ce problème de sorte que toutes les réponses soient à iso
df[] <- lapply(df[], function(x) trimws(x))
df[, c(3:21, 23:29, 31:32)] <- lapply(df[, c(3:21, 23:29, 31:32)], function(x) gsub("^Pas du tout d'accord","1 - Pas du tout d'accord",as.character(x)))
df[, c(3:21, 23:29, 31:32)] <- lapply(df[, c(3:21, 23:29, 31:32)], function(x) gsub("^Pas d'accord","2 - Pas d'accord",as.character(x)))
df[, c(3:21, 23:29, 31:32)] <- lapply(df[, c(3:21, 23:29, 31:32)], function(x) gsub("^Ni en désaccord ni d'accord","3 - Ni en désaccord ni d'accord",as.character(x)))
df[, c(3:21, 23:29, 31:32)] <- lapply(df[, c(3:21, 23:29, 31:32)], function(x) gsub("^D'accord","4 - D'accord",as.character(x)))
df[, c(3:21, 23:29, 31:32)] <- lapply(df[, c(3:21, 23:29, 31:32)], function(x) gsub("^Tout à fait d'accord","5 - Tout à fait d'accord",as.character(x)))

# Suppression du texte dans les réponses aux Likerts
df[, c(3:21, 23:29, 31:32)] <- lapply(df[, c(3:21, 23:29, 31:32)], function(x) gsub("\\D+","",as.character(x)))
df[, c(3:21, 23:29, 31:32)] <- lapply(df[, c(3:21, 23:29, 31:32)], function(x) as.numeric(x))

# Exclusion des participants ayant mal répondu à la question témoin
df <- df %>%
  filter(bloc2_q5 == 4)

# Conversion du timestamp au format datetime
df$timestamp <- date(df$timestamp)

# Suppression de la colonne consentement
unique(df$participation)
df$participation <- NULL

# Changement des valeurs pour la question du QCM
df <- df %>%
  mutate(qcm_q1 = 
           ifelse(qcm_q1 == 'Faire un état de l’art, Formuler des hypothèses, opérationnaliser, analyser, publier.', "correct",
              ifelse(qcm_q1 == 'Je ne sais pas', "nsp", "faux")))

# Vérification des âges
df$yob <- gsub("\\s", "", df$yob)
df$yob <- year(parse_date_time(df$yob, orders = c("dmy", "%Y")))
ggplot(data = df, mapping = aes(x = as.numeric(rownames(df)), y = yob)) +
  geom_point() +
  xlab("Participant") +
  ylab("Année de Naissance") +
  ggtitle("Visualisation des années de naissance") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 16))

# Correction des années
df <- df %>%
  mutate(yob = ifelse(grepl("(19|20)\\d+", .$yob) == TRUE, .$yob,
                            ifelse(grepl("(1[0-8])\\d{2}$", .$yob) == TRUE,
                                   sub("\\d{2}", "19", .$yob),
                                   sub("\\d{1}", "1", .$yob))))

ggplot(data = df, aes(x = as.numeric(yob))) +
  geom_histogram(fill = "#282828", color = "white", binwidth = 5) +
  xlab("Année de Naissance") +
  ylab("Répartition") +
  ggtitle("Visualisation des années de naissance") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, size = 16))

# Correction de la réponse à français en tant que langue maternelle
df$french_maternal <- gsub("Oui;Non", "Non", df$french_maternal)

# Correction du nombre d'années de français
df$french_practice <- gsub("\\D+", "", df$french_practice)

# Correction mineure liée aux diplômes :
df$diploma <- gsub("BAC", "Bac", df$diploma)

# Calcul de l'âge
df$age <- year(Sys.Date()) - year(as.Date(df$yob, format = "%Y"))

# Conversion de french_practice en nombres
df$french_practice <- as.numeric(df$french_practice)

# Correction du mauvais codage du "Ne se prononce pas" à la question sur le coronavirus
df$coronavirus <- ifelse(test = df$coronavirus == "", "nsp", df$coronavirus)

unique(df$coronavirus)

#####################################
#### Informations démographiques ####
#####################################

summary <- df %>%
  select(age, gender, french_maternal, french_practice, french_residence, occupation, medical_worker, coronavirus, diploma) %>%
  tbl_summary(statistic = list(all_continuous() ~ "{mean} ({sd})",
                               all_categorical() ~ "{n} ({p}%)"))

# gt::gtsave(as_gt(summary), file = file.path(tempdir(), "temp.png"))

ggplot(data = df, aes(y = age)) +
  geom_boxplot() +
  ylab("Âge") +
  ggtitle("Boxplot de répartition des âges au sein de l'échantillon")+
  theme(plot.title = element_text(hjust = 0.5, size = 16),
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

# Suppression de la question contrôle
df$bloc2_q5 <- NULL

##############################
#### Analyse des réponses ####
##############################

# L'avenir de la recherche perçu par l'échantillon
df %>%
  select(starts_with("bloc1")) %>%
  pivot_wider() %>%
  pivot_longer(cols = starts_with("bloc1")) %>%
  group_by(name, value) %>%
  tally() %>%
  group_by(name) %>%
  mutate(perc = n/sum(n)*100) %>%
  ggplot(data = ., mapping = aes(x = fct_rev(name), 
                                 y = perc, 
                                 group = fct_rev(as.factor(value)), 
                                 fill = fct_rev(as.factor(value)))) +
    geom_bar(stat = "identity") +
    scale_x_discrete(labels = c("bloc1_q1" = "La communauté scientifique\nsera davantage consultée\npar le gouvernement",
                                "bloc1_q2" = "Les laboratoires publics\nauront plus de moyens",
                                "bloc1_q3" = "Le processus scientifique\nsera accéléré (demande de\nfinancements, analyse...)",
                                "bloc1_q4" = "Les laboratoires français\npourront continuer de rivaliser\navec les recherches issues\ndes pays anglo-saxons",
                                "bloc1_q5" = "L’éducation à la culture\nscientifique sera plus développée\ndans l’éducation nationale",
                                "bloc1_q6" = "Les scientifiques seront\nplus présents dans le paysage public")) +
    coord_flip() +
  scale_fill_viridis_d(labels = c("1" = "Pas du tout\nd'accord",
                                  "2" = "Pas d'accord",
                                  "3" = "Ni en désaccord\nNi d'accord",
                                  "4" = "D'accord",
                                  "5" = "Tout à fait\nd'accord")) +
  guides(fill = guide_legend(reverse=T, title = "Réponses")) +
    theme(legend.position="bottom",
          plot.title = element_text(hjust = 0.5, size = 16)) +
    ylab("Répartition (%)") +
    xlab("") +
    ggtitle("La perception de l'avenir de la recherche")

df %>%
  select(starts_with("bloc1")) %>%
  rename(`La communauté scientifique sera davantage consultée par le gouvernement` = bloc1_q1,
         `Les laboratoires publics auront plus de moyens` = bloc1_q2,
         `Le processus scientifique sera accéléré (demande de financements, analyse...)` = bloc1_q3,
         `Les laboratoires français pourront continuer de rivaliser avec les recherches issues des pays anglo-saxons` = bloc1_q4,
         `L’éducation à la culture scientifique sera plus développée dans l’éducation nationale` = bloc1_q5,
         `Les scientifiques seront plus présents dans le paysage public` = bloc1_q6) %>%
  descr(show = c("var", "n", "NA.prc", "mean", "sd", "se", "md", "range")) %>%
  tab_df(title = "Résumé des réponses sur l'avenir de la recherche")

df %>%
  select(starts_with("bloc1")) %>%
  mutate(mean = rowMeans(.)) %>%
  select(mean) %>%
  t.test(., mu = 3)

df %>%
  select(bloc1_q1) %>%
  t.test(., mu = 3)

# La gestion de la crise par...
df %>%
  select(starts_with("bloc3")) %>%
  pivot_wider() %>%
  pivot_longer(cols = starts_with("bloc3")) %>%
  group_by(name, value) %>%
  tally() %>%
  group_by(name) %>%
  mutate(perc = n/sum(n)*100) %>%
  ggplot(data = ., mapping = aes(x = fct_rev(name), 
                                 y = perc, 
                                 group = fct_rev(as.factor(value)), 
                                 fill = fct_rev(as.factor(value)))) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = c("bloc3_q1" = "Des scientifiques",
                              "bloc3_q2" = "Des universités",
                              "bloc3_q3" = "Des associations et ONG",
                              "bloc3_q4" = "Des start-ups",
                              "bloc3_q5" = "Des citoyens",
                              "bloc3_q6" = "Des entreprises",
                              "bloc3_q7" = "Des pouvoirs publics")) +
  coord_flip() +
  scale_fill_viridis_d(labels = c("1" = "Pas du tout\nd'accord",
                                  "2" = "Pas d'accord",
                                  "3" = "Ni en désaccord\nNi d'accord",
                                  "4" = "D'accord",
                                  "5" = "Tout à fait\nd'accord")) +
  guides(fill = guide_legend(reverse=T, title = "Réponses")) +
  theme(legend.position="bottom",
        plot.title = element_text(hjust = 0.5, size = 16)) +
  ylab("Répartition (%)") +
  xlab("") +
  ggtitle("Pour gérer la crise, les politiques\nse sont appuyés sur l'avis")

bloc3 <- df %>%
  select(starts_with("bloc3")) %>%
  pivot_longer(cols = starts_with("bloc"))

pairwise.t.test(bloc3$value, bloc3$name, p.adjust = "bonferroni")

# La gestion de la crise du COVID par la recherche
df %>%
  select(starts_with("bloc2")) %>%
  pivot_wider() %>%
  pivot_longer(cols = starts_with("bloc2")) %>%
  group_by(name, value) %>%
  tally() %>%
  group_by(name) %>%
  mutate(perc = n/sum(n)*100) %>%
  ggplot(data = ., mapping = aes(x = fct_rev(name), 
                                 y = perc, 
                                 group = fct_rev(as.factor(value)), 
                                 fill = fct_rev(as.factor(value)))) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = c("bloc2_q1" = "Les décisions politiques\nsur la gestion de la crise\nse sont faites sur la base\nde preuves scientifiques",
                              "bloc2_q2" = "Les scientifiques se sont trop\nimpliqués dans les politiques de santé",
                              "bloc2_q3" = "Les scientifiques ont\nmaintenant les solutions\npour ralentir la diffusion du virus",
                              "bloc2_q4" = "Les scientifiques ne comprennent\npas encore le virus",
                              "bloc2_q6" = "Les scientifiques parviendront\nà fournir un vaccin permettant\nde combattre le coronavirus")) +
  coord_flip() +
  scale_fill_viridis_d(labels = c("1" = "Pas du tout\nd'accord",
                                  "2" = "Pas d'accord",
                                  "3" = "Ni en désaccord\nNi d'accord",
                                  "4" = "D'accord",
                                  "5" = "Tout à fait\nd'accord")) +
  guides(fill = guide_legend(reverse=T, title = "Réponses")) +
  theme(legend.position="bottom",
        plot.title = element_text(hjust = 0.5, size = 16)) +
  ylab("Répartition (%)") +
  xlab("") +
  ggtitle("La gestion de la crise du COVID par la recherche")

df %>%
  select(starts_with("bloc2")) %>%
  rename(`Les décisions politiques\nsur la gestion de la crise\nse sont faites sur la base\nde preuves scientifiques` = bloc2_q1,
         `Les scientifiques se sont trop\nimpliqués dans les politiques de santé` = bloc2_q2,
         `Les scientifiques ont\nmaintenant les solutions\npour ralentir la diffusion du virus` = bloc2_q3,
         `Les scientifiques ne comprennent\npas encore le virus` = bloc2_q4,
         `Les scientifiques parviendront\nà fournir un vaccin permettant\nde combattre le coronavirus` = bloc2_q6) %>%
  descr(show = c("var", "n", "NA.prc", "mean", "sd", "se", "md", "range")) %>%
  tab_df(title = "Résumé des réponses sur l'implication des scientifiques")

df %>%
  select(starts_with("bloc2")) %>%
  summarise_each(funs(t_value = t.test(., mu = 3)$statistic,
                      para = t.test(., mu = 3)$parameter,
                      p_value = t.test(., mu = 3)$p.value)) %>%
  select(sort(names(.)))


# La gestion de la crise par
df %>%
  select(starts_with("bloc3")) %>%
  pivot_wider() %>%
  pivot_longer(cols = starts_with("bloc3")) %>%
  group_by(name, value) %>%
  tally() %>%
  group_by(name) %>%
  mutate(perc = n/sum(n)*100) %>%
  ggplot(data = ., mapping = aes(x = fct_rev(name), 
                                 y = perc, 
                                 group = fct_rev(as.factor(value)), 
                                 fill = fct_rev(as.factor(value)))) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = c("bloc3_q1" = "Des scientifiques",
                              "bloc3_q2" = "Des universités",
                              "bloc3_q3" = "Des associations et ONG",
                              "bloc3_q4" = "Des start-ups",
                              "bloc3_q5" = "Des citoyens",
                              "bloc3_q6" = "Des entreprises",
                              "bloc3_q7" = "Des pouvoirs publics")) +
  coord_flip() +
  scale_fill_viridis_d(labels = c("1" = "Pas du tout\nd'accord",
                                  "2" = "Pas d'accord",
                                  "3" = "Ni en désaccord\nNi d'accord",
                                  "4" = "D'accord",
                                  "5" = "Tout à fait\nd'accord")) +
  guides(fill = guide_legend(reverse=T, title = "Réponses")) +
  theme(legend.position="bottom",
        plot.title = element_text(hjust = 0.5, size = 16)) +
  ylab("Répartition (%)") +
  xlab("") +
  ggtitle("Pour gérer la crise, les politiques\nse sont appuyés sur l'avis")

# L'hydroxychloroquine
df %>%
  select(starts_with("bloc4"), starts_with("bloc5")) %>%
  pivot_wider() %>%
  mutate(bloc4_q1 = ifelse(bloc4_q1 == "Oui", 1, 0)) %>%
  pivot_longer(cols = matches("bloc4|bloc5")) %>%
  group_by(name, value) %>%
  tally() %>%
  group_by(name) %>%
  drop_na() %>%
  mutate(perc = n/sum(n)*100) %>%
  ggplot(data = ., mapping = aes(x = fct_rev(name), 
                                 y = perc, 
                                 group = fct_rev(as.factor(value)), 
                                 fill = fct_rev(as.factor(value)))) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = c("bloc4_q1" = "Q1-J’ai suivi les débats relatifs\nà l’hydroxychloroquine",
                              "bloc5_q1" = "Q2-J’ai compris pourquoi\nl’usage de l’hydroxychloroquine\nest controversé",
                              "bloc5_q2" = "Q3-J’ai su identifier les\ninformations inexactes au cours\nde ces débats.",
                              "bloc5_q3" = "Q4-J’ai trouvé ces débats\nutiles pour faire avancer la\nrecherche sur le traitement",
                              "bloc5_q4" = "Q5-Les scientifiques ont su\nreconnaître les informations de\nmauvaise qualité liées au\ncoronavirus")) +
  coord_flip() +
  scale_fill_viridis_d(labels = c("0" = "Q1=Non",
                                  "1" = "Q1=Oui\nQ2:Q5=Pas intéressé",
                                  "2" = "Pas du tout",
                                  "3" = "Un peu",
                                  "4" = "Parfaitement")) +
  guides(fill = guide_legend(reverse=T, title = "Réponses")) +
  theme(legend.position="bottom",
        plot.title = element_text(hjust = 0.5, size = 16),
        plot.subtitle=element_text(face = "italic", size = 10)) +
  ylab("Répartition (%)") +
  xlab("") +
  ggtitle("Les débats autour de l'hydroxychloroquine", subtitle = "Nb : L'apparition des questions 2 à 5 était dépendante de la réponse à la première question")

sci_culture <- df %>%
  select(qcm_q1) %>%
  group_by(qcm_q1) %>%
  mutate(qcm_q1 = ifelse(qcm_q1 == "nsp", "Je ne sais pas",
                         ifelse(qcm_q1 == "correct", "Correct", "Faux"))) %>%
  rename(`Le processus scientifique consiste à : (Faire un état de l’art, Formuler des hypothèses, opérationnaliser, analyser, publier.)` = qcm_q1) %>%
  tbl_summary()
sci_culture

sci <- df %>%
  select(bloc6_q1, qcm_q1) %>%
  mutate(qcm_q1 = ifelse(qcm_q1 == "nsp", "Je ne sais pas",
                         ifelse(qcm_q1 == "correct", "Correct", "Faux"))) %>%
  rename(`Le processus scientifique consiste à :\n(Faire un état de l’art, Formuler des hypothèses, opérationnaliser, analyser, publier.)` = qcm_q1) %>%
  tbl_summary(by = bloc6_q1)
sci

df %>%
  select(bloc6_q1, qcm_q1) %>%
  filter(qcm_q1 != "nsp") %>%
  mutate(qcm_q1 = ifelse(qcm_q1 == "correct", "Correct", "Faux")) %>%
  group_by(bloc6_q1, qcm_q1) %>%
  tally() %>%
  ggplot(data = ., mapping = aes(x = bloc6_q1, y = n, group = qcm_q1, color = qcm_q1)) +
    geom_point() +
    geom_line() +
    scale_color_manual(values = c("#008080", "#800000")) +
    ggtitle("J'ai une bonne connaissance globale\ndu fonctionnement de la recherche scientifique", 
            subtitle = "Réponses 'Ne sais pas' exclues (1 = 'Pas du tout d'accord', 5 = 'Tout à fait d'accord')") +
    xlab("") +
    ylab("Nombre d'observations") +
    theme(plot.title = element_text(hjust = 0.5, size = 16),
          plot.subtitle=element_text(face = "italic", size = 10)) +
    guides(color = guide_legend(title = "Réponse au QCM")) +
    scale_y_continuous(breaks = c(0, 2, 4, 6, 8, 10))
  
df %>%
  select(bloc6_q1, qcm_q1) %>%
  filter(qcm_q1 != "nsp") %>%
  filter(bloc6_q1 != 3) %>%
  mutate(bloc6_q1 = ifelse(bloc6_q1 == 2, 1,
                           ifelse(bloc6_q1 == 4, 5, bloc6_q1))) %>%
  group_by(bloc6_q1, qcm_q1) %>%
  tally() %>%
  mutate(bloc6_q1 = ifelse(bloc6_q1 == 1, "Peu de connaissances", "Bonnes connaissances")) %>%
  pivot_wider(names_from = qcm_q1, values_from = n) %>%
  tibble::column_to_rownames("bloc6_q1") %>%
  chisq.test(.)

tmp <- df %>%
  select(starts_with("bloc6"), starts_with("bloc7"), qcm_q1) %>%
  filter(qcm_q1 != "nsp") %>%
  mutate(qcm_q1 = ifelse(qcm_q1 == "faux", 0, 1))

log_model <- glm(formula = qcm_q1 ~ ., data = tmp, family = "binomial")

exp(log_model$coefficients)

# La culture scientifique
df %>%
  select(starts_with("bloc6"), starts_with("bloc7")) %>%
  pivot_wider() %>%
  pivot_longer(cols = matches("bloc6|bloc7")) %>%
  group_by(name, value) %>%
  tally() %>%
  group_by(name) %>%
  drop_na() %>%
  mutate(perc = n/sum(n)*100) %>%
  ggplot(data = ., mapping = aes(x = fct_rev(name), 
                                 y = perc, 
                                 group = fct_rev(as.factor(value)), 
                                 fill = fct_rev(as.factor(value)))) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = c("bloc6_q1" = "J’ai une bonne connaissance\nglobale du fonctionnement de\nla recherche scientifique",
                              "bloc6_q2" = "En tant qu’adulte, je vois\nl’intérêt d’avoir une compréhension\nde la méthode scientifique",
                              "bloc6_q3" = "Afin d’améliorer la qualité\ndes débats, l’approche scientifique\ndevrait être intégrée au parcours scolaire",
                              "bloc7_q1" = "Je connais et je peux expliquer\navec mes propres mots les différences\nentre une théorie et une hypothèse",
                              "bloc7_q2" = "Je suis capable d’expliquer avec\nmes propres mots ce qu’est une étude\ncontrôlée aléatoire en double aveugle")) +
  coord_flip() +
  scale_fill_viridis_d(labels = c("1" = "Pas du tout\nd'accord",
                                  "2" = "Pas d'accord",
                                  "3" = "Ni en désaccord\nNi d'accord",
                                  "4" = "D'accord",
                                  "5" = "Tout à fait\nd'accord")) +
  guides(fill = guide_legend(reverse=T, title = "Réponses")) +
  theme(legend.position="bottom",
        plot.title = element_text(hjust = 0.5, size = 16)) +
  ylab("Répartition (%)") +
  xlab("") +
  ggtitle("Les compétences perçues en sciences")


