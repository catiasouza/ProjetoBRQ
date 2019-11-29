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
    
    var saldoTotal: Double = 0
    // dados recebidos da listaConta
    var apelidoRecebido: String?
    var id:Int?
    
    var listaLancamentos: [Lancamento] = []
    
    var validador = false
    
    var dataComeco = ""
    var dataFinal = ""
    
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
        if Validacoes().validaRangeDatas(de: textDataInicio.text, ate: textDataFim.text){
            
            guard let dataIni = textDataInicio.text else {return}
            guard let dataFin = textDataFim.text else {return}
            self.dataComeco = dataIni
            self.dataFinal = dataFin
            setaDados()
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
    
    func setaDados(){
        guard let numeroId = id else { return }
        ExtratoService().retornaLancamentos(id: numeroId, dataInicio: dataComeco, dataFim: dataFinal) { (todosLancamentos) in
            self.listaLancamentos = todosLancamentos
            self.extratoTableView.reloadData()
        }
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
    
    func draw(_ rect: CGRect) {
        extratoTableView.reloadData()
    }
    
    //MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if validador{
            return listaLancamentos.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celulaExtrato = tableView.dequeueReusableCell(withIdentifier: "celulaExtrato", for: indexPath) as! ExtratoTableViewCell
        let lancamentoAtual = listaLancamentos[indexPath.row]
        
        if validador{
            celulaExtrato.labelLancamentos.text = lancamentoAtual.nome
            celulaExtrato.labelDatas.text = ConverterDatas().formattedDateFromString(dateString: lancamentoAtual.dataOperacao, withFormat: "dd-MMM")
            let valorFinal = formatarValor(valor: arredondaDouble(valor: lancamentoAtual.valor))
            if lancamentoAtual.tipoOperacao == "C" || lancamentoAtual.tipoOperacao == "c"{
                celulaExtrato.labelValores.text = valorFinal
            }else{
                celulaExtrato.labelValores.text = "-\(valorFinal)"
            }
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
