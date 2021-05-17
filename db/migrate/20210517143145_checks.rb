class Checks < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :checks, :users
  end
end
