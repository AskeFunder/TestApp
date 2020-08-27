//
//  Employee.swift
//  TestApp
//
//  Created by Aske Funder Jensen on 19/08/2020.
//  Copyright © 2020 Aske Funder Jensen. All rights reserved.
//

import Foundation

struct Employee: Codable {
    var id: Int64?
    var firstName: String
    var lastName: String
    var gender: String?
    var departments: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case gender = "gender"
        case departments = "departments"
    }
}

