import UIKit
import CoreLocation

public class LocationViewModel: NSObject,LocationStorage {

    // MARK: - Properties
    public typealias LocationDetailTuple = (latitude: String,longitude: String, address:String)
    private var networkManager: NetworkManager?
    public var locationDetail: LocationDetailTuple? {
        didSet {
            self.observerClosure?()
        }
    }
    public var errorMessage: String? {
        didSet {
          self.observerError?()
        }
    }
    public var coordinate: CLLocationCoordinate2D? {
        didSet {
            // get called when coordinates are set from viewController...
            self.getAddressFromCoordinate()
        }
    }
    
    // Closure Observers...
    public  var observerClosure: (()->())?
    public var observerError: (()->())?
 
    // MARK: - Object Lifecycle
    public init(coordinate: CLLocationCoordinate2D?, networkManager: NetworkManager?) {
        // depedency Injection
        self.coordinate = coordinate
        self.networkManager = networkManager
    }
}

extension LocationViewModel {

    public func getAddressFromCoordinate() {
        // Check For Internet Connection
        if Reachability.isConnectedToInternet() {
            // Get Location from network...
            self.fetchAddress(fromServer: { [weak self] (location, error) in
                guard let strongSelf = self else {
                    self?.errorMessage = error
                    return
                }
                // Store Location In Userdefault..
                strongSelf.locationDetail = (location?.latitude, location?.longitude, location?.address) as? LocationDetailTuple
                strongSelf.storeLocation(forKey: "Location", address: location!)
            })
        }
        else {
            if let location =  self.retriveLocation(forKey: "Location") {
                self.locationDetail = (location.latitude, location.longitude, location.address) as? LocationDetailTuple
            }
        }
    }
    
   public func fetchAddress(fromServer comletionHandler: @escaping (_ location: Location?,_ error: String?)->()) {
        
        networkManager?.getReverseGeoLocation(coordinate!) { (location, error) in
            // Capture StrongSelf
            guard error == nil else {
                comletionHandler(nil, error)
                return
            }
            comletionHandler(location,nil)
        }
    }
}

    



