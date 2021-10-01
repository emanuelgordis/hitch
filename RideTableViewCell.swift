//
//  RideTableViewCell.swift
//  hitch
//
//  Created by Shreeya Indap on 5/5/21.
//

import UIKit

class RideTableViewCell: UITableViewCell {
    
    let label = UILabel()
    let time = UILabel()
    let driver = UILabel()
    private var pin = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setUpViews()
        setUpConstraints()
    }
    
    func setUpViews() {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        contentView.addSubview(label)
        
        pin.image = UIImage(named: "Vector.png")
        pin.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pin)
        
        time.translatesAutoresizingMaskIntoConstraints = false
        time.font = UIFont.systemFont(ofSize: 15)
        time.textColor = .darkGray
        contentView.addSubview(time)
        
        driver.translatesAutoresizingMaskIntoConstraints = false
        driver.font = UIFont.systemFont(ofSize: 15)
        driver.textColor = .darkGray
        contentView.addSubview(driver)
      
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            label.leadingAnchor.constraint(equalTo: pin.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate ([
            pin.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            pin.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pin.heightAnchor.constraint(equalToConstant: 35),
            pin.widthAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            driver.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            driver.leadingAnchor.constraint(equalTo: label.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            time.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            time.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
        
        
    }
    
    func configure(with rideObject: PastRide){
        label.text = rideObject.destination
        time.text = rideObject.time
        driver.text = "With: \(rideObject.driver)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
