
import GoogleMaps
import SwiftUI

struct ContentView: View {
    @State private var zoomInCenter: Bool = false
    @State private var selectedMarker: GMSMarker?
    @StateObject var viewModel = MapViewModel()
    
    var body: some View {
            switch viewModel.constructionSiteState {
            case .loading:
                HStack {
                    Spacer()
                    LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                        .scaleEffect(0.5)
                    Spacer()
                }.frame(maxWidth:.infinity)
                 .background(Color.whiteProfile)
            case .ready(_):
                ZStack(alignment: .top) {
                    MapViewControllerBridge(
                        selectedMarker: $selectedMarker,
                        viewModel: viewModel,
                        onAnimationEnded: {
                        self.zoomInCenter = true
                    }, mapViewWillMove: { isGesture in
                        guard isGesture else { return }
                        self.zoomInCenter = false
                    })
                }.ignoresSafeArea(.all)
                 .background(Color.whiteProfile)
            case .failure(_):
                VStack(spacing: 10) {
                    Image(.icEmpty3)
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .center)
                    
                    Text("Nu ești asignat niciunui șantier!")
                        .font(.poppinsMedium(size: 18))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth:.infinity, alignment: .center)
                    
                    Text("Harta se va încărca după ce vei fi asignat unui șantier!")
                        .font(.poppinsRegular(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black)
                        .frame(width: 300, height: 100, alignment: .center)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                 .background(Color.whiteProfile)
            }
    }
}


