//
//  LoginViewController.swift
//  Expense Tracker
//
//  Created by Hemil
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
        signupButton.layer.cornerRadius = 20
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }
    
    @objc func handleTap() {
        view.endEditing(true) // dismiss keyoard
    }
    
    @IBAction func ActionLOginBtn(_ sender: Any) {
        if self.userTextField.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter user name", VC: self)
        }else if self.passwordTextField.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Password", VC: self)
        }else {
            
            if let profileDic = UserDefaults.standard.value(forKey: "LoginInfo") as? [String:Any] {
                if self.userTextField.text == profileDic["userName"] as? String ?? "" && self.passwordTextField.text == profileDic["password"] as? String ?? ""{
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }else {
                    AppDelegate.OpenAlert(with: "Alert!", message: "Username or Password is incorrect", VC: self)
                }
            }else {
                AppDelegate.OpenAlert(with: "Alert!", message: "Please Sign UP", VC: self)
            }
        }
    }
    
    
    
}
