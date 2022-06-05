//
//  NetworkHandler.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 05.06.2022.
//

import Alamofire

enum InternetStatus {
    case notReachable
    case reachable
    case unknown
}

protocol UINetworkHandler {
    func updateStatus(_ status: InternetStatus)
}

final class UINetworkHandlerImpl: UINetworkHandler {
    private let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    func updateStatus(_ status: InternetStatus) {
        switch status {
        case .notReachable:
            showNoNetworkView()
        case .reachable:
            hideNoNetworkView()
        case .unknown:
            break
        }
    }
    private weak var toast: UIView?
    private func showNoNetworkView() {
        guard toast == nil else { return }
        toast = window.rootViewController?.showToast(message: "No Internet connection. The data may be outdated.", autohide: false)
    }

    private func hideNoNetworkView() {
        guard let toast = toast else { return }
        UIView.animate(withDuration: 0.5, delay: 3.5, options: .curveEaseOut, animations: {
            toast.alpha = 0.0
        }, completion: {_ in
            toast.removeFromSuperview()
        })
    }
}


final class NetworkHandler {
    private let reachability = NetworkReachabilityManager()
    private let uiHandler: UINetworkHandler

    init(uiHandler: UINetworkHandler) {
        self.uiHandler = uiHandler
        startListening()
    }

    private func startListening() {
        reachability?.startListening(onUpdatePerforming: updateStatus(_:))
    }

    private func updateStatus(_ status: NetworkReachabilityManager.NetworkReachabilityStatus?){
        guard let status = status else { return }
        switch status {
        case .unknown:
            uiHandler.updateStatus(.unknown)
        case .notReachable:
            uiHandler.updateStatus(.notReachable)
        case .reachable(_):
            uiHandler.updateStatus(.reachable)
        }
    }
}
