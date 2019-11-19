

import Foundation

class Conta {
    
    let apelidoConta : String
    let banco: String
    let agencia : String
    let contaNumero: String
    let contaDigito: String
    let id : Int
    
    init (apelidoConta: String, banco:String, agencia:String, contaNumero:String, contaDigito:String, id:Int) {
        
        self.apelidoConta = apelidoConta
        self.banco = banco
        self.agencia = agencia
        self.contaNumero = contaNumero
        self.contaDigito = contaDigito
        self.id = id
        
    }
    
}
