//
//  progressIndicator.swift
//  coreGymMobile
//
//  Created by David Diego Gomez on 11/8/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit


class _downloadProgress: UIView {
    var progressBar : UIProgressView!
    var labelTitulo : UILabel!
    
    var porcentajeProgreso : Float = 0 {
        didSet {
            if porcentajeProgreso != oldValue {
                DispatchQueue.main.async {
                    self.progressBar.setProgress(self.porcentajeProgreso, animated: true)
                    self.labelTitulo.text = "⇣ bajando datos..."
                }
            }
        }
    }
    
    var totalUnitCount : Int64!
    
    var completedUnitCount : Int64! {
        didSet {
            let totalTareas = tareasPendientes + tareasRealizadas
            
            if totalTareas != 0 && totalUnitCount != 0 {
                
                let PorcentajeIndividual = Float(completedUnitCount)/Float(totalUnitCount) / Float(totalTareas)
                print(PorcentajeIndividual)
                porcentajeProgreso = (Float(tareasRealizadas) + PorcentajeIndividual) / Float(totalTareas) + 1/Float(totalTareas)
            }
        }
    }
    var totalBytesPorTarea : [Int64]!
    
    func inicializar() {
        dibujarBarraDeProgreso()
        
        self.totalUnitCount = 0
        self.completedUnitCount = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(progressNotificationHandler(notificacion:)), name: .progressNotification, object: nil)
        
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        inicializar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        inicializar()
    }
    
    deinit {
        print("_downloadProgress class deallocated")
        NotificationCenter.default.removeObserver(self, name: .progressNotification, object: nil)
    }
    
    @objc func progressNotificationHandler(notificacion: NSNotification) {
        if let progress = notificacion.object as? Progress {
            totalUnitCount = progress.totalUnitCount
            completedUnitCount = progress.completedUnitCount
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
    
    func dibujarBarraDeProgreso() {
        labelTitulo = UILabel(frame: CGRect(x: 0, y: -12, width: frame.width, height: frame.height))
        labelTitulo.font = UIFont(name: "ArialHebrew", size: 10)
        labelTitulo.textColor = UIColor.white
        labelTitulo.textAlignment = .center
        addSubview(labelTitulo)
        
        progressBar = UIProgressView(frame: self.frame)
        progressBar.setProgress(0, animated: false)
        self.isHidden = true
        addSubview(progressBar)
    }
    
}
