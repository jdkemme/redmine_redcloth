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

Forum links/ titles with quotes (") do not parse correctly

- example: [["very nifty" forum post]]

Markdown-style nested block quotes do not render
	
	>> Rails is a full-stack framework for developing database-backed web 
	>> applications according to the Model-View-Control pattern.
	>> To go live, all you need to add is a database and a web server.
	> Great!
	


