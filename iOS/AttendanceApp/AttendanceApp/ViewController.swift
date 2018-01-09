//
//  ViewController.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-02.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var majorValueLabel: UILabel!
    @IBOutlet weak var minorValueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var currentAccount: Account?
    
    let beaconManager: BeaconManager = BeaconManager()

    // MARK: - View
    
    override func viewDidLoad() {
        
        self.beaconManager.beaconManagerDelegate = self;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "accountsSegue"
        {
            let destinationVC = segue.destination as! AccountsViewController
            destinationVC.accountSwitchableDelegate = self;
        }
    }
    
    func refreshAccountView(_ account: Account) {
        
        self.currentAccount = account;
        let firstName = self.currentAccount!.firstName;
        let lastName = self.currentAccount!.lastName;
        self.nameLabel.text = "\(firstName) \(lastName)";
    }
    
    func refreshBeaconView(_ beacon: Object) {
        
        uuidLabel.text = beacon.uuid.uuidString
        majorValueLabel.text = "Major: \(beacon.majorValue)"
        minorValueLabel.text = "Minor: \(beacon.minorValue)"
        
        if (beacon.proximity != nil) {
            descriptionLabel.text = "Proximity: \(beacon.proximity!)"
        }
    }

}

// MARK: - Extensions

extension ViewController: AccountSwitchable {
    
    func userDidSwitch(to account: Account) {
        print("user did switch to")
        refreshAccountView(account);
    }
}

extension ViewController: BeaconManagerProtocol {
    
    func beaconWasMatched(_ beacon: Object) {
        print("match");
        refreshBeaconView(beacon);
    }
}
