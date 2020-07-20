//
//  HouseViewController.swift
//  DTT
//
//  Created by Nayer Jabri on 6/10/20.
//  Copyright © 2020 Nayer Jabri. All rights reserved.
//

import UIKit
import CoreLocation

class HouseViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchForHourse: UISearchBar!
    
    
    var locationManager:CLLocationManager!
    let viewModel = HousesViewModel()
    var selectedHouse :  House?
    lazy var myRefrechControl: UIRefreshControl = {
        let myRefrechControl = UIRefreshControl()
        myRefrechControl.addTarget(self, action: #selector(pageSetup), for: .valueChanged)
        return myRefrechControl
    }()
    
    override func viewDidLoad() {
              super.viewDidLoad()
              
              //initialize
              initialMethod()
              //get user location
              determineCurrentLocation()
              //data for tableview
              pageSetup()
        
    }
    
}

extension HouseViewController {
    
    func initialMethod() {
        
        // customize view
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1.0)
        self.tableView.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1.0)
        self.searchForHourse.layer.borderWidth = 0
        self.searchForHourse.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        //initialize for home page
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        tableView.delegate = self
        tableView.dataSource = self
        searchForHourse.delegate = self
        if #available(IOS 10.0, *) {
            tableView.refreshControl = myRefrechControl
        } else {
        tableView.addSubview(myRefrechControl)
        }
        
    }
    
    @objc
    func pageSetup()  {
          // add error handling example
            self.viewModel.onErrorHandling = { [weak self] error in
            // display error ?
            let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self?.present(controller, animated: true, completion: nil)
                 }
              // API calling from HousesViewModel class
            DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.viewModel.requestData { [weak self] (data: [House]) in
                self!.viewModel.HousesArray = data
                self!.viewModel.HousesArray.sort(by: {$0.price < $1.price})
                self!.viewModel.filterHouses = self!.viewModel.HousesArray
                self!.tableView.reloadData()
                self!.searchForHourse.text = ""
            }
        }
         myRefrechControl.endRefreshing()
    }
}

// TableView configuration and search bar
extension HouseViewController : UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.filterHouses.count > 0  {
            self.tableView.backgroundView = .none
           return 1
        } else {

         // in case Search not found
             let image = UIImage(named: "undraw_empty_xct9-2.png")
            let iv = UIImageView(image: image)
            iv.contentMode = .scaleAspectFit
            iv.layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            iv.center = self.view.center
            let tableViewBackgroundView = UIView()
            tableViewBackgroundView.addSubview(iv)
            self.tableView.backgroundView = tableViewBackgroundView
            return 0
        }
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.filterHouses.count
        
       }
    
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170
        
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath) as! HouseCell
           cell.contentView.backgroundColor = UIColor(red:235.0/255.0, green:235.0/255.0, blue:235.0/255.0, alpha:1.0)
           let house = self.viewModel.filterHouses[indexPath.row]
           cell.house = house
           return cell
        
       }
       
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          let house = self.viewModel.filterHouses[indexPath.row]
          self.selectedHouse = house
          self.performSegue(withIdentifier: "showHouseDetail", sender: nil)
        
      }
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.filterHouses = []
        if searchText == "" {
            // search text is empty reload all data
            viewModel.filterHouses = viewModel.HousesArray
        }
        for item in viewModel.HousesArray {
            if item.zip.lowercased().contains(searchText.lowercased()) || item.city.lowercased().contains(searchText.lowercased()) {
                viewModel.filterHouses.append(item)
            }
        }
        self.tableView.reloadData()
        
     }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showHouseDetail" {
            
            let housedetail = segue.destination as! HouseDetailViewController
            // send the selected house to HouseViewModel
            housedetail.houseDetailViewModel = HouseDetailViewModel(withHouse: selectedHouse!)
            
        }
    }
}


// User Location and authorization
extension HouseViewController: CLLocationManagerDelegate{
    
    func determineCurrentLocation()
    {
        
        if CLLocationManager.locationServicesEnabled() {

            checklocationAuthorization()
            
        }
    }
    
    // in case the user location changed, make the upadate on the view
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Location.shared.userLocation = locations[0] as CLLocation
        tableView.reloadData()
    }
    
    // something went wrong
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error \(error)")
    }
    
    //in case the authorization has been manually changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checklocationAuthorization()
        //self.tableView!.reloadData()
    }
    
    // check authorization for the user location
    func checklocationAuthorization() {
        
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        switch  status{
            
         case .authorizedWhenInUse:
            //update location
            locationManager.startUpdatingLocation()
            tableView.reloadData()
         break
         case .denied:
            // alert how to rechange the autorization
            let alert = UIAlertController(title: "Activate your location", message: "you need to activate your location to see the distance", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
         break
         case .notDetermined:
         break
         case .restricted:
         break
         case .authorizedAlways:
            //update location
            locationManager.startUpdatingLocation()
            tableView.reloadData()
         break
            
        }
    }
}
