//
//  ExpenseViewController.swift
//  Expense Tracker
//
//  Created by user204862 on 3/24/22.
//

import UIKit

//GLobal Category Array to access in whole project
var arrCategory = ["Clothing" , "Education" , "Fun" , "Food" , "Rent", "Travel" , "Medical" , "Others"]
//GLobal Category Color Array to access in whole project
var arrCategoryColor = [UIColor(red: 220/255, green: 102/255, blue: 144/255, alpha: 1),
                        UIColor(red: 228/255, green: 180/255, blue:74/255, alpha: 1),
                        UIColor(red: 145/255, green: 194/255, blue: 83/255, alpha: 1),
                        UIColor(red: 107/255, green: 169/255, blue: 212/255, alpha: 1),
                        UIColor(red: 170/255, green: 113/255, blue: 214/255, alpha: 1),
                        UIColor(red: 128/255, green: 130/255, blue: 255/255, alpha: 1),
                        UIColor(red: 179/255, green: 80/255, blue: 83/255, alpha: 1),
                        UIColor(red: 143/255, green: 162/255, blue: 2/255, alpha: 1),
                        UIColor(red: 83/255, green: 77/255, blue: 255/255, alpha: 1)]

class ExpenseViewController: UIViewController {

    @IBOutlet weak var lbl_TotalExpense: UILabel!
    @IBOutlet weak var txt_Title: UITextField!
    @IBOutlet weak var txt_Expense: UITextField!
    @IBOutlet weak var txt_SelectCategory: UITextField!
    @IBOutlet weak var txt_SelectDate: UITextField!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var tblvw: UITableView!
    
    var datePicker = UIDatePicker()
    var pickerView = UIPickerView()
    
    var arrExpenseDic = [[String:Any]]()
    
    //View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//Set Tableview delegate and datasource
        self.tblvw.delegate = self
        self.tblvw.dataSource = self
        //Set data
        self.SetData()
        //Set datepicker
        self.datePicker.date = Date()
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(self.DatePickerDidChange(_ :)), for: .valueChanged)
        self.txt_SelectDate.inputView = self.datePicker
        
        //Set textfield UI
        self.txt_Title.tintColor = UIColor.white
        self.txt_Title.layer.borderColor = UIColor.white.cgColor
        self.txt_Title.layer.borderWidth = 1.0
        self.txt_Title.layer.cornerRadius = 10
        self.txt_Title.attributedPlaceholder = NSAttributedString(
            string: "Eneter Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        self.txt_Expense.tintColor = UIColor.white
        self.txt_Expense.attributedPlaceholder = NSAttributedString(
            string: "Eneter Expense",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        self.txt_Expense.layer.borderColor = UIColor.white.cgColor
        self.txt_Expense.layer.borderWidth = 1.0
        self.txt_Expense.layer.cornerRadius = 10
        
        self.txt_SelectCategory.tintColor = UIColor.white
        self.txt_SelectCategory.layer.borderColor = UIColor.white.cgColor
        self.txt_SelectCategory.layer.borderWidth = 1.0
        self.txt_SelectCategory.layer.cornerRadius = 10
        self.txt_SelectCategory.attributedPlaceholder = NSAttributedString(
            string: "Select Category",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        
        self.txt_SelectDate.tintColor = UIColor.white
        self.txt_SelectDate.attributedPlaceholder = NSAttributedString(
            string: "Select Date",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        self.txt_SelectDate.layer.borderColor = UIColor.white.cgColor
        self.txt_SelectDate.layer.borderWidth = 1.0
        self.txt_SelectDate.layer.cornerRadius = 10
        self.btn_Save.layer.borderColor = UIColor.white.cgColor
        self.btn_Save.layer.borderWidth = 1.0
        self.btn_Save.layer.cornerRadius = 10
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.txt_SelectCategory.inputView = self.pickerView
        
        //Set Toolbar on Keyboard
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
        UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        self.txt_Title.inputAccessoryView = numberToolbar
        self.txt_Expense.inputAccessoryView = numberToolbar
        self.txt_SelectCategory.inputAccessoryView = numberToolbar
        self.txt_SelectDate.inputAccessoryView = numberToolbar
        self.SetDate()
    }
    @objc func cancelNumberPad() {
        //Dismiss keyboard
        self.view.endEditing(true)
    }
    @objc func doneWithNumberPad() {
        //Dismiss keyboard
        self.view.endEditing(true)
    }
    func SetData(){
        //Get dat from local preferences and set data in textfield
        if let arrExpenseDic = UserDefaults.standard.value(forKey: "arrExpenseDic") as? [[String:Any]] {
            self.arrExpenseDic = arrExpenseDic
            self.tblvw.reloadData()
            //Get total of expense using reduce method
            // Use map to get array only of expense value
            let total = self.arrExpenseDic.map { dic in
                return dic["expense"] as? String ?? "0"
            }.reduce(0) { partialResult, Expense in
                return (Int(Expense) ?? 0) + partialResult
            }
            self.lbl_TotalExpense.text = "$ \(total)"
        }
        self.txt_Title.text = ""
        self.txt_Expense.text = ""
        self.txt_SelectDate.text = ""
    }
    func SetDate(){
        //Set dat formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd-MMM-yy"
        self.txt_SelectDate.text = dateFormate.string(from: self.datePicker.date)
    }

    @objc func DatePickerDidChange(_ sender:UIDatePicker){
        //Call when date willl change
        self.SetDate()
    }
    
    @IBAction func ActionBtnSave(_ sender: Any) {
        //Check Validations
        if self.txt_Title.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Expense Title", VC: self)
            return
        }
        if self.txt_Expense.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Expense", VC: self)
            return
        }
        if self.txt_SelectCategory.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Select Category", VC: self)
            return
        }
        if self.txt_SelectDate.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Select Expense Date", VC: self)
            return
        }
        
        // Fetch Old data and add ned data and save it in local prefferences
        if var arrExpenseDic = UserDefaults.standard.value(forKey: "arrExpenseDic") as? [[String:Any]] {
            
            let expenseDic = ["title":self.txt_Title.text ?? "",
                            "expense":self.txt_Expense.text ?? "0",
                            "expenseCategory" : self.txt_SelectCategory.text ?? "",
                            "date":self.txt_SelectDate.text ?? ""]
            arrExpenseDic.append(expenseDic)
            UserDefaults.standard.set(arrExpenseDic, forKey: "arrExpenseDic")
        }else {
            //save new data first time in local prefferences
            let arrExpenseDic = [["title":self.txt_Title.text ?? "",
                            "expense":self.txt_Expense.text ?? "0",
                            "expenseCategory" : self.txt_SelectCategory.text ?? "",
                            "date":self.txt_SelectDate.text ?? ""]]
            UserDefaults.standard.set(arrExpenseDic, forKey: "arrExpenseDic")
        }
        self.SetData()
    }
    
}

extension ExpenseViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of rows as count of your inserted data
        return self.arrExpenseDic.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Set row and set data one by one
        let cell = tableView.dequeueReusableCell(withIdentifier: IncomeTableViewCell.IncomeTableViewCellId, for: indexPath) as! IncomeTableViewCell
        let incomDic = self.arrExpenseDic[indexPath.row]
        cell.lbl_Title.text = incomDic["title"] as? String ?? ""
        cell.lbl_Detail.text = "$ " + (incomDic["expense"] as? String ?? "0")
        cell.lbl_Date.text = (incomDic["date"] as? String ?? "")
        cell.lbl_Category.text = (incomDic["expenseCategory"] as? String ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //set row height as per your data
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Add Swipe actions to delete row
      let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
          self.arrExpenseDic.remove(at: indexPath.row)
          UserDefaults.standard.set(self.arrExpenseDic, forKey: "arrExpenseDic")
          self.SetData()
          completion(true)
      }
      deleteAction.backgroundColor = UIColor.red
      return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ExpenseViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCategory.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCategory[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txt_SelectCategory.text = arrCategory[row]
    }
    
}

