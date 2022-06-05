//
//  UIViewController+Extension.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 05.06.2022.
//

import UIKit

extension UIViewController {
    func showToast(message: String, autohide: Bool = true) -> UIView {
        let toastContainer = UIView(frame: .zero)
        toastContainer.backgroundColor = .black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 8
        toastContainer.isUserInteractionEnabled = false

        let toastLabel = UILabel(frame: .zero)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -24),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 24),
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 24),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -24),

            toastContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            toastContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            toastContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            if autohide {
                UIView.animate(withDuration: 0.5, delay: 3.5, options: .curveEaseOut, animations: {
                    toastContainer.alpha = 0.0
                }, completion: {_ in
                    toastContainer.removeFromSuperview()
                })
            }
        })

        return toastContainer
    }
}
