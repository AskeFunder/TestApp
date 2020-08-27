//
//  ViewController.swift
//  TestApp
//
//  Created by Aske Funder Jensen on 19/08/2020.
//  Copyright © 2020 Aske Funder Jensen. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {
    
    
    struct Cells {
        static let employeeCellIdentifier = "EmployeeCell"
    }
    
    var tableView: UITableView?
    
    var employees: [Employee] = []
    
    var accessToken: String?
    
    
    var pageNo: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating dataservice for rest
        let rest = RestService()
        //Injecting dataservice to repository
        let employeeRepo = EmployeeRepository(dataService: rest)

        //Checking for AuthToken
        if accessToken == nil {
            employeeRepo.getAccessToken(onSuccess: { (accessToken) in
                self.accessToken = accessToken
                
                employeeRepo.getEmployees(pageNo: self.pageNo, accessToken: self.accessToken!, onSuccess: { (employees) in
                    self.employees = employees
                    DispatchQueue.main.async {
                        self.tableView!.reloadData()
                    }
                }) { (data) in
                    
                }
            }) { (data) in
                
            }
        }
        
        configureTableView()
    }
    
    
    fileprivate func configureTableView() {
        tableView = UITableView()
        
        setTableViewDelegates()
        
        tableView!.rowHeight = 100
        
        ///TODO REGISTER WITH MY CELL
        //Registering cell for the TableView
        tableView?.register(EmployeeCell.self, forCellReuseIdentifier: Cells.employeeCellIdentifier)
        
        //Adding the TableView as a subview to the View
        view.addSubview(tableView!)
        
        //Constraining the TableView to the Views constraints
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView!.topAnchor.constraint(equalTo: view	.topAnchor),
            tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView!.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    fileprivate func setTableViewDelegates() {
        tableView!.delegate = self
        tableView!.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.employeeCellIdentifier) as! EmployeeCell
        
        let employee = employees[indexPath.row]
        
        cell.nameLabel.text = "\(employee.firstName) \(employee.lastName)"
        
        var departmentLabelString = ""
        
        for department in employee.departments {
            if departmentLabelString.count == 0 {
                departmentLabelString = departmentLabelString + "\(department)"
            } else {
                departmentLabelString + ", \(department)"
            }
        }
        
        cell.departmentLabel.text = departmentLabelString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeeDescriptiveViewController = EmployeeDescriptiveViewController() as! EmployeeDescriptiveViewController
        
        let rest = RestService()
        let employeeRepo = EmployeeRepository(dataService: rest)
        
        let selectedEmployeeId: Int64 = employees[indexPath.row].id!
        
        //Seeing as gender is not present in the data from get employee list, I'll
        //use the id, and get the employee from that
        
        employeeRepo.getEmployee(byId: selectedEmployeeId, accessToken: accessToken!, onSuccess: { (employee) in
            
            print("Employee \(employee)")
            
            employeeDescriptiveViewController.employee = employee
            employeeDescriptiveViewController.accessToken = self.accessToken
            DispatchQueue.main.async {
                self.present(employeeDescriptiveViewController, animated: true, completion: nil)
            }
        }, onError: { (data) in
            
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == employees.count - 5 {
            print("We need more lumber")
            
            pageNo = pageNo + 1
            //Get new page data
            
            let rest = RestService()
            let employeeRepo = EmployeeRepository(dataService: rest)

            employeeRepo.getEmployees(pageNo: pageNo, accessToken: accessToken!, onSuccess: { (employees) in
                
                self.employees.append(contentsOf: employees)
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                
                
            }) { (data) in
                
            }
        }
    }
}


