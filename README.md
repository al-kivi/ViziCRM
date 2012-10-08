## ViziCRM - Ramaze demo that provides a small CRM application. 

The VizCRM application combines the Viziframe framework with a simple CRM application.

This application can be used for tutorial purposes to learn about the features of Ramaze.

This application uses a SQLite database that is accessed with Sequel.  

By Al Kivi

Email: al.kivi@vizitrax.com

### About

ViziCRM is a fully functioning application that can be used to learn the basics of the Ramaze language. 

The application is modelled after various open source CRM applications including FatFreeCRM and SugarCRM.

Some of key features of this application include:

* The ViziCRM database includes a number of tables with complex relationships between the tables.
* The users can add, edit and delete all of the major CRM tables
* The application supports the conversion of Leads to Contacts
* User must register with a username and password to add or edit the key tables.
* Once the shopping cart is full, the user move to the check-out operation.
* The application has a dashboard screen that shows history of actions against the various tables.

All of the capabilities of the Viziframe framework are also available:

* The User model in the Viziframe applications is used
* A Blog application is also included although it is not accessible by a visible menu.
* Refer to the Viziframe application in Github for more information.

### Requirements

* Ruby 1.8.7 or greater
* Sqlite 3.7.13

And the following Gems

* Ramaze 2012.04.14
* Sqlite3 1.3.6
* Sequel 3.37.0

### Get started in the Development Environment

* Install SQLite

* Install the required Gems (as above)
	* Refer to www.ramaze.net for installation instructions for Ramaze
	* Refer to sequel.rubyforge.org for documentation on Sequel

---

* Download zip file from Github
* Extract into application directory (e.g., /apps)
* Use SQLite explorer create the 'crm.sqlite' in the /db sub-directory
* Load the 'crm.sqlite' using your SQLite administration tools
	* Load the tables and data from the extract file 'crm.sql' in the /migrations sub-directory.

---

* Go to the /apps/vizimusic sub-directory to start up the application
* Enter the following in the terminal command line > ramaze start
* The administrator can logon with user 'admin' and password 'myadmin' 

### Get started in the Production Environment (Passenger)

* Install SQLite

* Install the required Gems

* The app.rb module will look for the value in ENV['RACK_ENV']
	* If the value is nil, then a development environment is assumed
	* If the value is 'production', then it is a production environment. The conditional logic handles a Passenger environment, and makes appropriate adjustments to the Gem paths.
	* You may need to modify the add.rb code to reflect the requirements of your production environment.

### Demo Application

You can view a hosted version of the application at 'crm.vizitrax.com'.

### Thanks 

Yorick Peterse and Justkez for their applications that demonstrate the potential capabilities of Ramaze.
