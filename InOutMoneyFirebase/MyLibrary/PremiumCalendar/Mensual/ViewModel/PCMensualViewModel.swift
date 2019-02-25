//
//  PCMensualViewModel.swift
//  PremiumCalendar
//
//  Created by David Diego Gomez on 6/1/19.
//  Copyright © 2019 Gomez David Diego. All rights reserved.
//

import UIKit

class PCMensualViewModel: NSObject, PCMensualViewModelContract {
    func finishedWithSelection() {
        _view.highlightBorderForFinishedSelection()
    }
    
    
  
      
    var model: PCMensualModel
    var _view : PCMensualViewContract!
    
    required init(withCustomView view: PCMensualViewContract) {
        _view = view
        
        let selectedItems : [Int] = []
        model = PCMensualModel(selectionMode: PCMensualSelectionMode.singleSelection, selectedItems: selectedItems)
    
        model.construirNombreDias()
        
    
  
    }
    
    func getNameDay(index: Int) -> String {
        return model.nombreDiasConstruidos[index]
    }
    func getYear() -> Int {
        let año = Calendar.current.component(.year, from: model.viewDate)
        
        return año
        
    }
    
    
    func getMonth() -> Int {
        let mes = Calendar.current.component(.month, from: model.viewDate)
        return mes
    }
    
    func getMonthName() -> String {
        let mes = Calendar.current.component(.month, from: model.viewDate)
        return MESES[mes]!
    }
    
    
    func selectedView(_ view: PCDiaCustomView) {
        print(view.fechaString)
        
        if model.selectionMode == PCMensualSelectionMode.singleSelection {
            model.selectedDates.removeAll()
            model.selectedDates.append(view.fechaString)
         _view.highlightBorderForFinishedSelection()
            
        } else if model.selectionMode == PCMensualSelectionMode.randomSelection {
            if let index = model.selectedDates.firstIndex(where: {$0 == view.fechaString}) {
                model.selectedDates.remove(at: index)
                _view.dimmBorderForUnfinishedSelection()
            } else {
                _view.highlightBorderForFinishedSelection()
                model.selectedDates.append(view.fechaString)
            }
 
        } else if model.selectionMode == PCMensualSelectionMode.doubleSelection {
            if model.selectedDates.count > 1 {
                model.selectedDates.removeAll()
                model.selectedDates.append(view.fechaString)
                _view.dimmBorderForUnfinishedSelection()
            } else if model.selectedDates.count == 1 {
                _view.highlightBorderForFinishedSelection()
                model.selectedDates.append(view.fechaString)
             } else {
                model.selectedDates.append(view.fechaString)
                _view.dimmBorderForUnfinishedSelection()
            }
 
            
        } else if model.selectionMode == PCMensualSelectionMode.doubleSelection {
            
        }
        
         _view.showSelectedItems()
        
     }
    
   
    func avanzarMes() {
        model.viewDate.sumarMes(valor: 1)
        
        _view.hideYear {
            self._view.setYearTitle()
            self._view.showYear {}
        }
        
        _view.hideMesIzquierda {
            self._view.setMonthTitle()
            self._view.showMesDerecha {}
        }
        
        _view.hideCuerpoIzquierda {
             self._view.updateDays()
            self._view.showCuerpoDerecha {
                
            }
        }
    }
    
    func retrocederMes() {
        model.viewDate.sumarMes(valor: -1)
        
        _view.hideYear {
            self._view.setYearTitle()
            self._view.showYear {}
        }
        
        _view.hideMesDerecha {
            self._view.setMonthTitle()
            self._view.showMesIzquierda {}
        }
    
        _view.hideCuerpoDerecha {
            self._view.updateDays()
            self._view.showCuerpoIzquierda {
                
            }
        }
        
    }
    
    
   
    
}


