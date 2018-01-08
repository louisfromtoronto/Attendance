//
//  AccountsViewController.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-06.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var accounts: NSArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        let requestHander = RequestHandler();
        requestHander.getAllAccountsDelegate = self;
        requestHander.getAllAccounts();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
}

extension AccountsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AccountsViewControllerCell;
        
        let resultDictionary = self.accounts[indexPath.row] as! NSDictionary;
        
        cell.nameLabel.text = resultDictionary.value(forKey: "firstName") as? String;
        cell.studentNumberLabel.text = resultDictionary.value(forKey: "studentID") as? String;
        cell.accountTypeLabel.text = resultDictionary.value(forKey: "accountType") as? String;
        
        return cell;
    }
    
}

extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("");
    }
    
}

extension AccountsViewController: GetAllAccountsDelegate {
    func requestHandlerDidGetAllAccounts(sender: RequestHandler, results: NSArray) {
        self.accounts = results;
    
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
    }
}

class AccountsViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var studentNumberLabel: UILabel!
}
