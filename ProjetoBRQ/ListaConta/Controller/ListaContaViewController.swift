//
//  ListaContaViewController.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import CoreData

class ListaContaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var collectionListaContas: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageLogoBRQ: UIImageView!
    @IBOutlet weak var labelSaldoTotal: UILabel!
    @IBOutlet weak var buttonAdicionar: UIButton!
    
    //MARK: - Variaveis
    
    var fetchResultController:NSFetchedResultsController<ContaCD>!
    var somaSaldos:Double = 0
    var arraySaldos: [Double] = []
    
    //MARK: - Exibicao
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfiguraListaConta().setAcessibility(imageLogoBRQ: imageLogoBRQ, labelSaldoTotal: labelSaldoTotal, buttonAdicionar: buttonAdicionar)
        collectionListaContas.dataSource = self
        collectionListaContas.delegate = self
        searchBar.delegate = self
        self.collectionListaContas.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recuperaContas()
        somaSaldosMetodo(contas: fetchResultController.fetchedObjects!)
    }
    
    //MARK: - Métodos

    @objc func exibeAlerta(recognizer: UILongPressGestureRecognizer) {

        if (recognizer.state == UIGestureRecognizer.State.began) {
            let celula = recognizer.view as! UICollectionViewCell
            if let indexPath = self.collectionListaContas.indexPath(for: celula) {
                let row = indexPath.row
                 
                AlertaRemoveConta(controller: self).alerta(controller: self) { (action) in

                    let conta = self.fetchResultController.fetchedObjects?[row]
                    self.context.delete(conta!)
                    self.recuperaContas()
                    self.collectionListaContas.reloadData()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func recuperaContas(filtro: String = "") {
        let fetchRequest:NSFetchRequest<ContaCD>  = ContaCD.fetchRequest()
        let sort = NSSortDescriptor(key: "data", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        if filtro != ""{
            let predicate = NSPredicate(format: "apelidoConta contains [c]%@", filtro)
            fetchRequest.predicate = predicate
        }
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            somaSaldosMetodo(contas: fetchResultController.fetchedObjects!)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func somaSaldosMetodo(contas:[ContaCD]){
        var saldoTotal:Double = 0
        for conta in contas {
            saldoTotal += conta.saldo
        }
        self.somaSaldos = saldoTotal
        labelSaldoTotal.text = "R$ \( SetupModel().formatarValor(valor: somaSaldos) )"
    }
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchResultController.fetchedObjects?.count != 0 {
            return fetchResultController.fetchedObjects!.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if fetchResultController.fetchedObjects?.count == 0 {
            let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
            
            let mensagem = "Nenhuma conta encontrada, cadastre uma nova conta"
            celula.dadosDaConta(apelido: mensagem, saldo: nil)
            celula.fixaLabels(labelFixaBanco: "", labelFixaAgencia: "", labelFixaConta: "", labelFixaSaldo: "")
            celula.configuraExibicaoCelula(celula: celula)

            return celula
        } else {
            
            let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
            let contaSelecionada = fetchResultController.fetchedObjects?[indexPath.row]
            ConfiguraListaConta().populaCollection(contaSelecionada: contaSelecionada!, celula: celula, indexPath: indexPath)
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector( exibeAlerta ) )
            celula.addGestureRecognizer(longPress)
            
            return celula
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if fetchResultController.fetchedObjects?.count != 0 {
            let contaSelecionada = fetchResultController.fetchedObjects?[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "extratoID") as! ExtratoViewController
            controller.apelidoRecebido = contaSelecionada?.apelidoConta
            controller.id = Int(contaSelecionada!.id)
            present(controller, animated: true, completion: nil)
        } else {
            return
        }
    }
    //MARK: - Navegação

    @IBAction func botaoAdicionar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "cadastroID") as! CadastroViewController
        present(controller, animated: true, completion: nil)
    }
    //MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        recuperaContas(filtro: searchText )
        collectionListaContas.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
