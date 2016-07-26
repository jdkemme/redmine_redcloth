# redmine_redcloth plugin
A Redcloth 4 plugin for Redmine

### Installation:

- Choose folder /plugins, run command

    >git clone https://github.com/jdkemme/redmine_redcloth.git   
    >bundle install --without development test

- restart rails server. (touch tmp/restart.txt)
- In redmine, Administration>Settings>General
	- set Text formatting to: Redcloth 4

### Known Limitations:

- Markdown-style nested block quotes do not render if escape HTML option is enabled.
	
		>> Rails is a full-stack framework for developing database-backed web 
		>> applications according to the Model-View-Control pattern.
		>> To go live, all you need to add is a database and a web server.
		> Great!

- lite mode setting doesn't appear to have an effect on formatting


