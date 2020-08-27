//
//  ApiService.swift
//  TestApp
//
//  Created by Aske Funder Jensen on 23/08/2020.
//  Copyright © 2020 Aske Funder Jensen. All rights reserved.
//

import Foundation

protocol EmployeeDataService {
    
    func getAccessToken(onSuccess: @escaping (String) -> Void, onError: @escaping (Data) -> Void)
    
    func getEmployees(pageNo: Int, accessToken: String, onSuccess: @escaping ([Employee]) -> Void, onError: @escaping (Data) -> Void)
    
    func updateEmployee(employee: Employee, accessToken: String, onSuccess: @escaping () -> Void, onError: @escaping (Data) -> Void)
    
    func getEmployee(byId id: Int64, accessToken: String, onSuccess: @escaping (Employee) -> Void, onError: @escaping (Data) -> Void)
}


class RestService: EmployeeDataService {
    func getEmployee(byId id: Int64, accessToken: String, onSuccess: @escaping (Employee) -> Void, onError: @escaping (Data) -> Void) {
        restManager?.fetchEmployee(byId: id, accessToken: accessToken, onSucces: { (data) in
            let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            
            //Creating data from the nested employee
            let employeeData = try! JSONSerialization.data(withJSONObject: jsonData["data"], options: .fragmentsAllowed)
            
            let employee = try! JSONDecoder().decode(Employee.self, from: employeeData)
            
            //Returning the employee
            onSuccess(employee)
        }, onError: { (data) in
            onError(data)
        })
    }
    
    func getAccessToken(onSuccess: @escaping (String) -> Void, onError: @escaping (Data) -> Void) {
            
        restManager?.fetchAuthToken(onSuccess: { (data) in
            
            var authModel: AuthModel?
            
            //Decoding the data
            authModel = try! JSONDecoder().decode(AuthModel.self, from: data)
            //Returning the accessToken
            onSuccess(authModel!.accessToken)
        }, onError: { (data) in
            onError(data)
        })
    }
    
    func getEmployees(pageNo: Int, accessToken: String, onSuccess: @escaping ([Employee]) -> Void, onError: @escaping (Data) -> Void) {
        
        restManager?.fetchEmployees(pageNo: pageNo, accessToken: accessToken, onSuccess: { (data) in
            // Convert HTTP Response Data to a simple String
            let dataString = String(data: data, encoding: .utf8)
            
            var dataAsDict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            
            let employeesData = try! JSONSerialization.data(withJSONObject: dataAsDict!["data"], options: .fragmentsAllowed)
            
            let listOfEmployees = try! JSONDecoder().decode([Employee].self, from: employeesData)
            
            onSuccess(listOfEmployees)
        }, onError: { (data) in
            onError(data)
        })
    }
    
    func updateEmployee(employee: Employee, accessToken: String, onSuccess: @escaping () -> Void, onError: @escaping (Data) -> Void) {
        
        print("This is employee ID \(employee.id)")
        
        restManager?.updateEmployee(employee: employee, accessToken: accessToken, onSucces: { (data) in
            
        }, onError: { (data) in
            onError(data)
        })
    }
    

    var restManager: RestManager?
    
    init() {
        restManager = RestManager()
    }
}
