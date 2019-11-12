

import UIKit

class CadastroViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
        // MARK: - Outlets
    
    @IBOutlet weak var pickerConta: UIPickerView!
    var conta: [String] = []
    
    @IBOutlet weak var pickerAgencia: UIPickerView!
    var agencia: [String] = []
    
    
    @IBOutlet weak var botaoAdicionar: UIButton!
    
    @IBAction func botaoAdicionarAcao(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func botaoVoltar(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var viewCadastro: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        configuraBordas()
        
        NotificationCenter.default.addObserver(self, selector: #selector(scroll(notification: )), name: UIResponder.keyboardWillShowNotification ,object: nil)
        
                conta.append("Itau")
                conta.append("Santander")
                conta.append("C6")
                conta.append("Nubank")
                conta.append("Safra")
                
                
                pickerConta.dataSource = self
                pickerConta.delegate = self

                
    }
    
    // MARK: - PickerView
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerAgencia{
            return conta.count
        }
        
        return conta.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->String{
        
        if pickerView == pickerAgencia{
            return conta[row]
            
        }
        
        return conta[row]
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow: Int, inComponent component: Int){
        
    }
    
    // MARK: - Métodos
    
    func configuraBordas(){
        
        botaoAdicionar.layer.cornerRadius = 8
        botaoAdicionar.layer.masksToBounds = true
        viewCadastro.layer.cornerRadius = 8
        viewCadastro.layer.masksToBounds = true
        
    }
    
    // MARK: - Scroll
    
    @objc func scroll(notification: Notification){
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height + 750)
    }
}

