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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: Actions
    
    @IBAction func ButtonLogin(_ sender: UIButton) {
        
        let login = self.textFieldUser.text
        let senha = self.textFieldPassword.text
        let verificacao = try? NSRegularExpression(pattern: "(?=.[A-Z])(?=.[!@#$&])(?=.[0-9]).{6}$", options: .caseInsensitive)
        
        
        // Validacao do User e Password
        guard let login = self.textFieldUser.text, let senha = self.textFieldPassword.text else {
            
            // Alerta
            let alerta = UIAlertController(title: "Alerta", message: "Usuario ou senha invalidos", preferredStyle: .alert)
            
            let botaoOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alerta.addAction(botaoOk)
            
            present(alerta, animated: true, completion: nil)
            // Final alerta
            
            print("Login ou senha nulos")
            return
        }
        
        // urlLogin
        guard let urlLogin = URL(string: "https://bank-app-test.herokuapp.com/api/login") else {
            print("Não foi possível inicializar a URL a partir da string")
            return
        }
        
        //MARK: Primeira request
        
        var requestBoladona  = URLRequest(url: urlLogin)
        requestBoladona.httpMethod = "POST"
        requestBoladona.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestBoladona.httpBody = "user=\(login)&password=\(senha)".data(using: .utf8)
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: requestBoladona) { (data, response, error) in
            
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
            
            print("Awe caraca peguei o retorno: é o baguho é este aqui:\n \(resultado)")
            
            // Aqui vc toma decisão do que vai fazer com o resultado
            
            }.resume()
        
    }
    
    //MARK: Funcoes
    
    // funcao de validacao de email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}


