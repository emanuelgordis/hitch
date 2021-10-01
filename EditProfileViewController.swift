//
//  EditProfileViewController.swift
//  hitch
//
//  Created by Shreeya Indap on 5/10/21.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    let name = UILabel()
    let enterName = UITextField()
    let status = UILabel()
    let enterStatus = UITextField()
    let number = UILabel()
    let enterNumber = UITextField()
    let graphic = UIImageView()
    
    let userDefaults = UserDefaults.standard
    
    weak var delegate: UserDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Settings"
        
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        self.navigationItem.rightBarButtonItem  = save
        
        setUpViews()
        setUpConstraints()
    }
    
    @objc func saveButtonPressed() {
        delegate?.changeName(newName: enterName.text!)
        delegate?.changeStatus(newStatus: enterStatus.text!)
        delegate?.changeNumber(newNumber: enterNumber.text!)
        if let userEmaill = userDefaults.string(forKey: "userEmail"){
            NetworkManager.editUser(name: enterName.text!, session_token: "DONTKNOWYET", email: userEmaill) { user in
            }
        }
        navigationController?.popViewController(animated: true)
    }

    func setUpViews() {
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Name"
        name.font = UIFont.boldSystemFont(ofSize: 17)
        name.textColor = .lightGray
        view.addSubview(name)
        
        enterName.translatesAutoresizingMaskIntoConstraints = false
        enterName.borderStyle = UITextField.BorderStyle.roundedRect
        enterName.keyboardType = UIKeyboardType.default
        enterName.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        view.addSubview(enterName)
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Status"
        status.font = UIFont.boldSystemFont(ofSize: 17)
        status.textColor = .lightGray
        view.addSubview(status)
        
        enterStatus.translatesAutoresizingMaskIntoConstraints = false
        enterStatus.borderStyle = UITextField.BorderStyle.roundedRect
        enterStatus.keyboardType = UIKeyboardType.default
        enterStatus.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        view.addSubview(enterStatus)
        
        number.translatesAutoresizingMaskIntoConstraints = false
        number.text = "Phone Number"
        number.font = UIFont.boldSystemFont(ofSize: 17)
        number.textColor = .lightGray
        view.addSubview(number)
        
        enterNumber.translatesAutoresizingMaskIntoConstraints = false
        enterNumber.borderStyle = UITextField.BorderStyle.roundedRect
        enterNumber.keyboardType = UIKeyboardType.default
        enterNumber.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        view.addSubview(enterNumber)
        
        graphic.image = UIImage(named: "graphic2.png")
        graphic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphic)
        
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
            ])
        
        NSLayoutConstraint.activate([
            enterName.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            enterName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterName.widthAnchor.constraint(equalToConstant: 320),
            enterName.heightAnchor.constraint(equalToConstant: 45)
            ])
        
        NSLayoutConstraint.activate([
            status.topAnchor.constraint(equalTo: enterName.bottomAnchor, constant: 25),
            status.leadingAnchor.constraint(equalTo: name.leadingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            enterStatus.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 8),
            enterStatus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterStatus.widthAnchor.constraint(equalToConstant: 320),
            enterStatus.heightAnchor.constraint(equalToConstant: 45)
            ])
        
        NSLayoutConstraint.activate([
            number.topAnchor.constraint(equalTo: enterStatus.bottomAnchor, constant: 25),
            number.leadingAnchor.constraint(equalTo: name.leadingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            enterNumber.topAnchor.constraint(equalTo: number.bottomAnchor, constant: 8),
            enterNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterNumber.widthAnchor.constraint(equalToConstant: 320),
            enterNumber.heightAnchor.constraint(equalToConstant: 45)
            ])
        
        NSLayoutConstraint.activate ([
            graphic.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            graphic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            graphic.heightAnchor.constraint(equalToConstant: 300),
            graphic.widthAnchor.constraint(equalToConstant: 500)
        ])
        
    }
    
}
