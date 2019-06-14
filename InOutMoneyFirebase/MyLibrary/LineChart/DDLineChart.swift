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

class _unidadesVendidas {
    var meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    var unidadesVendidas = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
}

class DDLineChart: UIView {
    
    var myLineChart : LineChartView!
    
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
    
        mostrarLineChart()
    }
    
    func mostrarLineChart() {
        let ventas1 = obtenerUnidadesVendidas()
        
        let recta = LineChartModel()
        recta.nombreX = ventas1.meses
        recta.valores = ventas1.unidadesVendidas
        
        DrawLineChart(lineChart: myLineChart, recta: recta)
        
    }
    
    func obtenerUnidadesVendidas() -> _unidadesVendidas {
        let unidadesVendidas = _unidadesVendidas()
        
        unidadesVendidas.meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic", "Ene x"]
        unidadesVendidas.unidadesVendidas = [12.0, 5.0, 4, 6, 23, 3, 1, 3, 10, 2, 14, 12, 5]
        
        return unidadesVendidas
    }
    
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


class LineChartModel {
    var nombreX = [String]()
    var valores = [Double]()
    
    init() {
        nombreX.removeAll()
        valores.removeAll()
    }
}

func DrawLineChart(lineChart: LineChartView, recta: LineChartModel) {
    //use dataSets in step #3
    var dataSets : [LineChartDataSet] = [LineChartDataSet]()
    var data: AnyObject?
    
         var dataEntries : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< recta.nombreX.count {
            dataEntries.append(ChartDataEntry(x: Double(i), y: recta.valores[i]))
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
        set1.valueTextColor = UIColor.black
        
        
        set1.setColor(UIColor.blue.withAlphaComponent(1))
        set1.setCircleColor(UIColor.cyan)
        set1.lineWidth = 3
        set1.circleRadius = 3.0
        set1.fillAlpha = 1
        set1.fillColor = UIColor.green
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        
        
        //cambio el formato de los valores del eje Y
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.locale = Locale.current
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
        set1.valueFormatter = valuesNumberFormatter
        
    
    
    //customize rect
    
    lineChart.legend.formSize = 0
    lineChart.xAxis.drawGridLinesEnabled = false
    
    lineChart.xAxis.labelTextColor = UIColor.blue
    lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 8)
    //esta linea es para mostrar los labels con los string
    lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: recta.nombreX)
    lineChart.xAxis.labelPosition = .bottom
    //esta linea es para mostrar todos los labels en el eje x
    //lineChart.xAxis.setLabelCount(rectas.nombreX.count, force: true)
    //esta linea cambia el tamaño de los numeros a la izquierda del eje y
    lineChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 8.0, weight: UIFont.Weight.regular)
    lineChart.leftAxis.labelTextColor = .black
    //valor minimo, los valores menores a 0.1 no se muestran en el grafico
    lineChart.leftAxis.axisMinimum = 0.0
    lineChart.rightAxis.axisMinimum = 0.0
    lineChart.rightAxis.enabled = false
    //saca las lineas horizonatales
    lineChart.rightAxis.drawGridLinesEnabled = false
    //no muestra algunas lineas horizontales extras
    lineChart.leftAxis.drawGridLinesEnabled = false
    //description label text
    lineChart.chartDescription?.text = "Unidades Vendidas"
    lineChart.chartDescription?.xOffset = 45
    lineChart.chartDescription?.yOffset = 45
    lineChart.zoomOut()
    
    
    lineChart.noDataText = "Sin Información"
    
    
    //cambio el formato de los valores en el eje Y izquierdo
    lineChart.leftAxis.valueFormatter = YAxisValueFormatter()
    
    //es para que no se repitan los label de los ejes X e Y
    lineChart.xAxis.granularity = 1
    //separacion de los valores del eje y
    lineChart.leftAxis.granularity = 5
    
    lineChart.animate(yAxisDuration: 1, easingOption: .easeInOutQuart)
    
    lineChart.data = (data as! ChartData)
}
