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
        overrideUserInterfaceStyle = .dark
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
                self.showMessage(title: "Error", message: error.localizedDescription)
            }
        }
        page += 1
    }
    
    private func uploadInfo() {
        NetworkManager.uploadInfo(with: selectedRow, image: imageToSend) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let response = response else { return }
                DispatchQueue.main.async {
                    self.showMessage(title: "Uploaded", message: "Status code: \(response.statusCode)")
                }
            case .failure(let error):
                self.showMessage(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        selectedRow = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        openCamera()
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

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.cameraFlashMode = .off
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            showMessage(title: "Error", message: "Image not found")
            return
        }
        
        imageToSend = image
        picker.dismiss(animated: true, completion: uploadInfo)
    }
}

