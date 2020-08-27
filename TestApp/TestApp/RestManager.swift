//
//  RestManager.swift
//  RestManager
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//
import Foundation

class RestManager {
    
    let clientId = "b6e01899-f593-4eec-9b34-56fe41a5ecab"
    let refreshToken = "fQiCPR1SZU-ml3cATrHLiQ"
    
    func fetchAuthToken(onSuccess: @escaping (Data) -> Void, onError: @escaping (Data) -> Void) {
        
        //Destination URL
        let url: URL? = URL(string: "https://id.planday.com/connect/token")!
        
        guard let requestUrl = url else { fatalError() }
        
        //Create URL request
        var request = URLRequest(url: requestUrl)
        
        //Adding the request header
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //Specify HTTP method
        request.httpMethod = "POST"
        
        //Defining the parameters
        let param: [String: Any] = [
            "client_id": clientId,
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        
        request.httpBody = param.percentEncoded()
        
        //Send HTTP request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //Checking for error
            if let error = error {
                print("Error occured \(error.localizedDescription)")
            }
            
            if let response = response as? HTTPURLResponse {
                //Checking for success
                if 200...299 ~= response.statusCode {
                    if let data = data {
                        //Return the data
                        onSuccess(data)
                    } else if 400...499 ~= response.statusCode {
                        onError(data!)
                    }
                }
            }
        }
        //Starting the task
        task.resume()
    }
    
    func updateEmployee(employee: Employee, accessToken: String, onSucces: @escaping (Data) -> Void, onError: @escaping (Data) -> Void) {
        //Destination URL
        let url: URL? = URL(string: "https://openapi.planday.com/hr/v1/employees/\(employee.id)")
        
        guard let requestUrl = url else { fatalError() }
        
        //Create URL request
        var request = URLRequest(url: requestUrl)
        
        //Adding the request header
        request.addValue(clientId, forHTTPHeaderField: "X-ClientId")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")

        
        //Specify HTTP method
        request.httpMethod = "PUT"
        
        var employeeData = try! JSONEncoder().encode(employee)
        let employeeJson = String(data: employeeData, encoding: String.Encoding.utf8)

        

        request.httpBody = employeeData
        
        //Send HTTP request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error has occured \(error.localizedDescription)")
            }
            
            if let response = response as? HTTPURLResponse {
                if 200...299 ~= response.statusCode {
                    print("Put was a success")
                } else if 400...499 ~= response.statusCode {
                    onError(data!)
                    print("Error occurred")
                }
            }
        }
        task.resume()
    }
    
    func fetchEmployee(byId id: Int64, accessToken: String, onSucces: @escaping (Data) -> Void, onError: @escaping (Data) -> Void) {
        //Destination URL
        let url: URL? = URL(string: "https://openapi.planday.com/hr/v1/employees/\(id)")
        
        guard let requestUrl = url else { fatalError() }
        
        //Create URL request
        var request = URLRequest(url: requestUrl)
        
        //Adding the request header
        request.addValue(clientId, forHTTPHeaderField: "X-ClientId")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        //Specify HTTP method
        request.httpMethod = "GET"
        
        //Send HTTP request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error occurred \(error.localizedDescription)")
            }
            
            if let response = response as? HTTPURLResponse {
                //Checking for success
                if 200...299 ~= response.statusCode {
                    if let data = data {
                        //Returning the data
                        onSucces(data)
                    } else if 400...499 ~= response.statusCode {
                        onError(data!)
                    }
                }
            }
        }
        //Starting the task
        task.resume()
    }
    
    func fetchEmployees(pageNo: Int, accessToken: String, onSuccess: @escaping (Data) -> Void, onError: @escaping (Data) -> Void) {
        //Destination URL
        var url: URL? = URL(string: "https://openapi.planday.com/hr/v1/employees")
        url?.appendQueryItem(name: "offset", value: "\(pageNo)")
        url?.appendQueryItem(name: "limit", value: "20")
        
        guard let requestUrl = url else { fatalError() }
        
        //Create URL request
        var request = URLRequest(url: requestUrl)
        
        
        
        //Adding the request header
        request.addValue(clientId, forHTTPHeaderField: "X-ClientId")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        //Specify HTTP method
        request.httpMethod = "GET"
                
        //Send HTTP request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Checking for error
            if let error = error {
                print("Error occurred \(error.localizedDescription)")
            }
            
            if let response = response as? HTTPURLResponse {
                //Checking for success
                if 200...299 ~= response.statusCode {
                    if let data = data {
                        //Return the data
                        onSuccess(data)
                    } else if 400...499 ~= response.statusCode {
                        onError(data!)
                    }
                }
            }

        }
        //Starting the task
        task.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url!
    }
}
