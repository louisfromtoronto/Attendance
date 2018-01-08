//
//  RequestHandler.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-06.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import Foundation

class RequestHandler {
    
    weak var getAllAccountsDelegate: GetAllAccountsDelegate?;
    
    
    static func createStudent(withFirstName firstName: String,
                                             lastName: String,
                                            studentID: String,
                                          accountType: String) {
        
        var request = URLRequest(url: URL(string: urls.studentsPath)!);
        request.httpMethod = "POST";
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type");
        
        let documentDictionary: [String:String] = ["firstName":firstName,
                                                    "lastName":lastName,
                                                   "studentID":studentID,
                                                 "accountType":accountType];
        do {
            let documentJSON = try JSONSerialization.data(withJSONObject: documentDictionary, options: []);
            
            request.httpBody = documentJSON;
            
            //TODO: Error handling
            let task = URLSession.shared.dataTask(with: request)
            task.resume();
        } catch {
            print("Error converting dictionary to JSON");
        }
    }
    
    // Retrieves all accounts from the Database, and returns them as an
    // array of dictionaries. You must set a value for getAllAccountsDelegate.
    func getAllAccounts() {
        
        var request = URLRequest(url: URL(string: (urls.studentsPath + "findAll/"))!);
        request.httpMethod = "GET";
        
        var resultArray: NSArray = [];
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if (error != nil) {
                print("ERROR: URLSession.shared.dataTask");
            }
            
            // let resultsString = String(data: data!, encoding: String.Encoding.utf8) as String!
            // print("Results string: \n" + resultsString!);
            
            do {
                resultArray  = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray;
                print(String(resultArray.count) + " items in resultArray");
                
                if (self.getAllAccountsDelegate != nil) {
                    self.getAllAccountsDelegate?.requestHandlerDidGetAllAccounts(sender: self, results: resultArray)
                } else {
                    print("You must implement the delegate protocol and set a value for RequestHandler.getAllAcountsDelegate");
                }
            } catch {
                print("Error converting JSON to array of dictionaries");
            }
        }
        task.resume();
    }
}

protocol GetAllAccountsDelegate: class {
    func requestHandlerDidGetAllAccounts(sender: RequestHandler, results: NSArray);
}
