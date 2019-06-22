//
//  LineChart.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 14/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

import Charts

class DDLineChartModel {
    var labels = [String]()
    var values = [Double]()
    
}

struct DDLineChartParameters {
    var isAnimated = true
    var gradientColorLocation : [CGFloat] = [0.0, 0.5]
    
    //
     var gradientColors : CFArray = [UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor,
                                     UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor] as CFArray
}

class DDLineChart: UIView {
    
    var myLineChart : LineChartView!
    var parametros = DDLineChartParameters()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        inicializar()
    }
    
    func inicializar() {
        myLineChart = LineChartView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        addSubview(myLineChart)
    
    }
    
    class YAxisValueFormatter: NSObject, IAxisValueFormatter {
        
        let numFormatter: NumberFormatter
        
        override init() {
            numFormatter = NumberFormatter()
            numFormatter.minimumFractionDigits = 0
            numFormatter.maximumFractionDigits = 0
            
            // if number is less than 1 add 0 before decimal
            numFormatter.minimumIntegerDigits = 1 // how many digits do want before decimal
            numFormatter.paddingPosition = .afterSuffix
            numFormatter.paddingCharacter = "M"
        }
        
        /// Called when a value from an axis is formatted before being drawn.
        ///
        /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
        ///
        /// - returns: The customized label that is drawn on the axis.
        /// - parameter value:           the value that is currently being drawn
        /// - parameter axis:            the axis that the value belongs to
        ///
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return numFormatter.string(from: NSNumber(floatLiteral: value))!
        }
    }
    

    
    class ChartValueFormatter: NSObject, IValueFormatter {
        fileprivate var numberFormatter: NumberFormatter?
        
        convenience init(numberFormatter: NumberFormatter) {
            self.init()
            self.numberFormatter = numberFormatter
            self.numberFormatter?.maximumFractionDigits = 0
        }
        
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            guard let numberFormatter = numberFormatter
                else {
                    return ""
            }
            return numberFormatter.string(for: value)!
        }
    }
    
    func DrawLineChart(recta: DDLineChartModel) {
        //use dataSets in step #3
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        var data: AnyObject?
        
        var dataEntries : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< recta.labels.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: recta.values[i]))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: dataEntries, label: "")
        
        //3 - create an array to store our LineChartDataSets
        dataSets.append(set1)
        //4 - pass our months in for our x-axis label value along with our dataSets
        data = LineChartData(dataSets: dataSets) as AnyObject
        
        
        
        //      lineChartDataSet.colors = colors
        set1.mode = .cubicBezier
        //  set1.mode = .horizontalBezier
        set1.valueFont = UIFont.systemFont(ofSize: 8)
        set1.valueTextColor = UIColor.lightGray
        
        
        set1.setColor(UIColor.red.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.red)
        set1.lineWidth = 2
        set1.circleRadius = 2.0
        set1.fillAlpha = 1
        set1.fillColor = UIColor.green
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        
        
        //gradiente
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.5
        
         let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: parametros.gradientColors,
                                        locations: parametros.gradientColorLocation) // Gradient Object
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        
        
        
        //cambio el formato de los valores del eje Y
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.locale = Locale.current
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
        set1.valueFormatter = valuesNumberFormatter
        
        
        
        //customize rect
        
        myLineChart.legend.formSize = 0
        myLineChart.xAxis.drawGridLinesEnabled = false
        
        myLineChart.xAxis.labelTextColor = UIColor.lightGray
        myLineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 8)
        //esta linea es para mostrar los labels con los string
        myLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: recta.labels)
        myLineChart.xAxis.labelPosition = .bottom
        //esta linea es para mostrar todos los labels en el eje x
        //lineChart.xAxis.setLabelCount(rectas.nombreX.count, force: true)
        //esta linea cambia el tamaño de los numeros a la izquierda del eje y
        myLineChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 8.0, weight: UIFont.Weight.regular)
        myLineChart.leftAxis.labelTextColor = .lightGray
        //valor minimo, los valores menores a 0.1 no se muestran en el grafico
        myLineChart.leftAxis.axisMinimum = 0.0
        myLineChart.rightAxis.axisMinimum = 0.0
        myLineChart.rightAxis.enabled = false
        //saca las lineas horizonatales
        myLineChart.rightAxis.drawGridLinesEnabled = false
        //no muestra algunas lineas horizontales extras
        myLineChart.leftAxis.drawGridLinesEnabled = false
        //description label text
        myLineChart.chartDescription?.textColor = UIColor.lightGray
        myLineChart.chartDescription?.text = ""
        myLineChart.chartDescription?.xOffset = 0
        myLineChart.chartDescription?.yOffset = 0
        myLineChart.zoomOut()
        myLineChart.drawGridBackgroundEnabled = true
        myLineChart.gridBackgroundColor = UIColor.clear
        myLineChart.drawBordersEnabled = false
        myLineChart.borderColor = UIColor.blue
        myLineChart.borderLineWidth = 0
        myLineChart.backgroundColor = UIColor.clear
        myLineChart.layer.cornerRadius = 10
        
        
        myLineChart.noDataText = "Sin Información"
        myLineChart.noDataTextColor = UIColor.lightGray
        
        //cambio el formato de los valores en el eje Y izquierdo
        myLineChart.leftAxis.valueFormatter = YAxisValueFormatter()
        
        //es para que no se repitan los label de los ejes X e Y
        myLineChart.xAxis.granularity = 1
        //separacion de los valores del eje y
        myLineChart.leftAxis.granularity = 1
        
        if parametros.isAnimated {
            myLineChart.animate(yAxisDuration: 1, easingOption: .easeInOutQuart)
        }
        
        myLineChart.data = (data as! ChartData)
    }

}

