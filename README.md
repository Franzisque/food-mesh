# Food Mesh
    + Link to Git Repo: git@git.mediacube.at:fhs34784/food-mesh.git
    + Link to Project: http://food-mesh.herokuapp.com/

## Features
+ Search Food Items from different sources. Currently:
	+ FDDB (http://fddb.info/)
    + Nutritionix (http://www.nutritionix.com/api)
    + Fatsecret (http://www.fatsecret.com/)
    + other apis may be available in the future
+ Translate Food Item Names to any language using bing_translator gem
    + Translations are cached to the food_item model
+ Cache Food Items:
	+ all Searches and Food Items are stored in a mongoDB Database
    	+ Info: the database is currently hosted on lnx-tm.may-it.net
+ Two different chart views all created with SVG and Animated with
	+ Single item (animated with http://d3js.org/)
    + Multiple Item Chart
+ Calculate all nutrition information according to the personal condition
    + Info: only works on pie chart currently, line chart etc. will follow
+ Admin Dashboard for administrative tasks also see

## Admin Dashboard Info
This project contains an administrative interface, which can be accessed via <root_url>/admin (currently this is http://food-mesh.herokuapp.com/admin)
There is currently a demo usere with the following credentials:

	Username: demo@fh-salzburg.ac.at
	Password: foodmesh#2014


### Features of the Dashboard
+ add/remove Admins
+ clear search cache
+ view most searched queries
+ administer nutrition information
+ change homepage text



## mongoDB Info
Because we forgot to request a mongoDB database and the port 27027 is not opend on the FH Webspace we've deployed our project to heroku and hosted the database on lnx-tm.may-it.net.
So if the port is opend on the server, the application should be running without any issues.




## About
Food Mesh is a projekt by our awesome team:

### Developer
+ Franziska Oberhauser
+ Thomas Mayrhofer

### Graphics
+ Gudrun Öhlinger
+ Nora Sieß
+ Marie-Therese Schweitl

##Impressum
This project is a Multimedia Project for our studies at the University of Applied Sciences in Salzburg/Austria.