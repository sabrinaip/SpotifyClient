//
//  APIRequestManager.swift
//  SpotifyClient
//
//  Created by Sabrina Ip on 3/24/17.
//  Copyright © 2017 Sabrina Ip. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let peopleEndpoint = "https://powerful-forest-36673.herokuapp.com/people"
    static let shared = APIRequestManager()
    private init() {}
    
    func getRequest(endpoint: String, callback: @escaping (Data?) -> Void) {
        guard let requestURL = URL(string: endpoint) else {
            print("Endpoint \(endpoint) cannot be converted to URL")
            return }

        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                print("GET request error: \(error)")
            }
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            guard let data = data else {
                print("Data is nil")
                return }
            callback(data)
            }.resume()
    }
    
    
    func postRequest(endpoint: String, data: [String: Any]) {
        guard let requestURL = URL(string: endpoint) else {
            print("Endpoint \(endpoint) cannot be converted to URL")
            return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let body = try JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = body
        } catch {
            print("Error serializing body: \(error)")
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data, response, error) in
            
            
            if let error = error {
                print("Post request error: \(error)")
            }
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            guard data != nil else {
                print("Data is nil")
                return }

            }.resume()
    }
}

