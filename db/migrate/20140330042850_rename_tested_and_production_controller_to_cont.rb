class RenameTestedAndProductionControllerToCont < ActiveRecord::Migration
  def change
    rename_table :tested_controllers, :tested_conts
    rename_table :production_controllers, :production_conts
  end
end
