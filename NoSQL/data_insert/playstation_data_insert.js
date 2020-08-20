use Mediatheque

db.ouvrages_ref.insert([
  {
       "type": "Jeu video",
       "sous-type": "PS4",
       "categorie": [
           "RPG",
           "Action",
           "JRPG"
       ],
       "titre": "Final Fantasy VII Remake",
       "edition": {
           "developpeur": "Square Enix",
           "editeur": "Square Enix",
           "date_sortie": new Date("2020-04-10")
       },
       "exemplaires" : [{
           "code_barre": "152JIH1-4512436346",
           "premiere_mise_en_rayonnage": new Date(""),
           "disponible": "oui",
       }]
   },
   {
        "type": "Jeu video",
        "sous-type": "PS4",
        "categorie": "FPS",
        "titre": "Doom Eternal",
        "edition": {
            "developpeur": "id Software",
            "editeur": "Bethesda Softworks",
            "date_sortie": new Date("2020-03-20")
        },
        "exemplaires" : [{
            "code_barre": "152JIH1-4212986346",
            "premiere_mise_en_rayonnage": new Date(""),
            "disponible": "oui",
        }]
    },
    {
         "type": "Jeu video",
         "sous-type": "PS4",
         "categorie": [
             "RPG",
             "Isometrique"
         ],
         "titre": "Pillars of Eternity II : Deadfire",
         "edition": {
             "developpeur": "Obsidian Entertainment",
             "editeur": "Versus Evil",
             "date_sortie": new Date("2020-01-28")
         },
         "exemplaires" : [{
             "code_barre": "152JIH1-4512986346",
             "premiere_mise_en_rayonnage": new Date(""),
             "disponible": "oui",
         }]
     },
     {
          "type": "Jeu video",
          "sous-type": "PS4",
          "categorie": [
              "Gestion",
              "Stratégie",
              "Histoire"
          ],
          "titre": "Civilization VI",
          "edition": {
              "developpeur": ["Firaxis Games", "Aspyr"],
              "editeur": "2K Games",
              "date_sortie": new Date("2019-11-22")
          },
          "exemplaires" : [{
              "code_barre": "152JIH1-4512986346",
              "premiere_mise_en_rayonnage": new Date(""),
              "disponible": "oui",
          }]
      }
])
