//
//  MLButtonCircleCustomView.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 27/2/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//


import Foundation
import UIKit

class MLBotonCircularCustomView: UIView {
    var layerCirculo : CAShapeLayer!
    var label : UILabel!
    let ACTIVE_BACKGROUND_COLOR = UIColor.init(red: 0, green: 0.6, blue: 0, alpha: 1)
    let ACTIVE_RING_COLOR = UIColor.init(red: 0, green: 1, blue: 0, alpha: 1)
    let INACTIVE_BACKGROUND_COLOR = UIColor.lightGray
    let INACTIVE_RING_COLOR = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
    
    let ACTIVE_LABEL_COLOR = UIColor.white
    let INACTIVE_LABEL_COLOR = UIColor.gray
    let SHADOW_OFFSET = CGSize(width: 3, height: 3)
    var SHADOW_RADIOUS : CGFloat!
    let SHADOW_COLOR : UIColor = .black
    let INACTIVE_SHADOW_COLOR : UIColor = .black
    let SHADOW_OPACITY : Float = 1
    
    var RING_WIDTH : CGFloat!
    
    var activeText = "✔︎"
    var inactiveText = "✘"
    
    
    var isSelected = false {
        didSet {
            
            if isSelected {
                layerCirculo.strokeColor = ACTIVE_RING_COLOR.cgColor
                
                activateLabelAnimation()
                activateAnimation()
            } else {
                layerCirculo.strokeColor = INACTIVE_RING_COLOR.cgColor
                deactivateLabelAnimation()
                
                deactivateAnimation()
            }
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        inicializar()
    }
    
    func inicializar() {
        SHADOW_RADIOUS = self.frame.height / 10
        RING_WIDTH = self.frame.height / 30
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
        
        crearBoton()
    }
    
    @objc func tapped() {
        if isSelected {
            deactivateButton()
        } else {
            activateButton()
        }
    }
    
    func crearBoton() {
        
        crearLayer()
        
        crearLabel()
    }
    
    func crearLabel() {
        label = UILabel(frame: CGRect(x: 8, y: 0, width: self.frame.width - 16, height: self.frame.height))
        //valor por defecto
        if isSelected {
            label.text = activeText
            label.textColor = ACTIVE_LABEL_COLOR
        } else {
            label.text = inactiveText
            label.textColor = INACTIVE_LABEL_COLOR
        }
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: self.frame.height/1.5)
        self.addSubview(label)
    }
    
    func activateButton() {
        if isSelected == true {return}
        isSelected = true
    }
    
    func deactivateButton() {
        if isSelected == false {return}
        isSelected = false
    }
    
    func crearLayer() {
        layerCirculo = CAShapeLayer()
        layerCirculo.strokeStart = 0
        layerCirculo.strokeEnd = 1
        layerCirculo.lineWidth = RING_WIDTH
        layerCirculo.strokeColor = UIColor.clear.cgColor
        if isSelected {
            layerCirculo.strokeColor = ACTIVE_RING_COLOR.cgColor
            layerCirculo.fillColor = ACTIVE_BACKGROUND_COLOR.cgColor
            
        } else {
         //   layerCirculo.strokeColor = INACTIVE_RING_COLOR.cgColor
            layerCirculo.fillColor = INACTIVE_BACKGROUND_COLOR.cgColor
            
        }
        layerCirculo.path = getCirclePath()
        layerCirculo.shadowColor = SHADOW_COLOR.cgColor
        layerCirculo.shadowRadius = SHADOW_RADIOUS
        layerCirculo.shadowOffset = SHADOW_OFFSET
        layerCirculo.shadowOpacity = SHADOW_OPACITY
        layerCirculo.shouldRasterize = true
        let scale = true
        layerCirculo.rasterizationScale = scale ? UIScreen.main.scale : 1
        //  layerCirculo.shadowPath = getRectPath()
        
        self.backgroundColor = .white
        self.layer.addSublayer(layerCirculo)
        
        
        
        
        
    }
    
    func getCirclePath() -> CGPath {
        let path = UIBezierPath()
        path.addArc(withCenter: self.center, radius: self.frame.height/2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        path.close()
        return path.cgPath
    }
    
    func getRectPath() -> CGPath {
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        return path
    }
    
    func activateLabelAnimation() {
        let fontAnim = labelAnimation(from: 1, to: 0)
        fontAnim.delegate = self
        
        fontAnim.setValue(1, forKey: "miLabel")
        label.layer.add(fontAnim, forKey: "label")
        
    }
    
    func activateLabelAnimationSecond() {
        let fontAnim = labelAnimation(from: 0, to: 1)
        label.layer.add(fontAnim, forKey: "label")
        
    }
    
    func deactivateLabelAnimation() {
        let fontAnim = labelAnimation(from: 1, to: 0)
        fontAnim.delegate = self
        
        fontAnim.setValue(2, forKey: "miLabel")
        label.layer.add(fontAnim, forKey: "label")
    }
    
    func activateAnimation() {
        let strokeAnim = animateStroke(from: 0, to: 1)
        
        
        let fillAnim = animateColor(from: INACTIVE_BACKGROUND_COLOR, to: ACTIVE_BACKGROUND_COLOR)
        let anchoLineaAnim = animateLineWidth(from: 0, to: RING_WIDTH)
        
        let group = CAAnimationGroup()
        group.animations = [strokeAnim, anchoLineaAnim, fillAnim]
        group.duration = 1
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        // And finally add the linear animation to the shape!
        layerCirculo.add(group, forKey: "activate")
    }
    
    func deactivateAnimation() {
        // Create the animation for the shape view
        let strokeAnim = animateStroke(from: 1, to: 0)
        
        let animLinea = animateLineWidth(from: RING_WIDTH, to: 0)
        let fillAnim = animateColor(from: ACTIVE_BACKGROUND_COLOR, to: INACTIVE_BACKGROUND_COLOR)
        
        //agrupando
        let group = CAAnimationGroup()
        group.animations = [strokeAnim, fillAnim, animLinea]
        group.duration = 1
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        
        // And finally add the linear animation to the shape!
        layerCirculo.add(group, forKey: "deactivate")
        
    }
    
    func animateStroke(from: CGFloat, to: CGFloat) -> CABasicAnimation {
        // Create the animation for the shape view
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = 1 // seconds
        //  animationCircle.isRemovedOnCompletion = true
        animation.autoreverses = false
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        return animation
    }
    
    func animateColor(from: UIColor, to: UIColor) -> CABasicAnimation {
        // Create the animation for the shape view
        let anim = CABasicAnimation(keyPath: "fillColor")
        anim.fromValue = from.cgColor
        anim.toValue = to.cgColor
        anim.duration = 1 // seconds
        anim.repeatCount = 1
        
        return anim
    }
    
    func animateShadowColor(from: UIColor, to: UIColor) -> CABasicAnimation {
        // Create the animation for the shape view
        let anim = CABasicAnimation(keyPath: "shadowColor")
        anim.fromValue = from.cgColor
        anim.toValue = to.cgColor
        anim.duration = 1 // seconds
        anim.repeatCount = 1
        
        return anim
    }
    
    func animateLineWidth(from: CGFloat, to: CGFloat) -> CABasicAnimation {
        // Create the animation for the shape view
        let anchoLinea = CABasicAnimation(keyPath: "lineWidth")
        anchoLinea.fromValue = from
        anchoLinea.toValue = to
        anchoLinea.duration = 1 // seconds
        
        anchoLinea.autoreverses = false
        anchoLinea.repeatCount = 1
        anchoLinea.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        return anchoLinea
    }
    
    func labelAnimation(from: CGFloat, to: CGFloat) -> CABasicAnimation {
        // Animate font size
        
        let animation = CABasicAnimation(keyPath: "transform.scale.x")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        return animation
    }
}


extension MLBotonCircularCustomView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let key = anim.value(forKey: "miLabel") as? Int {
            if key == 1 {
                label.text = activeText
                self.activateLabelAnimationSecond()
                label.textColor = ACTIVE_LABEL_COLOR
                
                
            } else if key == 2 {
                label.text = inactiveText
                self.activateLabelAnimationSecond()
                label.textColor = INACTIVE_LABEL_COLOR
                
            }
        }
    }
}
