//
//  IncomeViewController.swift
//  Expense Tracker
//
//  Created by user204862 on 3/24/22.
//

import UIKit

class IncomeViewController: UIViewController {

    @IBOutlet weak var lbl_TotalIncome: UILabel!
    @IBOutlet weak var txt_Title: UITextField!
    @IBOutlet weak var txt_Income: UITextField!
    @IBOutlet weak var txt_SelectDate: UITextField!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var tblvw: UITableView!
    
    var datePicker = UIDatePicker()
    var arrIncomeDic = [[String:Any]]()
    
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
        self.txt_Income.tintColor = UIColor.white
        self.txt_Income.attributedPlaceholder = NSAttributedString(
            string: "Eneter Income",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)]
        )
        self.txt_Income.layer.borderColor = UIColor.white.cgColor
        self.txt_Income.layer.borderWidth = 1.0
        self.txt_Income.layer.cornerRadius = 10
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
        self.txt_Income.inputAccessoryView = numberToolbar
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
        if let arrincomeDic = UserDefaults.standard.value(forKey: "arrIncomeDic") as? [[String:Any]] {
            self.arrIncomeDic = arrincomeDic
            self.tblvw.reloadData()
            let total = self.arrIncomeDic.map { dic in
                return dic["income"] as? String ?? "0"
            }.reduce(0) { partialResult, income in
                return (Int(income) ?? 0) + partialResult
            }
            self.lbl_TotalIncome.text = "$ \(total)"
        }
        self.txt_Title.text = ""
        self.txt_Income.text = ""
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
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Income Title", VC: self)
            return
        }
        if self.txt_Income.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Enter Income", VC: self)
            return
        }
        if self.txt_SelectDate.text?.trim().count == 0 {
            AppDelegate.OpenAlert(with: "Alert!", message: "Select Income Date", VC: self)
            return
        }
        
        if var arrincomeDic = UserDefaults.standard.value(forKey: "arrIncomeDic") as? [[String:Any]] {
            let incomDic = ["title":self.txt_Title.text ?? "",
                            "income":self.txt_Income.text ?? "0",
                            "date":self.txt_SelectDate.text ?? ""]
            arrincomeDic.append(incomDic)
            UserDefaults.standard.set(arrincomeDic, forKey: "arrIncomeDic")
        }else {
            let arrincomeDic = [["title":self.txt_Title.text ?? "",
                            "income":self.txt_Income.text ?? "0",
                            "date":self.txt_SelectDate.text ?? ""]]
            UserDefaults.standard.set(arrincomeDic, forKey: "arrIncomeDic")
        }
        self.SetData()
    }
    
}

extension IncomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrIncomeDic.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IncomeTableViewCell.IncomeTableViewCellId, for: indexPath) as! IncomeTableViewCell
        let incomDic = self.arrIncomeDic[indexPath.row]
        cell.lbl_Title.text = incomDic["title"] as? String ?? ""
        cell.lbl_Income.text = "$ " + (incomDic["income"] as? String ?? "0")
        cell.lbl_Date.text = (incomDic["date"] as? String ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
          self.arrIncomeDic.remove(at: indexPath.row)
          UserDefaults.standard.set(self.arrIncomeDic, forKey: "arrIncomeDic")
          self.SetData()
          completion(true)
      }
      deleteAction.backgroundColor = UIColor.red
      return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

class IncomeTableViewCell:UITableViewCell {
    static let IncomeTableViewCellId = "IncomeTableViewCell"
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Income: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
}


