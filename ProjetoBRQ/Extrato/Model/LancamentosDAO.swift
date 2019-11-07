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
        let numeroConta: String = ""
        if numeroConta == "123456-7"{
            let listaLancamentos: Array<Lancamento> = []
            return listaLancamentos
        }else{
            return []
        }
    }
    
}
