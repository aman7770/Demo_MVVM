import UIKit
import CoreLocation

class ViewController: UIViewController  {
    // Properties...
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblAddress: UILabel!

    // LocationManager
    private let locationManager = CLLocationManager()
    // Default Coordinate
    // 12.9716,77.5946
    private var defaultCoordinate = CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946)
    // Intialise viewModel...
    lazy var viewModel: LocationViewModel = {
      return LocationViewModel(coordinate: defaultCoordinate, networkManager: NetworkManager())
    }()


  //  var viewModel =
    override func viewDidLoad() {
        super.viewDidLoad()
        // Intialise LocationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        // Setup ViewModel
        self.observeValues()
    }
}

// CoreLocation Methods
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if let currentLocation = locations.first {
            // Asssign Coordinates to ViewModel...
            viewModel.coordinate = currentLocation.coordinate
            //  Location is stopped from updating...
            locationManager.stopUpdatingLocation()
        }
    }
}

extension ViewController {
    
    private func fill(labelWith latitude: String,longitude: String, address: String) {
        // Load UI in MainQueue...
        DispatchQueue.main.async {
            self.lblLatitude.text = "Latitude:- \(latitude)"
            self.lblLongitude.text = "Longitude:- \(longitude)"
            self.lblAddress.text = "Address:- \(address)"
        }
    }
    
    // Method observes value changes in viewModel
    private func observeValues() {
        // Observe viewModel...
        viewModel.observerClosure = { [unowned self] () in
            self.fill(labelWith: self.viewModel.locationDetail?.latitude ?? "", longitude: self.viewModel.locationDetail?.longitude ?? "", address: self.viewModel.locationDetail?.address ?? "")
        }
        // Error Message Observer
        viewModel.observerError = { [unowned self] () in
            // Show Alert..
            let alert = UIAlertController(title: "", message: self.viewModel.errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                // DISMISS CONTROLLER..
                self.dismiss(animated: true, completion: nil)
            }))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
}


