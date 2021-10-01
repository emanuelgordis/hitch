//
//  User.swift
//  hitch
//
//  Created by Shreeya Indap on 5/11/21.
//

import Foundation
    
struct User: Codable {
    let id: String
    let email: String
    let password: String
    let name: String
    let netid: String
    let status: String
    
    init(id: String, email: String, password: String, name: String, netid: String, status: String){
        self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.netid = netid
        self.status = status
    }
}
    
struct UserResponse: Codable {
    let success: Bool
    let data: User
}

struct UserRideResponse: Codable {
    let success: Bool
    let data: [Ride]
}

struct loginResponse: Codable {
    let success: Bool
    let data: loginData
}

struct loginData: Codable {
    let id: Int
    let name: String
    let email: String
    let longitude: String
    let latitude: String
    let session_token: String
}
