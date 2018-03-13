//
//  ViewController.swift
//  FirebaseSampler
//
//  Created by Daniel Espinosa on 3/10/18.
//  Copyright © 2018 Daniel Espinosa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class HomeController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var realTimeTableView: RealTimeTableView!
    @IBOutlet weak var fireStoreTableView: FireStoreTableView!
    
    var messageHandlerController: MessageHandlerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkIfLoggedIn()
        
        setupRealTimeTableView()
        setupFireStoreTableView()
        setupMessageHandlerController()

        self.navigationController?.navigationBar.isHidden = false
    }

    func checkIfLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            self.performSegue(withIdentifier: "segueLoginController", sender: nil)
        }
    }
    
    func setupRealTimeTableView(){
        realTimeTableView.isHidden = false
        realTimeTableView.delegate = realTimeTableView
        realTimeTableView.dataSource = realTimeTableView
        realTimeTableView.fetchData()
    }
    
    func setupFireStoreTableView(){
        fireStoreTableView.isHidden = true
        fireStoreTableView.delegate = fireStoreTableView
        fireStoreTableView.dataSource = fireStoreTableView
        fireStoreTableView.fetchData()
    }
    
    func setupMessageHandlerController(){
        guard let messageHandlerController = self.childViewControllers[0] as? MessageHandlerController else { return }
        self.messageHandlerController = messageHandlerController
        messageHandlerController.homeController = self
    }

    @IBAction func handleSegmentControl(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            realTimeTableView.isHidden = false
            fireStoreTableView.isHidden = true
            messageHandlerController?.isDisplayingRealTimeTableView = true
        } else {
            realTimeTableView.isHidden = true
            fireStoreTableView.isHidden = false
            messageHandlerController?.isDisplayingRealTimeTableView = false
        }
        
    }

    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "segueLoginController", sender: nil)
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    
}


