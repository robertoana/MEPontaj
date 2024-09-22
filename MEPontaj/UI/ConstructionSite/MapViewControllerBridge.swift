import GoogleMaps
import SwiftUI

struct MapViewControllerBridge: UIViewControllerRepresentable {
    
    @Binding var selectedMarker: GMSMarker?
    @StateObject var viewModel: MapViewModel
    
    var onAnimationEnded: () -> ()
    var mapViewWillMove: (Bool) -> ()
    
    func makeUIViewController(context: Context) -> MapViewController {
        let uiViewController = MapViewController(viewModel: viewModel)
        uiViewController.mapView.delegate = context.coordinator
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        viewModel.markers.forEach { marker in
            marker.map = uiViewController.mapView
        }
        viewModel.circles.forEach { $0.map = uiViewController.mapView }
        selectedMarker?.map = uiViewController.mapView
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapViewControllerBridge: MapViewControllerBridge
        
        init(_ mapViewControllerBridge: MapViewControllerBridge) {
            self.mapViewControllerBridge = mapViewControllerBridge
        }
        
        func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            if let site = marker.userData as? ConstructionSite {
                let latitude = site.latitude
                let longitude = site.longitude
                
                let url = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&center=\(latitude),\(longitude)&zoom=14")!
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let browserUrl = URL(string: "https://maps.google.com/?q=\(latitude),\(longitude)")!
                    UIApplication.shared.open(browserUrl, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
