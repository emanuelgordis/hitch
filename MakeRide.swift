//
//  MakeRide.swift
//  hitch
//
//  Created by Emanuel on 5/5/21.
//

class Ride: Codable {
    let begin_lat: Float
    let begin_long: Float
    let end_lat: Float
    let end_long: Float
    let status: Int
     
    init(begin_lat: Float, begin_long: Float, end_lat: Float, end_long: Float, status: Int)
    {
        self.begin_lat = begin_lat
        self.begin_long = begin_long
        self.end_lat = end_lat
        self.end_long = end_long
        self.status = status
    }
}

class LocationItem: Codable {
    let latitude: Float
    let longitude: Float
    init(latitude: Float, longitude: Float){
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct RidesResponse: Codable {
    let success: Bool
    let data: [Ride]
}
