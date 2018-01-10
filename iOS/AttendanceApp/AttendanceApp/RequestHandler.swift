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
    
    func createStudent(withFirstName firstName: String,
                                      lastName: String,
                                     studentID: String,
                                   accountType: String) {
        
        if let json = makeJSONForNewStudent(firstName: firstName,
                                            lastName: lastName,
                                            studentID: studentID,
                                            accountType: accountType) {

            sendPOSTDataTaskWith(path: urls.studentsPath,
                                value: "application/x-www-form-urlencoded",
                      HTTPHeaderField: "Content-Type",
                                 data: json)
        }
    }
    
    // Retrieves all accounts from the Database, and sends them to the delegate
    // array of dictionaries. You must set a value for getAllAccountsDelegate.
    func getAllAccounts() {
        
        self.sendGETDataTaskWith(path: (urls.studentsPath + "findAll/"), completion: { (data) in
                                    
            // Serialize into [Account?]? object
            if let accountArray = self.accountSerialization(from: data) {
                
                // [Account?]? serialization was a success
                if self.getAllAccountsDelegate != nil {
                    self.getAllAccountsDelegate!.requestHandlerDidGetAllAccounts(sender: self, results: accountArray)
                } else {
                    print("You must set getAllAccountsDelegate")
                }
            } else {
                // accountArray is nil. The [Account?]? serialization failed
                print("The [Account?]? serialization failed")
            }
        })
    }
}

// MARK: Private methods
extension RequestHandler {
    
    // Serializes an Account object from a Data object containing JSON
    // formatted data
    private func accountSerialization(from data: Data) -> [Account?]? {
        
        var dataArray: [NSDictionary]
        do {
            dataArray  = try JSONSerialization.jsonObject(with: data, options: []) as! [NSDictionary];
        } catch {
            // TODO: Throw an error here
            print("Error converting JSON to [NSDictionary]");
            return nil
        }
        
        let accountsArray: [Account?] = dataArray.map({ (account: Any!) -> Account? in
            
            let accountDictionary = account as! NSDictionary; // Needed to covert account to NSDictionary
            
            return self.serializeAccountFromDictionary(accountDictionary: accountDictionary)
        })
        return accountsArray
    }
    
    // Serializes and returns an account object, bases on the account
    // data in the dictionary
    private func serializeAccountFromDictionary(accountDictionary: NSDictionary) -> Account? {
        
        let id = accountDictionary.value(forKey: "_id") as? String
        let firstName = accountDictionary.value(forKey: "firstName") as? String
        let lastName = accountDictionary.value(forKey: "lastName") as? String
        let studentNumber = accountDictionary.value(forKey: "studentID") as? String
        let accountTypeString = accountDictionary.value(forKey: "studentID") as? String
        var accountTypeEnum: AccountTypes
        {
            if (accountTypeString != nil && accountTypeString == AccountTypes.student.rawValue) {
                return .student
            } else if (accountTypeString != nil && accountTypeString == AccountTypes.teacher.rawValue) {
                return .teacher
            } else {
                return .unknown
            }
        }
        
        if (id == nil || firstName == nil || lastName == nil
            || studentNumber == nil ) {
            return nil
            
        } else {
            let account = Account(id: id!,
                                  firstName: firstName!,
                                  lastName: lastName!,
                                  studentNumber: studentNumber!,
                                  accountType: accountTypeEnum)
            return account
        }
    }
    
    private func makeJSONForNewStudent(firstName: String,
                                      lastName: String,
                                      studentID: String,
                                      accountType:String) -> Data? {
        
        //documentDictionary to be conerted to JSON
        let documentDictionary: [String:String] = ["firstName":firstName,
                                                   "lastName":lastName,
                                                   "studentID":studentID,
                                                   "accountType":accountType];
        
        var json: Data?
        do {
            json = try JSONSerialization.data(withJSONObject: documentDictionary,
                                              options: []);
        } catch {
            print("Error converting dictionary to JSON");
            json = nil
            // TODO: Present error to user, informing them that there was a
            // failure to create new user.
        }
        return json
    }
    
    // MARK: sendDataTask methods
    private func sendGETDataTaskWith(path: String, completion: @escaping (_ data: Data) -> Void) {
            
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = HTTPMethods.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("ERROR: URLSession.shared.dataTask");
                self.getAllAccountsDelegate?.networkCommunicationError(errorString: error!.localizedDescription);
            } else {
                // TODO: Error handling if data object is empty
                completion(data!)
            }
        }
        
        task.resume();
    }
    
    private func sendPOSTDataTaskWith(path: String,
                             value: String,
                   HTTPHeaderField: String,
                              data: Data) {
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = HTTPMethods.post.rawValue
        request.setValue(value, forHTTPHeaderField: HTTPHeaderField)
        request.httpBody = data
        
        // TODO: Error handling
        let task = URLSession.shared.dataTask(with: request)
        task.resume();
    }
}

protocol GetAllAccountsDelegate: class {
    func requestHandlerDidGetAllAccounts(sender: RequestHandler, results: [Account?]);
    func networkCommunicationError(errorString: String);
}

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
