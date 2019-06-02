//
//  IOTableViewCellSingleDateCell.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 24/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

protocol IOTableViewCellSingleDateCellDelegate {
    func buttonCellPressedDelegate(_ sender: UIButton)
}

class IOTableViewCellSingleDateCell: UITableViewCell {
    var delegate : IOTableViewCellSingleDateCellDelegate?
    
    var calendario : PCMensualCustomView!
    var backgroundContainer : UIView!

    @IBOutlet var titleCell: UILabel!
    @IBOutlet var valueCell: UILabel!
    @IBOutlet var outletButtonCell: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.tag = tag
        delegate?.buttonCellPressedDelegate(sender)
        
        backgroundContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        backgroundContainer.backgroundColor = .black
        backgroundContainer.startBlurEffect(duration: 0.6, stopAt: 0.3)
        
        backgroundContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTouched)))
        UIApplication.shared.keyWindow?.addSubview(backgroundContainer)
        
        
        calendario = PCMensualCustomView(frame: CGRect(x: 0, y: 100, width: superview?.frame.width ?? 100, height: 250))
        calendario.colorLabelDia = UIColor.white
        calendario.layer.cornerRadius = 250/20
        calendario.layer.borderColor = UIColor.white.cgColor
        calendario.layer.borderWidth = 2
        calendario.delegate = self
        calendario.setInitialDate(value: valueCell.text?.toDate(formato: "dd-MM-yyyy") ?? Date())
    
        
       // superview?.addSubview(calendario)
        UIApplication.shared.keyWindow?.addSubview(calendario)
        
        
        /*    calendario.translatesAutoresizingMaskIntoConstraints = false
         
         let a = NSLayoutConstraint(item: calendario, attribute: .top, relatedBy: .equal, toItem: view.topAnchor, attribute: .topMargin, multiplier: 1, constant: 0)
         let b = NSLayoutConstraint(item: calendario, attribute: .left, relatedBy: .equal, toItem: view.leftAnchor, attribute: .left, multiplier: 1, constant: 0)
         let c = NSLayoutConstraint(item: calendario, attribute: .right, relatedBy: .equal, toItem: view.rightAnchor, attribute: .right, multiplier: 1, constant: 0)
         let d = NSLayoutConstraint(item: calendario, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height/2.5)
         
         view.addConstraints([a,b,c, d])
         */
    }
    
   
    
    @objc func backgroundTouched() {
        backgroundContainer.removeFromSuperview()
        calendario.removeFromSuperview()
    }
    
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
}

extension IOTableViewCellSingleDateCell: PCMensualCustomViewDelegate {
    func didSelectDate(value: Date) {
        backgroundContainer.removeFromSuperview()
        calendario.removeFromSuperview()
        let strDate = value.toString(formato: "dd-MM-yyyy")
        valueCell.text = strDate
    }
    
    
}
