class CreateRaces < ActiveRecord::Migration[6.1]
  def change
    create_table :races do |t|
      t.integer :track_id
      t.integer :position
      t.string :driver
      t.string :team
      t.integer :grid
      t.string :best
      t.integer :milliseconds
      t.string :time

      t.timestamps
    end
  end
end
