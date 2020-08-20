// Création de la database Mediatheque
use MediathequeNeo

db.createCollection('users_ref')
db.createCollection('ouvrages_ref')

db.ouvrages_ref.insert([
    {   
        "_id" : ObjectId("5e888c7b788e2ab63ff926bf"),
        "type": "Livre",
        "sous-type": "Roman",
        "categorie": "Fantastique",
        "titre": "Autre-Monde, Tome 1 : L'alliance des Trois",
        "auteur": "Maxime Chattam",
        "edition": {
            "editeur": "Albin Michel",
            "date_edition": new Date("2008-11-03"),
            "langue": "Français",
            "Nombre_de_pages": NumberLong(496)
        },
        "resume": "New York, de nos jours. Matt et Tobias sont amis depuis l’enfance, grands amateurs de jeux de rôles, de jeux vidéos. Mais ce qui leur arrive est bien réel. New York est balayée par une tempête sans précédent. Des éclairs bleus fouillent les immeubles ne laissant des humains que leurs vêtements ou les transformant en mutants répugnants.Matt et Tobias arrivent à fuir sur une île et rejoignent une communauté d’enfants épargnés. Ils sont 77, de 9 à 17 ans, se dénomment les Pans et s’organisent pour survivre. Leurs ennemis sont les monstres Gloutons et les Cyniks humains, violents et perfides, des adultes qui se sont transformés.Les enfants survivants ont développé des dons surnaturels, faire jaillir le feu, créer de l’électricité. Avec Ambre, Matt et Tobias vont former l’alliance des trois et essayer de comprendre et utiliser leur nouvelle nature. Comprendre aussi l’attitude étrange de certains membres de la communauté.",
    "exemplaires" : [{
        "code_barre": "0101234567890128TEC-IT",
        "premiere_mise_en_rayonnage": new Date("2015-05-30"),
        "disponible": "oui",
        "emprunts": [
            {
                "date_emprunt": new Date("2015-05-30"),
                "etat_debut_emprunt": "RAS",
                "date_retour": new Date("2016-06-10"),
                "etat_retour": "RAS",
            },
            {
                "date_emprunt": new Date("2018-09-30"),
                "etat_debut_emprunt": "RAS",
                "date_retour": new Date("2018-10-17"),
                "etat_retour": "couverture ecornee",
            }
        ]
    },
    {
        "code_barre": "123456789",
        "premiere_mise_en_rayonnage": new Date("2017-05-30"),
        "disponible": "oui",
        "emprunts": [
            {
                "date_emprunt": new Date("2018-05-30"),
                "etat_debut_emprunt": "RAS",
                "date_retour": new Date("2018-06-10"),
                "etat_retour": "RAS",
            },
            {
                "date_emprunt": new Date("2019-09-30"),
                "etat_debut_emprunt": "RAS",
                "date_retour": new Date("2019-10-17"),
                "etat_retour": "une page dechire",
            },
            {
                "date_emprunt": new Date("2020-02-30"),
                "etat_debut_emprunt": "une page dechire",
                "date_retour": "",
                "etat_retour": "",
            }
        ]
    }]},
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c0"),
        "type": "Livre",
        "sous-type": "BD",
        "titre": "Astérix le Gaulois",
        "scenario": "Goscinny",
        "dessins": "Uderzo",
        "edition": {
            "editeur": "Hachette Livre",
            "date_edition": new Date("1961-10-01"),
            "langue": "Français",
            "Nombre_de_pages": NumberLong(48)
        },
        "resume": "Dans le camp fortifié romain Petibonum, on se pose des questions : comment les Irréductibles Gaulois du village d’Astérix font-ils pour ridiculiser encore et toujours la puissance romaine ? Décidé à percer à jour le mystère de la force surhumaine de nos héros, le centurion Caius Bonus envoie un espion déguisé en Gaulois.C’est Caligula Minus qui s’y colle, et découvre bien vite l’existence de la potion magique préparée par Panoramix. Sans attendre, le centurion Caius Bonus fait enlever le druide pour s’emparer de la recette du fameux breuvage histoire, qui sait, de devenir César à la place de Jules ! Une première occasion pour Astérix de démontrer son courage et ses talents de stratège.",
        "exemplaires" : [{
            "code_barre": "01234567",
            "premiere_mise_en_rayonnage": new Date("2017-05-30"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2018-05-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2018-06-10"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2019-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2019-10-17"),
                    "etat_retour": "une page dechire",
                },
                {
                    "date_emprunt": new Date("2020-02-30"),
                    "etat_debut_emprunt": "une page dechire",
                    "date_retour": "",
                    "etat_retour": "",
                }
            ]
        }]},
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c1"),
        "type": "Livre",
        "sous-type": "Manga",
        "categorie": "Shonen",
        "titre": "Naruto Tome 1",
        "auteur": "KISHIMOTO Masashi",
        "edition": {
            "editeur": "Kana",
            "date_edition": new Date("2002-03-07"),
            "langue": "Français",
            "Nombre_de_pages": NumberLong(187)
        },
        "resume": "Naruto est un garçon un peu spécial. Solitaire au caractère fougueux, il n'est pas des plus appréciés dans son village. Malgré cela, il garde au fond de lui une ambition: celle de devenir un maître Hokage, la plus haute distinction dans l'ordre des ninjas, et ainsi obtenir la reconnaissance de ses pairs mais cela nesera pas de tout repos ... Suivez l'éternel farceur dans sa quête du secret de sa naissance et de la conquête des fruits de son ambition !",
        "exemplaires" : [{
            "code_barre": "01234567",
            "premiere_mise_en_rayonnage": new Date("2018-05-30"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2018-06-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2018-07-10"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2019-02-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2019-03-17"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2020-03-08"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": "",
                    "etat_retour": "",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926d7"),
        "type": "Livre",
        "sous-type": "Manga",
        "categorie": "Shonen",
        "titre": "L'attaque des Titans",
        "auteur": "ISAYAMA Hajime",
        "edition": {
            "editeur": "Pika Edition",
            "date_edition": new Date("2009-09-09"),
            "langue": "Français",
            "Nombre_de_pages": NumberLong(177)
        },
        "resume": "Dans un monde ravagé par des titans mangeurs d'homme depuis plus d'un siècle, les rares survivants de l'Humanité n'ont d'autres choix pour survivre que de se barricader dans une cité-forteresse",
        "exemplaires" : [{
            "code_barre": "01234569",
            "premiere_mise_en_rayonnage": new Date("2020-02-20"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2020-02-21"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2020-02-25"),
                    "etat_retour": "RAS",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c2"),
        "type": "Livre",
        "sous-type": "Comics",
        "categorie": "Super-Heros",
        "titre": "Marvel Anthologie : Nous Sommes Les X-Men",
        "auteur": [
            "Stan Lee",
            "Roy Thomas",
            "Chris Claremont",
            "Len Wein",
            "Ann Nocenti",
            "Joe Kelly",
            "Grant Morrison",
            "Jack Kirby",
            "Neal Adams",
            "Dave Cockrum",
            "Jim Lee",
            "John Byrne",
            "Alan Davis",
            "Frank Quitely",
            "Art Adams"
        ],
        "edition": {
            "editeur": "Panini Comics",
            "date_edition": new Date("2014-05-21"),
            "langue": "Français",
            "Nombre_de_pages": NumberLong(288)
        },
        "resume": "Cette anthologie présente les moments-clés de l'histoire des X-Men au travers de sagas signées par les auteurs qui ont marqué le destin des mutants. Explorez également l'univers des héros grâce à de nombreux articles qui retracent l'évolution de l'équipe des années 60 à nos jours.",
        "exemplaires" : [{
            "code_barre": "0123-4567",
            "premiere_mise_en_rayonnage": new Date("2016-06-30"),
            "disponible": "non",
            "emprunts": [
                {
                    "date_emprunt": new Date("2019-06-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2019-07-10"),
                    "etat_retour": "RAS",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c3"),
        "type": "Livre",
        "sous-type": "Beau-livre",
        "categorie": "Cuisine",
        "titre": "Voyage culinaire au pays du soleil-levant",
        "auteur": "Laure Kié",
        "illustration": "Haruna Kishi",
        "photographie": [
            "Patrice Hauser",
            "Cyril Castaing"
        ],
        "edition": {
            "editeur": "Mango",
            "date_edition": new Date("2019-22-11"),
            "langue": "Français",
            "Nombre_de_pages": NumberLong(304)
        },
        "resume": "La bible de la cuisine japonaise mais surtout un melting-pot ultra vivant et complet qui aborde toutes les facettes de la culture gastronomique japonaise. Des photos, des illustrations, des portraits, des anecdotes, des histoires, plusieurs centaines de recettes, des tours de main, des pas à pas des adresses,  des cartes, des photos reportage, des leçons (apprendre à faire le dashi, apprendre à découper les fruits et légumes, réaliser des gyozas, faire des sushi comme un  maître sushi…). De nombreux intervenants japonais (producteur de saké, producteur de sauce soja, spécialiste de sumie, producteur de yuzu, sumo…).Pour toute savoir sur la gastronomie nippone et l’art de vivre à la japonaise.",
        "exemplaires" : [{
            "code_barre": "012Z3-4AP567",
            "premiere_mise_en_rayonnage": new Date("2018-06-30"),
            "disponible": "non",
            "emprunts": [
                {
                    "date_emprunt": new Date("2019-06-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2019-07-10"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2019-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2019-10-10"),
                    "etat_retour": "RAS",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c4"),
        "type": "CD",
        "sous-type": "Musique",
        "categorie": [
            "Electronic",
            "Jazz"
        ],
        "album": "Caravan Palace",
        "Groupe(s)": "Caravan Palace",
        "compositeur(s)": [
            "Arnaud Vial",
            "Charles Delaporte",
            "Hugues Payen",
            "Antoine Toustou"
        ],
        "Interprète(s)": [
            "Zoé Colotis",
            "Camille Chapelière",
            "Victor Raimondeau",
            "Paul-Marie Barbier"
        ],
        "titre(s)": [
            "Dragons",
            "Star Scat",
            "Ended With the Night",
            "Jolie Coquine",
            "Oooh",
            "Suzy",
            "Je m'amuse",
            "Violente Valse",
            "Brotherswing",
            "L'Envol",
            "Sofa",
            "Bambous",
            "Lazy Place",
            "We Can Dance",
            "La Caravane"
        ],
        "production": {
            "producteur": "Wagram Music",
            "date_production": new Date("2008-10-01"),
            "langue": "Français"
        },
        "exemplaires" : [{
            "code_barre": "0144Z3-4A555P567",
            "premiere_mise_en_rayonnage": new Date("2019-05-30"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2019-06-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2019-07-10"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2019-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2019-10-10"),
                    "etat_retour": "rayé",
                },
                {
                    "date_emprunt": new Date("2020-03-03"),
                    "etat_debut_emprunt": "rayé",
                    "date_retour": "",
                    "etat_retour": "",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c5"),
        "type": "CD",
        "sous-type": "Education",
        "categorie": "Jeunesse",
        "album": "Mes premières chansons d'enfant",
        "titre(s)": [
            "A la claire fontaine",
            "Il court, il court, le furet",
            "Alouette, gentille alouette",
            "Le bon roi Dagobert"
        ],
        "production": {
            "producteur": "Deva Jeunesse",
            "date_production": new Date("2010-10-14"),
            "langue": "Français"
        },
        "exemplaires" : [{
            "code_barre": "01-4A554485556589",
            "premiere_mise_en_rayonnage": new Date("2020-01-10"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2020-03-08"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": "",
                    "etat_retour": "",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c6"),
        "type": "Film",
        "sous-type": "DVD",
        "categorie": "Fantastique",
        "titre": "Warcraft : Le Commencement",
        "duree": "118 minutes",
        "acteurs": [
            "Travis Fimmel",
            "Toby Kebbell",
            "Paula Patton",
            "Ben Foster",
            "Dominic Cooper"
        ],
        "audio": [
            "Italien (Dolby Digital 5.1)",
            "Anglais (Dolby Digital 5.1)",
            "Français (Dolby Digital 5.1)",
            "Espagnol (Dolby Digital 5.1)",
            "Néerlandais"
        ],
        "sous-titres": [
            "Italien",
            "Français",
            "Néerlandais",
            "Espagnol"
        ],
        "production": {
            "realisateur": "Duncan Jones",
            "date_production": new Date("2016-10-11"),
            "studio": "Universal Pictures France"
        },
        "exemplaires" : [{
            "code_barre": "055551-44485556589",
            "premiere_mise_en_rayonnage": new Date("2017-05-10"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2018-06-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2018-07-10"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2019-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2019-10-10"),
                    "etat_retour": "RAS",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c7"),
        "type": "Film",
        "sous-type": "Blu-ray",
        "categorie": "SF",
        "titre": "Alien, le huitième passager",
        "duree": "117 minutes",
        "acteurs": [
            "Sigourney Weaver",
            "Tom Skerritt",
            "Veronica Cartwright",
            "Harry Dean Stanton",
            "John Hurt"
        ],
        "audio": [
            "Anglais (DTS-HD 5.1)",
            "Français (DTS 5.1)"
        ],
        "sous-titres": [
            "Français",
            "Espagnol"
        ],
        "production": {
            "realisateur": "Ridley Scott",
            "date_production": new Date("1979-06-22"),
            "studio": "20th Century Fox"
        },
        "exemplaires" : [{
            "code_barre": "05AGH1-4AFU6589",
            "premiere_mise_en_rayonnage": new Date("2015-11-11"),
            "disponible": "non",
            "emprunts": [
                {
                    "date_emprunt": new Date("2016-06-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2016-07-10"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2018-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2018-10-10"),
                    "etat_retour": "RAS",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c8"),
        "type": "Jeu video",
        "sous-type": "PS3",
        "categorie": [
            "fantastique",
            "action",
            "JDR"
        ],
        "titre": "The Witcher 2 : Assassins of Kings",
        "edition": {
            "developpeur": "CD Projekt Red",
            "editeur": "Namco Bandai Partners",
            "date_sortie": new Date("2011-05-17")
        },
        "exemplaires" : [{
            "code_barre": "152JIH1-4512986345",
            "premiere_mise_en_rayonnage": new Date("2014-11-11"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2015-06-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2015-07-10"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2017-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2017-10-10"),
                    "etat_retour": "RAS",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926c9"),
        "type": "Jeu video",
        "sous-type": "Xbox",
        "categorie": [
            "SF",
            "FPS"
        ],
        "titre": "Halo: Combat Evolved",
        "edition": {
            "developpeur": "Bungie",
            "editeur": "Microsoft Game Studios",
            "date_sortie": new Date("2002-03-14")
        },
        "exemplaires" : [{
            "code_barre": "1156e21245ergy41551",
            "premiere_mise_en_rayonnage": new Date("2005-11-11"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2008-04-10"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2008-04-25"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2012-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2012-10-10"),
                    "etat_retour": "RAS",
                },
 		{
                    "date_emprunt": new Date("2012-04-10"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2012-04-25"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2018-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2018-10-10"),
                    "etat_retour": "RAS",
                }
            ]
        }]
    },
    {
        "_id" : ObjectId("5e888c7b788e2ab63ff926ca"),
        "type": "Jeu video",
        "sous-type": "PC",
        "categorie": [
            "fantastique",
            "JDR",
            "strategie"
        ],
        "titre": "Might and Magic Heroes VI",
        "edition": {
            "developpeur": "Ubisoft",
            "editeur": "Black Hole Entertainment",
            "date_sortie": new Date("2011-10-13")
        },
        "exemplaires" : [{
            "code_barre": "1156tteg5465",
            "premiere_mise_en_rayonnage": new Date("2014-06-11"),
            "disponible": "non",
            "emprunts": [
                {
                    "date_emprunt": new Date("2016-04-10"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2016-04-25"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2020-03-15"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": "",
                    "etat_retour": "",
                }
            ]
        }]
    },
   {
        "_id" : ObjectId("5e888c7b788e2ab63ff926cb"),
        "type": "Jeu video",
        "sous-type": "PC",
        "categorie": [
            "fantastique",
            "point 'n click",
            "JDR"
        ],
        "titre": "Sam & Max Hit the Road",
        "edition": {
            "developpeur": "LucasArts",
            "editeur": "LucasArts",
            "date_sortie": new Date("1993-11-13")
        },
        "exemplaires" : [{
            "code_barre": "152JIH1-4512986346",
            "premiere_mise_en_rayonnage": new Date("2014-11-11"),
            "disponible": "oui",
            "emprunts": [
                {
                    "date_emprunt": new Date("2013-02-15"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2013-03-10"),
                    "etat_retour": "RAS",
                },
                {
                    "date_emprunt": new Date("2018-09-30"),
                    "etat_debut_emprunt": "RAS",
                    "date_retour": new Date("2018-10-10"),
                    "etat_retour": "RAS",
                }
            ]
        }]
    }
    ])

db.ouvrages_ref.createIndex({"type":1, "sous-type":1,"categorie":1,"titre":1})

db.users_ref.insert([
    {
    "_id" : ObjectId("5e88985f788e2ab63ff926d7"),
    "role": "member",
    "name": "Emmett Brown",
    "dob" : "1955-03-19",
    "registration_date" : "1985-10-26",
    "personalList" : [ObjectId("5e888c7b788e2ab63ff926c0"),
                ObjectId("5e888c7b788e2ab63ff926c2"),
                ObjectId("5e888c7b788e2ab63ff926c6")],
    "borrowed" : ["5e888c7b788e2ab63ff926c0",  "5e888c7b788e2ab63ff926c2", "5e888c7b788e2ab63ff926c1", "5e888c7b788e2ab63ff926c6"]
    },
    {
    "_id" : ObjectId("5e88985f788e2ab63ff926d8"),
    "role": "member",
    "name": "Marty McFly",
    "dob" : "1968-06-09",
    "registration_date" : "2015-10-26",
    "follows": [{
        "id" : ["5e88985f788e2ab63ff926d7", "5e88985f788e2ab63ff926da", "5e88985f788e2ab63ff926de"]
    }],
    "personalList" : [ObjectId("5e888c7b788e2ab63ff926c6"),
                ObjectId("5e888c7b788e2ab63ff926c7")],
    "borrowed" : ["5e88985f788e2ab63ff926d7",  "5e888c7b788e2ab63ff926bf", "5e88985f788e2ab63ff926da", "5e888c7b788e2ab63ff926c6", "5e88985f788e2ab63ff926de"]
    },
    {
    "_id" : ObjectId("5e88985f788e2ab63ff926d9"),
    "role": "member",
    "name": "Biff Tannen",
    "dob" : "1959-04-15",
    "registration_date" : "2006-09-15",
    "follows": [{
            "id" : ["5e88985f788e2ab63ff926d7", "5e88985f788e2ab63ff926d8", "5e88985f788e2ab63ff926de"]
        }],
    "personalList" :[ObjectId("5e888c7b788e2ab63ff926c2")],
    "borrowed" : ["5e88985f788e2ab63ff926d7",  "5e88985f788e2ab63ff926d8", "5e888c7b788e2ab63ff926c1", "5e88985f788e2ab63ff926de"]
    },
    {
    "_id" : ObjectId("5e88985f788e2ab63ff926da"),
    "role": "member",
    "name": "Jennifer Parker",
    "dob" : "1966-07-05",
    "registration_date" : "1990-07-16",
    "follows": [{
            "id" : ["5e88985f788e2ab63ff926d8"]
        }],
    "personalList" : [ObjectId("5e888c7b788e2ab63ff926c1")],
    "borrowed" : ["5e888c7b788e2ab63ff926c6",  "5e888c7b788e2ab63ff926c3", "5e888c7b788e2ab63ff926c1", "5e888c7b788e2ab63ff926c5", "5e888c7b788e2ab63ff926c2"],
    "reviews" : [{
        "reference_ouvrage": ObjectId("5e888c7b788e2ab63ff926c9"),
        "reference_auteur": ObjectId("5e88985f788e2ab63ff926d8"),
        "date_critique": new Date("2019-09-10"),
        "critique": "Ce jeu est anthologique c'est toute ma jeunesse",
        "note_critique" : 2
    },
    {
        "reference_ouvrage": ObjectId("5e888c7b788e2ab63ff926c0"),
        "reference_auteur": ObjectId("5e88985f788e2ab63ff926da"),
        "date_critique": new Date("2020-01-15"),
        "critique": "BD culte et indémodable",
        "note_critique" : 5
    }]
    },
    {
    "_id" : ObjectId("5e88985f788e2ab63ff926db"),
    "role": "member",
    "name": "Lorraine Baines",
    "dob" : "1961-05-31",
    "registration_date" : "1989-01-09",
    "follows": [{
            "id" : ["5e88985f788e2ab63ff926d8", "5e88985f788e2ab63ff926da", "5e88985f788e2ab63ff926dc"]
        }],
    "personalList" :[ObjectId("5e888c7b788e2ab63ff926c3")],
    "borrowed" : ["5e888c7b788e2ab63ff926c6",  "5e888c7b788e2ab63ff926bf", "5e888c7b788e2ab63ff926c4"]
    },
    {
    "_id" : ObjectId("5e88985f788e2ab63ff926dc"),
    "role": "member",
    "name": "George McFly",
    "dob" : "1964-04-20",
    "registration_date" : "1993-02-18",
    "follows": [{
            "id" : ["5e88985f788e2ab63ff926d8", "5e88985f788e2ab63ff926db"]
        }],
    "personalList" : [ObjectId("5e888c7b788e2ab63ff926c6")],
    "borrowed" : ["5e888c7b788e2ab63ff926c6",  "5e888c7b788e2ab63ff926bf", "5e888c7b788e2ab63ff926c1", "5e888c7b788e2ab63ff926c5"]
    },
    {
    "_id" : ObjectId("5e88985f788e2ab63ff926dd"),
    "role": "employee",
    "name": "Robert Zemeckis",
    "dob" : "1952-05-14",
    "registration_date" : "2000-03-15",
    "follows": [{
            "id" : ["5e88985f788e2ab63ff926d7", "5e88985f788e2ab63ff926d8", "5e88985f788e2ab63ff926de"]
        }],
    "personalList" : [ObjectId("5e888c7b788e2ab63ff926c4"),
                    ObjectId("5e888c7b788e2ab63ff926c5")],
    "borrowed" : ["5e88985f788e2ab63ff926d7",  "5e88985f788e2ab63ff926de", "5e888c7b788e2ab63ff926c1", "5e888c7b788e2ab63ff926c6", "5e88985f788e2ab63ff926d8"],
    "reviews" : [
    {
            "reference_ouvrage": ObjectId("5e888c7b788e2ab63ff926c3"),
            "reference_auteur": ObjectId("5e88985f788e2ab63ff926db"),
            "date_critique": new Date("2019-09-10"),
            "critique": "Faire des sushis soi-même ça déchire!",
            "note_critique" : 3
    }
    ]
    },
    {
    "_id" : ObjectId("5e88985f788e2ab63ff926de"),
    "role": "member",
    "name": "Lucas Dupuy",
    "dob" : "1991-04-20",
    "registration_date" : "2015-05-18",
    "follows": [{
            "id" : ["5e88985f788e2ab63ff926dd", "5e88985f788e2ab63ff926da"]
        }],
    "personalList" : [ObjectId("5e888c7b788e2ab63ff926c6")],
    "borrowed" : ["5e888c7b788e2ab63ff926c6",  "5e888c7b788e2ab63ff926bf", "5e888c7b788e2ab63ff926c1", "5e888c7b788e2ab63ff926c6"]
    }
])