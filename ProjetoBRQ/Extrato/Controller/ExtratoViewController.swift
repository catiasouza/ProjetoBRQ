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
    var apelidoRecebido: String?
    var id:Int?
    var listaLancamentos: [Lancamento] = []
    var validador = false
    var dataComeco = ""
    var dataFinal = ""
    
    //MARK: - Outlets
    
    @IBOutlet weak var iconeBRQ: UIImageView!
    @IBOutlet weak var botaoVoltar: UIButton!
    @IBOutlet weak var viewExtrato: UIView!
    @IBOutlet weak var somaSaldos: UILabel!
    @IBOutlet weak var labelExtratoApelido: UILabel!
    @IBOutlet weak var extratoTableView: UITableView!
    @IBOutlet weak var textDataInicio: UITextField!
    @IBOutlet weak var textDataFim: UITextField!
    @IBOutlet weak var botaoPesquisar: UIButton!
    
    
    //MARK: - Actions
    
    @IBAction func voltar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dataInicioEntrouFoco(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        toolbarPicker(picker: datePickerView)
        datePickerView.locale = Locale(identifier: "pt-BR")
        datePickerView.addTarget(self, action: #selector(exibeDataInicio), for: .valueChanged)
    }
    @IBAction func dataFimEntrouFoco(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        toolbarPicker(picker: datePickerView)
        datePickerView.locale = Locale(identifier: "pt-BR")
        datePickerView.addTarget(self, action: #selector(exibeDataFim), for: .valueChanged)
    }
    @IBAction func buscarExtrato(_ sender: UIButton) {
        if SetupModel().validaRangeDatas(de: textDataInicio.text, ate: textDataFim.text){
            guard let dataIni = textDataInicio.text else {return}
            guard let dataFin = textDataFim.text else {return}
            self.dataComeco = dataIni
            self.dataFinal = dataFin
            setaDados()
            recuperaSaldo()
            setaDados()
            recuperaSaldo()
            if listaLancamentos.count > 0{
                validador = true
                self.extratoTableView.reloadData()
                view.endEditing(true)
            }else{
                toastMessage("Nenhum lançamento encontrado")
                validador = false
                self.extratoTableView.reloadData()
                view.endEditing(true)
            }
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
        SetupModel().setupAccessibility(icone: iconeBRQ, labelApelido: labelExtratoApelido, dataInicio: textDataInicio, dataFim: textDataFim, buttonVoltar: botaoVoltar, buttonPesquisar: botaoPesquisar, saldo: somaSaldos)
        let dataAtual = Date()
        let dataMes = Date(timeIntervalSinceNow: -(60 * 60 * 24 * 30))
        let formatador = DateFormatter()
        formatador.dateFormat = "dd/MM/yyyy"
        textDataInicio.text = formatador.string(from: dataMes)
        textDataFim.text = formatador.string(from: dataAtual)
        dataComeco = formatador.string(from: dataMes)
        dataFinal = formatador.string(from: dataAtual)
        setaDados()
        recuperaSaldo()
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
    @objc func cancel(){
        textDataInicio.resignFirstResponder()
        textDataFim.resignFirstResponder()
    }
    func toolbarPicker(picker: UIDatePicker){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let botaoCancelar = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector( cancel ))
        toolbar.items = [botaoCancelar]
        textDataInicio.inputView = picker
        textDataInicio.inputAccessoryView = toolbar
        textDataFim.inputView = picker
        textDataFim.inputAccessoryView = toolbar
    }
    func setaDados(){
        guard let numeroId = id else { return }
        ExtratoService().retornaLancamentos(id: numeroId, dataInicio: dataComeco, dataFim: dataFinal) { (todosLancamentos) in
            self.listaLancamentos = todosLancamentos
            self.extratoTableView.reloadData()
        }
    }
    func recuperaSaldo(){
        guard let numeroId = id else { return }
        ExtratoService().getSaldo(id: numeroId) { (saldo) in
            self.saldoTotal = saldo
            self.somaSaldos.text = "R$" + SetupModel().formatarValor(valor: SetupModel().arredondaDouble(valor: self.saldoTotal))
        }
    }
    
    func draw(_ rect: CGRect) {
        setaDados()
        recuperaSaldo()
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
        return SetupModel().popularTableView(celula: celulaExtrato, lancamento: lancamentoAtual, validador: validador)
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
