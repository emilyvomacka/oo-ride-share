# driver.rb

require_relative 'csv_record'
require_relative 'trip'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      if vin.length != 17
        raise ArgumentError.new("Invalid VIN")
      end
      @status = status.to_sym
      ok_statuses = [:AVAILABLE, :UNAVAILABLE]
      if !ok_statuses.include?(status)
        raise ArgumentError.new("Invalid status")
      end
      @trips = trips || []
    end 
    
    #Similar method exists in passenger 
    def add_trip(trip)
      @trips << trip
    end
    
    #TODO
    def average_rating
      total_ratings = 0
      if trips.length == 0
        return 0
      end 
      trips.each do |trip|
        total_ratings += trip.rating
      end 
      return (total_ratings / trips.length.to_f).round(2) 
    end 
    
    #TODO
    def total_revenue
      total_revenue = 0
      if trips.length == 0
        return 0 
      else
        @trips.each do |trip|
          gross_profit = trip.cost
          if gross_profit < 1.65
            drivers_share = gross_profit * 0.8
          else
            drivers_share = (gross_profit - 1.65) * 0.8
          end          
          total_revenue += drivers_share
        end
        return total_revenue.round(2)
      end 
    end
    
    private
    
    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end
