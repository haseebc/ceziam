class AddStateToChecks < ActiveRecord::Migration[6.0]
  def change
    add_column :checks, :state, :string, default: "pending"
  end
end
