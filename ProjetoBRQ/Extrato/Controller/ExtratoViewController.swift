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
        Lancamento(nome: "Mc Donalds", data: "06-11-2019", valor: 21.99),
        Lancamento(nome: "Lojas Americanas", data: "06-11-2019", valor: 75.50),
        Lancamento(nome: "Samsung", data: "07-11-2019", valor: 8999.99)
    ]
    var saldoTotal: Double = 0
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewExtrato: UIView!
    @IBOutlet weak var somaSaldos: UILabel!
    @IBOutlet weak var labelExtratoApelido: UILabel!
    @IBOutlet weak var extratoTableView: UITableView!
    
    //MARK: - Actions
    
    @IBAction func voltar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Métodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extratoTableView.dataSource = self
        extratoTableView.delegate = self
        viewExtrato.layer.cornerRadius = 8
        labelExtratoApelido.text = "Apelido da conta"
        
        for i in listaLancamentos {
            let valorLista = i
            saldoTotal += valorLista.valor
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
}
