//
//  UserProfileController.swift
//  InstgramApp
//
//  Created by Mohamed Hadwa on 24/01/2023.
//

import UIKit
import Firebase


class UserProfileController: UICollectionViewController ,UICollectionViewDelegateFlowLayout {
 
    let cellId = "cellId"
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
       
        setupLogOutButton()
    
       // fetchPosts()
        fetchOrderdPosts()
        
    }
    
    private func fetchOrderdPosts (){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded , with: {( snapshot)  in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            let post  = Post(dictionary: dictionaries)
            self.posts.append(post)
            self.collectionView.reloadData()
        }) {(err) in
            print("failed to fetch Orderd posts" ,err)
            
        }
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            })
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
        
    }
    
    
    
    func setupLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action:#selector(handleLogOut))
    }
    @objc func handleLogOut(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
          try Auth.auth().signOut()
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
                
            }catch let signOutErr {
                print("failed to sign Out ", signOutErr)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user

        return header
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 2)/3, height: (view.frame.width - 2)/3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    var user :User?
    fileprivate func fetchUser(){
        guard let uid = Firebase.Auth.auth().currentUser?.uid else {return}
        Firebase.Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value ,with: { (snapshot) in
            print(snapshot.value ?? "")
            guard   let dictionary = snapshot.value as? [String:Any] else {return}
            self.user = User(dictionary: dictionary)

            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
        }){(err) in
            print("Failed to fetch user :" ,err)
        }
    }

}
struct User {
    let username : String
    let profileImageUrl :String
    init(dictionary : [String:Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
