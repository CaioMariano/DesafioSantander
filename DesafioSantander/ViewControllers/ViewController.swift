//
//  ViewController.swift
//  DesafioSantander
//
//  Created by Caio Araujo Mariano on 26/10/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var textFieldUser: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    
    //MARK: Propriedades
    
    private var userAccount : UserAccount?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Actions
    
    @IBAction func ButtonLogin(_ sender: UIButton) {
        
        // Validacao do User e Password
        
        let user = self.textFieldUser.text
        let password = self.textFieldPassword.text
        
        
        //MARK: validacao Password
        
        if password != nil {
            
            // parametros da senha
            // 1 letras maiusculas
            // 1 caracter especial
            // 1 numeros na senha
            // 8 numeros, nem mais nem menos
            
            
            func isPasswordValid(_ password : String) -> Bool{
                let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8}$")
                return passwordTest.evaluate(with: password)
            }
            
            if isPasswordValid(password!) == true {
                
                print("Senha Correta")
                
            } else {
                
                // Alerta
                let alerta = UIAlertController(title: "Alerta", message: "senha invalida", preferredStyle: .alert)
                
                let botaoOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alerta.addAction(botaoOk)
                
                present(alerta, animated: true, completion: nil)
                // Final alerta
                
                print("Login ou senha nulos")
                return
                
                
            }
        }// Fechamento validacao Password
        
        //MARK: validacao User
        
        if user != nil {
            
            // Validacao e-mail
            func isValidEmail(testStr:String) -> Bool {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailTest.evaluate(with: testStr)
                
            }
            
            // Validacao Cpf
            func validateCpf(value: String) -> Bool {
                let cpfRegex = "^\\d{3}.\\d{3}.\\d{3}-\\d{2}$"
                let cpfTest = NSPredicate(format: "SELF MATCHES %@", cpfRegex)
                let result =  cpfTest.evaluate(with: value)
                return result
            }
            
            
            if isValidEmail(testStr: user!) == true || validateCpf(value: user!) == true  {
                
                print("Login Correto")
                
            }else {
                print("Login nulo ")
                let alerta = UIAlertController(title: "Alerta", message: "Usuário/ Senha Inválidos. Preencha novamente.", preferredStyle: .alert)
                
                let acaoOk = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alerta.addAction(acaoOk)
                
                self.present(alerta, animated: true, completion: nil)
                
                return
            }
            
            
        }// Fechamento validacao User
        
        
        
        
        // urlLogin
        guard let urlLogin = URL(string: "https://bank-app-test.herokuapp.com/api/login") else {
            print("Não foi possível inicializar a URL a partir da string")
            return
        }
        
        //MARK: Primeira request
        
        var primeiraRequest  = URLRequest(url: urlLogin)
        primeiraRequest.httpMethod = "POST"
        primeiraRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        primeiraRequest.httpBody = "user=\(user)&password=\(password)".data(using: .utf8)
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: primeiraRequest) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("Error: data nula")
                return
            }
            
            guard let resultado = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]  else {
                
                print("Error em converter para NSDictionary")
                return
            }
            
            print("Primeiro Retorno:\n \(resultado)")
            
            // Extraindo os dados de User Account
            
            if let userAccount = resultado!["userAccount"], let userAccountObjeto = userAccount as? [String : AnyObject],
                let name = userAccountObjeto ["name"] ,
                let agency = userAccountObjeto ["agency"],
                let balance = userAccountObjeto ["balance"],
                let bankAccount = userAccountObjeto ["bankAccount"],
                let userId = userAccountObjeto ["userId"]{
                
                print("Name: \(name)")
                print("agency: \(agency)")
                print("balance: \(balance)")
                print("bankAccount: \(bankAccount)")
                print("userId: \(userId)")
                
                // Conversões
                guard let nameString = name as? String, let agencyString = agency as? String, let bankAccountString = bankAccount as? String, let userIDInt = userId as? Int, let balanceDouble = balance as? Double else {
                    print("Erro na conversão")
                    return
                }
                
                self.userAccount = UserAccount(userId: userIDInt, name: nameString, bankAccount: bankAccountString, agency: agencyString, balance: balanceDouble)
                
                //DispatchQueue
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "irTela2", sender: nil)
                }
            }
            }.resume()
    }
    
    // MARK: - Metodo UIResponder
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    //MARK: Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Acima if")
        if (segue.identifier == "irTela2"){
            
            print("Entrou")
            
            guard let viewController2 = segue.destination as? Tela2ViewController else {return}
            
            guard let userAccount = self.userAccount else {
                print("User Account inválido")
                return
            }
            
            viewController2.nome = "\(userAccount.name)"
            viewController2.conta = "\(userAccount.bankAccount) / \(userAccount.agency)"
            viewController2.saldo = "R$\(userAccount.balance)"
            
            print("Passou aqui")
            print(" \(viewController2.nome)")
            
        }
    }// Fechamento Prepare segue
    
}


