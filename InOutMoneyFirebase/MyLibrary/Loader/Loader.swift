//
//  Loader.swift
//  InOutMoneyFirebase
//
//  Created by David Diego Gomez on 12/6/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//


import Foundation
import UIKit

class DDBarLoader {
    var instance = DDBarLoader()
    
    //user parameters
    public static var roundedCap : Bool = false
    public static var duration : CFTimeInterval = 0.5
    public static var color : UIColor = UIColor.white
    public static var backgroundColor : UIColor = UIColor.black
    public static var isBlurred : Bool = true
    public static var backgroundAlpha : CGFloat = 1
    public static var numberOfBars : Int = 6
    public static var spaceBetweenBars : CGFloat = 10
    public static var barWidth : CGFloat = 5
    public static var barHeight : CGFloat = 50
    
    //private parameters
    private static let totalLengthOfBars : CGFloat = (CGFloat(numberOfBars) * barWidth) + (CGFloat(numberOfBars - 1) * spaceBetweenBars)
    private static var blurEffectView : UIVisualEffectView!
    
    private static var ancho : CGFloat!
    private static var alto : CGFloat!
    private static var borderArea : UIView!
    private static var bodyArea : UIView!
    private static var loadingMessage : String = "Loading"
    
    static var viewController : UIViewController!
    
    
    static func showLoading(controller: UIViewController, message: String) {
        if viewController != nil {
            removeAllViews()
        }
        viewController = controller
        loadingMessage = message
        
        ancho = viewController?.view.frame.width
        alto = viewController?.view.frame.height
        
        borderAreaInit()
        bodyAreaInit()
        
        drawBodyArea()
        if isBlurred {
            startBlurEffect()
        }
        
    }
    
    static func hideLoading() {
        removeAllViews()
    }
}

//drawing
extension DDBarLoader {
    
    fileprivate static func removeAllViews() {
        borderArea.removeFromSuperview()
        bodyArea.removeFromSuperview()
        
    }
    
    fileprivate static func drawBodyArea() {
        
        let elapsedTime : Double = Double(duration) * 0.1
        
        for i in 0...numberOfBars - 1 {
            let bar = drawOneBar(x: (CGFloat(i) * (spaceBetweenBars + barWidth)), y: 0, width: barWidth, height: barHeight, color: color)
            bodyArea.addSubview(bar)
            
            let barAnimation = animateBar(duration: duration, beginTime: elapsedTime * Double(i))
            bar.layer.add(barAnimation, forKey: "bar-animation")
        }
        drawLabel()
    }
    
    fileprivate static func drawLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: ancho, height: alto))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = loadingMessage
        bodyArea.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: bodyArea, attribute: .centerX, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: bodyArea, attribute: .bottom, multiplier: 1, constant: 20)
        viewController.view.addConstraints([c1,c2])
        
    }
    
    fileprivate static func drawOneBar(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) -> UIImageView {
        let shape = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        shape.layer.backgroundColor = color.cgColor
        if roundedCap {
            shape.layer.cornerRadius = width/2
        }
        return shape
        
    }
}

//some animations and effects
extension DDBarLoader {
    fileprivate static func animateBar(duration: CFTimeInterval, beginTime: CFTimeInterval) -> CASpringAnimation {
        
        let animation = CASpringAnimation(keyPath: "transform.scale.y")
        animation.fromValue = 0.05
        animation.toValue = 1
        animation.damping = 30
        
        animation.mass = 1
        animation.stiffness = 100
        //  end.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.8, 0.9, 1.0)
        
        animation.duration = duration
        animation.beginTime = beginTime
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = true
        animation.autoreverses = true
        return animation
        
    }
    
    fileprivate static func startBlurEffect() {
        borderArea.layer.backgroundColor = UIColor.clear.cgColor
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.effect = nil
        blurEffectView.frame = borderArea.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        borderArea.addSubview(blurEffectView)
        
        //start blurring
        UIView.animate(withDuration: 3) {
            self.blurEffectView.effect = UIBlurEffect(style: .light)
            //stop animation at 0.5sec
            self.blurEffectView.pauseAnimation(delay: 0.6)
            
        }
    }
}

//some init views
extension DDBarLoader {
    fileprivate static func borderAreaInit() {
        borderArea = UIView(frame: CGRect(x: 0, y: 0, width: ancho, height: alto))
        borderArea.layer.backgroundColor = backgroundColor.cgColor
        borderArea.alpha = backgroundAlpha
        viewController?.view.addSubview(borderArea)
        
    }
    
    fileprivate static func bodyAreaInit() {
        
        bodyArea = UIView(frame: CGRect(x: (borderArea.frame.width - totalLengthOfBars)/2, y: (alto - barHeight)/2, width: totalLengthOfBars, height: barHeight))
        bodyArea.layer.backgroundColor = UIColor.clear.cgColor
        
        
        viewController?.view.addSubview(bodyArea)
    }
}
