require "sequel"
require "csv"

db = Sequel.sqlite('geocoding.db')

db.drop_table? :states
db.create_table :states do
  String :abbreviation
  Float :latitude
  Float :longitude
end

db.drop_table? :zip_codes
db.create_table :zip_codes do
  String :zip
  String :city
  String :state
  String :area_codes
  Float :latitude
  Float :longitude
end

states = db[:states]
CSV.foreach(File.join(File.dirname(__FILE__), "/state_latlon.csv")) do |row|
  states.insert(:abbreviation => row[0],
                :latitude => row[1].to_f,
                :longitude => row[2].to_f)
end

zip_codes = db[:zip_codes]
CSV.foreach(File.join(File.dirname(__FILE__), "/zip_code_database.csv")) do |row|
  zip_codes.insert(:zip => row[0],
                   :city => row[2],
                   :state => row[5],
                   :area_codes => row[8],
                   :latitude => row[9],
                   :longitude => row[10])
end