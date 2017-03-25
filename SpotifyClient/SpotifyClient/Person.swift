//
//  Person.swift
//  SpotifyClient
//
//  Created by Sabrina Ip on 3/24/17.
//  Copyright © 2017 Sabrina Ip. All rights reserved.
//

import Foundation

enum PersonModelError: Error {
    case parse(dict: [String: Any])
}

class Person {
    var id: Int
    var name: String
    var favoriteCity: String
    
    init(id: Int, name: String, favoriteCity: String) {
        self.id = id
        self.name = name
        self.favoriteCity = favoriteCity
    }
    
    convenience init?(from dict: [String: Any]) throws {
        guard let id = dict["_id"] as? Int,
            let name = dict["name"] as? String,
            let favoriteCity = dict["favoriteCity"] as? String else { throw PersonModelError.parse(dict: dict) }
        self.init(id: id, name: name, favoriteCity: favoriteCity)
    }
}
