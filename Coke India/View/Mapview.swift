//
//  Mapview.swift
//  FlagOn
//
//  Created by Deepak on 29/03/17.
//  Copyright © 2017 IOS Development. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Mapview: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITextFieldDelegate,UITableViewDataSource  {

    
    @IBOutlet weak var mapView: MKMapView!
    var locationTextField: UITextField!
    @IBOutlet weak var mapTableview: UITableView!
    var locationManager = CLLocationManager()
    var annotationPoint: MKPointAnnotation!
    var getMovedMapCenter: CLLocation!
    let newPin = MKPointAnnotation()
    var myPinView:MKPinAnnotationView!
    var autoComplete = [String]()
    var draggedAddress = ""
    var defaultLocation = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        locationTextField = UITextField(frame: CGRect(x: screenSize.width*0.14, y: screenSize.height*0.12, width: screenSize.width*0.7, height: 30))
        self.view.addSubview(locationTextField)
        mapTableview.delegate = self
        mapTableview.delegate = self
        mapTableview.isHidden = true
        
        let locationButton = UIButton(frame: CGRect(x: screenSize.width*0.85, y: screenSize.height*0.12, width: screenSize.width*0.14, height: 26))
       // locationButton.backgroundColor = UIColor.red
        locationButton.addTarget(self, action: #selector(getcurrentLocation), for: .touchUpInside)
        view.addSubview(locationButton)
        //locationButton.setTitle("TRST", for: UIControlState.normal)
        locationButton.setImage(UIImage(named:"user-map-location.png"), for: UIControl.State.normal)
        locationTextField.delegate  = self
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        //locationManager.startUpdatingLocation()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(Mapview.mapLongPress(_:)))
        longPress.minimumPressDuration = 1.5
        
        mapView.addGestureRecognizer(longPress)
        mapTableview.rowHeight = 25
        textFields = [locationTextField]
       //Commonhelper().addBorderToTextField(textFields,color: "red")
        Commonhelper().paddingView(textFields)
        locationTextField.layer.borderColor = UIColor.black.cgColor
        locationTextField.layer.borderWidth = 1

        locationTextField.placeholder = "Search your location."
        locationTextField.font = UIFont.systemFont(ofSize: 10)
        locationTextField.textAlignment = .center
        locationTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        
    }
    
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //defaultLocation = ""
        selectedLocation(address: defaultLocation)
        selectedAddress(address: defaultLocation)
        locationTextField.text = defaultLocation
    
    }
    
    @objc func getcurrentLocation() {
        
        determineMyCurrentLocation()
        print("Button pressed")
    }
    
    func determineMyCurrentLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
  func textField(_ locationTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        mapTableview.isHidden = false
        let substring = (locationTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if Reachability.isConnectedToNetwork() == true {
           
            let response = Api().generateAddress(substring: substring)
            searchAutocompleteEntriesWithSubstring(substring: substring,jsonData: response)
        }
        else{
            Commonhelper().showErrorMessage(internetError)
        }
        
         return true
    }
    
    func tableView(_ locationTableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        let index = indexPath.row as Int
        cell.textLabel?.font = UIFont.systemFont(ofSize: 10)
        cell.textLabel!.text = autoComplete[index]
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ locationTableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let location = autoComplete[selectedIndex]
        locationTextField.text = location
        selectedLocation(address: location)
        selectedAddress(address: location)
    }
    
    func tableView(_ locationTableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return autoComplete.count
     }
    
    func searchAutocompleteEntriesWithSubstring(substring: String,jsonData: NSDictionary)
    {
       autoComplete.removeAll(keepingCapacity: false)
        print(substring)
        
        if let status = jsonData["status"] as? String{
            if status == "OK"{
                if let predictions = jsonData["predictions"] as? NSArray{
                   
                    for dict in predictions as! [NSDictionary]{
                        print(dict["description"] as! String)
                        autoComplete.append(dict["description"] as! String)
                     }
                }
            }
        }
        
        mapTableview.reloadData()
    }
    
    func tableView(mapTableview: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let selectedCell: UITableViewCell = mapTableview.cellForRow(at: indexPath as IndexPath)!
        locationTextField.text = selectedCell.textLabel!.text!
        if autoComplete.isEmpty == true {
            print("There are no objects")
        }
        else{
            mapTableview.isHidden = true
        }
        
    }
    
    @IBAction func dismissViewController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
    
        let touchedAt = recognizer.location(in: self.mapView)
        let touchedAtCoordinate : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
        print(newPin.coordinate.latitude)
        newPin.coordinate = touchedAtCoordinate
        mapView.addAnnotation(newPin)
       self.cordinateToLocation(lat: newPin.coordinate.latitude,lon: newPin.coordinate.longitude)
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075))
        mapView.setRegion(region, animated: true)
        newPin.coordinate = location.coordinate
        mapView.addAnnotation(newPin)
        self.cordinateToLocation(lat: newPin.coordinate.latitude,lon: newPin.coordinate.longitude)
        
    }
    
    func selectedLocation(address:String){
        
        let address = address
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            if let placemarks = $0 {
                let placemark = placemarks.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                print(placemarks.first?.location)
                print(lat)
                print(lon)
                let center = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075))
                print(center)
                self.mapView.setRegion(region, animated: true)
                self.newPin.coordinate = (placemark?.location?.coordinate)!
                self.mapView.addAnnotation(self.newPin)
                
            } else {
                print($1)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
   func cordinateToLocation(lat:CLLocationDegrees,lon:CLLocationDegrees){
    
        let longitude :CLLocationDegrees = lon
        let latitude :CLLocationDegrees = lat
        print(longitude)
        print(latitude)
        let location = CLLocation(latitude: latitude, longitude: longitude)
    
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        
        // Place details
        var placeMark: CLPlacemark!
        placeMark = placemarks?[0]
        if placeMark != nil{
        // Address dictionary
        print(placeMark.addressDictionary, terminator: "")
        
        // Location name
        if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
            self.draggedAddress = locationName as String
            print(locationName, terminator: "")
        }
        
        // Street address
//        if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
//            self.draggedAddress = self.draggedAddress+" "+(street as String) as String
//            print(street, terminator: "")
//        }
        
        // City
        if let city = placeMark.addressDictionary!["City"] as? NSString {
            self.draggedAddress = self.draggedAddress+" "+(city as String) as String
            print(city, terminator: "")
        }
        
        // Zip code
        if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
            self.draggedAddress = self.draggedAddress+" "+(zip as String) as String
            print(zip, terminator: "")
        }
        
        // Country
        if let country = placeMark.addressDictionary!["Country"] as? NSString {
            self.draggedAddress = self.draggedAddress+" "+(country as String) as String
            print(country, terminator: "")
        }
            }
       print(self.draggedAddress)
            print("dragged")
            print(self.draggedAddress)
           //self.locationTextField.text = self.draggedAddress
            self.selectedAddress(address: self.draggedAddress)
            self.locationManager.stopUpdatingLocation()
            self.defaultLocation = ""
    })
    
    
    }
    
    func selectedAddress(address:String){
        
        let alertController = UIAlertController(title: "Your Address !", message: address, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default) {
            UIAlertAction in
        self.navigationController?.popViewController(animated: true)
            UserDefaults.standard.set(address, forKey: "selectedAdd")
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Locate on map", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            self.locationTextField.resignFirstResponder()
            self.locationTextField.text = address
            alertController.dismiss(animated: true, completion: nil)
            
        }
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
   
}
