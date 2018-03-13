//
//  FireStoreTableView.swift
//  FirebaseSampler
//
//  Created by Daniel Espinosa on 3/10/18.
//  Copyright © 2018 Daniel Espinosa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FireStoreTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    
    var data = [String]()
    
    
    func fetchData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let fsDB = Firestore.firestore()
        
        fsDB.collection("users").document(uid).collection("messages").order(by: "time", descending: false).getDocuments { (snapshot, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "There was an error")
                return
            }
            
            if let documents = snapshot?.documents {
                
                var fetchedData = [String]()
                
                for document in documents {
                    let data = document.data()

                    if let text = data["message"]{
                        let textString = text as! String
                        fetchedData.append(textString)
                    }
                    
                    DispatchQueue.main.async {
                        self.data = fetchedData
                        self.reloadData()
                    }
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fsCell", for: indexPath) as! FSTableViewCell
        cell.label.text = data[indexPath.item]
        cell.label.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        label.backgroundColor = .red
        label.text = "Firestore Database"
        label.textAlignment = .center
        return label
    }

}
