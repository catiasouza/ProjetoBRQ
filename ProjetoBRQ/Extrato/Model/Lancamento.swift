//
//  Lancamento.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class Lancamento: NSObject {

    let nome: String
    let data: String
    let valor: Double
    
    init(nome: String, data: String, valor: Double) {
        self.nome = nome
        self.data = data
        self.valor = valor
    }
}
