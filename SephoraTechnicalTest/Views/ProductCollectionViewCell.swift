//
//  ProductCollectionViewCell.swift
//  SephoraTechnicalTest
//
//  Created by Achref LETAIEF on 27/09/2023.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupPriceLabel()
        setupStackView()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: Theme.FontSize.title)
        titleLabel.numberOfLines = 2
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: Theme.FontSize.description)
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupPriceLabel() {
        priceLabel.font = UIFont.systemFont(ofSize: Theme.FontSize.price)
        priceLabel.textColor = .green
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(priceLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(with product: Product) {
        if let imageUrl = URL(string: product.imagesUrl.small) {
            imageView.load(url: imageUrl)
        }
        titleLabel.text = product.productName
        descriptionLabel.text = product.description
        priceLabel.text =  "\(product.price) €"
    }
}
