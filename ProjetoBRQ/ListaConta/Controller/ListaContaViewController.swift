//
//  ListaContaViewController.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

// Projeto oficial que vai subir pro git

import UIKit

class ListaContaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    

    //MARK: - Outlets
    
    @IBOutlet weak var collectionListaContas: UICollectionView!
    
    
    //MARK: - Variaveis
    
    var teste = ["Conta 1", "Conta 2", "Conta 3", "Conta 4", "Conta 5"]
    
    
    //MARK: - Exibicao
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionListaContas.dataSource = self
        collectionListaContas.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Métodos

    @objc func exibeAlerta(recognizer: UILongPressGestureRecognizer) {
        
        if (recognizer.state == UIGestureRecognizer.State.began) {
            let celula = recognizer.view  as! UICollectionViewCell
            
            if let indexPath = collectionListaContas.indexPath(for: celula) {
                let row = indexPath.row
                 
                AlertaRemoveConta(controller: self).alerta(controller: self) { (action) in
                    self.teste.remove(at: row)
                    self.collectionListaContas.reloadData()
                    print("Conta excluida com sucesso")
                }
            }
        }
    }
    
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teste.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
        
        celula.celulaTexto.text = teste[ indexPath.row ]
        celula.celulaView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector( exibeAlerta ) )
        celula.addGestureRecognizer(longPress)
        
        celula.layer.cornerRadius = 8
        
        return celula
    }
    
    //configura o tamanho da exibição de cada celula
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let largura = collectionView.bounds.width
        let altura: CGFloat = 160
        return CGSize(width: largura, height: altura)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "extratoID") as! ExtratoViewController
        present(controller, animated: true, completion: nil)
        
        
    }
    

    //MARK: - Navegação

    @IBAction func botaoAdicionar(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "cadastroID") as! CadastroViewController
        present(controller, animated: true, completion: nil)
        
    }
    
    //MARK: - Search Bar
    
}
