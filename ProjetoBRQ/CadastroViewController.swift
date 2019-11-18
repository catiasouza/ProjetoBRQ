

import UIKit

class CadastroViewController: UIViewController{

    
     // MARK: - Variaveis/Constantes
    var conta: [String] = []
    var dropDown = dropDownBtn()
    
        // MARK: - Outlets
    
    @IBOutlet weak var viewAmbienteCadastro: UIView!
    @IBOutlet weak var botaoAdicionar: UIButton!
    @IBOutlet weak var viewCadastro: UIView!
    @IBAction func botaoAdicionarAcao(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func botaoVoltar(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configuraBordas()
        viewCadastro.layer.masksToBounds = true
        dropDown = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDown.setTitle("Selecione banco", for: .normal)
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        self.viewAmbienteCadastro.addSubview(dropDown)
        dropDown.centerXAnchor.constraint(equalTo: self.viewAmbienteCadastro.centerXAnchor).isActive = true
        dropDown.topAnchor.constraint(equalTo: self.viewAmbienteCadastro.topAnchor, constant: 10).isActive = true
        dropDown.widthAnchor.constraint(equalToConstant: 255).isActive = true
        dropDown.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dropDown.dropView.dropDownOptions = ["Bradesco", "Santander", "Itau", "NuBank", "Caixa Economica"]
       
                
    }
    func configuraBordas(){
        botaoAdicionar.layer.cornerRadius = 8
        botaoAdicionar.layer.masksToBounds = true
        viewCadastro.layer.cornerRadius = 8
    }
    
   
    
    
}

