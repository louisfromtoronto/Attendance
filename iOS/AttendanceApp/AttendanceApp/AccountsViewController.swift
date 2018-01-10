//
//  AccountsViewController.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-06.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {
    
    var accountSwitchableDelegate: AccountSwitchable?

    @IBOutlet weak var tableView: UITableView!
    var accounts: [Account] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "Accounts"

        self.tableView.delegate = self;
        
        let requestHander = RequestHandler();
        requestHander.getAllAccountsDelegate = self;
        requestHander.getAllAccounts();
        
        self.tableView.dataSource = self;

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
        return self.accounts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AccountsViewControllerCell;
        
        let account = self.accounts[indexPath.row]

        cell.nameLabel.text = "\(account.firstName) \(account.lastName)";
        cell.accountTypeLabel.text = account.accountType.rawValue;
        cell.studentNumberLabel.text = account.studentNumber;
        
        return cell;
    }
    
}

extension AccountsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        accountSwitchableDelegate?.userDidSwitch(to: accounts[indexPath.row]);
        print("did select row");
        if (accountSwitchableDelegate == nil) {
            print("Account switchable delegate is nil");
        }
        self.dismiss(animated: true, completion: nil);
    }
    
}

extension AccountsViewController: GetAllAccountsDelegate {
    
    func networkCommunicationError(errorString: String) {
        
        print("Presenting error")
        
        let errorString = "There was an issue communicating with the server. "
            + "Check that you've set up the project as outlined in readme.md"
        
        let alert = UIAlertController(title: "Network communication error",
                                      message: errorString,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestHandlerDidGetAllAccounts(sender: RequestHandler, results: [Account?]) {
        
        for account in results {
            if account != nil {
                self.accounts += [account!]
            }
        }
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

protocol AccountSwitchable {
    
    func userDidSwitch(to account: Account);
}
