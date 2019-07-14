import XCTest
import CoreLocation
@testable import Demo_MVVMte

// Mock Class
// To Test Binding..
fileprivate class MockViewController {
     var viewModel: LocationViewModel?
}

class Demo_MVVMTests: XCTestCase {
    // viewModel object
    var viewModel: LocationViewModel? = nil
    // Default coordinate for testpurpose
    fileprivate var viewController: MockViewController?
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946)
    
    override func setUp() {
        super.setUp()
        
        // Intialization for viewModel
        viewModel = LocationViewModel(coordinate: defaultCoordinate, networkManager: NetworkManager())
        viewController = MockViewController()
        // Assign viewModel To Controller
        viewController?.viewModel = viewModel
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        super.tearDown()
    }
    
    
    // Test to demonstrate if 'Here' GeoLocation webservice returns appropriate data..
    func testAddressFetchWebService() {

        let expectation = XCTestExpectation(description: "Wait until operation finish...")
        
        // Service Call...
        viewModel?.fetchAddress(fromServer: { (location, error) in
            // Assert For Error
            XCTAssertNil(error)
            // Assert For Location
            XCTAssertNotNil(location)
            // Assert for Address
            XCTAssertFalse(location!.address!.isEmpty)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Test to demonstrate binding between viewController and viewModel...
    func testBinding() {
        // Observe viewModel...
        // Observe for locationValue closure...
        let expectationLocation = XCTestExpectation(description: "Wait until closure is invoke...")
        viewController?.viewModel?.observerClosure = {() in
            expectationLocation.fulfill()
        }
        // Observe for Error closure..
        let expectationErrorClosure = XCTestExpectation(description: "Wait until error closure is invoke...")
        viewController?.viewModel?.observerError = {() in
            expectationErrorClosure.fulfill()
        }
        
        // Intiate Closure.
        viewModel?.locationDetail = ("12.9716", "77.5946", "Bengaluru")
        viewModel?.errorMessage = "Test Error Message"
        
        wait(for: [expectationLocation,expectationErrorClosure ], timeout: 5.0)
    }
    
    func testStorageProtocol() {
        let testUserDefaultKey = "test"
        let mockLocation = Location(latitude: "12.9716", longitude: "77.5946", address: "Bengaluru")
        // Store value..
        viewModel?.storeLocation(forKey: testUserDefaultKey, address: mockLocation)
        let value = viewModel?.retriveLocation(forKey: testUserDefaultKey)
        XCTAssertEqual(mockLocation.latitude, value?.latitude)
        XCTAssertEqual(mockLocation.longitude, value?.longitude)
        XCTAssertEqual(mockLocation.address, value?.address)
    }
}
