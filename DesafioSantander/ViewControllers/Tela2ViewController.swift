//
//  Tela2ViewController.swift
//  DesafioSantander
//
//  Created by Caio Araujo Mariano on 26/10/2018.
//  Copyright © 2018 Caio Araujo Mariano. All rights reserved.
//

import UIKit

class Tela2ViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var labelNome: UILabel!
    
    @IBOutlet weak var labelConta: UILabel!
    
    @IBOutlet weak var labelSaldo: UILabel!
    
    //MARK: Propriedades
    
    var nome : String?
    var conta : String?
    var saldo : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
         requestDaTela2()
        
        self.labelSaldo.text = saldo
        self.labelNome.text = nome
        self.labelConta.text = conta
        
       
    }
    
    //MARK: Actions
    
    @IBAction func ButtonVoltar(_ sender: UIButton) {
        
    }
    
    //MARK: Funcoes

    //MARK: Segunda request
    
    func requestDaTela2() {
    
    guard let urlTela2 = URL(string: "https://bank-app-test.herokuapp.com/api/statements/1") else {
    print("Não foi possível inicializar a URL a partir da string")
    return
    }
    
    var segundaRequest  = URLRequest(url: urlTela2)
    segundaRequest.httpMethod = "GET"
    segundaRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let session2 = URLSession(configuration: .default)
    
    session2.dataTask(with: segundaRequest) { (data, response, error) in
    
    if let error = error {
    print("Error\(error)")
    return
    }
    
    guard let data = data else {
    print("Data nula")
    return
    }
    
    guard let resultado = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]  else {
    
    print("Erro ao converter o resultado em um NSDictionary")
    return
    }
    
    print("retorno da segunda request:\n \(resultado)")
    
    
    
//        if let statementList = resultado!["statementList"], let statementListObjeto = statementList as? Dictionary<String, AnyObject>,
//            let date = statementListObjeto ["date"] ,
//            let desc = statementListObjeto ["desc"],
//            let title = statementListObjeto ["title"],
//            let value = statementListObjeto ["value"]{
//
//            print("Title: \(title)")
//
//        }
    }.resume()
    
    }
}



