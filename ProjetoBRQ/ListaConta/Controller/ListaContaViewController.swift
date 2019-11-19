//
//  ListaContaViewController.swift
//  ProjetoBRQ
//
//  Created by Marcello Pontes Domingos on 06/11/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

// Projeto oficial que vai subir pro git

import UIKit

class ListaContaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ContaDelegate {

    

    //MARK: - Outlets
    
    @IBOutlet weak var collectionListaContas: UICollectionView!
    
    
    //MARK: - Variaveis
    
    var contas = [ Conta(apelidoConta: "Conta Teste", banco: "BRQ", agencia: "01", contaNumero: "0001", contaDigito: "1", id: 1) ]
    
    
    //MARK: - Exibicao
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionListaContas.dataSource = self
        collectionListaContas.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionListaContas.reloadData()
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
                    self.contas.remove(at: row)
                    self.collectionListaContas.reloadData()
                    print("Conta excluida com sucesso")
                }
            }
        }
    }
    
    //MARK: - Delegate
    
    func adicionaConta(conta:Conta) {
        
        self.contas.append(conta)
        
    }
    
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPadrao", for: indexPath) as! ContaCollectionViewCell
        
        let contaSelecionada = contas[ indexPath.row ]
        
        celula.labelApelidoConta.text = contaSelecionada.apelidoConta
        celula.labelBanco.text = contaSelecionada.banco
        celula.labelAgencia.text = contaSelecionada.agencia
        celula.labelConta.text = contaSelecionada.contaNumero + "-" + contaSelecionada.contaDigito
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector( exibeAlerta ) )
        celula.addGestureRecognizer(longPress)
        
        celula.layer.cornerRadius = 8
        celula.celulaView.backgroundColor = UIColor.white
        
        return celula
    }
    
    //configura o tamanho da exibição de cada celula
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let largura = collectionView.bounds.width
        let altura: CGFloat = 160
        return CGSize(width: largura, height: altura)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let contaSelecionada = contas[ indexPath.row ]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "extratoID") as! ExtratoViewController
        
        controller.apelidoRecebido = contaSelecionada.apelidoConta
        controller.id = contaSelecionada.id
        
        present(controller, animated: true, completion: nil)
        
    }
    

    //MARK: - Navegação

    @IBAction func botaoAdicionar(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "cadastroID") as! CadastroViewController
        controller.delegate = self
        present(controller, animated: true, completion: nil)
        
    }
    
    //MARK: - Search Bar
    
}
