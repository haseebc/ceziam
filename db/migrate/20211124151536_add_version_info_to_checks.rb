class AddVersionInfoToChecks < ActiveRecord::Migration[6.0]
  def change
    add_column :checks, :version_info, :jsonb
  end
end
