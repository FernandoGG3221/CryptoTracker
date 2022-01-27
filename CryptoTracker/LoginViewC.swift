//
//  LoginViewC.swift
//  CryptoTracker
//
//  Created by Fernando González González on 26/01/22.
//

import UIKit

class LoginViewC: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var lblTitleOption: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPass: UILabel!
    @IBOutlet weak var lblConfirmPass: UILabel!
    @IBOutlet weak var edtEmail: UITextField!
    @IBOutlet weak var edtPass: UITextField!
    @IBOutlet weak var edtConfirmPass: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var optionsLogin: UISegmentedControl!
    @IBOutlet weak var viewB: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configurations()
        
        if NetworkMonitor.shared.isConnected{
            print("Tienes internet")
            
        }else{
            print("No tienes internet ")
            
            internetConection()
        }
        
    }
    
    private func configurations(){
        configureOptions()
        configureElementsUI()
        configureTextField()
        configureKeyboard()
    }
    
    private func internetConection(){
        let message = UIAlertController(title: "Conexión a internet", message: "No tienes internet", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        message.addAction(btnOk)
        
        self.present(message, animated: true, completion: nil)
    }
    
    private func configureOptions(){
        
        //Configure type Keyboard
        edtEmail.textContentType = .emailAddress
        edtPass.isSecureTextEntry = true
        
        edtConfirmPass.isSecureTextEntry = true
        
        if optionsLogin.selectedSegmentIndex == 0{
            lblTitleOption.text = "Iniciar sesión"
            edtConfirmPass.isHidden = true
            lblConfirmPass.isHidden = true
        }else{
            lblTitleOption.text = "Registrar usuario"
            edtConfirmPass.isHidden = false
            lblConfirmPass.isHidden = false
        }
    }
    
    private func configureElementsUI(){
        btnSend.layer.cornerRadius = 15
        edtConfirmPass.alpha = 50
        viewB.layer.cornerRadius = 30
        
    }
    
    private func configureTextField(){
        edtEmail.delegate = self
        edtPass.delegate = self
        edtConfirmPass.delegate = self
    }
    
    private func clearEDT(){
        edtConfirmPass.text = ""
        edtPass.text = ""
        edtEmail.text = ""
    }
    
    private func configureKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //Deteccion de eventos del teclado
        NotificationCenter.default.addObserver(self, selector: #selector(changeKB(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeKB(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeKB(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer){
        edtEmail.resignFirstResponder()
        edtPass.resignFirstResponder()
        edtConfirmPass.resignFirstResponder()
    }
    
    @objc func changeKB(notification: Notification){
        let infoKeyboard = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let dimensionesKeyboard = infoKeyboard?.cgRectValue
        let hightKeyboard = dimensionesKeyboard?.height
        let nameNotification = notification.name.rawValue
        
        switch nameNotification{
        case "UIKeyboardWillHideNotification": view.frame.origin.y = 0
            
        case "UIKeyboardWillShowNotification":
            let altura = hightKeyboard! / 5
            
            if edtEmail.isFirstResponder || edtPass.isFirstResponder || edtConfirmPass.isFirstResponder{
                view.frame.origin.y = (-1 * altura) * 0.80
            }
            
            
        default: view.frame.origin.y = 0
        }
        
    }
    
    @IBAction func changeOptions(_ sender: Any) {
        configureOptions()
        clearEDT()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField")
        switch textField{
        case edtEmail: edtPass.becomeFirstResponder()
        case edtPass: edtConfirmPass.becomeFirstResponder()
        //case edtConfirmPass: .becomeFirstResponder()
        default: textField.becomeFirstResponder()
        }
        return true
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
}
