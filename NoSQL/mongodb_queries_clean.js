//    4-a Retourner tous les utilisateurs qui suivent Lucas Dupuy
//    On créé une variable capturant l'id de l'utilisateur Lucas Dupuy comprenant le nom et la date de naissance pour éviter les homonymes
var ldupuy = db.users_ref.findOne({$and: [{name: "Lucas Dupuy"}, {dob: "1991-04-20"}]})._id.valueOf()
//On récupère ensuite tous les utilisateurs suivant Lucas Dupuy
var ldupuyFollowers = db.users_ref.find({"follows":{$in:[ldupuy]}})
//On affiche enfin le nom de ces utilisateurs
ldupuyFollowers.forEach(follower => print(follower.name))

//    4-b Retourner tous les jeux vidéo disponible sur PS3
db.ouvrages_ref.find({"sous-type":"PS3", "exemplaires.disponible":"oui"}).forEach(psgame => print(psgame.titre))

//    4-c Retourner tous les livres écrit par Maxime Chattam
db.ouvrages_ref.find({"type":"Livre","auteur":"Maxime Chattam"}).forEach(chattamBook => print(chattamBook.titre))

//    4-d Retourner tous les mangas disponibles depuis moins de 6 mois
//On créé dans un premier temps une variable capturant la date actuelle
var exo_date = new Date();
//On soustrait ensuite 6 mois à cette date
exo_date.setMonth(exo_date.getMonth() - 6);
//On cherche ensuite tous les exemplaires disponibles, comportant une date supérieure à exo_date, et dont le sous-type correspond à un manga
db.ouvrages_ref.find({
    $and:[
		{
			"exemplaires.premiere_mise_en_rayonnage" : {$gte:exo_date}
		},
		{
			"sous-type": {$regex: "manga", $options: "ix"}
		},
		{
			"exemplaires.disponible" : "oui"
		}]
    }).forEach(recentManga => print(recentManga.titre))

//    4-e Retourner tous les livres édités par Hachette Livre
db.ouvrages_ref.find({"type":"Livre","edition.editeur":"Hachette Livre"}).forEach(hachetteBook => print(hachetteBook.titre))

//    4-f Retourner tous les films réalisés par Ridley Scott
db.ouvrages_ref.find({"type":"Film","production.realisateur" : "Ridley Scott"}).forEach(scottMovie => print(scottMovie.titre))

//    4-g Retourner les 5 ouvrages ayant été le plus empruntés
var mostBorrowed = db.users_ref.aggregate([
	//On aplanit tous les ouvrages empruntés
	{ $unwind: "$borrowed" },
	//On groupe ensuite par _id d'ouvrage afin de compter le nombre d'occurence de chaque _id
	{ $group: { "_id": "$borrowed", "count": { $sum: 1 } } },
	//On trie le résultat par ordre décroissant
	{ $sort: { "count": -1 } },
	//On limite le nombre de résultats aux 5 premiers
	{ $limit: 5}
	]);

//On affiche enfin les résultats
mostBorrowed.forEach(printjson)

//4-h Retourner les 5 ouvrages les plus cités dans les listes
var mostFrequent = db.users_ref.aggregate([
	//On aplanit les objets contenus dans les listes personnelles
	{ $unwind: "$personalList" },
	//On groupe par identifiant d'ouvrages contenus dans les listes, puis on compte le nombre d'occurence de chaque _id
	{ $group:
		{
			"_id": "$personalList", "count": { $sum: 1 }
		}
	},
	//On trie le résultat par ordre décroissant
	{ $sort: { "count": -1 } },
	//On limite le nombre de résultats aux 5 premiers
	{ $limit: 5}
	]);

//On affiche enfin les résultats
mostFrequent.forEach(printjson)

//    4-i Sachant que Lucas aime les romans policiers et les point 'n click, écrire une requête recommandant un jeu
//    que Lucas n'a jamais emprunté qui peut lui plaire
//On capture l'utilisateur Lucas dans une variable pour accéder facilement à sa liste
var alreadySeen = db.users_ref.findOne({
	//On rajoute la date de naissance de l'utilisateur pour éviter de trouver un homonyme à "Lucas Dupuy"
    $and:[{name: "Lucas Dupuy"}, {dob:"1991-04-20"}]
    })

//On cherche ensuite tous les ouvrages contenant "point" dans leur categorie ou "policier"
db.ouvrages_ref.find({
    $or:[
			{
				"categorie": {
					"$elemMatch": {"$regex" : "point", "$options" : "i"}
				}
			},
			{
				"sous-type": {$regex: "policier", $options: "ix"}
			}
		],
	//et les ouvrages ne faisant pas partie de la liste de Lucas
    $and:[{
        "_id":{"$nin": alreadySeen.personalList}
        }]
    }).forEach(newGameOrBook => print(newGameOrBook.titre))

//4-j Retourner un ouvrage à emprunter apprécié par l'une des personnes que Lucas Dupuy suit
//    On créé une variable contenant l'utilisateur Lucas Dupuy
var ldupuyMedia = db.users_ref.findOne({$and: [{name: "Lucas Dupuy"}, {dob: "1991-04-20"}]})
//    On récupère arbitrairement l'id de la première personne que Lucas Dupuy suit
var ldFollows = ldupuyMedia.follows[0]
//    On récupère ensuite tout ouvrage faisant partie d'une review de l'utilisateur ldFollows
//    ayant une note supérieure ou égale à 3
var followerMedia = db.users_ref.findOne({
        $and:[
            {_id: ObjectId(ldFollows)},
            {"reviews.note_critique": {$gte: 3}}]
    }).reviews.valueOf()[0]
followerMedia

//4-k Retourner la moyenne d'âge des utilisateurs
// Calculer l'âge des utilisateurs, créer une nouvelle collection avec
db.getCollection("users_ref").aggregate([
	//On convertit le champ "dob" en date
	{ "$addFields":
		{"dob": {"$toDate": "$dob"}}
	},
	//On récupère ensuite dans un projet le nom, la date de naissance et l'âge
	{ $project: {
		name: 1,
		dob:"$dob",

		age: ({$subtract:[
			//On soustrait l'année actuelle à l'année de naissance
			{$subtract:[{$year:"$$NOW"},{$year:"$dob"}]},
			//Si le jour de naissance de l'individu est inférieur à la date d'aujourd'hui,
			//on renvoie 1 qui sera soustrait à l'âge de l'individu. Sinon, on renvoie 0 (on ne soustrait rien)
			{$cond:[
				{$gt:[0, {$subtract:[
					{$dayOfYear:"$$NOW"},
					{$dayOfYear:"$dob"}]}
				]},
				1,
				0]}
		]})
	}},
	//On renvoie ensuite une nouvelle collection usersAge (cette dernière étant issue d'un aggrégat,
	//on utilise la convention varName au lieu du var_name jusqu'ici employé) pour mieux la repérer
	{$out: "usersAge"}
])

//On calcule ensuite l'âge moyen
db.usersAge.aggregate([
    {
        "$group": {
            "_id": null,
            "avg": { "$avg": "$age" }
        }
    }
]).forEach(age =>  print("Age moyen : ", age.avg));

//4-l Retourner l'ouvrage ayant la meilleure moyenne de note et celui ayant la moins bonne
var grades = db.users_ref.aggregate(
    [
        //On déploie les reviews dans un premier temps
        { "$unwind": "$reviews" },
        //On regroupe ensuite par référence d'ouvrage, puis on calcule la note moyenne
        { "$group": {
            "_id": "$reviews.reference_ouvrage",
            "note_moyenne": { "$avg": "$reviews.note_critique" }
        }},
        //On définit les champs correspondant aux données triées en asc. et en desc.
        { "$facet": {
            "best_grade": [{ "$sort": { "note_moyenne": -1 } }],
            "lowest_grade": [{ "$sort": { "note_moyenne": 1 } }]
        }},
        //On ajoute les champs correspondant au premier élément de chaque item,
        //soit le premier élément du tri descendant (plus haute note) et le premier élément du tri descendant
        { "$addFields": {
            "BestGrade": {
            "$arrayElemAt": ["$best_grade", 0]
            },
            "LowestGrade": {
            "$arrayElemAt": ["$lowest_grade", 0]
            }
        }},
        //On sélectionne ensuite uniquement ces deux derniers champs
        {
            "$project": {
                "BestGrade": 1,
                "LowestGrade": 1
        }}
    ]
)

grades
