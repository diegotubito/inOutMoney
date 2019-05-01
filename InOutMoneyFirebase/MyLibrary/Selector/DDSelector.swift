//
//  DDSelector.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 20/4/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import Foundation
import UIKit

struct DDSelectorParameters {
    var isBlurred : Bool
    var bouncing : Bool
 
    
}

class DDSelector: UIView {
    var parameters : DDSelectorParameters!
    var selectedItem : Int?
    var itemList = [String]()
  
    private var blurEffectView : UIVisualEffectView!
 
    private var hiddenHeaderHeight : CGFloat = UIScreen.main.bounds.height * 0.15
    private var hiddenFooterHeight : CGFloat = UIScreen.main.bounds.height * 0.15
    private var magnificationSelectedFont : CGFloat = 1.25
    private var buttonSize : CGFloat = UIScreen.main.bounds.width * 0.10
    private var buttonFontSize : CGFloat = UIScreen.main.bounds.width * 0.10 / 2
    private var selectedItemFontName = "ChalkboardSE-Regular"
    private var itemFontName = "ChalkboardSE-Light"
    private var itemFontSize : CGFloat = UIScreen.main.bounds.width * 0.15 / 3
    private var rowHeight : CGFloat = UIScreen.main.bounds.height / 12
    
    private var contentView : UIView!
    private var viewButton : UIView!
    private var backgroundView : UIView!
  
    private var tableView : UITableView!
    
    var onSelectedItem: ((Int?)->Void)?
    
    private var selectedIndex : Int? {
        didSet {
       
            backgroundFadeOutAnimation {
                self.onSelectedItem?(self.selectedIndex)
                self.removeFromSuperview()
                
            }
           
        }
    }
    
    
 
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        defaultParameters()
    }
    
    required init(frame: CGRect, parameters: DDSelectorParameters? = nil) {
        super.init(frame: frame)
        
        if parameters != nil {
            self.parameters = parameters
        } else {
            defaultParameters()
        }
        self.start()
    }
    
    private func defaultParameters() {
        //the gradient is used in footer
        parameters = DDSelectorParameters(isBlurred: true,
                                          bouncing: false)
     }
    
    func start() {
        
        drawBackground()
        drawContentView()
        addTableView()
        addTransparentMask()
        
        drawXButton()
        addButtonHandler()
    }
    
  
    
    private func addTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        tableView.register(TableViewCellSelector.nib, forCellReuseIdentifier: TableViewCellSelector.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = parameters.bouncing
        tableView.bounces = parameters.bouncing
    
        contentView.addSubview(tableView)
    }
    
  
    private func addButtonHandler() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
   
        viewButton.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        viewButton.shake()
        if sender.state == .ended {
            // handling code
            selectedIndex = nil
        }
    }
    
    
    private func drawContentView() {
        self.contentView = UIView()
        self.contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.contentView.backgroundColor = .clear
        
        self.addSubview(contentView)
     
        contentViewFadeInAnimation {}
    }
    
    private func startBlurEffect() {
        backgroundView.layer.backgroundColor = UIColor.clear.cgColor
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.effect = nil
        blurEffectView.frame = backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurEffectView)
        
        //start blurring
        UIView.animate(withDuration: 1) {
            self.blurEffectView.effect = UIBlurEffect(style: .dark)
            //stop animation at 0.5sec
           // self.blurEffectView.pauseAnimation(delay: 0.6)
            
        }
    }
    private func drawBackground() {
        backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        addSubview(backgroundView)
        
        if parameters.isBlurred {
            startBlurEffect()
        } else {
            backgroundFadeInAnimation {}
        }
    }
    
    private func addTransparentMask() {
        let maskView = UIView(frame: CGRect(x: 0, y: frame.height - (buttonSize*3), width: frame.width, height: buttonSize*3))
        maskView.backgroundColor = .clear
        contentView.addSubview(maskView)
        
        let gradient = createGradient(topColor: .clear, bottomColor: UIColor.black.withAlphaComponent(0.7))
        gradient.frame = maskView.frame
        contentView.layer.insertSublayer(gradient, at: 1)
        
        
        
    }
    
    private func drawXButton() {
        viewButton = UIView()
        
        viewButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        viewButton.layer.backgroundColor = UIColor.white.cgColor
        viewButton.layer.cornerRadius = buttonSize/2
        viewButton.layer.masksToBounds = true
        
        contentView.addSubview(viewButton)
        
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: viewButton, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: viewButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 0.95, constant: 0)
        let c3 = NSLayoutConstraint(item: viewButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: buttonSize)
           let c4 = NSLayoutConstraint(item: viewButton, attribute: .height, relatedBy: .equal, toItem: viewButton, attribute: .width, multiplier: 1/1, constant: 0)
        
        contentView.addConstraints([c1, c2, c3, c4])
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        label.text = "X"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: buttonFontSize)
        label.textAlignment = .center
        
        viewButton.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let l1 = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: viewButton, attribute: .centerX, multiplier: 1, constant: 0)
        let l2 = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: viewButton, attribute: .centerY, multiplier: 1, constant: 0)
        
        viewButton.addConstraints([l1, l2])
        
        
        
    }
    
    
}


extension DDSelector: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellSelector.identifier, for: indexPath) as? TableViewCellSelector {
         
            cell.descriptionLabel.textColor = .lightGray
            cell.descriptionLabel.font = UIFont(name: itemFontName, size: itemFontSize)
            
            if selectedItem == indexPath.row {
                cell.descriptionLabel.textColor = .white
                cell.descriptionLabel.font = UIFont(name: selectedItemFontName, size: itemFontSize * magnificationSelectedFont)
                cell.descriptionLabel.textColor = UIColor.white
            }
            cell.descriptionLabel.text = itemList[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension DDSelector : UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = indexPath.row
        self.tableView.reloadData()
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
         }) { (result) in
             self.selectedIndex = indexPath.row
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return hiddenHeaderHeight
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: hiddenHeaderHeight))
        label.text = " "
        label.backgroundColor = .clear
        return label
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return hiddenFooterHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: hiddenFooterHeight))
        
     
        return footer

     }
    
    private func createGradient(topColor: UIColor, bottomColor: UIColor) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [bottomColor.cgColor, topColor.cgColor, topColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.locations = [0.2, 0.8, 0.9]
        
        return gradient
        
    }
}


//ANIMATION

extension DDSelector {
    func backgroundFadeInAnimation(finished: @escaping () -> Void) {
        //animate
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.backgroundView.alpha = 0.75
        }) { (done) in
            finished()
        }
    }
    
    func contentViewFadeInAnimation(finished: @escaping () -> Void) {
        //animate
        contentView.alpha = 0
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: {
            self.contentView.alpha = 1
        }) { (done) in
            finished()
        }
    }
    
    func backgroundFadeOutAnimation(finished: @escaping () -> Void) {
        //animate
        self.alpha = 1.0
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 0.0
        }) { (done) in
            finished()
        }
    }
    
    
}
