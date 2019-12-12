

import UIKit

class CadastroViewController: UIViewController, UITextFieldDelegate {
    
    
    // MARK: - Variaveis/Constantes
    
    var conta: [String] = []
    var dropDown = dropDownBtn()
    var delegate : ContaDelegate?
    var arrayApi: Array<Any>?
    var contaCD: ContaCD!
    
    // MARK: - Outlets
    
    @IBOutlet weak var textAgencia: UITextField!
    @IBOutlet weak var textConta: UITextField!
    @IBOutlet weak var textApelidoConta: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewAmbienteCadastro: UIView!
    @IBOutlet weak var botaoAdicionar: UIButton!
    @IBOutlet weak var viewCadastro: UIView!
    @IBOutlet weak var botaoVoltar: UIButton!
    @IBOutlet weak var textDig: UITextField!
    @IBOutlet weak var logoBRQ: UIImageView!
    
    @IBAction func botaoAdicionarAcao(_ sender: UIButton) {
        
        if textApelidoConta.text!.isEmpty || textAgencia.text!.isEmpty || textConta.text!.isEmpty || textDig.text!.isEmpty{
            self.toastMessage("Favor preencher todos campos!")
            return;
        }
           
        
        if let del = delegate {
            guard let apelido = textApelidoConta.text! as String? else { return }
            guard let agencia = Int(textAgencia.text!) else { return }
            guard let contaNumero = Int(textConta.text!) else { return }
            guard let banco = dropDown.titleLabel?.text else {return}
            guard let digito  = Int(textDig.text!) else { return }
            
            let id = validarEntrada(bancoDigitado: banco, agenciaDigitada: agencia, contaDigitada: contaNumero, digitoDigitado: digito)
            print(id)
            if id != 0{

                // Persistencia  De Dados
                if contaCD == nil{
                    contaCD = ContaCD(context: context)
                }

                contaCD.agencia = Int16(agencia)
                contaCD.apelidoConta = apelido
                contaCD.banco = banco
                contaCD.conta = Int16(contaNumero)
                contaCD.digito = Int16(digito)
                contaCD.id = Int16(id)

                do {
                    try context.save()
        
                } catch  {
                    print(error.localizedDescription)
                }

//                let conta = Conta(apelidoConta: apelido, banco: banco, agencia: agencia, contaNumero: contaNumero, contaDigito: 1, id: id)
//                del.adicionaConta(conta: conta)
                self.toastMessage("Conta adicionada com sucesso!")
                dismiss(animated: true, completion: nil)
            }else{
                self.toastMessage("Conta inexistente!")
            }
        }
    }
    
    @IBAction func botaoVoltar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Metodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessibilidadeCadastro()
        acessoAPI()
        criarListaBancos()
        self.textApelidoConta.delegate = self
        self.textAgencia.delegate = self
        self.textConta.delegate = self
        
        configuraBordas()
        viewCadastro.layer.masksToBounds = true
        dropDown = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDown.setTitle("Selecione banco", for: .normal)
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        self.viewAmbienteCadastro.addSubview(dropDown)
        dropDown.centerXAnchor.constraint(equalTo: self.viewAmbienteCadastro.centerXAnchor, constant: 6).isActive = true
        dropDown.topAnchor.constraint(equalTo: self.viewAmbienteCadastro.topAnchor, constant: 10).isActive = true
        dropDown.widthAnchor.constraint(equalTo: self.textAgencia.widthAnchor).isActive = true
        dropDown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dropDown.layer.cornerRadius = 8
        dropDown.layer.borderWidth = 0.5
        dropDown.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(scroll(notification: )), name: UIResponder.keyboardWillShowNotification ,object: nil)
        
    }
    
    func configuraBordas(){
        botaoAdicionar.layer.cornerRadius = 8
        botaoAdicionar.layer.masksToBounds = true
        viewCadastro.layer.cornerRadius = 8
        backView.layer.cornerRadius = 8
    }
    
    func criarListaBancos() {
        CadastroService().acessarApi{ (bancos) in
            self.dropDown.dropView.dropDownOptions = bancos
            self.dropDown.dropView.tableView.reloadData()
        }
    }
    func acessoAPI(){
        CadastroService().criarArrayAPI { (array) in
            print(array)
            self.arrayApi = array
        }
    }
    
    @objc func fecharTeclado () {
        view.endEditing(true)
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
    func validarEntrada(bancoDigitado: String, agenciaDigitada: Int, contaDigitada: Int, digitoDigitado:Int) -> Int{
        guard let n = self.arrayApi?.count else {return 0}
        
        for i in (0...n-1) {
            let array = arrayApi?[i] as? Array<Any>
            guard let bancoApi = array?[0] as? String else { return 0}
            guard let agenciaApi = array?[1]  as? Int else { return 0}
            guard let contaApi = array?[2] as? Int else { return 0}
            guard let digitoApi = array?[3] as? Int else { return 0 }
            
            if bancoApi == bancoDigitado && agenciaApi == agenciaDigitada && contaApi == contaDigitada && digitoApi == digitoDigitado {
                return array![4] as! Int
            }
        }
        return 0
    }
    func accessibilidadeCadastro(){
        
        botaoAdicionar.isAccessibilityElement = true
        botaoAdicionar.accessibilityLabel = "Adicione sua conta"
        botaoAdicionar.accessibilityTraits = .button
        
        botaoVoltar.isAccessibilityElement = true
        botaoVoltar.accessibilityLabel = "Voltar para a tela lista de contas"
        botaoVoltar.accessibilityTraits = .button
        
        logoBRQ.isAccessibilityElement = true
        logoBRQ.accessibilityLabel = "Logo da BRQ"
        logoBRQ.accessibilityTraits = .image

        textApelidoConta.isAccessibilityElement = true
        textApelidoConta.accessibilityLabel = "Digite um apelido para sua conta"
        textApelidoConta.accessibilityTraits = .none
    }
    
}


