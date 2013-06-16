require "sequel"
require "csv"

db = Sequel.sqlite('geocoding.db')

db.drop_table? :states
db.create_table :states do
  String :abbreviation
  String :latitude
  String :longitude
  primary_key :abbreviation
end

db.drop_table? :zip_codes
db.create_table :zip_codes do
  String :zip
  String :city
  String :state
  String :area_codes
  String :latitude
  String :longitude

  index [:city, :state]
end

states = db[:states]
CSV.foreach(File.join(File.dirname(__FILE__), "/state_latlon.csv")) do |row|
  states.insert(:abbreviation => row[0],
                :latitude => row[1],
                :longitude => row[2])
end

zip_codes = db[:zip_codes]
CSV.foreach(File.join(File.dirname(__FILE__), "/zip_code_database.csv")) do |row|
  next unless row[1] == 'STANDARD'
  zip_codes.insert(:zip => row[0],
                   :city => row[2],
                   :state => row[5],
                   :area_codes => row[8],
                   :latitude => row[9],
                   :longitude => row[10])
end
