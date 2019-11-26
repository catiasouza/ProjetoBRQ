//
//  Lancamento.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class Lancamento: NSObject {

    let id: Int
    let nome: String
    let dataOperacao: String
    let tipoOperacao: String
    let valor: Double
    
    init(id: Int, nome: String, dataOperacao: String, tipoOperacao: String, valor: Double) {
        self.id = id
        self.nome = nome
        self.dataOperacao = dataOperacao
        self.tipoOperacao = tipoOperacao
        self.valor = valor
    }
}
