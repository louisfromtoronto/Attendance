//
//  ProfileViewController.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-06.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let requestHander = RequestHandler()
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var studentNumberTextField: UITextField!
    @IBOutlet weak var accountTypePicker: UIPickerView!
    var pickerViewOptions: [String] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.firstNameTextField.delegate = self;
        self.lastNameTextField.delegate = self;
        self.studentNumberTextField.delegate = self;
        self.accountTypePicker.dataSource = self;
        self.accountTypePicker.delegate = self;
        
        pickerViewOptions = ["Student", "Teacher"];
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
    
    @IBAction func doneButton(_ sender: Any) {
        if (firstNameTextField.hasText && lastNameTextField.hasText && studentNumberTextField.hasText) {
            self.dismiss(animated: true, completion: {
                
                let firstNameString = self.firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                let lastNameString = self.lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                let studentNumberString = self.studentNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                let pickerViewSelectedIndex = self.accountTypePicker.selectedRow(inComponent: 0);
                let accountTypeString = self.pickerViewOptions[pickerViewSelectedIndex].lowercased();
                
                self.requestHander.createStudent(withFirstName: firstNameString!,
                                                  lastName: lastNameString!,
                                                 studentID: studentNumberString!,
                                               accountType: accountTypeString);
            });
        } else {
            let alertTitle = "Fields not completed"
            let alertMessage = "All fields must be completed to submit this form."
            let alert = UIAlertController(title: alertTitle,
                                        message: alertMessage,
                                 preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default));
            self.present(alert, animated: true, completion: nil);
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

extension ProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewOptions[row];
    }
}
