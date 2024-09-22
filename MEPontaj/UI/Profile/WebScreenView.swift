//
//  WebScreenView.swift
//  MEPontaj
//
//  Created by Robert Oană on 02.09.2024.
//

import SwiftUI
import WebKit

struct WebViewScreen: View {
    
    private let navigation = EnvironmentObjects.navigation
    @State var urlString = "https://www.codulmuncii.ro/titlul_11/capitolul_1_1.html"
    @State var workState = WebView.WorkState.done
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    navigation?.pop(animated: true)
                } label: {
                    Image(.icBack)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .leading)
                }.padding(.leading, 12)
                
                
                Text("Documente legale")
                    .font(.poppinsMedium(size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color.black)
                
                Color.clear
                    .frame(width: 30, height: 30, alignment: .leading)
                
            }.background(Color.white)
            
            WebView(urlString: self.$urlString , workState: self.$workState)
                .overlay {
                    if workState == .working {
                        VStack {
                            Spacer()
                            LottieViewGeneral(name: "Blue Animation", loopMode: .loop)
                                .scaleEffect(0.3)
                            Spacer()
                        }.background(Color.white)
                    }
                    if workState == .errorOccurred {
                        Text("Eroare")
                            .background(Color.white)
                    }
                }
        }.background(Color.white)
    }
}

struct WebView: UIViewRepresentable {
    enum WorkState: String {
        case initial
        case done
        case working
        case errorOccurred
    }
    
    @Binding var urlString: String
    @Binding var workState: WorkState
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: self.urlString) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.parent.workState = .working
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            //                self.parent.workState = .errorOccurred
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.workState = .done
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            
        }
        
        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}
