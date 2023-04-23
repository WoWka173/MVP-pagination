//
//  TableViewPresenter.swift
//  thirdTask
//
//  Created by Владимир Курганов on 13.09.2022.
//

import Foundation
import UIKit

enum ConstantUrl {
    static let defaultUrl = "https://api.unsplash.com/search/photos?"
}

// MARK: - CustomSection
struct CustomSection {
    var cellsModels: [CellModel]
    let headerIndetifaer: String = "modelHeader"
}

//MARK: - TableViewPresenterProtocol
protocol TableViewPresenterProtocol: AnyObject {
    var view: TableViewControllerProtocol? { get set }
    var mainModels: [ResultPhoto] { get set }
    var appendModels: [ResultPhoto] { get set }
    func viewDidLoad()
    func setupData() -> [CustomSection]
    func appendData(completion: @escaping (Bool) -> Void)
    var router: RouterProtocol? { get set }
    var sections: [CustomSection]  { get set }
}

//MARK: - TableViewPresenter
final class TableViewPresenter: TableViewPresenterProtocol {
    
    //MARK: - Properties
    weak var view: TableViewControllerProtocol?
    var mainModels: [ResultPhoto] = []
    var appendModels: [ResultPhoto] = []
    var router: RouterProtocol?
    var networkService: NetworkServiceProtocol?
    var sections = [CustomSection(cellsModels: [])]
    let group = DispatchGroup()
    
    //MARK: - Init
    init(networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.networkService = networkService
        self.router = router
    }
    
    //MARK: - Methods
    func viewDidLoad() {
        appendData(completion: { _ in
            self.reloadTable()
            DispatchQueue.main.async {
                self.view?.checkOut()
            }
        })
    }
    
    func appendData(completion: @escaping (Bool) -> Void) {
        let nextPage = sections[0].cellsModels.count / 10 + 1
        networkService?.fetchData(numberPage: nextPage) { [weak self] profiles in
            guard let self = self else { return }
            self.mainModels += profiles
            self.appendModels = profiles
            profiles.forEach  { profileImage in
                self.group.enter()
                if let url = URL(string: profileImage.urls?.regular ?? ConstantUrl.defaultUrl) {
                    self.networkService?.downloadImage(url: url, completion: { _ in
                        self.group.leave()
                    })
                }
            }
            self.group.notify(queue: DispatchQueue.main) {
                completion(true)
            }
        }
    }
    
    func reloadTable() {
        var arrayIndexPath: [IndexPath] = []
        
        for numberOfRows in 0...9 {
            arrayIndexPath.append(IndexPath(row: numberOfRows, section: 0))
        }
        self.view?.tableViewBuilder.presenter?.sections = self.setupData()
        DispatchQueue.main.async {
            self.view?.tableViewBuilder.tableView?.beginUpdates()
            self.view?.tableViewBuilder.tableView?.insertRows(at: arrayIndexPath, with: .bottom)
            self.view?.tableViewBuilder.tableView?.endUpdates()
        }
    }
    
    func setupData() -> [CustomSection]  {
        self.appendModels.forEach { model in
            
            let onFill: (CustomCell) -> Void = { cell in
                cell.firstNameLabel.text = model.user?.firstName
                cell.lastNameLabel.text = model.user?.lastName
                if let url = URL(string: model.urls?.regular ?? ConstantUrl.defaultUrl) {
                    self.networkService?.getCachedImage(url: url, completion: { image in
                        cell.photoImageView.image = image
                    })
                }
            }
            let onSelect: (IndexPath) -> Void = { indexPath in
                self.router?.showDetail(person: self.mainModels[indexPath.row])
            }
            
            let cellModel = CellModel(onFill: onFill, onSelect: onSelect)
            self.sections[0].cellsModels.append(cellModel)
        }
        return sections
    }
}
