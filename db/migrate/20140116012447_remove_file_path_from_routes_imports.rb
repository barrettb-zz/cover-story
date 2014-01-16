class RemoveFilePathFromRoutesImports < ActiveRecord::Migration
  def change
    remove_column :routes_imports, :file_path
  end
end
