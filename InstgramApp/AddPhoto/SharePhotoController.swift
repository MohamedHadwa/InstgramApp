//
//  SharePhotoController.swift
//  InstgramApp
//
//  Created by Mohamed Hadwa on 31/01/2023.
//

import UIKit
import Firebase

class SharePhotoController : UIViewController {
    var selectedImage : UIImage? {
        didSet{
            self.imageView.image = selectedImage
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setupImageAndTextViews()
    }
    @objc func handleShare (){
        guard let caption  = captionTextView.text ,!caption.isEmpty else{return}
        guard let image = selectedImage else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else{return}
        navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData,metadata: nil) { (metadata , err ) in
            
            if let err = err{
                self.navigationItem.rightBarButtonItem?.isEnabled = false

                print("failed to upload post image" , err)
                return
            }
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image:", imageUrl)
                
                self.saveToDatabaseWithUrl(imageUrl: imageUrl)
            })
        }
        
    }
    
    private func saveToDatabaseWithUrl(imageUrl:String) {
        guard let postImage = selectedImage else{return}
        guard let caption = captionTextView.text else{return}
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let userPostRef = Database.database().reference().child("posts").child(uid)
           let ref = userPostRef.childByAutoId()
        let values = ["imageUrl" :imageUrl , "caption" : caption, "imageWidth" : postImage.size.width , "imageHeight" : postImage.size.height ,"creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = false

                print("Failed to save post in Db" , err)
                return
            }
            print("succesfully saved post in Db" )
            self.dismiss(animated: true)
        }
    }
    let imageView :UIImageView = {
       let iv  = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let captionTextView : UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14 )
        return tv
    }()
    
    private func setupImageAndTextViews(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 84, height: 0)
        containerView.addSubview(captionTextView)
        captionTextView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
     
}
