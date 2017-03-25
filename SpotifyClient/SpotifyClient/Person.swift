//
//  Person.swift
//  SpotifyClient
//
//  Created by Sabrina Ip on 3/24/17.
//  Copyright © 2017 Sabrina Ip. All rights reserved.
//

import Foundation

enum PersonModelError: Error {
    case initPerson(dict: [String: Any])
    case response(json: Any)
}

class Person {
    var id: String
    var name: String
    var favoriteCity: String
    
    init(id: String, name: String, favoriteCity: String) {
        self.id = id
        self.name = name
        self.favoriteCity = favoriteCity
    }
    
    convenience init?(from dict: [String: Any]) throws {
        guard let id = dict["_id"] as? String,
            let name = dict["name"] as? String,
            let favoriteCity = dict["favoriteCity"] as? String else { throw PersonModelError.initPerson(dict: dict) }
        self.init(id: id, name: name, favoriteCity: favoriteCity)
    }
    
    static func getPerson(from data: Data) -> Person? {
        var person: Person?
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let response = json as? [String: AnyObject] else {
                throw PersonModelError.response(json: json)
            }
            
            person = try Person(from: response)
            
        } catch let PersonModelError.response(json: json) {
            print("Error encountered with json response: \(json)")
        } catch {
            print("Error encountered: \(error)")
        }
        return person
    }
    
    static func getAllPeople(from data: Data) -> [Person] {
        var peopleArr = [Person]()
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let response = json as? [[String: AnyObject]] else {
                throw PersonModelError.response(json: json)
            }
            
            for dict in response {
                if let personInit = try? Person(from: dict), let person = personInit {
                    peopleArr.append(person)
                }
            }
            
        } catch let PersonModelError.response(json: json) {
            print("Error encountered with json response: \(json)")
        } catch {
            print("Error encountered: \(error)")
        }
        return peopleArr
    }
}
