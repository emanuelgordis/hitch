//
//  ViewController.swift
//  hitch
//
//  Created by Emanuel on 5/1/21.
//

import MapKit
import CoreLocation
import UIKit

protocol ViewControllerDelegate: AnyObject{
    func settingsButtonPressed()
}

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, MKMapViewDelegate {
    
    weak var delegate: ViewControllerDelegate?
    
    private var options = UIView()
    private var optionsYOrigin = CGFloat()
    private var optionsExpanded = false
    private var activeRide = false
    private var destinationEntry = UITextField()
    private var timeEntry = UITextField()
    private var roundtripLabel = UILabel()
    private var roundtripButton = UIButton()
    private var scheduleButton = UIButton()
    private var editRideButton = UIButton()
    private var rideDetailsLabel = UILabel()
    private var etaLabel = UILabel()
    private var pickupLabel = UILabel()
    private var destLabel = UILabel()
    private var driverLabel = UILabel()
    private var priceLabel = UILabel()
    private var background = UIImageView()
    private var eta = UILabel()
    private var pickup = UILabel()
    private var dest = UILabel()
    private var fontSize = CGFloat()
    private var driver = UILabel()
    private var price = UILabel()
    private var locationText = ""
    let topDarkLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    let userDefaults = UserDefaults.standard
    
    var newRide: Ride?
    var destinationCoordinates: CLLocation?
    var topConstraint = NSLayoutConstraint()
    var backgroundConstraint = NSLayoutConstraint()
    var rideDetailSideConstraint = NSLayoutConstraint()
    var rideDetailTopConstraint = NSLayoutConstraint()
    lazy var roundTripSwitch: UISwitch = {
        let roundTripSwitch = UISwitch()
        return roundTripSwitch
    }()
    @IBOutlet  var mapView: MKMapView!
    var locationManager: CLLocationManager!
    

    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        //self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(settingsButtonPressed))
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //title = "Home"
        // navigationController?.navigationBar.prefersLargeTitles = true
        mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:  view.frame.height)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(mapView)
      //  checkLocationServices()
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        
        
       
//        let location = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! ,longitude: (locationManager.location?.coordinate.longitude)!)
//        let location = CLLocationCoordinate2D(latitude: (42.444161954209704),
//                                              longitude: -76.48193325732547)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
    
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: currentLocation(), span: span)
        mapView.setRegion(region, animated: true)
        
        userDefaults.set(currentLocation().latitude, forKey: "userLat")
        userDefaults.set(currentLocation().longitude, forKey: "userLong")
        
        setupViews()
        setUpConstraints()
        currentLocality()
        mapView.delegate = self
        
        
    }
    
    //Return CLLocationCoordinate2D object with current location. Longitude and latitude can be obtained
    //with currentLocation().longitude...
    func currentLocation() -> CLLocationCoordinate2D{
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let location = CLLocationCoordinate2D(latitude: (42.444161954209704),
                                              longitude: -76.48193325732547)
        return location
    }
    
    
    //Hide the keyboard when return key is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Find the name of users current location 
    func currentLocality() {
        let geocoder = CLGeocoder()
            if let lastLocation = self.locationManager.location {
                    geocoder.reverseGeocodeLocation(lastLocation,
                                completionHandler: { (places, error) in
                        if error == nil {
                            let firstPlace = places?.first
                            self.locationText = (firstPlace?.name!)!
                        }
                        else {}})
                }
                else {}
    }
   
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                //for getting just one route
                if let route = unwrappedResponse.routes.first {
                    //show on map
                    self.mapView.addOverlay(route.polyline)
                    //set the map area to show the route
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 250.0, right: 20.0), animated: true)
                }

            }
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
         renderer.strokeColor = UIColor.systemBlue
         renderer.lineWidth = 5.0
         return renderer
    }
    
    
    //Confirm location was updated and print confirmation.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
               print("Found user's location: \(location)")
           }
       }
    //Print location update failure message
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
    
    //Hide ride creation UI, truthify activeRide, and post a ride request to backend.
    func rideStarted(coords: CLLocation){
        activeRide = true
        editRideButton.isHidden = true
        destinationEntry.isHidden = true
        timeEntry.isHidden = true
        roundtripLabel.isHidden = true
        roundTripSwitch.isHidden = true
        scheduleButton.setTitle("End Ride", for: .normal)
        scheduleButton.backgroundColor = .red
        rideDetailsLabel.isHidden = false
        etaLabel.isHidden = false
        pickupLabel.isHidden = false
        destLabel.isHidden = false
        driverLabel.isHidden = false
        priceLabel.isHidden = false
        eta.isHidden = false
        pickup.isHidden = false
        pickup.text = locationText
        dest.isHidden = false
        driver.isHidden = false
        price.isHidden = false
        topDarkLine.isHidden = false
        
        var destinationCoords = CLLocationCoordinate2D(latitude: 42.44476652441194, longitude: -76.48891988172505)
        var loc = currentLocation()
        showRouteOnMap(pickupCoordinate: loc, destinationCoordinate: destinationCoords)
        
        if let userEmaill = userDefaults.string(forKey: "userEmail"){
            NetworkManager.createRide(end_lat: (Float)(coords.coordinate.latitude), end_long: (Float)(coords.coordinate.longitude), email: userEmaill, session_token: "DONTKNOWYET") { ride in
//                self.newRide = Ride(id: ride.id, name: ride.name, startingLongitude: 42.444161954209704, startingLatitude: -76.48193325732547, destinationLongitude: ride.destinationLongitude, destinationLatitude: ride.destinationLatitude, roundTrip: self.roundTripSwitch.isOn)
                
                //changing the actual ride class so this is gonna glitch out
            }
        }
    }
    
    //Animate UI to react to a keyboardWillShowNotification.
    @objc func keyboardWillShow(sender: Notification){
        if options.frame.minY < 500 {return}
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
        let  keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3){
            self.topConstraint.constant = self.topConstraint.constant - keyboardHeight
            self.options.layoutIfNeeded()
        }

    }
    
    //Animate UI to react to a keyboardWillHideNotification.
    @objc func keyboardDidHide(sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
        let  keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3){
            self.topConstraint.constant = self.topConstraint.constant + keyboardHeight
            self.options.layoutIfNeeded()
        }
    }
    
    //Enable ride fields and revert to original UI.
    @objc func editButtonPressed() {
        activeRide = false
        destinationEntry.isEnabled = true
        destinationEntry.textColor = .black
        timeEntry.isEnabled = true
        timeEntry.textColor = .black
        roundtripLabel.isEnabled = true
        roundTripSwitch.isEnabled = true
        scheduleButton.backgroundColor = .lightGray
        scheduleButton.setTitle("Schedule Ride", for: .normal)
        editRideButton.isHidden = true
    }
    
    // Either change UI to confirmation screen or change UI to reflect active ride depending on the state
    //of scheduleButton.
    @objc func scheduleButtonPressed() {
        if scheduleButton.titleLabel?.text == "Schedule Ride"{
        guard destinationEntry.hasText && timeEntry.hasText else{return}
        let destinationAddress = destinationEntry.text
            let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(destinationAddress!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                return}
            self.destinationEntry.isEnabled = false
            self.destinationEntry.textColor = .gray
            self.timeEntry.isEnabled = false
            self.timeEntry.textColor = .gray
            self.roundtripLabel.isEnabled = false
            self.roundTripSwitch.isEnabled = false
            self.scheduleButton.backgroundColor = UIColor.init(red: 129/255, green: 208/255, blue: 137/255, alpha: 1)
            
            self.scheduleButton.setTitle("Confirm", for: .normal)
            self.editRideButton.isHidden = false
            self.dest.text = self.destinationEntry.text
            self.destinationCoordinates = location
            }
            
        }
        
        
        else if scheduleButton.titleLabel?.text == "Confirm"{
            
            self.rideStarted(coords: destinationCoordinates!)
        }
        
        else {
            mapView.overlays.forEach {
                if !($0 is MKUserLocation) {
                    mapView.removeOverlay($0)
                }
            }
            translateOptions(optionsConstant: 0, backgroundConstant: 0)
            activeRide = false
            rideDetailsLabel.isHidden = true
            etaLabel.isHidden = true
            pickupLabel.isHidden = true
            destLabel.isHidden = true
            driverLabel.isHidden = true
            priceLabel.isHidden = true
            eta.isHidden = true
            pickup.isHidden = true
            dest.isHidden = true
            driver.isHidden = true
            price.isHidden = true
            topDarkLine.isHidden = true
            editRideButton.isHidden = true
            destinationEntry.isHidden = false
            destinationEntry.isEnabled = true
            destinationEntry.text = nil
            timeEntry.isHidden = false
            timeEntry.isEnabled = true
            timeEntry.text = nil
            roundtripLabel.isHidden = false
            roundtripLabel.isEnabled = true
            roundTripSwitch.isHidden = false
            roundTripSwitch.isEnabled = true
            scheduleButton.setTitle("Schedule Ride", for: .normal)
            scheduleButton.backgroundColor = .lightGray
            if let userEmaill = userDefaults.string(forKey: "userEmail"){
                NetworkManager.completeRide(email: userEmaill, session_token: " ") { user in
                
                }
            }
            
        }
        
    }
    
    //Dismiss keyboard and call delegate in MenuViewController.
    @objc func settingsButtonPressed() {
        destinationEntry.resignFirstResponder()
        timeEntry.resignFirstResponder()
        delegate?.settingsButtonPressed()
    }
    
    func translateOptions(optionsConstant: CGFloat, backgroundConstant: CGFloat) {
        topConstraint.constant = self.optionsYOrigin + optionsConstant
        backgroundConstraint.constant = 120 + backgroundConstant
        options.layoutIfNeeded()
    }

    //Move options view in response to a UIPanGesture.
    @objc func panGestureRecognizerAction(_ gestureRecognier: UIPanGestureRecognizer){
        let translation = gestureRecognier.translation(in: view)
        guard activeRide else {return}
     
        if !optionsExpanded {
            var bounds = rideDetailsLabel.bounds
            rideDetailsLabel.font = rideDetailsLabel.font.withSize(fontSize - translation.y/50)
            bounds.size = rideDetailsLabel.intrinsicContentSize
            rideDetailsLabel.bounds = bounds
            let scaleX = rideDetailsLabel.frame.size.width / bounds.size.width
            let scaleY = rideDetailsLabel.frame.size.height / bounds.size.height
            rideDetailsLabel.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            UIView.animate(withDuration: 1.0) {
                self.rideDetailsLabel.transform = .identity
                if self.options.frame.minY < self.optionsYOrigin{
                self.rideDetailSideConstraint.constant = translation.y/3
                    self.rideDetailsLabel.layoutIfNeeded() }
            }
            //self.topConstraint.constant = self.optionsYOrigin + translation.y
            translateOptions(optionsConstant: translation.y, backgroundConstant: translation.y/10)
            //self.backgroundConstraint.constant = 120 + translation.y/10
            //self.options.layoutIfNeeded()
                }
        else {
            var bounds = rideDetailsLabel.bounds
            rideDetailsLabel.font = rideDetailsLabel.font.withSize(fontSize + 6 - translation.y/50)
            bounds.size = rideDetailsLabel.intrinsicContentSize
            rideDetailsLabel.bounds = bounds
            let scaleX = rideDetailsLabel.frame.size.width / bounds.size.width
            let scaleY = rideDetailsLabel.frame.size.height / bounds.size.height
            rideDetailsLabel.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            UIView.animate(withDuration: 1.0) {
                self.rideDetailsLabel.transform = .identity
            }
            
          //  self.topConstraint.constant = self.optionsYOrigin + translation.y - 300
            //self.backgroundConstraint.constant = 60
              //  self.options.layoutIfNeeded()
            translateOptions(optionsConstant: translation.y - 300, backgroundConstant: -60)
        }
        if gestureRecognier.state == .ended{
            if options.frame.minY < optionsYOrigin - 100{
                optionsExpanded = true
                var bounds = rideDetailsLabel.bounds
                rideDetailsLabel.font = rideDetailsLabel.font.withSize(fontSize + 300/50)
                bounds.size = rideDetailsLabel.intrinsicContentSize
                rideDetailsLabel.bounds = bounds
                let scaleX = rideDetailsLabel.frame.size.width / bounds.size.width
                let scaleY = rideDetailsLabel.frame.size.height / bounds.size.height
                rideDetailsLabel.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                UIView.animate(withDuration: 1.0) {
                    self.rideDetailsLabel.transform = .identity
                    self.rideDetailSideConstraint.constant = -112
                        self.rideDetailsLabel.layoutIfNeeded()
                }
                UIView.animate(withDuration: 0.3){
                //self.topConstraint.constant = self.optionsYOrigin - 300
                //self.backgroundConstraint.constant = 60
                  //  self.options.layoutIfNeeded()
                    self.translateOptions(optionsConstant: -300, backgroundConstant: -60)
                }
                
            }
            else{
                optionsExpanded = false
                var bounds = rideDetailsLabel.bounds
                rideDetailsLabel.font = rideDetailsLabel.font.withSize(fontSize)
                bounds.size = rideDetailsLabel.intrinsicContentSize
                rideDetailsLabel.bounds = bounds
                let scaleX = rideDetailsLabel.frame.size.width / bounds.size.width
                let scaleY = rideDetailsLabel.frame.size.height / bounds.size.height
                rideDetailsLabel.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                UIView.animate(withDuration: 1.0) {
                    self.rideDetailsLabel.transform = .identity
                    self.rideDetailSideConstraint.constant = 0
                        self.rideDetailsLabel.layoutIfNeeded()
                }
                UIView.animate(withDuration: 0.3){
                //self.topConstraint.constant = self.optionsYOrigin
                //self.backgroundConstraint.constant = 120
                //self.options.layoutIfNeeded()
                    self.translateOptions(optionsConstant: 0, backgroundConstant: 0)
                }
            }

        }

    }
    
    //Configure subviews of ViewController.
    func setupViews() {
        options.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        options.translatesAutoresizingMaskIntoConstraints = false
        options.layer.masksToBounds = true
        options.layer.cornerRadius = 15
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        options.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        options.isUserInteractionEnabled = true
        view.addSubview(options)
        optionsYOrigin = 550
        
     

        destinationEntry.translatesAutoresizingMaskIntoConstraints = false
        destinationEntry.borderStyle = UITextField.BorderStyle.roundedRect
        destinationEntry.keyboardType = UIKeyboardType.default
        destinationEntry.autocorrectionType = .no
        destinationEntry.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.8)
        destinationEntry.placeholder = "Where To?"
        destinationEntry.delegate = self
        
        options.addSubview(destinationEntry)

        timeEntry.translatesAutoresizingMaskIntoConstraints = false
        timeEntry.borderStyle = UITextField.BorderStyle.roundedRect
        timeEntry.keyboardType = UIKeyboardType.default
        timeEntry.autocorrectionType = .no
        timeEntry.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.8)
        timeEntry.placeholder = "Pickup Time"
        timeEntry.delegate = self
        options.addSubview(timeEntry)
        
        

        roundtripLabel.translatesAutoresizingMaskIntoConstraints = false
        roundtripLabel.font = UIFont.boldSystemFont(ofSize: 17)
        roundtripLabel.textColor = .darkGray
        roundtripLabel.text = "Roundtrip?"
        options.addSubview(roundtripLabel)

        roundTripSwitch.translatesAutoresizingMaskIntoConstraints = false
        options.addSubview(roundTripSwitch)

        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.setTitle("Schedule Ride", for: .normal)
        scheduleButton.setTitleColor(UIColor.white, for: .normal)
        scheduleButton.clipsToBounds = true
        scheduleButton.layer.cornerRadius = 5
        scheduleButton.layer.borderColor = UIColor.lightGray.cgColor
        scheduleButton.layer.borderWidth = 1
        scheduleButton.backgroundColor = .lightGray
        scheduleButton.addTarget(self, action: #selector(scheduleButtonPressed), for: .touchUpInside)
        options.addSubview(scheduleButton)
        
        editRideButton.translatesAutoresizingMaskIntoConstraints = false
        editRideButton.setTitle("Edit", for: .normal)
        editRideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        editRideButton.setTitleColor(.black, for: .normal)
        editRideButton.isHidden = true
        editRideButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        options.addSubview(editRideButton)
        
        rideDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        rideDetailsLabel.text = "Ride Details"
        rideDetailsLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        rideDetailsLabel.isHidden = true
        options.addSubview(rideDetailsLabel)
        
        fontSize = rideDetailsLabel.font.pointSize

        
        etaLabel.translatesAutoresizingMaskIntoConstraints = false
        etaLabel.text = "Estimated Wait Time:"
        etaLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        etaLabel.isHidden = true
        options.addSubview(etaLabel)
        
        pickupLabel.translatesAutoresizingMaskIntoConstraints = false
        pickupLabel.text = "Pickup Location:"
        pickupLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        pickupLabel.isHidden = true
        options.addSubview(pickupLabel)
        
        destLabel.translatesAutoresizingMaskIntoConstraints = false
        destLabel.text = "Destination:"
        destLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        destLabel.isHidden = true
        options.addSubview(destLabel)
        
        driverLabel.translatesAutoresizingMaskIntoConstraints = false
        driverLabel.text = "Driver:"
        driverLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        driverLabel.isHidden = true
        options.addSubview(driverLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.text = "Price:"
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        priceLabel.isHidden = true
        options.addSubview(priceLabel)
        
        eta.translatesAutoresizingMaskIntoConstraints = false
        eta.text = "3 min"
        eta.font = UIFont.systemFont(ofSize: 15)
        eta.isHidden = true
        options.addSubview(eta)
        
        pickup.translatesAutoresizingMaskIntoConstraints = false
        pickup.text = "Baker Lab"
        pickup.font = UIFont.systemFont(ofSize: 15)
        pickup.isHidden = true
        options.addSubview(pickup)
        
        dest.translatesAutoresizingMaskIntoConstraints = false
        dest.text = "123 East Ave."
        dest.font = UIFont.systemFont(ofSize: 15)
        dest.isHidden = true
        options.addSubview(dest)
        
        driver.translatesAutoresizingMaskIntoConstraints = false
        driver.text = "John Doe"
        driver.font = UIFont.systemFont(ofSize: 15)
        driver.isHidden = true
        options.addSubview(driver)
        
        price.translatesAutoresizingMaskIntoConstraints = false
        price.text = "$8"
        price.font = UIFont.systemFont(ofSize: 15)
        price.isHidden = true
        options.addSubview(price)
        
        topDarkLine.translatesAutoresizingMaskIntoConstraints = false
        topDarkLine.isHidden = true
        options.addSubview(topDarkLine)
        background = UIImageView(image: UIImage(named: "background1.png"))
      
        background.translatesAutoresizingMaskIntoConstraints = false
        options.addSubview(background)
        
        topConstraint = options.topAnchor.constraint(equalTo: view.topAnchor, constant: optionsYOrigin)
        backgroundConstraint = background.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 120)
        rideDetailTopConstraint = rideDetailsLabel.topAnchor.constraint(equalTo: options.topAnchor, constant: 25)
        rideDetailSideConstraint = rideDetailsLabel.centerXAnchor.constraint(equalTo: options.centerXAnchor)
    }
    
    //Set up NSLayoutConstraints for ViewController.
    func setUpConstraints() {
            NSLayoutConstraint.activate([
                topConstraint,
                options.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                options.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                options.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 500),
            ])
        
        NSLayoutConstraint.activate([
          //  background.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: -1624),
            background.widthAnchor.constraint(equalTo: view.widthAnchor),
            backgroundConstraint,
            background.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2.16)
        ])

            NSLayoutConstraint.activate([
                destinationEntry.topAnchor.constraint(equalTo: options.topAnchor, constant: 60),
                destinationEntry.leadingAnchor.constraint(equalTo: options.leadingAnchor, constant: 60),
                destinationEntry.trailingAnchor.constraint(equalTo: options.trailingAnchor, constant: -60),
                destinationEntry.heightAnchor.constraint(equalToConstant: 40)
            ])

            NSLayoutConstraint.activate([
                timeEntry.topAnchor.constraint(equalTo: destinationEntry.topAnchor, constant: 60),
                timeEntry.leadingAnchor.constraint(equalTo: destinationEntry.leadingAnchor),
                timeEntry.trailingAnchor.constraint(equalTo: destinationEntry.trailingAnchor),
                timeEntry.heightAnchor.constraint(equalToConstant: 40)
            ])


            NSLayoutConstraint.activate([
                roundtripLabel.topAnchor.constraint(equalTo: timeEntry.bottomAnchor, constant: 25),
                roundtripLabel.leadingAnchor.constraint(equalTo: timeEntry.leadingAnchor, constant: 5)
            ])
        NSLayoutConstraint.activate([
                   roundTripSwitch.trailingAnchor.constraint(equalTo: timeEntry.trailingAnchor, constant: -5),
                   roundTripSwitch.topAnchor.constraint(equalTo: roundtripLabel.topAnchor, constant: -5)
               ])

            NSLayoutConstraint.activate([
                scheduleButton.topAnchor.constraint(equalTo: roundtripLabel.bottomAnchor, constant: 25),
                scheduleButton.centerXAnchor.constraint(equalTo: options.centerXAnchor),
                scheduleButton.heightAnchor.constraint(equalToConstant: 40),
                scheduleButton.widthAnchor.constraint(equalToConstant: 200),
            ])
        
     
        
        NSLayoutConstraint.activate([
            editRideButton.topAnchor.constraint(equalTo: options.topAnchor, constant: 20),
            editRideButton.leadingAnchor.constraint(equalTo: options.leadingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            rideDetailTopConstraint,
            rideDetailSideConstraint
        ])
        
        NSLayoutConstraint.activate([
            etaLabel.topAnchor.constraint(equalTo: rideDetailsLabel.bottomAnchor, constant: 30),
            etaLabel.leadingAnchor.constraint(equalTo: options.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            pickupLabel.topAnchor.constraint(equalTo: etaLabel.bottomAnchor, constant: 20),
            pickupLabel.leadingAnchor.constraint(equalTo: options.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            destLabel.topAnchor.constraint(equalTo: pickupLabel.bottomAnchor, constant: 20),
            destLabel.leadingAnchor.constraint(equalTo: etaLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            driverLabel.topAnchor.constraint(equalTo: destLabel.bottomAnchor, constant: 20),
            driverLabel.leadingAnchor.constraint(equalTo: etaLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: driverLabel.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: driver.trailingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            eta.topAnchor.constraint(equalTo: rideDetailsLabel.bottomAnchor, constant: 30),
            eta.leadingAnchor.constraint(equalTo: etaLabel.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            pickup.topAnchor.constraint(equalTo: etaLabel.bottomAnchor, constant: 20),
            pickup.leadingAnchor.constraint(equalTo: pickupLabel.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            dest.topAnchor.constraint(equalTo: pickupLabel.bottomAnchor, constant: 20),
            dest.leadingAnchor.constraint(equalTo: destLabel.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            driver.topAnchor.constraint(equalTo: destLabel.bottomAnchor, constant: 20),
            driver.leadingAnchor.constraint(equalTo: driverLabel.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            price.topAnchor.constraint(equalTo: driverLabel.topAnchor),
            price.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            topDarkLine.topAnchor.constraint(equalTo: options.topAnchor, constant: 12),
            topDarkLine.centerXAnchor.constraint(equalTo: options.centerXAnchor),
            topDarkLine.widthAnchor.constraint(equalToConstant: 40),
            topDarkLine.bottomAnchor.constraint(equalTo: options.topAnchor, constant: 18)

        ])
        
        }

}


