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
    
    //View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Border and Corner Radius
        self.imgvw_Profile.layer.borderWidth = 2.0
        self.imgvw_Profile.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.6).cgColor
        self.imgvw_Profile.layer.masksToBounds = true
        self.imgvw_Profile.layer.cornerRadius = self.imgvw_Profile.frame.size.width/2
        self.imgvw_Profile.contentMode = .scaleAspectFill
        
        
        
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
        
        //Set Date Picker to text field
        self.datePicker.date = Date()
        self.datePicker.maximumDate = Date()
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(self.DatePickerDidChange(_ :)), for: .valueChanged)
        self.txt_BirthDate.inputView = self.datePicker
        
        //Set ToolBar On keyboard for textfield
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
        
        //Set Top Navigation Bar Button
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.ActionBtnSave))
        btnSave.tintColor = .white
        self.navigationItem.rightBarButtonItem = btnSave
        self.title = "Profile"
        
        //Set Default Save Data
        self.SetData()
        
        // Add Tap Gesture in View to close the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }
    
    @objc func handleTap() {
        view.endEditing(true) // dismiss keyoard
    }

    func SetData(){
        //Get data from Device local prefference and set in textfield
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
        //Dismiss Keyboard
        self.view.endEditing(true)
    }
    @objc func doneWithNumberPad() {
        //Dismiss Keyboard
        self.view.endEditing(true)
    }
    func SetDate(){
        //Set date formate to text field
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd-MMM-yy"
        self.txt_BirthDate.text = dateFormate.string(from: self.datePicker.date)
    }

    @objc func DatePickerDidChange(_ sender:UIDatePicker){
        self.SetDate()
    }
    
    @objc func ActionBtnSave(){
        //Check Validations
        if self.txt_FullName.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Full Name", VC: self)
        }else if self.txt_Email.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Email", VC: self)
        }else if (self.txt_MobileNumber.text?.trim().count ?? 0) < 10 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Valid Mobile Number", VC: self)
        }else if self.txt_BirthDate.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Select BirtDate", VC: self)
        }else {
            //Save data in the device local prefference
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
        //Alert for choose image from camera or photo
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
        //OPen Image Picker to take photo from camera
        self.imgPicker.delegate = self
        self.imgPicker.allowsEditing = true
        self.imgPicker.mediaTypes = ["public.image"] // Media Type Image
        self.imgPicker.sourceType = .camera // Source type Camera
        self.present(self.imgPicker, animated: true, completion: nil)
    }
    func OpenPhotos(){
        //OPen Image Picker to take photo from Photos
        self.imgPicker.delegate = self
        self.imgPicker.allowsEditing = true
        self.imgPicker.mediaTypes = ["public.image"] // Media Type Image
        self.imgPicker.sourceType = .photoLibrary // Source type photoLibrary
        self.present(self.imgPicker, animated: true, completion: nil)
    }
    //Image Picker Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss ImagePicker
        self.imgPicker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Did finish by choosing photo
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
        // Create Path in Filemanager to save file on that path
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let path = paths[0] as String;
        let fullPath = path.appending(name)

        return fullPath
    }
}

