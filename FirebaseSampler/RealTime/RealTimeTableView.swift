//
//  RealTimeTableView.swift
//  FirebaseSampler
//
//  Created by Daniel Espinosa on 3/10/18.
//  Copyright © 2018 Daniel Espinosa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RealTimeTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var data = [String]()
    
    
    func fetchData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let rtDB = Database.database().reference()
        rtDB.child("users").child(uid).child("messages").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]{
                
                var fetchedData = [String]()
                
                for (_, value) in dictionary {
                    fetchedData.append(value as! String)
                }
                  
                DispatchQueue.main.async {
                    self.data = fetchedData
                    self.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rtCell", for: indexPath) as! RTTableViewCell
        cell.label.text = data[indexPath.item]
        cell.label.textColor = .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        label.backgroundColor = .blue
        label.text = "Realtime Database"
        label.textAlignment = .center
        return label
    }


}
