//
//  CadastroService.swift
//  ProjetoBRQ
//
//  Created by Catia Miranda de Souza on 26/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import Foundation

class CadastroService{
    func acessarApi( sucesso:@escaping (_ bancos: Array<String> ) -> Void ) {
        
        var bancos: Array<String> = []
        
        if let url = URL(string: "http://api.rlmsolutions.com.br/estagio/trabalho/bancos") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil {
                    if let dadosRecebidos = dados {
                        do{
                            let objetoJson = try JSONSerialization.jsonObject(with: dadosRecebidos, options: [] ) as! [String:Any]
                            if let arrayBancos = objetoJson["data"] as? Array<Any> {
                                
                                let n = arrayBancos.count
                                for i in (0...n-1) {
                                    if let dicionario = arrayBancos[i] as? [String:Any] {
                                        if let banco = dicionario["nome"] as? String {
                                            bancos.append(banco)
                                        }
                                    }
                                }
                                DispatchQueue.main.sync {
                                    sucesso(bancos)
                                }
                            }
                        }catch {
                            print("Erro ao formatar")
                        }
                    }
                    
                } else {
                    print("Ouve um erro")
                }
            }
            tarefa.resume()
            
        }
    }
}
