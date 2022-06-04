//
//  TickerCell.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 04.06.2022.
//

import UIKit

final class TickerCell: UITableViewCell {
    private let titleLabel: UILabel = .init()
    private let subtitleLabel: UILabel = .init()
    private let priceLabel: UILabel = .init()
    private let icon: UIImageView = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none

        contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 48)

        ])

        let titleStackView = UIStackView()
        titleStackView.axis = .vertical
        titleStackView.spacing = 8
        contentView.addSubview(titleStackView)

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)

        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 24),
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])


        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray

        priceLabel.font = UIFont.boldSystemFont(ofSize: 23)
    }

    func update(with model: TickerModel) {
        titleLabel.text = model.name
        subtitleLabel.text = model.symbol
        priceLabel.text = model.price

        icon.image = UIImage(named: model.symbol.lowercased())
    }
}
