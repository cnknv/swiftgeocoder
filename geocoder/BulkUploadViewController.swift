//
//  BulkUploadViewController.swift
//  geocoder
//
//  Created by John KINAV on 1/23/21.
//

import UIKit
import MapKit
import UniformTypeIdentifiers
import SwiftCSV

class BulkUploadViewController: UIViewController {

    @IBAction func selectFileButton(_ sender: Any) {
        coordinatesTextView.text = ""
        
  
        
        let supportedFiles : [UTType] = [UTType.data]


    let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles,asCopy: true)
        controller.delegate = self
        controller.allowsMultipleSelection = false

    present(controller, animated: true, completion: nil)
    
    }
    
    
    
    @IBOutlet weak var coordinatesTextView: UITextView!
    
   
    @IBAction func copyCoordinates(_ sender: Any) {
        UIPasteboard.general.string = coordinatesTextView.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    private func alertTheUser(title:String, message:String){
 
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

extension BulkUploadViewController: UIDocumentPickerDelegate{
    
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
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
   
       
        do {

            // From a file (with errors)
            let csvFile: CSV = try CSV(url: url)
          
            if csvFile.namedRows.count > 200 {
            alertTheUser(title: "File error!", message: "Your cvs file has more than 200 addresses. Please lower your address count and try again!")
                
            } else if (csvFile.header != ["Address Name", "Address"]) {
                
                alertTheUser(title: "File error!", message: "Your cvs file has wrong header. Please download the example file and fix your header and try again!")
            } else {
            
            try csvFile.enumerateAsDict { [self]  dict in
                
                getCoordinate(addressString: dict["Address"]! ) { (coordinates, _: NSError?) in
                    
                    if (coordinates.latitude == -180) || (coordinates.longitude == -180) { coordinatesTextView.text += " Ivalid Address, " } else { coordinatesTextView.text += ( String(dict["Address Name"]!) + " = Lat: " + String(coordinates.latitude) + " Long: " + String(coordinates.longitude) + ", ") 
                        
                        
                    }
                   
                    
   
                   
                                              }

            }
        } //elses
            

        }
        catch {
            alertTheUser(title: "File Error! ", message: "You are trying to add wrong file")
        }
        
        
        
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

        controller.dismiss(animated: true, completion: nil)
    }

}
