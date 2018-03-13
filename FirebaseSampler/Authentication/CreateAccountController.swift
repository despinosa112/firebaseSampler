//
//  CreateAccountController.swift
//  FirebaseSampler
//
//  Created by Daniel Espinosa on 3/11/18.
//  Copyright © 2018 Daniel Espinosa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class CreateAccountController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createAccount(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription ?? "there was an error")
                return
            }
            
            guard let uid = user?.uid else { return }
            
            //Adding user to Realtime Datatbase
            let rtDB = Database.database().reference()
            rtDB.child("users").child(uid).child("email").setValue(email)
            
            
            //Adding user to Firestore Database
            let fsDB = Firestore.firestore()
            fsDB.collection("users").document(uid).setData(["email": email])
            
            
            self.performSegue(withIdentifier: "createAccountToHome", sender: nil)
        }
        
    }
}
