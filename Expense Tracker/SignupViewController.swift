//
//  SignupViewController.swift
//  Expense Tracker
//
//  Created by Hemil
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        confirmPasswordTextField.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
        signupButton.layer.cornerRadius = 20
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }
    
    @objc func handleTap() {
        view.endEditing(true) // dismiss keyoard
    }
    
    
    @IBAction func ActionBtnSignUp(_ sender: Any) {
        if self.userTextField.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter user name", VC: self)
        }else if self.passwordTextField.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Password", VC: self)
        }else if self.confirmPasswordTextField.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Confirm Password", VC: self)
        }else if self.confirmPasswordTextField.text != self.passwordTextField.text {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Confirm Password", VC: self)
        }else {
            let profileDic = ["userName":self.userTextField.text ?? "","password":self.passwordTextField.text ?? ""]
            UserDefaults.standard.set(profileDic, forKey: "LoginInfo")
        }
    }
    
    
}
