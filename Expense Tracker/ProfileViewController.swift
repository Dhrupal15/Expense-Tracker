//
//  ProfileViewController.swift
//  Expense Tracker
//
//  Created by user204862 on 3/24/22.
//

import UIKit
import Foundation

class ProfileViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imgvw_Profile: UIImageView!
    @IBOutlet weak var txt_FullName: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_MobileNumber: UITextField!
    @IBOutlet weak var txt_BirthDate: UITextField!
    
    var datePicker = UIDatePicker()
    var imgPicker = UIImagePickerController()
    var imgURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgvw_Profile.layer.borderWidth = 2.0
        self.imgvw_Profile.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.6).cgColor
        self.imgvw_Profile.layer.masksToBounds = true
        self.imgvw_Profile.layer.cornerRadius = self.imgvw_Profile.frame.size.width/2
        self.imgvw_Profile.contentMode = .scaleAspectFill
        
        self.datePicker.date = Date()
        self.datePicker.maximumDate = Date()
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(self.DatePickerDidChange(_ :)), for: .valueChanged)
        self.txt_BirthDate.inputView = self.datePicker
        
        self.txt_FullName.tintColor = UIColor.white
        self.txt_FullName.layer.borderColor = UIColor.white.cgColor
        self.txt_FullName.layer.borderWidth = 1.0
        self.txt_FullName.layer.cornerRadius = 10
        self.txt_FullName.attributedPlaceholder = NSAttributedString(
            string: "Eneter Full Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        
        self.txt_Email.tintColor = UIColor.white
        self.txt_Email.layer.borderColor = UIColor.white.cgColor
        self.txt_Email.layer.borderWidth = 1.0
        self.txt_Email.layer.cornerRadius = 10
        self.txt_Email.attributedPlaceholder = NSAttributedString(
            string: "Eneter Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        
        self.txt_MobileNumber.tintColor = UIColor.white
        self.txt_MobileNumber.layer.borderColor = UIColor.white.cgColor
        self.txt_MobileNumber.layer.borderWidth = 1.0
        self.txt_MobileNumber.layer.cornerRadius = 10
        self.txt_MobileNumber.attributedPlaceholder = NSAttributedString(
            string: "Eneter Moble Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        
        self.txt_BirthDate.tintColor = UIColor.white
        self.txt_BirthDate.layer.borderColor = UIColor.white.cgColor
        self.txt_BirthDate.layer.borderWidth = 1.0
        self.txt_BirthDate.layer.cornerRadius = 10
        self.txt_BirthDate.attributedPlaceholder = NSAttributedString(
            string: "Select Birth Date",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
        UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        self.txt_FullName.inputAccessoryView = numberToolbar
        self.txt_Email.inputAccessoryView = numberToolbar
        self.txt_MobileNumber.inputAccessoryView = numberToolbar
        self.txt_BirthDate.inputAccessoryView = numberToolbar
        
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.ActionBtnSave))
        btnSave.tintColor = .white
        self.navigationItem.rightBarButtonItem = btnSave
        self.title = "Profile"
        
        self.SetData()
    }

    func SetData(){
        if let profileDic = UserDefaults.standard.value(forKey: "ProfileDic") as? [String:Any] {
            self.txt_FullName.text = profileDic["fullName"] as? String ?? ""
            self.txt_Email.text = profileDic["email"] as? String ?? ""
            self.txt_MobileNumber.text = profileDic["mobileNumber"] as? String ?? ""
            self.txt_BirthDate.text = profileDic["birthDate"] as? String ?? ""
            if let oldImagePath = profileDic["profileImage"] as? String {
                
                let oldFullPath = self.documentsPathForFileName(name: oldImagePath)
                    
                self.imgvw_Profile.image = UIImage(contentsOfFile: oldFullPath)
                
            }
            
        }
    }
    
    @objc func cancelNumberPad() {
        self.view.endEditing(true)
    }
    @objc func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    func SetDate(){
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd-MMM-yy"
        self.txt_BirthDate.text = dateFormate.string(from: self.datePicker.date)
    }

    @objc func DatePickerDidChange(_ sender:UIDatePicker){
        self.SetDate()
    }
    
    @objc func ActionBtnSave(){
        if self.txt_FullName.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Full Name", VC: self)
        }else if self.txt_Email.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Email", VC: self)
        }else if (self.txt_MobileNumber.text?.trim().count ?? 0) < 10 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Valid Mobile Number", VC: self)
        }else if self.txt_BirthDate.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Select BirtDate", VC: self)
        }else {
            let profileDic = ["fullName":self.txt_FullName.text ?? "",
                              "email":self.txt_Email.text ?? "",
                              "mobileNumber":self.txt_MobileNumber.text ?? "",
                              "birthDate":self.txt_BirthDate.text ?? "",
                              "profileImage":self.imgURL]
            UserDefaults.standard.set(profileDic, forKey: "ProfileDic")
            AppDelegate.OpenAlert(with: "Success!", message: "Your profile Data is saved!", VC: self)
        }
    }
    
    @IBAction func ActionChangeProfilePic(_ sender: Any) {
        let alert = UIAlertController(title: "Select Options", message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction.init(title: "Camera", style: .default) { action in
            self.OpenCamera()
        }
        let photoAction = UIAlertAction.init(title: "Photos", style: .default) { action in
            self.OpenPhotos()
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func OpenCamera(){
        self.imgPicker.delegate = self
        self.imgPicker.allowsEditing = true
        self.imgPicker.mediaTypes = ["public.image"]
        self.imgPicker.sourceType = .camera
        self.present(self.imgPicker, animated: true, completion: nil)
    }
    func OpenPhotos(){
        self.imgPicker.delegate = self
        self.imgPicker.allowsEditing = true
        self.imgPicker.mediaTypes = ["public.image"]
        self.imgPicker.sourceType = .photoLibrary
        self.present(self.imgPicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imgPicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage  {
            let imageData = image.jpegData(compressionQuality: 1) as! NSData
            let relativePath = "image_\(Date()).jpg"
            let path = self.documentsPathForFileName(name: relativePath)
            imageData.write(toFile: path, atomically: true)
            self.imgURL = relativePath
            self.imgvw_Profile.image = image
        }
        self.imgPicker.dismiss(animated: true, completion: nil)
    }
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let path = paths[0] as String;
        let fullPath = path.appending(name)

        return fullPath
    }
}

