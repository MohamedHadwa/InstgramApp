//
//  LoginViewController.swift
//  InstgramApp
//
//  Created by Mohamed Hadwa on 30/01/2023.
//

import UIKit
import Firebase

class LoginViewController:UIViewController{
    
    let logoContainerView :UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    let emailTextFieled : UITextField = {
        let tf = UITextField()
        tf .placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
        
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    @objc func handleLogin(){
        guard let email = emailTextFieled.text else{return}
        guard let password = passwordTextField.text else{return}
        Firebase.Auth.auth().signIn(withEmail: email, password: password , completion: {(user ,error)in
            if let err = error {
                print("failed to sign in with email" , err)
                return
            }
            print("Successfully logged bake in with user :" ,user?.user.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else{return}
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true)
            
        })
    }
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        let attributied = NSMutableAttributedString(string: "Don't have an account?  " ,attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor :UIColor.lightGray ])
        attributied.append(NSAttributedString(string: "Sign Up",attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor :UIColor.rgb(red: 17, green: 154, blue: 237) ]))
        button.setAttributedTitle(attributied, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    @objc func handleShowSignUp (){
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    @objc func handleTextInputChange (){
        let isFormValid = emailTextFieled.text?.isEmpty != true && passwordTextField.text?.isEmpty != true
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -20, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)
        setupInputFeilds()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    fileprivate func setupInputFeilds(){
        let stackView = UIStackView(arrangedSubviews: [emailTextFieled,passwordTextField,loginButton ])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView .spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0 , paddingRight: 40 ,width: 0 , height: 140)

    }
    
}
