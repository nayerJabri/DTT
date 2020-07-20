//
//  HouseCell.swift
//  DTT
//
//  Created by Nayer Jabri on 6/10/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//



import UIKit
import CoreLocation

class HouseCell: UITableViewCell {
    
    
    var locationManager:CLLocationManager!
    var userLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    //var userLocation = HouseViewController(userLocation: HouseViewController.init(user))
    @IBOutlet weak var Cellview: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var shower: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var bed: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var housepic: UIImageView!
    @IBOutlet weak var content: UIView!
    
     override func prepareForReuse() {
        super.prepareForReuse()
            //Do  here
            price?.text = ""
            shower?.text = ""
            size?.text = ""
            bed?.text = ""
            zip?.text = ""
            housepic = nil
            distance?.text = ""
            
        
    }
    
    var house : House? {
         didSet {
             
             guard var house = house else {
                 return
             }
               //customize the view
                Cellview.layer.cornerRadius = 10
                Cellview.layer.shadowColor = UIColor.black.cgColor
                Cellview.layer.shadowOpacity = 0.4
                Cellview.layer.shadowOffset = .zero
                Cellview.layer.shadowRadius = 2
                price?.text = "$" + "\(house.price)"
                shower?.text = "\(house.bathrooms)"
                size?.text = "\(house.size)"
                bed?.text = "\(house.bedrooms)"
                zip?.text = house.zip
                self.housepic?.makeRoundCorners(byRadius: 10)
                let parsed = house.image.replacingOccurrences(of: "/uploads/", with: "")
                housepic?.image = UIImage(named: parsed)
                    
            if  CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                // in case athorized do
                let houseLocation = CLLocation(latitude: house.latitude, longitude: house.longitude)
                // calcule the distance
                let dist = Location.shared.userLocation.distance(from: houseLocation) / 1000
                distance?.text = String(format: "%.f", dist) + "Km"
                
            }
            else  {
                // in case athorization denied
                distance?.text = "Unknown"
                
            }
 
         }
}
     
     override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
}


// image border cornor
extension UIImageView {
   func makeRoundCorners(byRadius rad: CGFloat) {
      self.layer.cornerRadius = rad
      self.clipsToBounds = true
   }
}
