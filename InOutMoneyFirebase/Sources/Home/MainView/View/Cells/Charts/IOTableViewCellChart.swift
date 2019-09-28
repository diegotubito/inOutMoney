//
//  IOTableViewCellChart.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 14/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class IOTableViewCellChart: UITableViewCell {

    @IBOutlet var myView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      }
    
    func drawChart(values: DDLineChartModel?) {
        if myView == nil {return}
        
        for i in myView.subviews {
            i.removeFromSuperview()
        }
        
        if values == nil {
            showEmptyValue()
            return
        }
        
        let width = myView.frame.width
        let height = myView.frame.height
        let grafico = DDLineChart(frame: CGRect(x: 0, y: 0, width: width, height: height))
        grafico.parametros.isAnimated = true
        grafico.parametros.gradientColors = [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.clear.cgColor] as CFArray
        grafico.parametros.gradientColorLocation = [0.0, 0.25, 0.50]
        grafico.DrawLineChart(recta: values!)
        myView.addSubview(grafico)
        
    }
 
    func showEmptyValue() {
        myView.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
