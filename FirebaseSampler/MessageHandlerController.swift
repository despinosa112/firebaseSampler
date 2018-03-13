//
//  MessageHandlerController.swift
//  FirebaseSampler
//
//  Created by Daniel Espinosa on 3/10/18.
//  Copyright © 2018 Daniel Espinosa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class MessageHandlerController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var homeController: HomeController?
    var isDisplayingRealTimeTableView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func send(_ sender: Any) {
        guard let text = textField.text, let uid = Auth.auth().currentUser?.uid else { return }
        
        if self.isDisplayingRealTimeTableView {
            setValueInRTTB(text: text, uid:uid)
        } else {
            setValueInFSTB(text: text, uid:uid)
        }
    }
    
    func setValueInRTTB(text: String, uid:String){
        let rtDB = Database.database().reference()
        
        rtDB.child("users").child(uid).child("messages").childByAutoId().setValue(text) { (error, rtDB) in
            guard let homecontroller = self.homeController else { return }
            homecontroller.realTimeTableView.fetchData()
            self.textField.text = ""
        }
    }
    
    
    func setValueInFSTB(text: String, uid:String){
        let fsDB = Firestore.firestore()
        
        fsDB.collection("users").document(uid).collection("messages").document().setData(["message" : text, "time" :FieldValue.serverTimestamp()], completion: { (error) in

            guard let homecontroller = self.homeController else { return }
            homecontroller.fireStoreTableView.fetchData()
            self.textField.text = ""
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
