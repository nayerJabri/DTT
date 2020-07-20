//
//  HouseDetailViewController.swift
//  DTT
//
//  Created by Nayer Jabri on 6/13/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import UIKit
import MapKit

class HouseDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var descip: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bathrooms: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var bedrooms: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewdetail: UIView!
    

    var houseDetailViewModel: HouseDetailViewModel!
    var locationManager:CLLocationManager!
    var houseD: HouseDetailViewModel?
    var kaka: String?
    var directionRequest = MKDirections.Request()
    let house = MKPointAnnotation()
    let userCurrentLocation = MKPointAnnotation()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize
        initialMethod()
        //show the house detail information
        updatedata()
        //configure house loction on the map
        determineHouseLocation()
        
    }
        
     //map has been tapped by user do
    @IBAction func clickmap(_ sender: Any) {
            //configure user location on the map
            determinateuserLocation()
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)        
        // Create and Add MapView to our main view

    }
    
    func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension HouseDetailViewController {
    
    func initialMethod(){
        
        //navigation background transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //cutomize view
        self.viewdetail.layer.cornerRadius = 10
        viewdetail.layer.shadowColor = UIColor.black.cgColor
        viewdetail.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
        viewdetail.layer.shadowOpacity = 0.3
        viewdetail.layer.shadowRadius = 2.0
        viewdetail.layer.masksToBounds  = false
        self.view.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1.0)
        viewdetail.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1.0)
        //initialize for House detail page
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:"clickmap:")
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        mapView.delegate = self
        determinateuserLocation()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func updatedata(){
        
        descip.text = houseDetailViewModel!.house.description
        price.text = "$" + "\(houseDetailViewModel!.house.price)"
        bathrooms.text = "\(houseDetailViewModel!.house.bathrooms)"
        size.text = "\(houseDetailViewModel!.house.size)"
        location.text = houseDetailViewModel!.house.distance
        bedrooms.text = "\(houseDetailViewModel!.house.bedrooms)"
        location.text = "Unknown"
        let parsed = houseDetailViewModel!.house.image.replacingOccurrences(of: "/uploads/", with: "")
        img.image = UIImage(named: parsed)
        
    }
}

// Mapkit and Location Manager
extension HouseDetailViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    

        // in case the user location changed, make the updates and clear the map
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            Location.shared.userLocation = locations[0] as CLLocation
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotation(userCurrentLocation)
            let houseLocation = CLLocation(latitude: houseDetailViewModel!.house.latitude, longitude: houseDetailViewModel!.house.longitude)
            let dist = Location.shared.userLocation.distance(from: houseLocation) / 1000
            location?.text = String(format: "%.f", dist) + "Km"
            
        }

       func determinateuserLocation(){
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            // athorized do
           if CLLocationManager.locationServicesEnabled() {
            
                locationManager.startUpdatingLocation()
            
            }
            
             userCurrentLocation.title = "User Location"
                       userCurrentLocation.coordinate = CLLocationCoordinate2D(latitude:Location.shared.userLocation.coordinate.latitude,longitude: Location.shared.userLocation.coordinate.longitude)
                       mapView.addAnnotation(userCurrentLocation)
                       directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Location.shared.userLocation.coordinate.latitude, longitude: Location.shared.userLocation.coordinate.longitude), addressDictionary: nil))
                       directionRequest.requestsAlternateRoutes = true
                       directionRequest.transportType = .automobile
                       let directions = MKDirections(request: directionRequest)
            
                       //show the distance on map between user location and house location
                       directions.calculate { [unowned self] response, error in
                       guard let unwrappedResponse = response else { return }
                       for route in unwrappedResponse.routes {
                            self.mapView.addOverlay(route.polyline)
                            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                       }
                    }
         }
        
    }
    
    
    func determineHouseLocation(){

                let housecoord = CLLocationCoordinate2DMake(houseDetailViewModel!.house.latitude, houseDetailViewModel!.house.longitude)
                let coordinateRegion = MKCoordinateRegion.init(center: housecoord, latitudinalMeters:  1000, longitudinalMeters: 1000)
                mapView.setRegion(coordinateRegion, animated: true)
                let house = MKPointAnnotation()
                house.title = "House Location"
                house.coordinate = housecoord
                mapView.addAnnotation(house)
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: houseDetailViewModel!.house.latitude, longitude: houseDetailViewModel!.house.longitude), addressDictionary: nil))
                   
    }

                
                        
                
                           
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.blue
            return renderer
            
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
           print("Error \(error)")
    }
     

}
