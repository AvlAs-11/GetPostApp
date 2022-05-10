//
//  Cell.swift
//  GetPostApp
//
//  Created by Pavel Avlasov on 06.05.2022.
//

import Foundation
import UIKit
import Kingfisher

final class TableViewCell: UITableViewCell {
    
    lazy var nameCellLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var imageCell: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(nameCellLabel)
        self.addSubview(imageCell)
        self.imageCell.clipsToBounds = true
        imageCell.layer.cornerRadius = 40
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        nameCellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameCellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            nameCellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameCellLabel.heightAnchor.constraint(equalToConstant: 80),
            nameCellLabel.widthAnchor.constraint(equalToConstant: 100),
            imageCell.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            imageCell.heightAnchor.constraint(equalToConstant: 80),
            imageCell.widthAnchor.constraint(equalToConstant: 160),
            imageCell.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configurate(_ content: Content) {
        nameCellLabel.text = content.name
        imageCell.kf.setImage(with: content.image, placeholder: UIImage(named: "PlaceHolderImage"))
    }
}
