
import GoogleMaps
import UIKit
import Combine

class MapViewController: UIViewController {
    
    let mapView = GMSMapView()
    private var viewModel: MapViewModel
    private var bag = Set<AnyCancellable>()
    private var lastLocation: CLLocationCoordinate2D?
    private var isCameraInitialized = false
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.lastLocation = .init(latitude: 0, longitude: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        viewModel.observeLocationManager()
        setupMapView()
        loadMapData()
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupMapView() {
        if let location = viewModel.lastKnownLocation {
            mapView.camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
        }
        mapView.frame = self.view.bounds;
        mapView.mapType = .normal
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
    }
    
    private func loadMapData() {
        viewModel.$lastKnownLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                
                if !self.isCameraInitialized {
                    let cameraPosition = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
                    self.mapView.animate(to: cameraPosition)
                    self.isCameraInitialized = true
                }
                
                self.lastLocation = location
            }
            .store(in: &bag)
        }
    }

extension CLLocationCoordinate2D {
    static func != (_ lhs: CLLocationCoordinate2D, _ rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude {
            return false
        }
        return true
    }
}

