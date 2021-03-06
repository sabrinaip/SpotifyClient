//
//  APIRequestManager.swift
//  SpotifyClient
//
//  Created by Sabrina Ip on 3/24/17.
//  Copyright © 2017 Sabrina Ip. All rights reserved.
//

import Foundation

enum RequestType: String {
    case get, post, put, delete
}

class APIRequestManager {
    static let peopleEndpoint = "https://powerful-forest-36673.herokuapp.com/people"
    static let shared = APIRequestManager()
    private init() {}
    
    func makeRequest(ofType requestType: RequestType, endpoint: String, with jsonObject: [String: Any]?, completion: @escaping (Data?) -> Void) {
        guard let requestURL = URL(string: endpoint) else {
            print("Endpoint \(endpoint) cannot be converted to URL")
            return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = requestType.rawValue.uppercased()
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonObject = jsonObject {
            do {
                let body = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                request.httpBody = body
            } catch {
                print("Error serializing body: \(error)")
            }
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("GET request error: \(error)")
            }
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            guard let data = data else {
                print("Data is nil")
                return }
            completion(data)
            }.resume()
    }
}

