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
        let width = myView.bounds.width*0.7
        let height = myView.bounds.height*0.7
        let grafico = DDLineChart(frame: CGRect(x: 0, y: 0, width: width, height: height))
        myView.addSubview(grafico)
        
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
