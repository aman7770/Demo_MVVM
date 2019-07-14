import UIKit
import CoreLocation


public typealias NetworkCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

fileprivate enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

public class NetworkManager {
    
    func getReverseGeoLocation(_ coordinate: CLLocationCoordinate2D,completion: @escaping (_ location: Location?,_ error: String?)->()) {
        
        let stringCoordinates = coordinate.toString()

        self.performGetRequest("https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?prox=\(stringCoordinates.latitude)%2C\(stringCoordinates.longitude)%2C250&mode=retrieveAddresses&maxresults=1&gen=9&app_id=apYuUoAyQo5k3w2Hus71&app_code=QZ9G7OUgw1_W0m2Yv2ux-w") { (data, response, error) in
            let result = self.handleNetworkResponse(response as! HTTPURLResponse)
            switch result {
            case .success:
            guard let responseData = data else {
                completion(nil, NetworkResponse.noData.rawValue)
                return
            }
            do {
                _ = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                let locationDetail = try JSONDecoder().decode(LocationBase.self, from: responseData)
                // Fetch Address from response..
                guard let locationBase = locationDetail.response, let view = locationBase.view?.first, let result = view.result?.first, let locationInfo = result.location, let address = locationInfo.address?.label else {
                    return
                }
                
                let location = Location(latitude: stringCoordinates.latitude, longitude: stringCoordinates.longitude, address: address)
            
                completion(location,nil)
            }catch {
                print(error)
                completion(nil, NetworkResponse.unableToDecode.rawValue)
            }
            case .failure(let networkFailureError):
            completion(nil, networkFailureError)
         }
       }
    }
    
    private func performGetRequest(_ endPoint: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: endPoint) else {
            completion(nil, nil,  NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request,  completionHandler: { data, response, error in
            DispatchQueue.main.async(execute: { () -> Void in
                completion(data, response, error)
            })
        })
        task.resume()
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

