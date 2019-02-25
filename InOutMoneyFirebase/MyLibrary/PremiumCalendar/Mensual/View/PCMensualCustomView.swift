//
//  PCGrillaMensualCustomView.swift
//  PremiumCalendar
//
//  Created by David Diego Gomez on 6/1/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

@IBDesignable
class PCMensualCustomView: UIView, PCMensualViewContract {
    func highlightBorderForFinishedSelection() {
        self.layer.borderColor = UIColor.red.cgColor
    }
    func dimmBorderForUnfinishedSelection() {
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    func pintarSelectedDate(view: PCDiaCustomView) {
        view.backgroundColor = COLOR_FONDO_SELECCION
    }
    
    func deselectAll() {
        for view in listaViews {
            view.backgroundColor = UIColor.clear
        }
    }
    
   
    
    var COLOR_FONDO_SELECCION = UIColor.cyan.withAlphaComponent(0.4)
    var COLOR_TEXTO_AÑO = UIColor.black
    var COLOR_TEXTO_MES = UIColor.lightGray
    var FONT_NAME_TEXTO_AÑO = "Verdana-Bold"
    var FONT_NAME_TEXTO_MES = "Verdana"
    var DURACION_ANIMACION_SLIDE_CUERPO : Double = 0.25
    var DURACION_ANIMACION_SLIDE_HEADER : Double = 0.5
    
       
    var factorDimension : CGFloat = 1.0
    var altoHeader : CGFloat = 0
    var altoFontDia : CGFloat = 0
    var altoFontMes : CGFloat = 0
    var altoFontAño : CGFloat = 0
    
    var listaViews = [PCDiaCustomView]()
    var monthTitle = UILabel()
    var yearTitle = UILabel()
    var cuerpo = UIView()
    
    var viewModel : PCMensualViewModelContract!
    
    func updateView() {
        dibujarGrilla()
    }
    
    @IBInspectable
    var colorLabelDia: UIColor = UIColor.white {
        didSet {
            dibujarGrilla()
        }
    }
    
    @IBInspectable
    var fuenteLabelDia: String = "Arial" {
        didSet {
            dibujarGrilla()
        }
    }
    @IBInspectable
    var tamañoFuente: CGFloat = 10.0 {
        didSet {
            dibujarGrilla()
        }
    }
    
    @IBInspectable
    var fondoPlantilla: UIColor = UIColor.blue {
        didSet {
            dibujarGrilla()
        }
    }
    
    @IBInspectable
    var fondoDia: UIColor = UIColor.blue {
        didSet {
            dibujarGrilla()
        }
    }
    
   
    @IBInspectable
    var radio: CGFloat = 0 {
        didSet {
            dibujarGrilla()
        }
    }
    
    @IBInspectable
    var bordeColor : UIColor = UIColor.black {
        didSet {
            dibujarGrilla()
        }
    }
    
    @IBInspectable
    var bordeAncho : CGFloat = 0 {
        didSet {
            dibujarGrilla()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        inicializar()
    }
    
    func inicializar() {
        let screenSize = UIScreen.main.bounds
        self.factorDimension = (frame.width + frame.height) / (screenSize.width + screenSize.height)
    
        self.viewModel = PCMensualViewModel(withCustomView: self)
        self.dibujarGrilla()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftHandle))
        swipeLeft.direction = .left
        addGestureRecognizer(swipeLeft)
 
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightHandle))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
        
        self.layer.masksToBounds = true
        
        viewModel.retrocederMes()
    }
    
    @objc func swipeLeftHandle() {
        viewModel.avanzarMes()
    }
    @objc func swipeRightHandle() {
        viewModel.retrocederMes()
    }
    
    func setMonthTitle() {
        monthTitle.text = viewModel.getMonthName()
    }
   
   
    
    func showSelectedItems() {
        deselectAll()
     
        if viewModel.model.selectionMode == PCMensualSelectionMode.doubleSelection && viewModel.model.selectedDates.count == 2 {
            let str1 = viewModel.model.selectedDates[0]
            let str2 = viewModel.model.selectedDates[1]
            let date1 = str1.toDate(formato: "dd-MM-yyyy")!
            let date2 = str2.toDate(formato: "dd-MM-yyyy")!
            
            var dateMayor = date1
            var dateMenor = date2
            if date2 > date1 {
                dateMayor = date2
                dateMenor = date1
            }
            for i in listaViews {
                let fecha = i.fechaString.toDate(formato: "dd-MM-yyyy")!
                if fecha >= dateMenor && fecha <= dateMayor {
                      pintarSelectedDate(view: i)
                }
            }
            
            
        }
        
        for i in listaViews {
            if viewModel.model.selectedDates.contains(i.fechaString) {
                pintarSelectedDate(view: i)
            }
        }
        
        
      
    }
    
    func animarSegunModo(view: PCDiaCustomView) {
      
       /* view.buttonAnimation()
        if viewModel.model.selectionMode == PCMensualSelectionMode.doubleSelection && viewModel.model.selectedItems.count >= 2 {
            animarViewModeDoubleSelection(view: view)
        }
 */
        
    }
    
    func animarViewModeDoubleSelection(view: PCDiaCustomView) {
        
        view.fondoSeleccion.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIButton.animate(withDuration: 0.2, delay: 0.02,
                         animations: {
                            view.fondoSeleccion.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })

    }
   
    func hideYear(completion: @escaping () -> Void) {
        if Int(self.yearTitle.text!) != self.viewModel.getYear() {
             self.yearTitle.fadeOut {
                completion()
            }
        }
    }
    
    func showYear(completion: @escaping () -> Void) {
        self.yearTitle.alpha = 1
        
        self.yearTitle.zoomIn(duration: 0.5, completed: {
            completion()
        })
    }
    
    func setYearTitle() {
        self.yearTitle.text = String(self.viewModel.getYear())
    }
    
    
    
    func hideMesIzquierda(completion: @escaping () -> Void) {
        let from = monthTitle.frame.origin.x
        let to = from - monthTitle.layer.frame.size.width - 16

        monthTitle.slide(fromX: from, toX: to, duration: DURACION_ANIMACION_SLIDE_HEADER) {
             completion()
        }
    }
    
    func showMesDerecha(completion: @escaping () -> Void) {
        let from = (self.monthTitle.superview?.frame.width)!
        let to = monthTitle.frame.origin.x
    
        monthTitle.slide(fromX: from, toX: to, duration: DURACION_ANIMACION_SLIDE_HEADER) {
             completion()
        }
    }
    
    func hideMesDerecha(completion: @escaping () -> Void) {
        let from = monthTitle.frame.origin.x
        let to = (self.monthTitle.superview?.frame.width)!
        
        monthTitle.slide(fromX: from, toX: to, duration: DURACION_ANIMACION_SLIDE_HEADER) {
             completion()
        }

    }
    
    func showMesIzquierda(completion: @escaping () -> Void) {
        let from = -self.monthTitle.ancho - 16
        let to = monthTitle.frame.origin.x
        
        monthTitle.slide(fromX: from, toX: to, duration: DURACION_ANIMACION_SLIDE_HEADER) {
            completion()
        }
        
    }
    
    func hideCuerpoIzquierda(completion: @escaping () -> Void) {
        let from = cuerpo.frame.origin.x
        let to = from - cuerpo.layer.frame.size.width
        
        cuerpo.slide(fromX: from, toX: to, duration: DURACION_ANIMACION_SLIDE_CUERPO) {
            completion()
        }

    }
    
    func showCuerpoDerecha(completion: @escaping () -> Void) {
        let from = self.cuerpo.frame.width
        let to : CGFloat = 0
        
        cuerpo.slide(fromX: from, toX: to, duration: DURACION_ANIMACION_SLIDE_CUERPO) {
            completion()
        }

    }
    
    func hideCuerpoDerecha(completion: @escaping () -> Void) {
        let from = cuerpo.frame.origin.x
        let to = self.cuerpo.frame.width
        
        cuerpo.slide(fromX: from, toX: to, duration: DURACION_ANIMACION_SLIDE_CUERPO) {
            completion()
        }

    }
    
    func showCuerpoIzquierda(completion: @escaping () -> Void) {
        let from = -self.cuerpo.frame.width
        let to : CGFloat = 0
        
        cuerpo.slide(fromX: from, toX: to, duration: DURACION_ANIMACION_SLIDE_CUERPO) {
            completion()
        }

    }
    
    func updateDays() {
        
        self.deselectAll()
        
        for fila in 0...5 {
            for columna in 0...6 {
                let atributos = getDayAttibutes(fecha: viewModel.model.viewDate, fila: fila, columna: columna)
                let i = columna + (fila * 7)
                listaViews[i].labelCentral.text = String(atributos.dia)
                listaViews[i].labelCentral.textColor = atributos.labelCentralColor
                listaViews[i].labelCentral.font = atributos.labelCentralFont
                
                let fecha = listaViews[i].fechaString
                if viewModel.model.selectedDates.contains(fecha) {
                    pintarSelectedDate(view: listaViews[i])
       
                }
                
                self.showSelectedItems()
                
                let aux = String(atributos.dia) + "-" + String(atributos.mes) + "-" + String(atributos.año)
                let auxDate = aux.toDate(formato: "dd-MM-yyyy")
                let finalStr = (auxDate?.toString(formato: "dd-MM-yyyy"))!
                
                listaViews[i].fechaString = finalStr
                
            }
        }
      
        
    }
    
    
    
    func getDayAttibutes(fecha: Date, fila: Int, columna: Int) -> PCMensualDayAttribute {
        let i = columna + (fila*7)
        let diaInicial = queDiaEmpiezaElMes(fecha: fecha)
        
        let mesAnterior = Calendar.current.date(byAdding: .month, value: -1, to: fecha)
        let mesSiguiente = Calendar.current.date(byAdding: .month, value: 1, to: fecha)
        
        let diasMaximoMesAnteriorEnPantalla = mesAnterior?.endDay()
        let diasMaximoMesActualEnPantalla = fecha.endDay()
        
        var x : Int = i - diaInicial + 2 + viewModel.model.firstDay.raw
        let valorEnCero = x - i
        var offset = 0
        
        if valorEnCero > 1 {
            offset = -7
        }
        
        x = x + offset
        
        
        let atributos = PCMensualDayAttribute()
        atributos.fila = fila
        atributos.columna = columna
        
        if x > 0 && x <= diasMaximoMesActualEnPantalla {
            atributos.antActSig = 0
            atributos.labelCentralFont = UIFont.systemFont(ofSize: frame.height/20)
            atributos.mes = fecha.mes
            atributos.año = fecha.año
            
        } else if x <= 0 {
            atributos.antActSig = 1
            x = x + diasMaximoMesAnteriorEnPantalla!
            atributos.labelCentralFont = UIFont.systemFont(ofSize: frame.height/20 * 0.8)
            
            atributos.mes = mesAnterior!.mes
            atributos.año = mesAnterior!.año
            
        } else {
            atributos.antActSig = -1
            x = x - diasMaximoMesActualEnPantalla
            atributos.labelCentralFont = UIFont.systemFont(ofSize: frame.height/20 * 0.8)
            
            atributos.mes = (mesSiguiente?.mes)!
            atributos.año = (mesSiguiente?.año)!
            
        }
        
        
        atributos.labelCentralColor = getLabelColor(atributos)
        atributos.dia = x
        
        
        return atributos
    }
    
    func getLabelColor(_ valor: PCMensualDayAttribute) -> UIColor {
        if viewModel.model.columnasOscurecidas.contains(valor.columna) {
            return UIColor.lightGray
        } else {
            if valor.antActSig == 0 {
                //mes actual
                return UIColor.white
            } else {
                return UIColor.lightGray
            }
        }
    }
    
    
}


extension PCMensualCustomView: PCDiaCustomViewDelegate {
    func didTouched(fila: Int, columna: Int) {
        let index = columna + (fila * 7)
        viewModel.selectedView(listaViews[index])
    }
  
}


extension PCMensualCustomView {
   /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
      
         
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
        
            print(currentPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
           // print(currentPoint)
        }
    }*/
}



//HEADER
extension PCMensualCustomView {
    
}
