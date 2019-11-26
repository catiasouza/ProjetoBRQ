//
//  Validacoes.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 26/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class Validacoes: NSObject {
    func validaRangeDatas(de: String?, ate: String?) -> Bool{
        //pegando datas dadas pelo usuario
        guard let dataInicioString = de else {return false}
        guard let dataFimString = ate else {return false}
        
        //criando formato padrao
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        //convertendo a string das datas para date
        let dataInicioDate = dateFormatter.date(from: dataInicioString)
        let dataFimDate = dateFormatter.date(from: dataFimString)
        
        //tirando dado do estado de opcional
        guard let dataInicio = dataInicioDate else{return false}
        guard let dataFim = dataFimDate else{return false}
        
        if dataInicio <= dataFim {
            return true
        }else{
            return false
        }
    }
}
