//
//  ChartTableViewCell.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import Charts
import ChartsRealm

class ChartTableViewCell: UITableViewCell {

  @IBOutlet weak var chartView: BarChartView!
  
  let user = User()
  
  // TODO: Refactor
  func configure(from user: User) {
    chartView.noDataText = "No Run Data"
    let description = Description()
    description.text = "Runs per Month"
    chartView.chartDescription = description
    let runs = user.runs.toArray()
    var data = [String: Int]()
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    runs.forEach { run in
      let month = run.timestamp.month
      guard let count = data[month] else {
        data[month] = 1
        return
      }
      data[month] = count + 1
    }
    
    let dataEntries: [BarChartDataEntry] = data.map { month, count in
      let index = months.index(of: month) ?? 0
      return BarChartDataEntry(x: Double(index), y: Double(count))
    }
    
    let chartDataSet = BarChartDataSet(values: dataEntries, label: "Number of Runs")
    let chartData = BarChartData(dataSet: chartDataSet)
    
    chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
    chartView.xAxis.granularity = 1
    chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
    chartView.data = chartData
    
    chartView.xAxis.drawGridLinesEnabled = false
    chartView.xAxis.drawAxisLineEnabled = false
    
    chartView.leftAxis.granularity = 1
    chartView.rightAxis.enabled = false
    
  }

}
