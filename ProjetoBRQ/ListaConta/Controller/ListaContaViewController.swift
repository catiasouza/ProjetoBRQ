//
//  ListaContaViewController.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

// Projeto oficial que vai subir pro git

import UIKit
import CoreData

class ListaContaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, ContaDelegate {

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
        setAcessibility()
        collectionListaContas.dataSource = self
        collectionListaContas.delegate = self
        searchBar.delegate = self
        self.collectionListaContas.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recuperaContas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        collectionListaContas.reloadData()
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
        fetchRequest.sortDescriptors = []
        
        if filtro != ""{
            let predicate = NSPredicate(format: "apelidoConta contains [c]%@", filtro)
            fetchRequest.predicate = predicate
        }
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            arraySaldos = recuperaSaldo()
            labelSaldoTotal.text = "R$ \( SetupModel().formatarValor(valor: somaSaldos) )"
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func recuperaSaldo() -> [Double] {
        somaSaldos = 0
        var saldos:[Double] = []
        let n = fetchResultController.fetchedObjects?.count as! Int
        if n != 0 {
            for i in (0..<n) {
                // pegar saldo
                let saldo = 1234.00
                saldos.append(saldo)
                somaSaldos += saldo
            }
            return saldos
        } else {
            return []
        }
    }
    
    private func setAcessibility() {
        
        imageLogoBRQ.isAccessibilityElement = true
        imageLogoBRQ.accessibilityLabel = "Logo da BRQ"
        imageLogoBRQ.accessibilityTraits = .image

        labelSaldoTotal.isAccessibilityElement = true
        labelSaldoTotal.accessibilityLabel = "Soma do saldo das contas em Reais"
        labelSaldoTotal.accessibilityTraits = .none
        
        buttonAdicionar.isAccessibilityElement = true
        buttonAdicionar.accessibilityLabel = "Botão para adicionar nova conta"
        buttonAdicionar.accessibilityTraits = .button
    }
    
    //MARK: - Delegate
    
    func adicionaConta(conta:Conta) {
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
            self.somaSaldos = 0
            labelSaldoTotal.text = "R$ \( SetupModel().formatarValor(valor: somaSaldos) )"
            let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
            
            let mensagem = "Nenhuma conta encontrada, cadastre uma nova conta"
            celula.dadosDaConta(apelido: mensagem, saldo: nil)
            celula.fixaLabels(labelFixaBanco: "", labelFixaAgencia: "", labelFixaConta: "", labelFixaSaldo: "")

            celula.configuraExibicaoCelula(celula: celula)

            return celula
        } else {
            
            let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
            
            let contaSelecionada = fetchResultController.fetchedObjects?[indexPath.row]
            
            let apelido = contaSelecionada?.apelidoConta as! String
            let banco = contaSelecionada?.banco as! String
            let agencia = String(describing: contaSelecionada!.agencia)
            let contaNumero = "\(String(describing: contaSelecionada!.conta))" + "-" + "\(String(describing: contaSelecionada!.digito))"
            let saldo = arraySaldos[ indexPath.row ]
            
            celula.dadosDaConta(apelido: apelido, banco: banco, agencia: agencia, conta: contaNumero, saldo: saldo)
            celula.fixaLabels()
            celula.setAccessibility()
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector( exibeAlerta ) )
            celula.addGestureRecognizer(longPress)
            
            celula.configuraExibicaoCelula(celula: celula)
            
            return celula
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let largura = collectionView.bounds.width
        let altura: CGFloat = 160
        return CGSize(width: largura, height: altura)
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
        controller.delegate = self
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

//MARK: - Extensoes

extension ListaContaViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            do {
                try context.save()
            } catch  {
                print(error.localizedDescription)
            }
        default:
            collectionListaContas.reloadData()
        }
    }
}
