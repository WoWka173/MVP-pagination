//
//  ModuleBuilder.swift
//  thirdTask
//
//  Created by Владимир Курганов on 19.09.2022.
//

import UIKit
//MARK: - ModuleViewControllerBuilderProtocol
protocol ViewControllerBuilderProtocol {
    func createTableViewController(router: RouterProtocol) -> UIViewController
    func createDetailViewController(person: ResultPhoto, router: RouterProtocol) -> UIViewController
}

//MARK: - ModuleViewControllerBuilder
final class ViewControllerBuilder: ViewControllerBuilderProtocol {
    
    //MARK: - Methods
    func createTableViewController(router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let presenter = TableViewPresenter(networkService: networkService, router: router)
        let view = TableViewController(presenter: presenter)
        return view
    }
    
    func createDetailViewController(person: ResultPhoto, router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let presenter = DetailViewPresenter(modelDetail: person, router: router, networkService: networkService)
        let view = DetailViewController(presenter: presenter)
        return view
    }
}
