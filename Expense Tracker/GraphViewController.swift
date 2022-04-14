//
//  GraphViewController.swift
//  Expense Tracker
//
//  Created by Dhrupal
//

import UIKit

class GraphViewController: UIViewController , MDRotatingPieChartDelegate, MDRotatingPieChartDataSource {
    
    var slicesData:Array<Data> = Array<Data>()
    
    var pieChart:MDRotatingPieChart!

    //View Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Expense Chart"
        //Initialize pie chart set frame of pie chart
        pieChart = MDRotatingPieChart(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.width))
        
        //get expense data from local prefference
        if let arrExpenseDic = UserDefaults.standard.value(forKey: "arrExpenseDic") as? [[String:Any]] {
            // For loop of total category
            for (key,category) in arrCategory.enumerated() {
                //get data of category and total the expense value of same category
                let total = arrExpenseDic.map { dic in
                    if (dic["expenseCategory"] as? String ?? "") == category {
                        return dic["expense"] as? String ?? "0"
                    }
                    return "0"
                }.reduce(0) { partialResult, Expense in
                    return (Int(Expense) ?? 0) + partialResult
                }
                // Add point data to render the chart
                slicesData.append(Data(myValue: CGFloat(total), myColor: arrCategoryColor[key], myLabel:category))
                
            }
        }
        //get expense data from local prefference
        if let arrincomeDic = UserDefaults.standard.value(forKey: "arrIncomeDic") as? [[String:Any]] {
            //Get total of Income
            let total = arrincomeDic.map { dic in
                return dic["income"] as? String ?? "0"
            }.reduce(0) { partialResult, income in
                return (Int(income) ?? 0) + partialResult
            }
            slicesData.append(Data(myValue: CGFloat(total), myColor: UIColor.white, myLabel:"Income"))
        }
        //Set delegate and datasource
        pieChart.delegate = self
        pieChart.datasource = self
    
        //Add Pie chart in view
        view.addSubview(pieChart)
        
        /*
        Here you can dig into some properties
        -------------------------------------
        */
        //set pie chart view UI
        let peiChartWidth = UIScreen.main.bounds.width/2.2
        var properties = Properties()
        properties.smallRadius = peiChartWidth - 70
        properties.bigRadius = peiChartWidth
        properties.expand = 25
        properties.displayValueTypeInSlices = .percent
        properties.displayValueTypeCenter = .label
        properties.enableAnimation = true
        properties.animationDuration = 0.5
        
        
        let nf = NumberFormatter()
        nf.groupingSize = 1
        nf.maximumSignificantDigits = 2
        nf.minimumSignificantDigits = 2
        
        properties.nf = nf
        
        pieChart.properties = properties
        pieChart.isUserInteractionEnabled = false
    }
    
    //Delegate
    //some sample messages when actions are triggered (open/close slices)
    func didOpenSliceAtIndex(_ index: Int) {
        print("Open slice at \(index)")
    }
    
    func didCloseSliceAtIndex(_ index: Int) {
        print("Close slice at \(index)")
    }
    
    func willOpenSliceAtIndex(_ index: Int) {
        print("Will open slice at \(index)")
    }
    
    func willCloseSliceAtIndex(_ index: Int) {
        print("Will close slice at \(index)")
    }
    
    //Datasource
    func colorForSliceAtIndex(_ index:Int) -> UIColor {
        return slicesData[index].color
    }
    
    func valueForSliceAtIndex(_ index:Int) -> CGFloat {
        return slicesData[index].value
    }
    
    func labelForSliceAtIndex(_ index:Int) -> String {
        return slicesData[index].label
    }
    
    func numberOfSlices() -> Int {
        return slicesData.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refresh()  {
        pieChart.build()
    }
}


class Data {
    var value:CGFloat
    var color:UIColor = UIColor.gray
    var label:String = ""
    
    init(myValue:CGFloat, myColor:UIColor, myLabel:String) {
        value = myValue
        color = myColor
        label = myLabel
    }
}
