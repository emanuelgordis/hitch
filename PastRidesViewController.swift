//
//  PastRidesViewController.swift
//  hitch
//
//  Created by Shreeya Indap on 5/3/21.
//

import UIKit

class PastRidesViewController: UIViewController {
    
    private var titleLabel = UILabel()
    let rideTableView = UITableView()
    private var graphic = UIImageView()
    let rideReuseIdentifier = "rideReuseIdentifier"
    var pastRides: [PastRide] = []
    //might have to change to an array of ride objects?
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        createDummyData()
        setUpViews()
        setUpConstraints()

        // Do any additional setup after loading the view.
    }
    
    func createDummyData() {
        
        //something with network manager needs to go here???
        
        let ride1 = PastRide(destination: "516 University Ave", time: "3:45", driver: "Richard Smith")
        let ride2 = PastRide(destination: "232 East Ave", time: "12:33", driver: "Daniel Lewis")
        let ride3 = PastRide(destination: "107 Hoy Road", time: "11:25", driver: "Jessica Brown")
        let ride4 = PastRide(destination: "519 Stewart Ave", time: "8:50", driver: "Daniel Lewis")
        pastRides = [ride4, ride2, ride3, ride1]
    }
    
    func setUpViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.text = "Ride History"
        view.addSubview(titleLabel)
        
        rideTableView.translatesAutoresizingMaskIntoConstraints = false
        rideTableView.delegate = self
        rideTableView.dataSource = self
        rideTableView.rowHeight = 100
        rideTableView.register(RideTableViewCell.self, forCellReuseIdentifier: rideReuseIdentifier)
        view.addSubview(rideTableView)
        
        graphic.image = UIImage(named: "graphic2.png")
        graphic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphic)
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate ([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22)
        ])
        
        NSLayoutConstraint.activate ([
            rideTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            rideTableView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            rideTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            rideTableView.bottomAnchor.constraint(equalTo: graphic.topAnchor)
        ])
        
        NSLayoutConstraint.activate ([
            graphic.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            graphic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            graphic.heightAnchor.constraint(equalToConstant: 300),
            graphic.widthAnchor.constraint(equalToConstant: 500)
        ])
        
    }
    

}

extension PastRidesViewController: UITableViewDelegate {
    
}

extension PastRidesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastRides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rideTableView.dequeueReusableCell(withIdentifier: rideReuseIdentifier, for: indexPath) as! RideTableViewCell
        let rideObject = pastRides[indexPath.row]
     //   cell.destinationLabel.text = ride.destination
        cell.configure(with: rideObject)
        return cell
    }
    
    
}
