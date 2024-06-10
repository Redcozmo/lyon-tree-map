<style type="text/css">
#shiny-tab-explanation {
  max-width: 90ch;
  margin-left: auto;
  margin-right: auto;
  font-size: 1.2em;
}
</style>

# Présentation

Cette application permet une visualisation des arbres d’alignement de la
métropole de Lyon. Il est possible d’effectuer une recherche par ville,
par genre et par espèce. Une carte interactive permet la visualisation
du résultat de la recherche.

L’arbre d’alignement est un objet ponctuel représentant un arbre situé
sur le domaine public et géré par le Grand Lyon. Généralement localisé
le long des voies de circulation ou sur les espaces publics, il est
caractérisé par des informations de gestion (genre, espèce, variété,
essence botanique, hauteur, diamètre couronne, localisation, date et
année de plantation)<br>

## Source des données

Les données originales ont été téléchargées sur le site
[data.grandlyon.com](https://data.grandlyon.com), mise à jour du
24/08/2022.

Lien direct vers la donnée :<br>
<https://data.grandlyon.com/portail/fr/jeux-de-donnees/arbres-alignement-metropole-lyon/info>

Ces données sont fournies sous licence ouverte
[Etalab](https://data.grandlyon.com/portail/fr/assets/licences/ETALAB-Licence-Ouverte-v2.0.pdf).

## Source de données additionnelles

Données wikipedia formatées avec url + nom de genre + nom d’espece

## Nettoyage des données

La base de données comporte 106 710 arbres. Certains arbres ne sont pas
identifiés. En effet certains arbres ont la valeur “Souche”, “Non
défini” ou “Emplacement libre” pour leur attributs de genre ou de nom
commun. De la même manière certains arbres ont la valeur NA pour leur
espèce. Ces arbres non identifiés sont supprimés de l’analyse. La base
de données comporte après nettoyage 98 998 arbres identifiés.

L’attribut “variété” n’est pas toujours renseigné, 76 848 arbres ont une
valeur NA. Nous considérons que chaque individu végétal est considéré
comme appartenant à un certain nombre de taxons de rangs
hiérarchiquement subordonnés et dont l’espèce (species) constitue le
rang de base.

### Résumé global des données :

<table class="table table-striped" style="color: black; width: auto !important; ">
<thead>
<tr>
<th style="text-align:left;">
Item
</th>
<th style="text-align:right;">
Total
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Nombre de communes
</td>
<td style="text-align:right;">
67
</td>
</tr>
<tr>
<td style="text-align:left;">
Nombre de genres
</td>
<td style="text-align:right;">
122
</td>
</tr>
<tr>
<td style="text-align:left;">
Nombre d’espèces
</td>
<td style="text-align:right;">
280
</td>
</tr>
<tr>
<td style="text-align:left;">
Nombre d’arbres
</td>
<td style="text-align:right;">
98998
</td>
</tr>
</tbody>
</table>

### Répartition des arbres par genre :

<table class="table table-striped table-hover table-condensed table-responsive" style="color: black; width: auto !important; ">
<thead>
<tr>
<th style="text-align:left;">
Genre
</th>
<th style="text-align:right;">
Total
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Platanus
</td>
<td style="text-align:right;">
18037
</td>
</tr>
<tr>
<td style="text-align:left;">
Acer
</td>
<td style="text-align:right;">
13239
</td>
</tr>
<tr>
<td style="text-align:left;">
Fraxinus
</td>
<td style="text-align:right;">
7325
</td>
</tr>
<tr>
<td style="text-align:left;">
Celtis
</td>
<td style="text-align:right;">
6956
</td>
</tr>
<tr>
<td style="text-align:left;">
Quercus
</td>
<td style="text-align:right;">
6796
</td>
</tr>
</tbody>
</table>

### Répartition des arbres par nom commun :

<table class="table table-striped table-hover table-condensed table-responsive" style="color: black; width: auto !important; ">
<thead>
<tr>
<th style="text-align:left;">
Nom commun
</th>
<th style="text-align:right;">
Total
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Platane à feuilles d’érable
</td>
<td style="text-align:right;">
17097
</td>
</tr>
<tr>
<td style="text-align:left;">
Micocoulier de Provence
</td>
<td style="text-align:right;">
6443
</td>
</tr>
<tr>
<td style="text-align:left;">
Sophora du Japon
</td>
<td style="text-align:right;">
3016
</td>
</tr>
<tr>
<td style="text-align:left;">
Poirier à fleurs ‘Chanticleer’
</td>
<td style="text-align:right;">
2634
</td>
</tr>
<tr>
<td style="text-align:left;">
Erable champêtre
</td>
<td style="text-align:right;">
2503
</td>
</tr>
</tbody>
</table>

## Objectif

L’objectif de l’application est de rendre plus accessible cette donnée
des arbres de la métropole de Lyon. Il y a aussi un objectif personnel
qui est l’apprentissage la pratique de R et de Shiny ainsi que de rendre
visible mon travail.

## Exemple d’utilisation

Vous souhaitez aller à la rencontre d’un Ginkgo Biloba de la Métropole ?
Séléctionnez toutes les villes, ensuite le genre “Gingko” puis l’espèce
“biloba”. L’application vous amène directement sur la carte avec tous
les Ginkgo biloba de la Métropole. Il ne vous reste plus qu’à vous
rendre vers l’un d’eux.

## Développement

L’application est developpée en langage
[R](https://fr.wikipedia.org/wiki/R_(langage)) et au package
[shiny](https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/index.html)
qui permet de réaliser des applicatoin web interactives. Les packages
principaux utilisés sont shiny, [leaflet]() pour la carte,
[sf](https://r-spatial.github.io/sf/) pour la manipulation, la
transformation et l’analyse de données spatiales et
[dplyr](https://dplyr.tidyverse.org/) qui fait partie du
[tidyerse](https://www.tidyverse.org/) et permet de faciliter le
traitement et la manipulation des données un peu à la manière du langage
SQL.

## Evolution de l’application

Le coeur de l’application restera la visualisation des arbres dans le
métropole de Lyon. Une évolution importante pourrait être l’ajout des
arbres dans les parcs publics et les jardins privatifs. Le parc de la
tête d’or serait par exemple un terrain de jeu très interessant pour
cartographier les arbres avec la donnée lidarHD de l’IGN, et une
reconnaissance sur le terrain et / ou via un algortithme
d’apprentissage. L’arboretum de Sathonay Camp, le parc de la mairie de
Sathonay Village serait aussi des applicatoins intéressantes.

## Code source et licence

L’ensemble du code source est disponible sur le dépôt
[github.com](https://github.com/) de l’application sous licence
[BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/).

## Auteur

Josselin GIFFARD-CARLET<br> <https://github.com/Redcozmo>
