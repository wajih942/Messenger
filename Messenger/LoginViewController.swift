//
//  ViewController.swift
//  Messenger
//
//  Created by wajih on 8/16/22.
//

import UIKit
//if we want to rename our view controller (right click and refactor ->rename)
class LoginViewController: UIViewController {
    // MARK: - IBOutlet
    //labels
    
    @IBOutlet weak var emailLabelOutlet: UILabel!
    
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    
    @IBOutlet weak var RepeatLabelOutlet: UILabel!
    
    @IBOutlet weak var signUpLabelOutlet: UILabel!
    //textFields
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var repeatTextField: UITextField!
    
    @IBOutlet weak var resendEmailButtonOutlet: UIButton!
    //buttons
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    //views
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    // MARK: - Vars
    var isLogin = true
    

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIFor(login: true)
        setupTextFieldDelegates()
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    @IBAction func forgetPasswordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        //if it is true it will change to false the opposite is true 
        isLogin.toggle()
    }
    
    // MARK: - Setup
    
    private func setupTextFieldDelegates(){
        //SELF MEANS THAT THE FUNCTION THAT WILL BE FIRED IS OUR VIEW
        emailTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        repeatTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
    }
    @objc func textFieldDidChangeSelection(_ textField:UITextField) {
        updatePlaceholderLabels(textField: textField)
    }
    
    
    // MARK: - Animations
    
    private func updateUIFor(login:Bool)  {
        loginButtonOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButtonOutlet.setTitle(login ? "SignUp" : "Login", for: .normal)
        signUpLabelOutlet.text = login ? "Don't have an account?" : "Have an account?"
        
        UIView.animate(withDuration:0.5){
            self.repeatTextField.isHidden = login
            self.RepeatLabelOutlet.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    private func updatePlaceholderLabels(textField: UITextField){
        switch textField {
        case emailTextField:
            //this line line similar to if and else code
            emailLabelOutlet.text = textField.hasText ? "Email" : ""
        case passwordTextField:
            //this line line similar to if and else code
            passwordLabelOutlet.text = textField.hasText ? "Password" : ""
            
        default:
            RepeatLabelOutlet.text = textField.hasText ? "Repeat Password" : ""
            
        }
    }
        
    
    
}

