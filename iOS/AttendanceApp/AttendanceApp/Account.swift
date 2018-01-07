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
        } catch {
            throw AccountError.JSONSerialization;
        }
        
    }
}

extension NSDictionary {
    func toAccount() throws -> Account {
        var firstName: String;
        var lastName: String;
        var studentNumber: String;
        var accountType: AccountTypes;
        do {
            firstName = self.value(forKey: "firstName") as? String;
            lastName = self.value(forKey: "lastName") as! String;
            studentNumber = self.value(forKey: "studentID") as! String;
            let accountTypeString = self.value(forKey: "accountType") as! String;
            switch accountTypeString {
            case "teacher":
                accountType = .teacher
            default:
                accountType = .student
            }
        } catch {
            
        }
        
    }
}

enum AccountError: Error {
    case JSONSerialization
}
