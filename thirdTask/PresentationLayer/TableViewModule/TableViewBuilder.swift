//
//  TableViewBuilder.swift
//  thirdTask
//
//  Created by Владимир Курганов on 13.09.2022.
//

import UIKit

//MARK: - Constatns
fileprivate enum Constants {
    static let rowHeight: CGFloat = 130
    static let heightForHeader: CGFloat = 40.0
}

//MARK: - Models
struct CellModel {
    var onFill: ((CustomCell) -> Void)?
    var onSelect: ((IndexPath) -> Void)?
    let indefication: String = "modelCell"
}

//MARK: - TableViewBuilder
final class TableViewBuilder: NSObject {
    
    //MARK: - Properties
    weak var tableView: UITableView?
    weak var presenter: TableViewPresenterProtocol?
    var sections: [CustomSection] {
        guard let section = presenter?.sections else { return [] }
        return section
    }
    
    //MARK: - Init
    init(tableView: UITableView, presenter: TableViewPresenterProtocol) {
        super.init()
        self.presenter = presenter
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "modelCell")
        tableView.register(TableViewCustomHeader.self, forHeaderFooterViewReuseIdentifier: "modelHeader")
    }
    
    func updateTable(for page: Int) {
        var arrayIndexPath: [IndexPath] = []
        
        for numberOfRows in (page * 10 - 10)...(page * 10 - 1) {
            arrayIndexPath.append(IndexPath(row: numberOfRows, section: 0))
        }
        
        DispatchQueue.main.async {
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: arrayIndexPath, with: .bottom)
            self.tableView?.endUpdates()
        }
    }
}

//MARK: - Extension TableViewBuilder
extension TableViewBuilder: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].cellsModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: model.indefication  , for: indexPath) as? CustomCell else { return UITableViewCell() }
        model.onFill?(cell)
        
        let nextPage = sections[indexPath.section].cellsModels.count / 10 + 1
        
        if indexPath.row == sections[indexPath.section].cellsModels.count - 1 {
            let footer = tableView.tableFooterView as? TableViewCustomFooter
            footer?.indicator.startAnimating()
            footer?.indicator.isHidden = false
            self.presenter?.appendData(completion: { check in
                if check {
                    guard let present = self.presenter?.setupData() else { return }
                    self.presenter?.view?.tableViewBuilder.presenter?.sections = present
                    self.updateTable(for: nextPage)
                    footer?.indicator.stopAnimating()
                    footer?.indicator.isHidden = true
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].cellsModels[indexPath.row]
        model.onSelect?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = sections[section]
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: model.headerIndetifaer) as? TableViewCustomHeader else { return UIView() }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.heightForHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.heightForHeader
    }
}

