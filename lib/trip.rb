require 'csv'
require 'time'
require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver
    
    def initialize(id:,
      passenger: nil, passenger_id: nil,
      start_time:, end_time:, cost: nil, rating:, driver_id: nil, driver: nil)
      super(id)
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
        
      elsif passenger_id
        @passenger_id = passenger_id
        
      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end
      
      @start_time = start_time
      @end_time = end_time
      if end_time != nil && end_time < start_time 
        raise ArgumentError, "Trip ended before it started??! Are you OK?"
      end 
      @cost = cost
      @rating = rating
      
      if @rating != nil && (rating > 5 || @rating < 1)
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
      
      if driver
        @driver = driver
        @driver_id = driver.id
        
      elsif driver_id
        @driver_id = driver_id
        
      else
        raise ArgumentError, 'Driver or driver_id is required'
      end
    end
    
    def inspect
      # Prevent infinite loop when puts-ing a Trip
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect_passenger(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end
    
    def connect_driver(driver)
      @driver = driver
      driver.add_trip(self)
    end 
    
    def duration
      return end_time - start_time
    end 
    
    private
    
    def self.from_csv(record)
      return self.new(
        id: record[:id],
        driver_id: record[:driver_id],
        passenger_id: record[:passenger_id],
        start_time: Time.parse(record[:start_time]),
        end_time: Time.parse(record[:end_time]),
        cost: record[:cost],
        rating: record[:rating]
      )
    end
  end
end
