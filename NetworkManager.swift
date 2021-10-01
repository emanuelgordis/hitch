//
//  NetworkManager.swift
//  hitch
//
//  Created by Shreeya Indap on 5/11/21.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let host = "https://hitchhackchall.herokuapp.com"
    
    //Post request a new ride.
    static func createRide(end_lat: Float, end_long: Float, email: String, session_token: String, completion: @escaping (Ride) -> Void) {
        let endpoint = "\(host)/api/rides/\(email)/"
        let parameters: [String:Any] = [
            "end_lat": end_lat,
            "end_long": end_long,
            "session_token": session_token
        ]
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {response in
            switch response.result {
            case.success(let data):
            let jsonDecoder = JSONDecoder()
                if let ride = try? jsonDecoder.decode(Ride.self, from: data){
               completion(ride)
            }
            case .failure(let error): print(error.localizedDescription)

            }
          }
        
    }
    
    static func registerUser(email: String, password: String, name: String, latitude: Float, longitude: Float, completion: @escaping (loginData) -> Void) {
    let endpoint = host + "/register/"
    let parameters: [String:Any] = [
        "email": email,
        "password": password,
        "name": name,
        "latitude": (String)(latitude),
        "longitude": (String)(longitude),
    ]
    AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
        switch response.result {
        case .success(let data):
            let jsonDecoder = JSONDecoder()
            if let userResponse = try? jsonDecoder.decode(loginResponse.self, from: data) {
                completion(userResponse.data)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
    
    static func loginUser(email: String, password: String, completion: @escaping (loginData) -> Void) {
        let endpoint = "\(host)/login/"
        let parameters: [String:Any] = [
            "email": email,
            "password": password
        ]
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(loginResponse.self, from: data) {
                    completion(userResponse.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func editUser(name: String, session_token: String, email: String, completion: @escaping (User) -> Void) {
        let endpoint = "\(host)/api/user/\(email)"
        let parameters: [String:Any] = [
            "name": name,
            "session_token": session_token
        ]
        AF.request(endpoint, method: .post, parameters: parameters).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(UserResponse.self, from: data) {
                    completion(userResponse.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getUser(email: String, completion: @escaping (User) -> Void) {
        let endpoint = " \(host)/api/user/\(email)"
        AF.request(endpoint, method: .get).validate().responseData {response in
            switch response.result{
            case.success(let data):
                let jsonDecoder = JSONDecoder()
                if let user = try? jsonDecoder.decode(User.self, from: data){
               completion(user)
            }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    static func checkUser(email: String, completion: @escaping (Bool) -> Void) {
        let endpoint = host + "/api/user/" + email + "/"
        AF.request(endpoint, method: .get).validate().responseData {response in
            switch response.result{
            case .success( _):
                 completion(true)
            case .failure( _):
                 completion(false)
            }
        }
    }
    
    static func updateLocation(email: String, new_lat: Float, new_long: Float, session_token: String, completion: @escaping (User) -> Void) {
        let endpoint = "\(host)/api/user/\(email)/changecoords/"
        let parameters: [String:Any] = [
            "latitude": new_lat,
            "longitude": new_long,
            "current_session": session_token
        ]
        AF.request(endpoint, method: .post, parameters: parameters).validate().responseData {response in
            switch response.result{
            case.success(let data):
                let jsonDecoder = JSONDecoder()
                if let user = try? jsonDecoder.decode(User.self, from: data){
               completion(user)
            }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    static func createRide(email: String, end_lat: Float, end_long: Float, session_token: String, completion: @escaping (Ride) -> Void) {
        let endpoint = "\(host)/api/rides/\(email)/"
        let parameters: [String:Any] = [
            "end_lat": end_lat,
            "end_long": end_long,
            "session_token": session_token
        ]
        AF.request(endpoint, method: .post, parameters: parameters).validate().responseData {response in
            switch response.result{
            case.success(let data):
                let jsonDecoder = JSONDecoder()
                if let ride = try? jsonDecoder.decode(Ride.self, from: data){
               completion(ride)
            }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    static func completeRide(email: String, session_token: String, completion: @escaping (Ride) -> Void) {
        let endpoint = "\(host)/api/rides/\(email)/complete/"
        let parameters: [String:Any] = [
            "current_session": session_token
        ]
        AF.request(endpoint, method: .post, parameters: parameters).validate().responseData {response in
            switch response.result{
            case.success(let data):
                let jsonDecoder = JSONDecoder()
                if let ride = try? jsonDecoder.decode(Ride.self, from: data){
               completion(ride)
            }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    static func getPastRides(email: String, current_session: String, completion: @escaping ([Ride]) -> Void) {
        let endpoint = "\(host)/api/user\(email)/history"
        let parameters: [String:Any] = [
            "current_session": current_session
        ]
        AF.request(endpoint, method: .get, parameters: parameters).validate().responseData {response in
            switch response.result{
            case.success(let data):
                let jsonDecoder = JSONDecoder()
                if let user = try? jsonDecoder.decode(UserRideResponse.self, from: data){
                    completion(user.data)
            }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}
