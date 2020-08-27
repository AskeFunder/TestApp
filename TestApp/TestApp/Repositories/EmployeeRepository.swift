//
//  EmployeeRepository.swift
//  TestApp
//
//  Created by Aske Funder Jensen on 22/08/2020.
//  Copyright © 2020 Aske Funder Jensen. All rights reserved.
//

import Foundation


class EmployeeRepository {
    
    var dataService: EmployeeDataService?
    
    init(dataService: EmployeeDataService) {
        self.dataService = dataService
    }
    
    func updateEmployee(employee: Employee, accessToken: String, onSuccess: @escaping () -> Void, onError: @escaping (Data) -> Void) {
        
        dataService!.updateEmployee(employee: employee, accessToken: accessToken, onSuccess: {
            onSuccess()
            //self.dismiss(animated: true, completion: nil)
        }, onError: { (data) in
        
            onError(data)
//            DispatchQueue.main.async {
//                let jsonError = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String: Any]
//                if let error = jsonError["error"] as? [String: Any] {
//                    if let message = error["message"] {
//                        let alertController = UIAlertController(title: "Error", message: "Something went wrong: \(message)", preferredStyle: .alert)
//
//                        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
//                        }
//
//                        alertController.addAction(action)
//
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//                }
//
//            }
        })

    }
    
    func getAccessToken(onSuccess: @escaping (String) -> Void, onError: @escaping(Data) -> Void) {
        dataService!.getAccessToken(onSuccess: { (accessToken) in

            onSuccess(accessToken)
            
        }, onError: { (data) in
            
        })
    }
    
    func getEmployees(pageNo: Int, accessToken: String, onSuccess: @escaping ([Employee]) -> Void, onError: @escaping(Data) -> Void) {
        
        var employeesResult: [Employee]?
        
        dataService?.getEmployees(pageNo: pageNo, accessToken: accessToken, onSuccess: { (employees) in
            employeesResult = employees
            onSuccess(employeesResult!)
        }, onError: { (data) in
            
        })
    }
    
    func getEmployee(byId id: Int64, accessToken: String, onSuccess: @escaping (Employee) -> Void, onError: @escaping (Data) -> Void) {
        
        var employeeResult: Employee?
        
        dataService?.getEmployee(byId: id, accessToken: accessToken, onSuccess: { (employee) in
            employeeResult = employee
            onSuccess(employeeResult!)
        }, onError: { (data) in
            
        })
        
    }
    
    
}
