

import UIKit

class CadastroViewController: UIViewController, UITextFieldDelegate {

    
     // MARK: - Variaveis/Constantes
    var conta: [String] = []
    var dropDown = dropDownBtn()
    var delegate : ContaDelegate?
    
        // MARK: - Outlets
    
    @IBOutlet weak var textAgencia: UITextField!
    @IBOutlet weak var textConta: UITextField!
    @IBOutlet weak var textApelidoConta: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewAmbienteCadastro: UIView!
    @IBOutlet weak var botaoAdicionar: UIButton!
    @IBOutlet weak var viewCadastro: UIView!
    
    
    @IBAction func botaoAdicionarAcao(_ sender: UIButton) {
        
        if textConta .text?.isEmpty ?? true {
            self.toastMessage("Favor preencher todos campos!")
            return;
        }else{
            print("Nao entrou")
        }
        
        //TOAST PARA CONTA ADICIONADA
        self.toastMessage("Conta adicionada com sucesso!")
       
        
        if let del = delegate {
            guard let apelido = textApelidoConta.text! as String? else { return }
            guard let agencia = textAgencia.text! as String? else { return }
            guard let contaNumero = textConta.text! as String? else { return }
            guard let banco = dropDown.titleLabel?.text else {return}
            let conta = Conta(apelidoConta: apelido, banco: banco, agencia: agencia, contaNumero: contaNumero, contaDigito: "1", id: 1)
            del.adicionaConta(conta: conta)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func botaoVoltar(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textApelidoConta.delegate = self
        self.textAgencia.delegate = self
        self.textConta.delegate = self
    
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
       
        NotificationCenter.default.addObserver(self, selector: #selector(scroll(notification: )), name: UIResponder.keyboardWillShowNotification ,object: nil)
        
    }
    func configuraBordas(){
        botaoAdicionar.layer.cornerRadius = 8
        botaoAdicionar.layer.masksToBounds = true
        viewCadastro.layer.cornerRadius = 8
        backView.layer.cornerRadius = 8
    }
    
    // MARK: - Scroll
    @objc func scroll(notification: Notification){
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height + 150)
    }
    // MARK: - Teclado
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textConta.resignFirstResponder()
        textAgencia.resignFirstResponder()
        textApelidoConta.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
      // MARK: - Validacao TextField
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let apelidoConta = textField.text ?? ""
        guard let stringApelido = Range(range, in: apelidoConta)else{
            return false
        }
        let updateApelidoConta = apelidoConta.replacingCharacters(in: stringApelido, with: string)
        return updateApelidoConta.count < 26
    }
}

