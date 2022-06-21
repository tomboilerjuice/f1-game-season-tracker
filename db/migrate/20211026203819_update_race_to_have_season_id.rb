class UpdateRaceToHaveSeasonId < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :season_id, :integer
  end
end
