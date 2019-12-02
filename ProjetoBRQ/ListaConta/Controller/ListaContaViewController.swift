//
//  ListaContaViewController.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

// Projeto oficial que vai subir pro git

import UIKit

class ListaContaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, ContaDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var collectionListaContas: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Variaveis
    
    var contas = [ Conta(apelidoConta: "Conta Teste", banco: "BRQ", agencia: 0734, contaNumero: 0001, contaDigito: 1, id: 1),
                   Conta(apelidoConta: "João da Silva", banco: "Itaú", agencia: 0312, contaNumero: 0203, contaDigito: 7, id: 6),
                   Conta(apelidoConta: "Robson", banco: "Santander", agencia: 0001, contaNumero: 9631, contaDigito: 0, id: 11)
                    ]
    var listaDeContas : Array<Conta> = []
    
    //MARK: - Exibicao
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionListaContas.dataSource = self
        collectionListaContas.delegate = self
        listaDeContas = contas
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        collectionListaContas.reloadData()
        listaDeContas = contas
    }
    
    //MARK: - Métodos

    @objc func exibeAlerta(recognizer: UILongPressGestureRecognizer) {
        
        if (recognizer.state == UIGestureRecognizer.State.began) {
            let celula = recognizer.view  as! UICollectionViewCell
            if let indexPath = collectionListaContas.indexPath(for: celula) {
                let row = indexPath.row
                 
                AlertaRemoveConta(controller: self).alerta(controller: self) { (action) in

                    self.contas.remove(at: row)
                    self.listaDeContas = self.contas
                    self.collectionListaContas.reloadData()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Delegate
    
    func adicionaConta(conta:Conta) {
        self.contas.append(conta)
    }
    
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listaDeContas.count != 0 {
            return listaDeContas.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if listaDeContas.count == 0{
            
            let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
            
            let mensagem = "Nenhuma conta encontrada, cadastre uma nova conta"
            celula.dadosDaConta(apelido: mensagem)
            celula.fixaLabels(labelFixaBanco: "", labelFixaAgencia: "", labelFixaConta: "", labelFixaSaldo: "")

            celula.configuraExibicaoCelula(celula: celula)

            return celula
        }
        
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
        let contaSelecionada = listaDeContas[ indexPath.row ]
        
        let apelido = contaSelecionada.apelidoConta
        let banco = contaSelecionada.banco
        let agencia = String(contaSelecionada.agencia)
        let contaNumero = "\(contaSelecionada.contaNumero)" + "-" + "\(contaSelecionada.contaDigito)"
        let saldo = "R$ 1.234,56"
        celula.dadosDaConta(apelido: apelido, banco: banco, agencia: agencia, conta: contaNumero, saldo: saldo)
        celula.fixaLabels()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector( exibeAlerta ) )
        celula.addGestureRecognizer(longPress)
        
        celula.configuraExibicaoCelula(celula: celula)
        
        return celula
    }
    
    //configura o tamanho da exibição de cada celula
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let largura = collectionView.bounds.width
        let altura: CGFloat = 160
        return CGSize(width: largura, height: altura)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if listaDeContas.count != 0 {
            let contaSelecionada = listaDeContas[ indexPath.row ]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "extratoID") as! ExtratoViewController
            controller.apelidoRecebido = contaSelecionada.apelidoConta
            controller.id = contaSelecionada.id
            present(controller, animated: true, completion: nil)
        } else {
            return
        }
    }
    

    //MARK: - Navegação

    @IBAction func botaoAdicionar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "cadastroID") as! CadastroViewController
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listaDeContas = contas
        if searchText != "" {
            let listaFiltrada = contas.filter { (conta) -> Bool in
                conta.apelidoConta.lowercased().contains(searchText.lowercased() )
            }
            listaDeContas = listaFiltrada
        }
        collectionListaContas.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}
