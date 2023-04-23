//
//  Router.swift
//  thirdTask
//
//  Created by Владимир Курганов on 14.09.2022.
//

import Foundation
import UIKit

//MARK: - RouterProtocol
protocol RouterProtocol: AnyObject {
    func initialViewCotroller() -> UINavigationController?
    func showDetail(person: ResultPhoto)
    func popToRoot()

}

//MARK: - Router
final class Router: RouterProtocol {
    
    //MARK: - Properties
    var navigationController : UINavigationController?
    let viewControllerBuilder: ViewControllerBuilderProtocol?
    
    
    //MARK: - Init
    init() {
        self.viewControllerBuilder = ViewControllerBuilder()
    }

    //MARK: - Methods
    func initialViewCotroller() -> UINavigationController?  {
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        guard let mainViewController = viewControllerBuilder?.createTableViewController(router: self) else { return UINavigationController() }
        navigationController.viewControllers = [mainViewController]
        return navigationController
    }

        func showDetail(person: ResultPhoto) {
            guard let detailView = viewControllerBuilder?.createDetailViewController(person: person, router: self) else { return }
            navigationController?.pushViewController(detailView, animated: true)
            
        }
    
        func popToRoot() {
            navigationController?.popToRootViewController(animated: true)
        }
    }
