//
//  NotificacoesCadastro.swift
//  ProjetoBRQ
//
//  Created by Catia Miranda de Souza on 21/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import Foundation
import UIKit


class NotificacoesCadastro{
    var controller:UIViewController
    
    init (controller:UIViewController ) {
        self.controller = controller
    }
    //Acessibilidade
    func accessibilidadeCadastro(botaoAdicionar: UIButton, botaoVoltar: UIButton, logoBRQ: UIImageView, textApelidoConta: UITextField){
        
        
        botaoAdicionar.isAccessibilityElement = true
        botaoAdicionar.accessibilityLabel = "Adicione sua conta"
        botaoAdicionar.accessibilityTraits = .button
        
        botaoVoltar.isAccessibilityElement = true
        botaoVoltar.accessibilityLabel = "Voltar para a tela lista de contas"
        botaoVoltar.accessibilityTraits = .button
        
        logoBRQ.isAccessibilityElement = true
        logoBRQ.accessibilityLabel = "Logo da BRQ"
        logoBRQ.accessibilityTraits = .image
        
        textApelidoConta.isAccessibilityElement = true
        textApelidoConta.accessibilityLabel = "Digite um apelido para sua conta"
        textApelidoConta.accessibilityTraits = .none
    }
}
 //Criacao Toast
extension UIViewController {
    func toastMessage(_ message: String){
        guard let window = UIApplication.shared.keyWindow else {return}
        let messageLbl = UILabel()
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: 15)
        messageLbl.textColor = .white
        messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let textSize:CGSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, window.frame.width - 100)
        
        messageLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
        messageLbl.center.x = window.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height/2
        messageLbl.layer.masksToBounds = true
        window.addSubview(messageLbl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            UIView.animate(withDuration: 1, animations: {
                messageLbl.alpha = 0
            }) { (_) in
                messageLbl.removeFromSuperview()
            }
        }
    }
    
}
