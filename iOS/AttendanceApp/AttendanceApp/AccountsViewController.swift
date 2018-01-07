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
    static var accounts: NSArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView),
                                                         name: NSNotification.Name(rawValue: "load"),
                                                       object: nil);
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        RequestHandler.getAllAccounts();
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
    
    @objc func refreshTableView() {
        self.tableView.reloadData();
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
}

extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(AccountsViewController.accounts.count);
        return AccountsViewController.accounts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AccountsViewControllerCell;
        
        //let account = self.accounts[indexPath.row];
        //print(account);
        
        let resultDictionary = AccountsViewController.accounts[indexPath.row] as! NSDictionary;
        
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

class AccountsViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var studentNumberLabel: UILabel!
}
