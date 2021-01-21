//
//  ViewController.swift
//  geocoder
//
//  Created by John KINAV on 1/20/21.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    var addresses = [String]()
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func readPlist(){
        
        let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "all-adresses", ofType: "plist")!)
       
        addresses = dict?.allValues as! [String]
        

    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        readPlist()
   
        
        for address in addresses {

            getCoordinate(addressString: address) { (coordinates, _: NSError?) in
                print(coordinates)
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }


}

