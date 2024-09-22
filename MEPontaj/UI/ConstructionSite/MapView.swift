
import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    
    @Binding var markers: [GMSMarker]
    @Binding var selectedMarker: GMSMarker?
    
    var onAnimationEnded: () -> ()
    
    private let gmsMapView = GMSMapView()
    private let defaultZoomLevel: Float = 15
    
    func makeUIView(context: Context) -> GMSMapView {
        gmsMapView.delegate = context.coordinator
        gmsMapView.isUserInteractionEnabled = true
        gmsMapView.isMyLocationEnabled = true
        return gmsMapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: MapView
        
        init(_ mapView: MapView) {
            self.mapView = mapView
        }
        
        func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            if let site = marker.userData as? ConstructionSite {
                let latitude = site.latitude
                let longitude = site.longitude
                let zoomLevel = 14

                let url = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&center=\(latitude),\(longitude)&zoom=\(zoomLevel)")!

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
