//
//  ExpenseViewController.swift
//  Expense Tracker
//
//  Created by user204862 on 3/24/22.
//

import UIKit

class ExpenseViewController: UIViewController {

    @IBOutlet weak var lbl_TotalExpense: UILabel!
    @IBOutlet weak var txt_Title: UITextField!
    @IBOutlet weak var txt_Expense: UITextField!
    @IBOutlet weak var txt_SelectDate: UITextField!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var tblvw: UITableView!
    
    var datePicker = UIDatePicker()
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
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
        UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        self.txt_Title.inputAccessoryView = numberToolbar
        self.txt_Expense.inputAccessoryView = numberToolbar
        self.txt_SelectDate.inputAccessoryView = numberToolbar
    }
    @objc func cancelNumberPad() {
        self.view.endEditing(true)
    }
    @objc func doneWithNumberPad() {
        self.view.endEditing(true)
        self.SetDate()
    }
    func SetData(){
        if let arrExpenseDic = UserDefaults.standard.value(forKey: "arrExpenseDic") as? [[String:Any]] {
            self.arrExpenseDic = arrExpenseDic
            self.tblvw.reloadData()
            let total = self.arrExpenseDic.map { dic in
                return dic["Expense"] as? String ?? "0"
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
        if self.txt_SelectDate.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Select Expense Date", VC: self)
            return
        }
        
        if var arrExpenseDic = UserDefaults.standard.value(forKey: "arrExpenseDic") as? [[String:Any]] {
            let incomDic = ["title":self.txt_Title.text ?? "",
                            "Expense":self.txt_Expense.text ?? "0",
                            "date":self.txt_SelectDate.text ?? ""]
            arrExpenseDic.append(incomDic)
            UserDefaults.standard.set(arrExpenseDic, forKey: "arrExpenseDic")
        }else {
            let arrExpenseDic = [["title":self.txt_Title.text ?? "",
                            "Expense":self.txt_Expense.text ?? "0",
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
        cell.lbl_Income.text = "$ " + (incomDic["Expense"] as? String ?? "0")
        cell.lbl_Date.text = (incomDic["date"] as? String ?? "")
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



