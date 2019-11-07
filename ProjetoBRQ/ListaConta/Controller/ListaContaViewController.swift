//
//  ListaContaViewController.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit

class ListaContaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    

    //MARK: - Outlets
    
    @IBOutlet weak var collectionListaContas: UICollectionView!
    
    
    //MARK: - Variaveis
    
    let  teste = ["Teste1", "Teste2", "Teste3", "Teste4"]
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionListaContas.dataSource = self
        collectionListaContas.delegate = self
        
    }
    
    //MARK: - Métodos

    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teste.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("entrou")
        
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
        
        celula.celulaTexto.text = teste[ indexPath.row ]
        celula.celulaView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        
        celula.layer.cornerRadius = 10
        
        return celula
    }
    
    //configura o tamanho da exibição de cada celula
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let largura = collectionView.bounds.width
        let altura: CGFloat = 160 
        
        return CGSize(width: largura, height: altura)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alerta = UIAlertController(title: "Remover Conta", message: "Deseja remover esta conta?", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deletar = UIAlertAction(title: "Deletar", style: .destructive,handler: nil)
        
        alerta.addAction(cancelar)
        alerta.addAction(deletar)
        present(alerta, animated: true, completion: nil)
        
    }

    //MARK: - Navigation

}
