//
//  AlertaRemoveConta.swift
//  ProjetoBRQ
//
//  Created by Matheus Rodrigues Araujo on 07/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class AlertaRemoveConta {
    
    var controller:UIViewController
    
    init (controller:UIViewController ) {
        self.controller = controller
    }
    
    func alerta ( controller: UIViewController , handler : @escaping(UIAlertAction) -> Void ) {
        
        let alerta = UIAlertController(title: "Exclusão Permanentemente", message: "Essa conta será excluida permanentemente, tem certeza que excluida?", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        let deletar = UIAlertAction(title: "Excluir", style: .destructive, handler: handler)

        alerta.addAction(cancelar)
        alerta.addAction(deletar)
        controller.present(alerta, animated: true, completion: nil)
    }
    
}
