//
//  ProfileViewController.swift
//  hitch
//
//  Created by Shreeya Indap on 5/3/21.
//

import UIKit

protocol UserDelegate: AnyObject {
    func changeName(newName: String)
    func changeStatus(newStatus: String)
    func changeNumber(newNumber: String)
}

class ProfileViewController: UIViewController {
    
    private var nameLabel = UILabel()
    private var pfp = UIImageView()
    private var graphic = UIImageView()
    private var table = UIView()
    private var email = UILabel()
    private var status = UILabel()
    private var number = UILabel()
    private var userEmail = UILabel()
    private var userStatus = UILabel()
    private var userNumber = UILabel()
    private var editProfile = UIButton()
    private var background = UIImageView()
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        

        setUpViews()
        setUpConstraints()
        fillUserLabelValues()
//        NetworkManager.getUser(id: userEmail.text!) { user in
//            self.changeName(newName: user.name)
//            self.changeStatus(newStatus: user.status)
//        }

        // Do any additional setup after loading the view.
    }
   
    func setUpViews() {
        background.image = UIImage(named: "background2.png")
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.text = "Jane Doe"
        view.addSubview(nameLabel)
        
        pfp.layer.masksToBounds = false
        pfp.layer.cornerRadius = pfp.frame.height/2
        pfp.clipsToBounds = true
        pfp.image = UIImage(named: "defaultpfp.png")
        pfp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pfp)
        
        table.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 10
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        
        graphic.image = UIImage(named: "graphic1.png")
        graphic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphic)
        
        email.translatesAutoresizingMaskIntoConstraints = false
        email.font = UIFont.boldSystemFont(ofSize: 18)
        email.text = "Email"
        view.addSubview(email)
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.font = UIFont.boldSystemFont(ofSize: 18)
        status.text = "Status"
        view.addSubview(status)
        
        number.translatesAutoresizingMaskIntoConstraints = false
        number.font = UIFont.boldSystemFont(ofSize: 18)
        number.text = "Number"
        view.addSubview(number)
        
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        userEmail.font = UIFont.systemFont(ofSize: 18)
        userEmail.text = "si223@cornell.edu"
        view.addSubview(userEmail)
        
        userStatus.translatesAutoresizingMaskIntoConstraints = false
        userStatus.font = UIFont.systemFont(ofSize: 18)
        userStatus.text = "Student"
        view.addSubview(userStatus)
        
        userNumber.translatesAutoresizingMaskIntoConstraints = false
        userNumber.font = UIFont.systemFont(ofSize: 18)
        userNumber.text = "Not Provided"
        view.addSubview(userNumber)
        
        editProfile.translatesAutoresizingMaskIntoConstraints = false
        editProfile.setTitle("Edit Profile", for: .normal)
        editProfile.setTitleColor(UIColor.white, for: .normal)
        editProfile.clipsToBounds = true
        editProfile.layer.cornerRadius = 5
        editProfile.layer.borderColor = UIColor.lightGray.cgColor
        editProfile.layer.borderWidth = 1
        editProfile.backgroundColor = .lightGray
        editProfile.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        view.addSubview(editProfile)
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate ([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.bottomAnchor.constraint(equalTo: pfp.topAnchor, constant: 70),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate ([
            nameLabel.topAnchor.constraint(equalTo: pfp.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate ([
            pfp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            pfp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pfp.heightAnchor.constraint(equalToConstant: 135),
            pfp.widthAnchor.constraint(equalToConstant: 135)
        ])
        
        NSLayoutConstraint.activate ([
            graphic.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 200),
            graphic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            graphic.heightAnchor.constraint(equalToConstant: 450),
            graphic.widthAnchor.constraint(equalToConstant: 600)
        ])
        
        NSLayoutConstraint.activate ([
            table.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 35),
            table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            table.heightAnchor.constraint(equalToConstant: 160),
            table.widthAnchor.constraint(equalToConstant: 300),
        ])
        
        NSLayoutConstraint.activate ([
            email.topAnchor.constraint(equalTo: table.topAnchor, constant: 20),
            email.leadingAnchor.constraint(equalTo: table.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate ([
            status.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 27),
            status.leadingAnchor.constraint(equalTo: email.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate ([
            number.bottomAnchor.constraint(equalTo: table.bottomAnchor, constant: -20),
            number.leadingAnchor.constraint(equalTo: email.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate ([
            userEmail.topAnchor.constraint(equalTo: email.topAnchor),
            userEmail.trailingAnchor.constraint(equalTo: table.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate ([
            userStatus.topAnchor.constraint(equalTo: status.topAnchor),
            userStatus.trailingAnchor.constraint(equalTo: userEmail.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate ([
            userNumber.topAnchor.constraint(equalTo: number.topAnchor),
            userNumber.trailingAnchor.constraint(equalTo: userEmail.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            editProfile.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 35),
            editProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editProfile.heightAnchor.constraint(equalToConstant: 40),
            editProfile.widthAnchor.constraint(equalToConstant: 200),
        ])
        
    }
    
    @objc func editButtonPressed() {
        let pushViewController = EditProfileViewController()
        navigationController?.pushViewController(pushViewController, animated: true)
        pushViewController.delegate = self
    }
    
    func fillUserLabelValues() {
        if let userEmaill = userDefaults.string(forKey: "userEmail"),
           let userNamee = userDefaults.string(forKey: "userName"){
            nameLabel.text = userNamee
            userEmail.text = userEmaill
        }
    }

}

extension ProfileViewController: UserDelegate {
    func changeStatus(newStatus: String) {
        userStatus.text = newStatus
    }
    func changeName(newName: String){
        nameLabel.text = newName
    }
    func changeNumber(newNumber: String){
        userNumber.text = newNumber
    }
}

