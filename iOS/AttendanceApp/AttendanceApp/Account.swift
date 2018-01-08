//
//  Struct.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-06.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import Foundation

struct Account {
    let firstName: String;
    let lastName: String;
    let studentNumber: String;
    let accountType: AccountTypes;
}

enum AccountTypes: String {
    case student = "student";
    case teacher = "teacher";
}

extension Data {
    func dataToFoundation() throws -> Any {
        do {
            let foundationObject = try JSONSerialization.jsonObject(with: self, options: []);
            return foundationObject;
        } 
        
    }
}

