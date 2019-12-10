//
//  ExtratoService.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 26/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class ExtratoService: NSObject {
    
    func retornaLancamentos(id: Int, dataInicio: String, dataFim: String, sucesso:@escaping(_ lanca: Array<Lancamento>) -> Void){
        
        let dataComecoOpt = SetupModel().formattedDateFromString(dateString: dataInicio, withFormat: "yyyyMMdd")
        let dataFinalOpt = SetupModel().formattedDateFromString(dateString: dataFim, withFormat: "yyyyMMdd")
        guard let dataComeco = dataComecoOpt else { return }
        guard let dataFinal = dataFinalOpt else { return }
        var todosLancamentos: Array<Lancamento> = []
        if let url = URL(string: "http://api.rlmsolutions.com.br/estagio/trabalho/bancos/\(id)/extrato/\(dataComeco)/\(dataFinal)"){
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil{
                    guard let dadosRetorno = dados else {return}
                    do {
                        if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]{
                            if let lancamentos = objetoJson["data"] as? Array<Any>{
                                for i in lancamentos{
                                    if let valor = i as? [String: Any]{
                                        guard let dataOperacao = valor["data_operacao"] as? String else {return}
                                        guard let id = valor["id"] as? Int else {return}
                                        guard let lancamento = valor["lancamento"] as? String else {return}
                                        guard let tipoOperacao = valor["tipo_operacao"] as? String else {return}
                                        guard let valor = valor["valor"] as? Double else {return}
                                        todosLancamentos.append(Lancamento(id: id, nome: lancamento, dataOperacao: dataOperacao, tipoOperacao: tipoOperacao, valor: valor))
                                    }
                                }
                            }
                            DispatchQueue.main.sync {
                                sucesso(todosLancamentos)
                            }
                        }
                    } catch{
                        print("erro ao formatar retorno")
                    }
                }else{
                    print("erro ao fazer a consulta do extrato")
                }
            }
            
            tarefa.resume()
        }
    }
    
    func getSaldo(id: Int, sucesso:@escaping(_ saldo: Double) -> Void){
        
        var saldo: Double = 0
        if let url = URL(string: "http://api.rlmsolutions.com.br/estagio/trabalho/bancos/\(id)/extrato/20000101/22001231"){
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil{
                    guard let dadosRetorno = dados else {return}
                    do {
                        if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any]{
                            if let lancamentos = objetoJson["data"] as? Array<Any>{
                                for i in lancamentos{
                                    if let valor = i as? [String: Any]{
                                        guard let tipoOperacao = valor["tipo_operacao"] as? String else {return}
                                        guard let valor = valor["valor"] as? Double else {return}
                                        if tipoOperacao == "C" || tipoOperacao == "c"{
                                            saldo += valor
                                        }else{
                                            saldo += valor * -1
                                        }
                                    }
                                }
                            }
                            DispatchQueue.main.sync {
                                sucesso(saldo)
                            }
                        }
                    } catch{
                        print("erro ao formatar retorno")
                    }
                }else{
                    print("erro ao fazer a consulta do extrato")
                }
            }
            tarefa.resume()
        }
    }
}
