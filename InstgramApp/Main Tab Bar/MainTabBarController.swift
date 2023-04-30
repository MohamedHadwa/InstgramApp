//
//  MainTabBarController.swift
//  InstgramApp
//
//  Created by Mohamed Hadwa on 24/01/2023.
//

import UIKit
import Firebase
class MainTabBarController: UITabBarController ,UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of:viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let photoNavController = UINavigationController(rootViewController: photoSelectorController)
            photoNavController.modalPresentationStyle = .fullScreen
      //      photoNavController.navigationBar.backgroundColor = .white
            present(photoNavController, animated: true)
            return false
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Firebase.Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true )
            }
            return
        }
        setupViewControllers()
        
    }
    
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        // home
        let homeNavController = templetNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage:UIImage(named: "home_selected")!)
        
        //search
        let searchNavController = templetNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage:UIImage(named: "search_selected")!)
        
        // like
        
        let likeNavController =  templetNavController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage:UIImage(named: "like_selected")!)
        
        //plus
        
        let plusNavController =  templetNavController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage:UIImage(named: "plus_unselected")!)
        
        //profile
                let userProfileNavController = templetNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!,rootViewController:UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        viewControllers = [homeNavController,searchNavController,plusNavController,likeNavController,userProfileNavController ]
        
        guard let items = tabBar.items else {return}
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    func templetNavController(unselectedImage:UIImage , selectedImage : UIImage ,rootViewController:UIViewController = UIViewController()) ->UINavigationController{
        let viewController = rootViewController
        let NavController = UINavigationController(rootViewController: viewController)
        NavController.tabBarItem.image = unselectedImage
        NavController.tabBarItem.selectedImage = selectedImage
        return  NavController
    }
  
    

}
