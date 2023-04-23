//
//  ViewController.swift
//  thirdTask
//
//  Created by Владимир Курганов on 13.09.2022.
//

import UIKit

//MARK: - Constant
fileprivate enum Constant {
    static let zero: CGFloat = 0
    static let height: CGFloat = 40
}

//MARK: - TableViewProtocol
protocol TableViewControllerProtocol: AnyObject {
    func setupTableView()
    var tableViewBuilder: TableViewBuilder { get set }
    func checkOut()
}

//MARK: - TableView
final class TableViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: TableViewPresenterProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = TableViewCustomFooter(frame: CGRect(x: Constant.zero, y: Constant.zero, width: view.frame.width, height: Constant.height))
        return tableView
    }()
    
    lazy var tableViewBuilder = TableViewBuilder(tableView: tableView, presenter: presenter)
    let indicator = UIActivityIndicatorView(style: .medium)
    
    init(presenter: TableViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Profiles"
        setupTableView()
        indicatorSetup()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    func indicatorSetup() {
        tableView.addSubview(indicator)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }
}

//MARK: - Extension TableView
extension TableViewController: TableViewControllerProtocol {
    func checkOut() {
        indicator.stopAnimating()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


