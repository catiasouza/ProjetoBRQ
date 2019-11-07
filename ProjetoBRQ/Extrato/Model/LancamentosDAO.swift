//
//  LancamentosDAO.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 07/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class LancamentosDAO: NSObject {

    func retornaLancamentos() -> Array<Lancamento>{
        let mcdonalds = Lancamento(nome: "mc donalds", data: "22-12-2019", valor: 22.50)
        let americanas = Lancamento(nome: "americanas", data: "24-12-2019", valor: 75.99)
        let samsung = Lancamento(nome: "samsung", data: "29-12-2019", valor: 4000.00)
        let listaLancamentos: Array<Lancamento> = [mcdonalds, americanas, samsung]
        
        return listaLancamentos
    }
}
