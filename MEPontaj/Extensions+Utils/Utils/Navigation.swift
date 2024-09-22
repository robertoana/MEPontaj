//
//  Navigation.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import UIKit
import SwiftUI

protocol NavigationDestination {
    var tag: String? { get }
}

fileprivate struct ViewDestination: NavigationDestination {
    var tag: String?
    var statusBarStyle: UIStatusBarStyle
    var view: AnyView
}

extension View {
    func asDestination(tag: String? = nil) -> NavigationDestination {
        return ViewDestination(tag: tag, statusBarStyle: ScreenStatusBarStyle.getStyle(for: type(of: self)), view: AnyView(self))
    }
}

class Navigation: ObservableObject {
    
    let navigationController: NavigationController
    
    init(root: UIViewController? = nil) {
        navigationController = NavigationController(rootViewController: root ?? UIViewController())
    }
    
    convenience init(root: NavigationDestination) {
        self.init()
        replaceNavigationStack([root], animated: false)
    }
}

extension Navigation {
    
    func setRoot(_ dest: NavigationDestination, animated: Bool) {
        if let dest = dest as? ViewDestination {
            resignFirstResponder()
            navigationController.setViewControllers([wrapView(dest)], animated: animated)
        }
    }
    
    func replaceCurrent(with dest: NavigationDestination, animated: Bool) {
        resignFirstResponder()
        let current = navigationController.viewControllers.last
        push(dest, animated: animated)
        navigationController.viewControllers.removeAll(where: { $0 == current })
    }
    
    func replaceNavigationStack(_ views: [NavigationDestination], animated: Bool) {
        resignFirstResponder()
        let controllers: [ViewWrapperController] = views.compactMap {
             if let dest = $0 as? ViewDestination {
                return wrapView(dest)
            } else {
                return nil
            }
        }
        navigationController.setViewControllers(controllers, animated: animated)
    }
    
    func push(_ dest: NavigationDestination, animated: Bool) {
        if let dest = dest as? ViewDestination {
            resignFirstResponder()
            navigationController.pushViewController(wrapView(dest), animated: animated)
        }
    }
    
    func pop(animated: Bool) {
        resignFirstResponder()
        navigationController.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        resignFirstResponder()
        navigationController.popToRootViewController(animated: animated)
    }
    
    func popTo(tag: String, animated: Bool) {
        resignFirstResponder()
        let index: Int? = navigationController.viewControllers.firstIndex {
            if let controller = $0 as? NavigationDestination {
                return controller.tag == tag
            } else {
                return false
            }
        }
        
        if let index = index {
            navigationController.popToViewController(navigationController.viewControllers[index], animated: animated)
        } else {
            popToRoot(animated: animated)
        }
    }
    
    func removeFromStack(tag: String) {
        resignFirstResponder()
        navigationController.viewControllers.removeAll {
            if let controller = $0 as? NavigationDestination {
                return controller.tag == tag
            } else {
                return false
            }
        }
    }
    
    func presentModal(
        _ dest: NavigationDestination,
        animated: Bool,
        controllerConfig: ((UIViewController) -> Void) = { controller in
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overFullScreen
            controller.view.backgroundColor = .clear
        },
        completion: (() -> (Void))? = nil
    ) {
        guard let view = dest as? ViewDestination else {return}
        let controller = wrapView(view)
        controllerConfig(controller)
        navigationController.dismiss(animated: true) {
            self.navigationController.present(controller, animated: animated, completion: completion)
        }
    }
    
    func dismissModal(animated: Bool, completion: (() -> (Void))?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func setBackGesture(active: Bool) {
        navigationController.isBackGestureActive = active
    }
    
    private func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func wrapView(_ dest: ViewDestination) -> ViewWrapperController {
        return ViewWrapperController(
            tag: dest.tag,
            rootView: AnyView(dest.view.environmentObject(self)),
            statusBarStyle: dest.statusBarStyle
        )
    }
}

struct NavigationHostView: UIViewControllerRepresentable {
    let navigation: Navigation
    
    func makeUIViewController(context: Context) -> UIViewController {
        return navigation.navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

fileprivate class ViewWrapperController: UIHostingController<AnyView>, NavigationDestination {
    private(set) var tag: String?
    private var statusBarStyle: UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    init(tag: String?, rootView: AnyView, statusBarStyle: UIStatusBarStyle) {
        self.statusBarStyle = statusBarStyle
        super.init(rootView: AnyView(rootView.navigationBarHidden(true)))
        self.tag = tag
    }
    
    override func viewWillAppear(_ animated: Bool) {}
    
    override func viewWillDisappear(_ animated: Bool) {}
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var isBackGestureActive = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && isBackGestureActive
    }
}

enum ScreenStatusBarStyle {
    static func getStyle<T>(for screenType: T.Type) -> UIStatusBarStyle {
        
//        if screenType == OnboardingScreen.self {
//            return .lightContent
//        }
        return .darkContent
    }
}

