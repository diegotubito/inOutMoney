//
//  File.swift
//  PremiumCalendar
//
//  Created by David Diego Gomez on 13/1/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

extension PCMensualCustomView {
    func dibujarGrilla() {
        altoHeader = (frame.height / 1.5) * factorDimension
        altoFontDia = frame.height/12 * factorDimension
        altoFontMes = altoHeader/2.7
        altoFontAño = altoHeader/3
        
        for i in self.subviews {
            i.removeFromSuperview()
        }
        
        let stackGrilla = UIStackView()
        stackGrilla.alignment = .fill
        stackGrilla.distribution = .fill
        stackGrilla.spacing = 0
        stackGrilla.axis = .vertical
        
        addSubview(stackGrilla)
        
        stackGrilla.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: stackGrilla, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let a2 = NSLayoutConstraint(item: stackGrilla, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let a3 = NSLayoutConstraint(item: stackGrilla, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let a4 = NSLayoutConstraint(item: stackGrilla, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        self.addConstraints([a1, a2, a3, a4])
        
        addMonthView(stackGrilla: stackGrilla)
        addYearView(stackGrilla: stackGrilla)
        addHeaderDaysView(stackGrilla: stackGrilla)
        addDiasView(stackGrilla: stackGrilla)
      
        
    }
    func addDiasView(stackGrilla: UIStackView) {
        cuerpo = dibujarCuerpo()
        stackGrilla.addArrangedSubview(cuerpo)
        
    }
    func addHeaderDaysView(stackGrilla: UIStackView) {
        let diasDeLaSemana = dibujarDiasDeLaSemana()
        stackGrilla.addArrangedSubview(diasDeLaSemana)
        
        
        diasDeLaSemana.translatesAutoresizingMaskIntoConstraints = false
        let d1 = NSLayoutConstraint(item: diasDeLaSemana, attribute: .leading, relatedBy: .equal, toItem: stackGrilla, attribute: .leading, multiplier: 1, constant: 0)
        let d2 = NSLayoutConstraint(item: diasDeLaSemana, attribute: .trailing, relatedBy: .equal, toItem: stackGrilla, attribute: .trailing, multiplier: 1, constant: 0)
        let d3 = NSLayoutConstraint(item: diasDeLaSemana, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (altoFontDia)*1.5 )
        stackGrilla.addConstraints([d1, d2, d3])
    }
    func addMonthView(stackGrilla: UIStackView) {
        let monthView = dibujarMonthView()
        stackGrilla.addArrangedSubview(monthView)
        
        monthView.translatesAutoresizingMaskIntoConstraints = false
        let h1 = NSLayoutConstraint(item: monthView, attribute: .leading, relatedBy: .equal, toItem: stackGrilla, attribute: .leading, multiplier: 1, constant: 0)
        let h2 = NSLayoutConstraint(item: monthView, attribute: .trailing, relatedBy: .equal, toItem: stackGrilla, attribute: .trailing, multiplier: 1, constant: 0)
        let h3 = NSLayoutConstraint(item: monthView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: altoHeader)
        stackGrilla.addConstraints([h1, h2, h3])

    }
    
    func addYearView(stackGrilla: UIStackView) {
        let year = UIView(frame: CGRect.zero)
        year.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        year.layer.cornerRadius = altoHeader/10
        year.layer.masksToBounds = true
        stackGrilla.addSubview(year)
        
        year.translatesAutoresizingMaskIntoConstraints = false
        let y1 = NSLayoutConstraint(item: year, attribute: .top, relatedBy: .equal, toItem: stackGrilla, attribute: .top, multiplier: 1, constant: 0)
        let y4 = NSLayoutConstraint(item: year, attribute: .trailing, relatedBy: .equal, toItem: stackGrilla, attribute: .trailing, multiplier: 1, constant: 0)
        let y2 = NSLayoutConstraint(item: year, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.frame.width/3)
        let y3 = NSLayoutConstraint(item: year, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: altoHeader/2)
        stackGrilla.addConstraints([y1, y2, y3, y4])
        
        yearTitle.text = String(viewModel.getYear())
        yearTitle.textColor = COLOR_TEXTO_AÑO
        yearTitle.font = UIFont(name: FONT_NAME_TEXTO_AÑO, size: altoFontAño)!
        year.addSubview(yearTitle)
        
        yearTitle.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: yearTitle, attribute: .centerY, relatedBy: .equal, toItem: year, attribute: .centerY, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: yearTitle, attribute: .centerX, relatedBy: .equal, toItem: year, attribute: .centerX, multiplier: 1, constant: 0)
        year.addConstraints([c1,c2])
        
        
    }
    
    func dibujarMonthView() -> UIView {
        let rectangulo = UIView(frame: CGRect.zero)
        rectangulo.backgroundColor = UIColor.black
  
        monthTitle.text = viewModel.getMonthName()
        monthTitle.textColor = COLOR_TEXTO_MES
        monthTitle.font = UIFont(name: FONT_NAME_TEXTO_MES, size: altoFontMes)!
        
        rectangulo.addSubview(monthTitle)
        
        monthTitle.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: monthTitle, attribute: .left, relatedBy: .equal, toItem: rectangulo, attribute: .left, multiplier: 1, constant: 16)
        let c2 = NSLayoutConstraint(item: monthTitle, attribute: .centerY, relatedBy: .equal, toItem: rectangulo, attribute: .centerY, multiplier: 1, constant: 0)
        rectangulo.addConstraints([c1,c2])
        
        
        return rectangulo
    }
    
    func dibujarPathYearView(container: UIView) {
       
        let ancho = container.frame.width
        let alto = container.frame.size.height
         
        let myPath = CGMutablePath()
        let puntoInicial = CGPoint(x: ancho - ancho/3, y: 0)
        myPath.move(to: puntoInicial)
        myPath.addQuadCurve(to: CGPoint(x: ancho, y: alto/2), control: CGPoint(x: ancho - alto, y: alto/2))
        
        myPath.addLine(to: CGPoint(x: ancho, y: 0))
        myPath.closeSubpath()
        
        let layer = CAShapeLayer()
        layer.path = myPath
        //UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 50).cgPath
        layer.fillColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        layer.strokeColor = UIColor.white.cgColor
        container.layer.addSublayer(layer)
    }
 
    
    func dibujarDiasDeLaSemana() -> UIView {
        
        let rectangulo = UIView(frame: CGRect.zero)
        rectangulo.backgroundColor = UIColor.darkGray
        
        let containerStack = UIStackView()
        containerStack.alignment = .fill
        containerStack.distribution = .fillEqually
        containerStack.spacing = 0
        containerStack.axis = .horizontal
        
        for i in 0...6 {
            let lab = UILabel()
            lab.font = UIFont.systemFont(ofSize: altoFontDia)
            lab.text = viewModel.getNameDay(index: i)
            lab.textAlignment = .center
            containerStack.addArrangedSubview(lab)
        }
        
        rectangulo.addSubview(containerStack)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: containerStack, attribute: .leading, relatedBy: .equal, toItem: rectangulo, attribute: .leading, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: containerStack, attribute: .trailing, relatedBy: .equal, toItem: rectangulo, attribute: .trailing, multiplier: 1, constant: 0)
        let c3 = NSLayoutConstraint(item: containerStack, attribute: .bottom, relatedBy: .equal, toItem: rectangulo, attribute: .bottom, multiplier: 1, constant: 0)
        let c4 = NSLayoutConstraint(item: containerStack, attribute: .top, relatedBy: .equal, toItem: rectangulo, attribute: .top, multiplier: 1, constant: 0)
        
        rectangulo.addConstraints([c1,c2,c3,c4])
        
        return rectangulo
    }
    
    func dibujarCuerpo() -> UIView {
        listaViews.removeAll()
        backgroundColor = fondoPlantilla
        let cuerpo = crearColumnas()
        return cuerpo
    }
    
    func crearColumnas() -> UIStackView {
        var arrayFilas = [UIStackView]()
        
        for index in 0...5 {
            let stackFila = crearFila(fila: index)
            arrayFilas.append(stackFila)
        }
        
        let columnas = UIStackView(arrangedSubviews: arrayFilas)
        columnas.alignment = .fill
        columnas.distribution = .fillEqually
        columnas.spacing = 1
        columnas.axis = .vertical
        
        return columnas
    }
    
    func crearFila(fila: Int) -> UIStackView {
        var viewsFila = [UIView]()
        
        for index in 0...6 {
            let nuevaView = PCDiaCustomView(frame: CGRect())
            
            nuevaView.columna = index
            nuevaView.fila = fila
            nuevaView.bordeAncho = bordeAncho
            nuevaView.bordeColor = bordeColor
            nuevaView.fondoDia = fondoDia
            nuevaView.radio = radio
            nuevaView.delegate = self

            
            listaViews.append(nuevaView)
            viewsFila.append(nuevaView)
        }
        let stackFila = UIStackView(arrangedSubviews: viewsFila)
        stackFila.distribution = .fillEqually
        stackFila.alignment = .fill
        stackFila.spacing = 1
        stackFila.axis = .horizontal
        
        return stackFila
    }
    
}
