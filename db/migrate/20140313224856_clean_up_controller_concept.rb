class CleanUpControllerConcept < ActiveRecord::Migration
  def change
    rename_table "analyzed_route_controllers", "analyzed_controllers"
    remove_column "routes", "controller_association"
    remove_column "started_lines", "controller" 
  end
end
