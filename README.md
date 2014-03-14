cover-story: Code coverage dashboard (soon?)
===========

This is rough on purpose for now.  Things that are in place:

#### CONFIG (config/config.yml)

The config file is very important. It defines:
- file Matchers for import
- directory locations for file import


#### IMPORT:
We will rely entirely on file drop for import.  

For the file drop to work, the daemon needs to be running.  See: 
lib/daemons/file_import_watcher.rb.  

You can run it with: 
RAILS_ENV=development ruby lib/daemons/file_import_watcher.rb

The file drop uses ImportService (app/services/import_service.rb).  This service drives the importing of all accepted files:
- log_something.log
- routes_something.txt
- meta_something.txt
- something.zip (the zip file MUST contain at least one of each of the above)

Right now the main import service funnels things downwards to the log, routes, and (not implemented yet) meta file import services.  Whether or not we consolidate all this into a single service and push the rest down to /lib is TBD.  /lib definitely needs to be organized a bit better and in perpetual progress.

Upon import, the following tables get updated, important columns noted:

##### Import Collection:
import_collections: This is the core record that Logs and Meta ("revisions" for now, TBD) tie to

##### Routes: 
routes (columns: path, controller - both of which are formatted)
route_histories (activated, inactivated)

##### Logs:
sources aka LogSource (env, ignore, import_collection_id)
started_lines aka LogStartedLine (formatted_path)
processing_lines aka LogProcessingLine (controller)

##### Meta:
TBD, but there is a revisions table in place.
The importer also kicks off the analysis at the end.  See ANALYSIS.


#### ANALYSIS
TBD.  
Right now we have building blocks in place for tested paths, tested controllers.


#### VIEW
TBD.
Right now it is the ugliest, slightly misaligned graph that allows hovering over nodes in the crudest of ways.  We ONLY show the percentage covered, and may not even filter it correctly by analysis type right now.


#### RAKE tools (examples):
- rake import:clear:logs/routes/all
- rake analyze:clear:all will clear all analysis data
- rake import:logs/routes (need to specify file)


#### TODO:
- TESTS!!!! we need this around each of our specific requirements (sorry)
- Analysis - we just need to design this overall
- View - it would be nice to have a graph per analysis type to start, basically a toggle. The core graph can be shared (maybe a partial) and the data can be pulled in based on the toggle selection
- meta file - what do we want to expect in here
- general cleanup/consolidation of lib/services
- anything we are doing outside the app
- bug on importing single files: right now we reuse the most recent import collection ID. we need to generate a new one and associate all the most recent records to it
