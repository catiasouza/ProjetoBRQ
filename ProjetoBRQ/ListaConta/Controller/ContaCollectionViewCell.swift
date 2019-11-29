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
    
    
    func fixaLabels (labelFixaBanco:String = "Banco", labelFixaAgencia:String = "Agencia", labelFixaConta:String = "Conta", labelFixaSaldo:String = "Saldo" ) {
        self.labelFixaBanco.text = labelFixaBanco
        self.labelFixaAgencia.text = labelFixaAgencia
        self.labelFixaConta.text = labelFixaConta
        self.labelFixaSaldo.text = labelFixaSaldo
    }
    
}
