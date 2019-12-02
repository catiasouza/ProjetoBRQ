

import Foundation

class Conta {
    
    let apelidoConta : String
    let banco: String
    let agencia : Int
    let contaNumero: Int
    let contaDigito: Int
    let id : Int
    
    init (apelidoConta: String, banco:String, agencia:Int, contaNumero:Int, contaDigito:Int, id:Int) {
        
        self.apelidoConta = apelidoConta
        self.banco = banco
        self.agencia = agencia
        self.contaNumero = contaNumero
        self.contaDigito = contaDigito
        self.id = id
        
    }
    
}
