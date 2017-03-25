//
//  APIRequestManager.swift
//  SpotifyClient
//
//  Created by Sabrina Ip on 3/24/17.
//  Copyright © 2017 Sabrina Ip. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let shared = APIRequestManager()
    private init() {}
    
    func getData(endpoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endpoint) else {
            print("endpoint \(endpoint) cannot be converted to URL")
            return }

        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data, response, error) in
            if let error = error {
                print("Error durring session: \(error)")
            }
            guard let validData = data else {
                print("data is nil")
                return }
            callback(validData)
            }.resume()
    }
    
}
