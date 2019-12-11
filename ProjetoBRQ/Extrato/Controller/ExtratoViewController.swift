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
        setupAccessibility()
        setaDados()
        recuperaSaldo()
    }
    
    private func setupAccessibility(){
        iconeBRQ.isAccessibilityElement = true
        iconeBRQ.accessibilityLabel = "Logo da BRQ"
        iconeBRQ.accessibilityTraits = .image
        
        labelExtratoApelido.isAccessibilityElement = true
        labelExtratoApelido.accessibilityLabel = "Apelido da conta" + labelExtratoApelido.text!
        labelExtratoApelido.accessibilityTraits = .none
        
        textDataInicio.isAccessibilityElement = true
        textDataInicio.accessibilityLabel = "Data de início da busca"
        textDataInicio.accessibilityTraits = .staticText
        
        textDataFim.isAccessibilityElement = true
        textDataFim.accessibilityLabel = "Data de fim da busca"
        textDataFim.accessibilityTraits = .staticText
        
        botaoVoltar.isAccessibilityElement = true
        botaoVoltar.accessibilityLabel = "Botão de voltar para tela de lista de contas"
        botaoVoltar.accessibilityTraits = .staticText
        
        botaoPesquisar.isAccessibilityElement = true
        botaoPesquisar.accessibilityLabel = "Botão de busca pelas datas selecionadas"
        botaoPesquisar.accessibilityTraits = .staticText
        
        somaSaldos.isAccessibilityElement = true
        somaSaldos.accessibilityLabel = "Saldo atual da conta " + somaSaldos.text!
        somaSaldos.accessibilityTraits = .none
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
            celulaExtrato.labelDatas.text = SetupModel().formattedDateFromString(dateString: lancamentoAtual.dataOperacao, withFormat: "dd-MMM")?.uppercased()
            let valorFinal = SetupModel().formatarValor(valor: SetupModel().arredondaDouble(valor: lancamentoAtual.valor))
            if lancamentoAtual.tipoOperacao == "C" || lancamentoAtual.tipoOperacao == "c"{
                celulaExtrato.labelValores.text = valorFinal
                
                celulaExtrato.labelValores.isAccessibilityElement = true
                celulaExtrato.labelValores.accessibilityLabel = "Valor do lançamento" + "R$" + valorFinal
                celulaExtrato.labelValores.accessibilityTraits = .none
            }else{
                celulaExtrato.labelValores.text = "-\(valorFinal)"
                
                celulaExtrato.labelValores.isAccessibilityElement = true
                celulaExtrato.labelValores.accessibilityLabel = "Valor do lançamento" + "R$" + valorFinal + "negativos"
                celulaExtrato.labelValores.accessibilityTraits = .none
            }
            self.somaSaldos.text = "R$" + SetupModel().formatarValor(valor: SetupModel().arredondaDouble(valor: saldoTotal))
            
            celulaExtrato.labelDatas.isAccessibilityElement = true
            celulaExtrato.labelDatas.accessibilityLabel = "Data do lançamento" + celulaExtrato.labelDatas.text!
            celulaExtrato.labelDatas.accessibilityTraits = .none
            celulaExtrato.labelLancamentos.isAccessibilityElement = true
            celulaExtrato.labelLancamentos.accessibilityLabel = "Descrição do lançamento" + celulaExtrato.labelLancamentos.text!
            celulaExtrato.labelLancamentos.accessibilityTraits = .none
            
            
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
