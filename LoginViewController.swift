//
//  LoginViewController.swift
//  hitch
//
//  Created by Shreeya Indap on 5/8/21.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private var logo = UIImageView()
    private var graphic = UIImageView()
    private var loginButton = UIButton()
    private var nameLabel = UILabel()
    private var enterName = UITextField()
    private var emailLabel = UILabel()
    private var enterEmail = UITextField()
    private var passLabel = UILabel()
    private var enterPass = UITextField()
    private var hitchLabel = UILabel()
    private var slogan = UILabel()
    private var background = UIImageView()
    private var checkResponse = false
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 209/255, green: 232/255, blue: 209/255, alpha: 1.0)
        
        setUpViews()
        setUpConstraints()

        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(settingsButtonPressed))
//        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        background.image = UIImage(named: "background3.png")
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        
        
        logo.image = UIImage(named: "hitchlogo.png")
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        graphic.image = UIImage(named: "graphic3.png")
        graphic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphic)
        
        loginButton.backgroundColor = UIColor(red: 123/255, green: 190/255, blue: 123/255, alpha: 1.0)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 15
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        view.addSubview(loginButton)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.textColor = .darkGray
        nameLabel.text = "Name"
        view.addSubview(nameLabel)
        
        enterName.translatesAutoresizingMaskIntoConstraints = false
        enterName.borderStyle = UITextField.BorderStyle.roundedRect
        enterName.keyboardType = UIKeyboardType.default
        enterName.backgroundColor = UIColor(red: 212/255, green: 243/255, blue: 215/255, alpha: 0.43)
        view.addSubview(enterName)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.systemFont(ofSize: 17)
        emailLabel.textColor = .darkGray
        emailLabel.text = "Email"
        view.addSubview(emailLabel)
        
        enterEmail.translatesAutoresizingMaskIntoConstraints = false
        enterEmail.borderStyle = UITextField.BorderStyle.roundedRect
        enterEmail.placeholder = "@cornell.edu"
        enterEmail.keyboardType = UIKeyboardType.default
        enterEmail.autocapitalizationType = .none
        enterEmail.backgroundColor = UIColor(red: 212/255, green: 243/255, blue: 215/255, alpha: 0.43)
        view.addSubview(enterEmail)
        
        passLabel.translatesAutoresizingMaskIntoConstraints = false
        passLabel.font = UIFont.systemFont(ofSize: 17)
        passLabel.textColor = .darkGray
        passLabel.text = "Password"
        view.addSubview(passLabel)
        
        enterPass.translatesAutoresizingMaskIntoConstraints = false
        enterPass.borderStyle = UITextField.BorderStyle.roundedRect
        enterPass.isSecureTextEntry = true
        enterPass.keyboardType = UIKeyboardType.default
        enterPass.backgroundColor = UIColor(red: 212/255, green: 243/255, blue: 215/255, alpha: 0.43)
        view.addSubview(enterPass)
        
        hitchLabel.translatesAutoresizingMaskIntoConstraints = false
        hitchLabel.font = UIFont.boldSystemFont(ofSize: 38)
        hitchLabel.text = "HITCH"
        view.addSubview(hitchLabel)

        slogan.translatesAutoresizingMaskIntoConstraints = false
        slogan.font = UIFont.systemFont(ofSize: 19)
        slogan.textColor = .lightGray
        slogan.text = "any person, any place"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        enterEmail.delegate = self
        enterPass.delegate = self
        
        view.addSubview(slogan)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate ([
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate ([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 126),
            logo.widthAnchor.constraint(equalToConstant: 126)
        ])
        
        NSLayoutConstraint.activate ([
            nameLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: enterName.leadingAnchor)
        ])
        
        
        NSLayoutConstraint.activate ([
            enterName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterName.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            enterName.heightAnchor.constraint(equalToConstant: 45),
            enterName.widthAnchor.constraint(equalToConstant: 295)
        ])
        
        NSLayoutConstraint.activate ([
            emailLabel.topAnchor.constraint(equalTo: enterName.bottomAnchor, constant: 15),
            emailLabel.leadingAnchor.constraint(equalTo: enterEmail.leadingAnchor)
        ])
        
        
        NSLayoutConstraint.activate ([
            enterEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterEmail.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            enterEmail.heightAnchor.constraint(equalToConstant: 45),
            enterEmail.widthAnchor.constraint(equalToConstant: 295)
        ])
        
        NSLayoutConstraint.activate ([
            passLabel.topAnchor.constraint(equalTo: enterEmail.bottomAnchor, constant: 15),
            passLabel.leadingAnchor.constraint(equalTo: enterEmail.leadingAnchor)
        ])
        
        
        NSLayoutConstraint.activate ([
            enterPass.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterPass.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 5),
            enterPass.heightAnchor.constraint(equalToConstant: 45),
            enterPass.widthAnchor.constraint(equalToConstant: 295)
        ])
        
        NSLayoutConstraint.activate ([
            graphic.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 170),
            graphic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            graphic.heightAnchor.constraint(equalToConstant: 500),
            graphic.widthAnchor.constraint(equalToConstant: 700)
        ])
        
        NSLayoutConstraint.activate ([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: enterPass.bottomAnchor, constant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 130)
        ])
        
        NSLayoutConstraint.activate ([
            hitchLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 100),
            hitchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate ([
            slogan.topAnchor.constraint(equalTo: hitchLabel.bottomAnchor),
            slogan.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
           
       }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func loginPressed() {
      
        if let userEmail = enterEmail.text,
           let userName = enterName.text,
           let userPassword = enterPass.text{
            userDefaults.set(userEmail, forKey: "userEmail")
            userDefaults.set(userName, forKey: "userName")
            NetworkManager.checkUser(email: userEmail) { result in
                if result == true {
                    NetworkManager.loginUser(email: userEmail, password: userPassword) { user in
                        self.userDefaults.set(user.session_token, forKey: "session_token")
                    }
                    DispatchQueue.main.async {
                        self.view.window?.rootViewController = ContainerViewController()
                        self.view.window?.makeKeyAndVisible()
                    }
                 
                }
                else {
                    let userLatt = self.userDefaults.float(forKey: "userLat")
                    let userLongg = self.userDefaults.float(forKey: "userLong")
                    NetworkManager.registerUser(email: userEmail, password: userPassword, name: userName, latitude: userLatt, longitude: userLongg) { user in
                        self.userDefaults.set(user.session_token, forKey: "session_token")
                    }
                }
            }
            
        }
    }
    
}
