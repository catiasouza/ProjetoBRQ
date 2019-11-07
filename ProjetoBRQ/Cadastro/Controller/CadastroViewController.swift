

import UIKit

class CadastroViewController: UIViewController, UIPickerViewDelegate {
    
    
    @IBOutlet weak var botaoAdicionar: UIButton!
    
    @IBAction func botaoAdicionarAcao(_ sender: UIButton) {
    }
    
    @IBOutlet weak var listaBanco: UIPickerView!
    
    @IBOutlet weak var listaAgencia: UIPickerView!
    
    @IBOutlet weak var viewCadastro: UIView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.botaoAdicionar.layer.cornerRadius = 12
        self.botaoAdicionar.layer.masksToBounds = true
        self.viewCadastro.layer.cornerRadius = 8
        
    }
    
    
    
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
