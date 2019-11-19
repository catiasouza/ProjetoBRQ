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
        Lancamento(nome: "Samsung", data: "07 NOV", valor: -8999.99)
    ]
    var saldoTotal: Double = 0
    // dados recebidos da listaConta
    var apelidoRecebido: String?
    var id:Int?
    
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
    @IBAction func buscarExtrato(_ sender: Any) {
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
    
    func validaRangeDatas() -> Bool{
        guard let dataInicio = textDataInicio.text as? Date else {return false}
        guard let dataFim = textDataFim.text as? Date else {return false}
        
        if dataInicio <= dataFim{
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
        return listaLancamentos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celulaExtrato = tableView.dequeueReusableCell(withIdentifier: "celulaExtrato", for: indexPath) as! ExtratoTableViewCell
        
        let lancamentoAtual = listaLancamentos[indexPath.row]
        
        celulaExtrato.labelLancamentos.text = lancamentoAtual.nome
        celulaExtrato.labelDatas.text = lancamentoAtual.data
        celulaExtrato.labelValores.text = "R$ \(String(describing: lancamentoAtual.valor))"
        self.somaSaldos.text = "R$ \(String(describing: saldoTotal))"
                
        return celulaExtrato
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
