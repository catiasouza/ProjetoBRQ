//
//  ExtratoViewController.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class ExtratoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Variaveis/Constantes
    
    var listaLancamentos: Array<Lancamento> = []
    var saldoTotal: Double!
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewExtrato: UIView!
    @IBOutlet weak var somaSaldos: UILabel!
    
    //MARK: - Actions
    
    @IBAction func voltar(_ sender: Any) {
    }
    
    //MARK: - Métodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewExtrato.layer.cornerRadius = 8
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaLancamentos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celulaExtrato = tableView.dequeueReusableCell(withIdentifier: "celulaExtrato", for: indexPath) as! ExtratoTableViewCell
        
        let lancamentoAtual = listaLancamentos[indexPath.item]
        saldoTotal += lancamentoAtual.valor
        
        celulaExtrato.labelLancamentos.text = lancamentoAtual.nome
        celulaExtrato.labelDatas.text = lancamentoAtual.data
        celulaExtrato.labelValores.text = "R$ \(lancamentoAtual.valor)"
        self.somaSaldos.text = "R$ \(String(describing: saldoTotal))"
        
        return celulaExtrato
    }
    
    
    
}
