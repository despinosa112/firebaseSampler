//
//  StorageController.swift
//  FirebaseSampler
//
//  Created by Daniel Espinosa on 3/12/18.
//  Copyright © 2018 Daniel Espinosa. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class StorageController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isHidden = true
        
        downloadImage()

    }


    @IBAction func selectImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.image.image = selectedImage.withRenderingMode(.alwaysOriginal)
            dismiss(animated: true, completion: nil)
            saveButton.isHidden = false
        }
    }
    
    
    
    
    @IBAction func saveProfileImage(_ sender: Any) {
        guard let selectedImage = image.image, let uid = Auth.auth().currentUser?.uid else { return }
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profileImages").child(uid).child("\(imageName).jpg")
        
        if let imageToUpload = UIImageJPEGRepresentation(selectedImage, 0.4) {
            storageRef.putData(imageToUpload, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "putData Error")
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    //Upload To Realtime Database
                    let rdDB = Database.database().reference()
                    rdDB.child("users").child(uid).child("profileImageUrl").setValue(profileImageUrl)
                    
                    //Upload to FireStore
                    let fsDB = Firestore.firestore()
                    fsDB.collection("users").document(uid).collection("profileData").addDocument(data: ["profileImageUrl" : profileImageUrl])
                }
            })
        }
    }
    
    
    func downloadImage(){
        //pulling URL from Firestore
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("profileData").getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "There was an error")
                return
            }
            
            if let documents = snapshot?.documents {
                for document in documents {
                    let data = document.data()
                    
                    if let profileImageUrl = data["profileImageUrl"]{
                        
                        guard let url = URL(string: profileImageUrl as! String) else { return }
                        
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, urlError) in
                            
                            if urlError != nil {
                                print(urlError?.localizedDescription ?? "URLSession error")
                                return
                            }
                            
                            DispatchQueue.main.async {
                                self.image.image = UIImage(data: data!)
                            }
                            
                        }).resume()
                    }
                }
            }
        }
    }
    
}

