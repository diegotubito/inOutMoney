//
//  extensiones.swift
//  coreGym
//
//  Created by David Diego Gomez on 14/7/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//



import UIKit

extension UIColor {
    public convenience init(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        self.init(red: 0, green: 0, blue: 0, alpha: 0)
        return
    }
}

extension UIColor {
    struct Green {
        static let fern = UIColor(hexString: "#6ABB72FF")
        static let mountainMeadow = UIColor(hexString: "#3ABB9DFF")
        static let chateauGreen = UIColor(hexString: "#4DA664FF")
        static let persianGreen = UIColor(hexString: "#2CA786FF")
    }
    
    struct Blue {
        static let pictonBlue = UIColor(hexString: "#5CADCFFF")
        static let mariner = UIColor(hexString: "#3585C5FF")
        static let curiousBlue = UIColor(hexString: "#4590B6FF")
        static let denim = UIColor(hexString: "#2F6CADFF")
        static let chambray = UIColor(hexString: "#485675FF")
        static let blueWhale = UIColor(hexString: "#29334DFF")
        static let sponge = UIColor(hexString: "#5D92B1FF")
        static let saturatedBlue = UIColor(hexString: "#739AC5FF")
    }
    
    struct Violet {
        static let wisteria = UIColor(hexString: "#9069B5FF")
        static let blueGem = UIColor(hexString: "#533D7FFF")
    }
    
    struct Yellow {
        static let energy = UIColor(hexString: "#F2D46FFF")
        static let turbo = UIColor(hexString: "#F7C23EFF")
        
    }
    
    struct Orange {
        static let neonCarrot = UIColor(hexString: "#F79E3DFF")
        static let sun = UIColor(hexString: "#EE7841FF")
        static let carrot = UIColor(hexString: "#ED9121FF")
    }
    
    struct Red {
        static let terraCotta = UIColor(hexString: "#E66B5BFF")
        static let valencia = UIColor(hexString: "#CC4846FF")
        static let cinnabar = UIColor(hexString: "#DC5047FF")
        static let wellRead = UIColor(hexString: "#B33234FF")
        static let ematita = UIColor(hexString: "#E35152FF")
        
    }
    
    struct Gray {
        static let almondFrost = UIColor(hexString: "#A28F85FF")
        static let whiteSmoke = UIColor(hexString: "#EFEFEFFF")
        static let iron = UIColor(hexString: "#D1D5D8FF")
        static let ironGray = UIColor(hexString: "#75706BFF")
    }
    
}

extension String {
    
    static func random(length: Int = 12) -> String {
        let base = "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UITextView(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}



extension StringProtocol {
    var ascii: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
}

extension Character {
    var ascii: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}





extension String {
    var localized: String {
        //🖕Fuck the translators team, they don’t deserve comments
        return NSLocalizedString(self, comment: "")
    }
}

extension String {
    func hexToFloat() -> UInt32 {
        let result = UInt32(strtoul(self, nil, 16))  // 255
        return result
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    func formatoPorciento(decimales: Int, modulo: Bool) -> String {
        var porcentaje = Double((1-self) * 100).rounded(toPlaces: decimales)
        if porcentaje < 0 && modulo {
            porcentaje = porcentaje * (-1)
        }
        
        return String(porcentaje).replacingOccurrences(of: ".", with: ",") + " %"
    }
}

extension Double {
    func formatoMoneda(decimales: Int, codigoMoneda: String) -> String {
        let numberFormatter = NumberFormatter()
        // numberFormatter.locale = NSLocale.current
        //  numberFormatter.currencySymbol = "$"
        numberFormatter.currencyCode = codigoMoneda
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        let formatoFinal = numberFormatter.string(from: NSNumber(value: self))!
        
        return String(formatoFinal)
        
    }
    
    func formatoMoneda(decimales: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = NSLocale.current
        //  numberFormatter.currencySymbol = "$"
        numberFormatter.numberStyle = NumberFormatter.Style.currencyAccounting
        let formatoFinal = numberFormatter.string(from: NSNumber(value: self))!
        
        return String(formatoFinal)
        
    }
    
    func formatoMonedaTF(decimales: Int) -> String {
        let numero = self.rounded(toPlaces: decimales)
        let separador = ","
        var str = String(numero)
        str = str.replacingOccurrences(of: ".", with: separador)
        
        return "$ " + str
        
    }
}


extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}



/*
 extension NSTableView {
 open override func mouseDown(with event: NSEvent) {
 let globalLocation = event.locationInWindow
 let localLocation = self.convert(globalLocation, to: nil)
 let clickedRow = self.row(at: localLocation)
 
 super.mouseDown(with: event)
 
 if (clickedRow != -1) {
 (self.delegate as? NSTableViewClickableDelegate)?.tableView(self, didClickRow: clickedRow)
 }
 }
 }
 
 protocol NSTableViewClickableDelegate: NSTableViewDelegate {
 func tableView(_ tableView: NSTableView, didClickRow row: Int)
 }
 */
