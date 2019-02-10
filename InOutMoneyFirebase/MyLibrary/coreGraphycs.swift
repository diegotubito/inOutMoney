//
//  coreGraphycs.swift
//  coreGymMobile
//
//  Created by David Diego Gomez on 11/9/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

@IBDesignable class triaguno: UIView, CAAnimationDelegate {
    var trianguloShape : CAShapeLayer!
    
    @IBInspectable var fillColor : UIColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var strokeColor : UIColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineWidth : CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
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
    
    override func draw(_ rect: CGRect) {
        dibujar()
    }
    
    func inicializar() {
    }
    
    func dibujar() {
        print("dibujando triangulo...")
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width / 2, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: 0))
        
        
        trianguloShape = CAShapeLayer()
        trianguloShape.strokeColor = strokeColor.cgColor
        trianguloShape.fillColor = fillColor.cgColor
        trianguloShape.lineWidth = lineWidth
        trianguloShape.lineDashPattern = [1, 5]
        
        
        trianguloShape.path = path.cgPath
        trianguloShape.strokeStart = 0.0
        layer.addSublayer(trianguloShape)
        
        
        
        
        
    }
    
    func transformToRectangle() {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: bounds.width/2, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.addArc(tangent1End: CGPoint(x: bounds.width/4, y: bounds.height/4), tangent2End: CGPoint(x: bounds.width/2, y: bounds.height/2), radius: 10)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = path
        pathAnimation.duration = 0.75
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = .greatestFiniteMagnitude
        
        let grupo = CAAnimationGroup()
        grupo.duration = 0.75
        grupo.animations = [pathAnimation]
        
        trianguloShape.add(grupo, forKey: "pathAnimation")
    }
    
    func transformToEllipse() {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addEllipse(in: bounds)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = path
        pathAnimation.duration = 0.75
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = .greatestFiniteMagnitude
        
        trianguloShape.add(pathAnimation, forKey: "pathAnimation")
    }
    
    func animar() {
        
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 1
        anim.setValue("stroke", forKey: "name")
        anim.delegate = self
        trianguloShape.add(anim, forKey: nil)
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        
        if name == "stroke" {
            print("fin de animacion stroke.")
        }
    }
    
    
}

class _coreGraphics {
    static let instance = _coreGraphics()
    
    

    
}
