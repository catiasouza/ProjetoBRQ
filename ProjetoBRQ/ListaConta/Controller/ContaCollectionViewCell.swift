//
//  ContaCollectionViewCell.swift
//  ProjetoBRQ
//
//  Created by Matheus Rodrigues Araujo on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class ContaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var celulaView: UIView!
    
    @IBOutlet weak var labelApelidoConta: UILabel!
    @IBOutlet weak var labelBanco: UILabel!
    @IBOutlet weak var labelAgencia: UILabel!
    @IBOutlet weak var labelConta: UILabel!
    @IBOutlet weak var labelSaldo: UILabel!
    
    @IBOutlet weak var labelFixaBanco: UILabel!
    @IBOutlet weak var labelFixaAgencia: UILabel!
    @IBOutlet weak var labelFixaConta: UILabel!
    @IBOutlet weak var labelFixaSaldo: UILabel!
    
    
    func setAccessibility() {
        
        labelSaldo.isAccessibilityElement = true
        labelSaldo.accessibilityLabel = "Saldo total da conta" + labelSaldo.text!
        labelSaldo.accessibilityTraits = .none
    }
    
    func fixaLabels (labelFixaBanco:String = "Banco", labelFixaAgencia:String = "Agência", labelFixaConta:String = "Conta", labelFixaSaldo:String = "Saldo" ) {
        self.labelFixaBanco.text = labelFixaBanco
        self.labelFixaAgencia.text = labelFixaAgencia
        self.labelFixaConta.text = labelFixaConta
        self.labelFixaSaldo.text = labelFixaSaldo
    }
    
    func dadosDaConta (apelido:String, banco:String = "", agencia:String = "", conta:String = "", saldo:Double?) {
        
        self.labelApelidoConta.text = apelido
        self.labelBanco.text = banco
        self.labelAgencia.text = agencia
        self.labelConta.text = conta
        if saldo == nil {
            self.labelSaldo.text = ""
        } else {
            self.labelSaldo.text = "R$ \(SetupModel().formatarValor(valor: saldo!))"
        }
    }
    
    func configuraExibicaoCelula (celula:ContaCollectionViewCell) {
        
        celula.layer.cornerRadius = 8
        celula.celulaView.backgroundColor = UIColor.white
        celula.celulaView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        celula.contentView.layer.cornerRadius = 8
        celula.contentView.layer.borderWidth = 1
        celula.contentView.layer.borderColor = UIColor.clear.cgColor
        celula.contentView.layer.masksToBounds = true
        celula.layer.backgroundColor = UIColor.white.cgColor
        celula.layer.shadowColor = UIColor.gray.cgColor
        celula.layer.shadowOffset = CGSize(width: 0, height: 5)
        celula.layer.shadowRadius = 8
        celula.layer.shadowOpacity = 0.5
        celula.layer.masksToBounds = false
        
    }
    
}
