//
//  ViewController.swift
//  GetPostApp
//
//  Created by Pavel Avlasov on 06.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    let mainView = MainView()
    private var content = [Content]()
    private var page = 0
    static var totalPages: Int?
    private var selectedRow: Int?
    private var imageToSend: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        getInfo()
    }
    
    private func configuration() {
        let frame = view.safeAreaLayoutGuide.layoutFrame
        mainView.frame = frame
        mainView.tableView.frame = frame
        view.addSubview(mainView)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func getInfo() {
        NetworkManager.getInfo(with: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let content):
                self.content += content
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        page += 1
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.configurate(content[indexPath.row])       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.content[indexPath.row].id)
        selectedRow = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
       
        guard let totalPages = MainViewController.totalPages else { return }
        if y == h && page < totalPages {
            getInfo()
        }
    }
}
