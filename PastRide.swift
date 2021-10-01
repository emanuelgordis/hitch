//
//  PastRide.swift
//  hitch
//
//  Created by Shreeya Indap on 5/5/21.
//

import Foundation

//
struct PastRide: Codable {
    let destination: String
    let time: String
    let driver: String
    
    init(destination: String, time: String, driver: String) {
        self.destination = destination
        self.time = time
        self.driver = driver
    }
}


