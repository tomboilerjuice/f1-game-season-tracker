require 'csv'
require 'rails'

class RaceController < ApplicationController
  def index

  end

  def new
    @tracks = Track.all().pluck(:name)
  end

  def create
    data = params[:data]
    name = params[:track].downcase
    season_id = params[:season_number]
    track_id = Track.find_by(name: params[:track]).id
    @results_array = data.split("\r\n\r\n")
    position_array = build_array('POS')

    drivers_array = build_array('DRIVER')

    team_array = build_array('TEAM')

    grid_array = build_array('GRID')

    best_array = build_array('BEST')

    ms_array = best_array.map{ | best | convert_time_to_ms(best)}

    time_array = build_array('TIME')

    final = position_array.zip(drivers_array, team_array, grid_array, best_array, ms_array, time_array)

    race_result = []

    position_array.each_with_index do |position, id|
      race_result[id] = {
        :position => position,
        :driver => drivers_array[id],
        :team => team_array[id],
        :grid => grid_array[id],
        :best => best_array[id],
        :milliseconds => ms_array[id],
        :time => time_array[id],
        :track_id => track_id,
        :season_id => season_id
      }
    end

    Race.create(race_result)

    # binding.pry

    file_path = "#{Rails.application.credentials.dig(:local_storage)}#{name}.csv"

    s=CSV.generate do |csv|
      csv << ["Position", "Driver", "Team", "Grid", "Best", "Milliseconds", "Time"]
      final.each do |x|
        csv << x
      end
    end
    File.write(file_path, s)

  end

  private

  def convert_time_to_ms(time_string)
    a=[1, 1000, 60000, 3600000]*2
    time_string.split(/[:\.]/).map{|time| time.to_i*a.pop}.inject(&:+)
  end

  def replace_strings(str)
    replace_strings = {
      "M.Schumacher" => "Michael Schumacher",
      "Jean éric Vergne" => "Jean-Éric Vergne",
      "Mc Laren" => "McLaren",
      "Mclaren" => "McLaren",
      "Amg" => "AMG",
      "P1" => "",
      "P2" => "",
      "Pedro De La Rosa" => "Pedro de la Rosa",
      " Tm" => '™',
      'Hrt' => 'HRT'
    }

    replace_strings.each { |k, v| str.sub!(k, v) }
    strip = str.strip
    strip
  end

  def build_array(type)
    start_position = @results_array.find_index(type)
    end_position = start_position + 12
    trimmed_array = @results_array[start_position..end_position]
    trimmed_array.shift
    case type
    when 'POS'
      trimmed_array = trimmed_array.map { | no | no.to_i }
    when 'DRIVER', 'TEAM'
      trimmed_array = trimmed_array.map {|word| word.titleize}
      trimmed_array = trimmed_array.map {|s| replace_strings(s)}
    when 'BEST'
      trimmed_array = trimmed_array.map { |word| "00:0#{word}" }
    when 'TIME'
      trimmed_array = trimmed_array.map { |time| time.length < 8 ? "'+#{'%.3f' % time}" : time }
    end
    trimmed_array
  end

end
