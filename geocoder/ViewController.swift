//
//  ViewController.swift
//  geocoder
//
//  Created by John KINAV on 1/20/21.
//

import UIKit
import MapKit


class ViewController: UIViewController {
//    var addresses = [String]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var CoordinateTextField: UILabel!
    
    @IBAction func convertCoordinate(_ sender: Any) {
        let address = addressTextField.text!
        
        getCoordinate(addressString: address) { (coordinates, _: NSError?) in
            
            if (coordinates.longitude == -180) || (coordinates.latitude == -180)  {
                self.alertTheUser(title: "Address is not valid ", message: "Please update address and try again.")
                
            } else {
                
                self.CoordinateTextField.text = "Latitude: " + String(coordinates.latitude) + "  " + "Logitude: " + String(coordinates.longitude)
                
                        let latitude: CLLocationDegrees = coordinates.latitude
                                       let longitude: CLLocationDegrees = coordinates.longitude
                       
                                   
                let name = self.addressTextField.text!
                                       let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                                       let myAnn = MyAnnotation(title: name, coordinate: location)
                        
                      
                            self.mapView.addAnnotation(myAnn)
                
                let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)
               
         
                let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
                let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
                
                
                self.mapView.setRegion(region, animated: true)
                
            }

            
    }
    }
        
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
    
//    func readPlist(){
//
//        let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "all-adresses", ofType: "plist")!)
//
//        addresses = dict?.allValues as! [String]
//
//
//    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
       
      
//        readPlist()
   
        
//        for address in addresses {
//
//            getCoordinate(addressString: address) { (coordinates, _: NSError?) in
//                print(coordinates)
//            }
//        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    private func alertTheUser(title:String, message:String){
 
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}


class MyAnnotation: NSObject, MKAnnotation {
    
    var title : String?
    var coordinate : CLLocationCoordinate2D
    
    init(title:String, coordinate:CLLocationCoordinate2D){
        
        self.title = title
        self.coordinate = coordinate
        
        
    }
    
}

extension ViewController: MKMapViewDelegate {
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view = MKMarkerAnnotationView()
       
        
        if annotation is MKUserLocation { return nil }
        
else {  view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    view.canShowCallout = true
    view.calloutOffset = CGPoint(x: -5, y: 5)
   
    
    let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                            size: CGSize(width: 30, height: 30)))
    mapsButton.setBackgroundImage(UIImage(named: "Map-icon"), for: UIControl.State())
    view.rightCalloutAccessoryView = mapsButton
   
    
    view.markerTintColor = UIColor(displayP3Red: 255/255, green: 4/255, blue: 158/255, alpha: 1)

    
        }
        

        return view
    }
    


    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
          let location = view.annotation?.coordinate
        

        let placemark = MKPlacemark(coordinate: location!, addressDictionary:nil)
        
        
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = (view.annotation?.title)!
        
        
  
        
        
    }
    

    


}

