//
//  MainView.swift
//  GetPostApp
//
//  Created by Pavel Avlasov on 06.05.2022.
//

import Foundation
import UIKit

final class MainView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.addSubview(tableView)
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor)
        ])
    }
}
