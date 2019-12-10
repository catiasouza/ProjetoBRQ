//
//  SetupModel.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/12/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class SetupModel{
    
    //MARK: - Valores Numericos
    func arredondaDouble(valor: Double)-> Double{
        let formato = String(2)+"f"
        return Double(String(format: "%."+formato, valor))!
    }
    
    func formatarValor(valor: Double) -> String{
        let formato = NumberFormatter()
        formato.numberStyle = .decimal
        formato.locale = Locale(identifier: "pt_BR")
        if let valorFinal = formato.string(for: valor){
            let valorInteiro = Int(valor)
            var valorDecimal = valor - Double(valorInteiro)
            valorDecimal = arredondaDouble(valor: valorDecimal)
            valorDecimal = valorDecimal * 10
            let valorDecimalInteiro = Int(valorDecimal)
            if valor == 0{
                return "0,00"
            }
            if valor / Double(valorInteiro) == 1{
                return "\(valorFinal),00"
            }else if valorDecimal / Double(valorDecimalInteiro) == 1{
                return "\(valorFinal)0"
            }else{
                return valorFinal
            }
        }else {
            return "0,00"
        }
    }
    
    //MARK: - Datas
    func validaRangeDatas(de: String?, ate: String?) -> Bool{
        guard let dataInicioString = de else {return false}
        guard let dataFimString = ate else {return false}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dataInicioDate = dateFormatter.date(from: dataInicioString)
        let dataFimDate = dateFormatter.date(from: dataFimString)
        guard let dataInicio = dataInicioDate else{return false}
        guard let dataFim = dataFimDate else{return false}
        if dataInicio <= dataFim {
            return true
        }else{
            return false
        }
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
