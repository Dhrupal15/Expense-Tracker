//
//  ExpenseViewController.swift
//  Expense Tracker
//
//  Created by user204862 on 3/24/22.
//

import UIKit

var arrCategory = ["Clothing" , "Education" , "Fun" , "Food" , "Rent", "Travel" , "Medical" , "Others"]
var arrCategoryColor = [UIColor(red: 0.16, green: 0.73, blue: 0.61, alpha: 1),
                        UIColor(red: 0.23, green: 0.6, blue: 0.85, alpha: 1),
                        UIColor(red: 0.6, green: 0.36, blue: 0.71, alpha: 1),
                        UIColor(red: 0.46, green: 0.82, blue: 0.44, alpha: 1),
                        UIColor(red: 0.94, green: 0.79, blue: 0.19, alpha: 1),
                        UIColor(red: 0.89, green: 0.49, blue: 0.19, alpha: 1),
                        UIColor(red: 0.41, green: 0.82, blue: 0.23, alpha: 1),
                        UIColor(red: 0.98, green: 0.94, blue: 0.30, alpha: 1),
                        UIColor(red: 0.49, green: 0.39, blue: 0.43, alpha: 1)]

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblvw.delegate = self
        self.tblvw.dataSource = self
        self.SetData()
        self.datePicker.date = Date()
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(self.DatePickerDidChange(_ :)), for: .valueChanged)
        self.txt_SelectDate.inputView = self.datePicker
        
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
        self.view.endEditing(true)
    }
    @objc func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    func SetData(){
        if let arrExpenseDic = UserDefaults.standard.value(forKey: "arrExpenseDic") as? [[String:Any]] {
            self.arrExpenseDic = arrExpenseDic
            self.tblvw.reloadData()
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
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd-MMM-yy"
        self.txt_SelectDate.text = dateFormate.string(from: self.datePicker.date)
    }

    @objc func DatePickerDidChange(_ sender:UIDatePicker){
        self.SetDate()
    }
    
    @IBAction func ActionBtnSave(_ sender: Any) {
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
        
        if var arrExpenseDic = UserDefaults.standard.value(forKey: "arrExpenseDic") as? [[String:Any]] {
            let expenseDic = ["title":self.txt_Title.text ?? "",
                            "expense":self.txt_Expense.text ?? "0",
                            "expenseCategory" : self.txt_SelectCategory.text ?? "",
                            "date":self.txt_SelectDate.text ?? ""]
            arrExpenseDic.append(expenseDic)
            UserDefaults.standard.set(arrExpenseDic, forKey: "arrExpenseDic")
        }else {
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
        return self.arrExpenseDic.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IncomeTableViewCell.IncomeTableViewCellId, for: indexPath) as! IncomeTableViewCell
        let incomDic = self.arrExpenseDic[indexPath.row]
        cell.lbl_Title.text = incomDic["title"] as? String ?? ""
        cell.lbl_Detail.text = "$ " + (incomDic["expense"] as? String ?? "0")
        cell.lbl_Date.text = (incomDic["date"] as? String ?? "")
        cell.lbl_Category.text = (incomDic["expenseCategory"] as? String ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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

