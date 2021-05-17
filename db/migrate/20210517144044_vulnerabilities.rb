class Vulnerabilities < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key "vulnerabilities", "checks"
  end
end
