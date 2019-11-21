//
//  ExtratoViewController.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class ExtratoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variaveis/Constantes
    
    var listaLancamentos: [Lancamento] = [
        Lancamento(nome: "Mc Donalds", data: "06 NOV", valor: -21.99),
        Lancamento(nome: "Lojas Americanas", data: "06 NOV", valor: -75.50),
        Lancamento(nome: "Samsung", data: "07 NOV", valor: -8999.99),
        Lancamento(nome: "Açai Formosa", data: "08 NOV", valor: -24.99),
        Lancamento(nome: "Deposito Salario", data: "09 NOV", valor: 7500.00),
        Lancamento(nome: "Kanui", data: "10 NOV", valor: -8.99),
        Lancamento(nome: "Burguer King", data: "11 NOV", valor: -34.99),
        Lancamento(nome: "Netshoes", data: "12 NOV", valor: -20.75),
        Lancamento(nome: "Ali Express", data: "13 NOV", valor: -122.97),
        Lancamento(nome: "Tranferencia Itau", data: "14 NOV", valor: 21900.00),
        Lancamento(nome: "Estacionamento XPress", data: "15 NOV", valor: -5.00),
        Lancamento(nome: "Dell", data: "15 NOV", valor: -9999.99),
        Lancamento(nome: "Mc Donalds", data: "15 NOV", valor: -15.40),
        Lancamento(nome: "Japan House", data: "16 NOV", valor: -1.50),
        Lancamento(nome: "Carrefour", data: "16 NOV", valor: -25.99),
        Lancamento(nome: "Honda", data: "17 NOV", valor: -23.99),
        Lancamento(nome: "Wish", data: "17 NOV", valor: -13.50),
        Lancamento(nome: "Gearbest", data: "17 NOV", valor: -11.99),
        Lancamento(nome: "Banggod", data: "18 NOV", valor: -32.99),
        Lancamento(nome: "Lojas Americanas", data: "18 NOV", valor: -7.50),
        Lancamento(nome: "Chocolates Brasil", data: "18 NOV", valor: -9.99),
        Lancamento(nome: "Miniso", data: "19 NOV", valor: -1.99),
        Lancamento(nome: "Copias LTDA", data: "19 NOV", valor: -0.50),
        Lancamento(nome: "Fabrica de Bolos", data: "19 NOV", valor: -24.99),
    ]
    var saldoTotal: Double = 0
    // dados recebidos da listaConta
    var apelidoRecebido: String?
    var id:Int?
    
    var validador = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewExtrato: UIView!
    @IBOutlet weak var somaSaldos: UILabel!
    @IBOutlet weak var labelExtratoApelido: UILabel!
    @IBOutlet weak var extratoTableView: UITableView!
    @IBOutlet weak var textDataInicio: UITextField!
    @IBOutlet weak var textDataFim: UITextField!
    
    
    //MARK: - Actions
    
    @IBAction func voltar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dataInicioEntrouFoco(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(exibeDataInicio), for: .valueChanged)
    }
    @IBAction func dataFimEntrouFoco(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(exibeDataFim), for: .valueChanged)
    }
    @IBAction func buscarExtrato(_ sender: UIButton) {
        if validaRangeDatas(){
            validador = true
            self.extratoTableView.reloadData()
            view.endEditing(true)
        }else{
            toastMessage("Digite uma data valida")
            validador = false
            self.extratoTableView.reloadData()
            view.endEditing(true)
        }
    }
    
    
    //MARK: - Métodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extratoTableView.dataSource = self
        extratoTableView.delegate = self
        viewExtrato.layer.cornerRadius = 8
        labelExtratoApelido.text = apelidoRecebido
        
        for i in listaLancamentos {
            let valorLista = i
            saldoTotal += valorLista.valor
        }
    }
    
    @objc func exibeDataInicio(sender: UIDatePicker) {
        let formatador = DateFormatter()
        formatador.dateFormat = "dd/MM/yyyy"
        self.textDataInicio.text = formatador.string(from: sender.date)
    }
    
    @objc func exibeDataFim(sender: UIDatePicker) {
        let formatador = DateFormatter()
        formatador.dateFormat = "dd/MM/yyyy"
        self.textDataFim.text = formatador.string(from: sender.date)
    }
    
    func arredondaDouble(valor: Double)-> Double{
        let formato = String(2)+"f"
        return Double(String(format: "%."+formato, valor))!
    }
    
    func validaRangeDatas() -> Bool{
        
        //pegando datas dadas pelo usuario
        guard let dataInicioString = textDataInicio.text else {return false}
        guard let dataFimString = textDataFim.text else {return false}
        
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
    
    //MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        if validador{
            return listaLancamentos.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celulaExtrato = tableView.dequeueReusableCell(withIdentifier: "celulaExtrato", for: indexPath) as! ExtratoTableViewCell
        let lancamentoAtual = listaLancamentos[indexPath.row]
        
        if validador{
            celulaExtrato.labelLancamentos.text = lancamentoAtual.nome
            celulaExtrato.labelDatas.text = lancamentoAtual.data
            celulaExtrato.labelValores.text = "R$ \(String(describing: lancamentoAtual.valor))"
            self.somaSaldos.text = "R$ \(arredondaDouble(valor: saldoTotal))"
            return celulaExtrato
        }else{
            celulaExtrato.labelLancamentos.text = ""
            celulaExtrato.labelDatas.text = ""
            celulaExtrato.labelValores.text = ""
            self.somaSaldos.text = "R$ 0.00"
            return celulaExtrato
        }
        
    }
    
    // MARK: - Teclado
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textDataInicio.resignFirstResponder()
        textDataFim.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

