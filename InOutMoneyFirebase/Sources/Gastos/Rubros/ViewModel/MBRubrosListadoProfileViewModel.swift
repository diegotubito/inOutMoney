//
//  MBProductoListadoViewModelContract.swift
//  contractExample
//
//  Created by David Diego Gomez on 23/12/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import UIKit

enum MBRubrosListadoViewModelItemType {
    case header
    case infoGeneral
    case estadistica
}

protocol MBRubrosListadoProfileViewModelContract {
    init(withView view: MBRubrosListadoProfileViewContract)
   
    var items : [MBRubrosListadoProfileModel] {set get}
    func loadData()
  }

protocol MBRubrosListadoProfileViewContract {
    func toast(message: String)
    func showLoding()
    func hideLoding()
    func reloadList()
    func showError(_ descripcion: String)
}

class MBRubrosListadoProfileViewModel: NSObject, MBRubrosListadoProfileViewModelContract {
    
    var _view : MBRubrosListadoProfileViewContract
    var items = [MBRubrosListadoProfileModel]()
    
    required init(withView view: MBRubrosListadoProfileViewContract) {
        _view = view
    
    }
    
    func loadData() {
        
        MLFirebaseDatabaseService.retrieveData(path: UserID!) { (response, error) in
            if error != nil {
                self._view.toast(message: (error?.localizedDescription)!)
                return
            }
            
            if response == nil {
                self._view.toast(message: "No hay registros en Firebase.")
                return
            }
            
            print(response!)
          
            if let gastos = response?["gastos"] as? [String : Any], let rubros = gastos["rubros"] as? [String : Any] {
                
                
                for (_, value) in rubros {
                    if let registro = value as? [String: Any] {
                        let infoGeneralItem = MBRubrosListadoProfileModel(type: .infoGeneral,
                                                                          titleSection: registro["descripcion"] as! String,
                                                                          desplegable: true,
                                                                          rowCount: 1,
                                                                          json: registro)
                        
                        self.items.append(infoGeneralItem)
                        
                    
                   
                    }
                    
                }
            }
            
            
          
             self._view.reloadList()
 
        }
        
        
    }
    
    
    
    
   
    
    
}


