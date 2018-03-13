//
//  LoginController.swift
//  FirebaseSampler
//
//  Created by Daniel Espinosa on 3/11/18.
//  Copyright © 2018 Daniel Espinosa. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            self.performSegue(withIdentifier: "loginToHome", sender: nil)
        }
        
    }
    

}
