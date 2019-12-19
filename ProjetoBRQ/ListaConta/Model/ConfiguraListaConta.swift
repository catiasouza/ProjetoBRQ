//
//  ConfiguraListaConta.swift
//  ProjetoBRQ
//
//  Created by Matheus Rodrigues Araujo on 19/12/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class ConfiguraListaConta {
    
    func setAcessibility(imageLogoBRQ: UIImageView, labelSaldoTotal:UILabel, buttonAdicionar:UIButton) {
        
        imageLogoBRQ.isAccessibilityElement = true
        imageLogoBRQ.accessibilityLabel = "Logo da BRQ"
        imageLogoBRQ.accessibilityTraits = .image

        labelSaldoTotal.isAccessibilityElement = true
        labelSaldoTotal.accessibilityLabel = "Soma do saldo das contas em Reais"
        labelSaldoTotal.accessibilityTraits = .none
        
        buttonAdicionar.isAccessibilityElement = true
        buttonAdicionar.accessibilityLabel = "Botão para adicionar nova conta"
        buttonAdicionar.accessibilityTraits = .button
    }
    
    func populaCollection(contaSelecionada:ContaCD, celula:ContaCollectionViewCell, indexPath:IndexPath) {
        
        let apelido = contaSelecionada.apelidoConta!
        let banco = contaSelecionada.banco!
        let agencia = String(describing: contaSelecionada.agencia)
        let contaNumero = "\(String(describing: contaSelecionada.conta))" + "-" + "\(String(describing: contaSelecionada.digito))"
        let saldo = SetupModel().arredondaDouble(valor: contaSelecionada.saldo)
        
        celula.dadosDaConta(apelido: apelido, banco: banco, agencia: agencia, conta: contaNumero, saldo: saldo)
        celula.fixaLabels()
        celula.setAccessibility()
        
        celula.configuraExibicaoCelula(celula: celula)
        
    }
    
}
