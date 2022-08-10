
```
shape de coll
	vérifier les dimensions, correspondance entre ScenePhysicDebug et dimensions spécifiées
		-> petit contrôle visual avec studio bienvenu
	vérifier transformations
	gestion correcte de multi shape (eg. chaise avec multiple box coll)

type de body
	static
		pas de réaction aux forces (gravité, force, impulse, collisions)
		pas déplacable

	kinematic
		- pas de réaction aux forces (gravité, force, impulse, collisions)
		- déplacable en code
			- récupérer les coord modifiées ?

		- parentage de kinematic doit marcher
			- via instantiation
			- via animation

	dynamic
		réaction aux forces (gravité, force, impulse, torque, collisions)

	interaction entre types

		- intéraction statique/kinematique
			-> collision event devraient être levés ! (ex implémenter un character controller à la main)
		- intéraction kinematique/dynamique (plateforme mobile sur lequel se trouve un cube/sphere/cone)
			-> vérifier collision event
		- interaction dynamique/dynamique

raycast
	bouton r qui balance 4 raycast offset dans l'espace vue sur X et Y et affiche en 3d les points d'intersection (rayon blanc jusqu'au point d'intersection ou rouge si pas d'intersection)
	
collision event
	write écran du nombre de coll dans la frame
	prévoir une sortie visuelle (ScenePhysicDebug probablement)

restitution
	sol avec 10 cubes qui rebondissent depuis une hauteur prédéfinie (0, 0.1, 0.2, 0.3, etc...)

friction
	planche avec 10 cubes qui glissent (0, 0.1, 0.2, 0.3, etc...)

ajout/suppression d'élément physiques
```
