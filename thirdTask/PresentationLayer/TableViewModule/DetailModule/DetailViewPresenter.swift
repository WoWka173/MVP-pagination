//
//  DetailPresenter.swift
//  thirdTask
//
//  Created by Владимир Курганов on 13.09.2022.
//

import Foundation
import UIKit

// MARK: - DetailViewPresenterProtocol
protocol DetailViewPresenterProtocol: AnyObject {
    var view: DetailViewControllerProtocol? { get set }
    func viewDidLoad()
}

// MARK: - DetailViewPresenter
final class DetailViewPresenter: DetailViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: DetailViewControllerProtocol?
    weak var router: RouterProtocol?
    var networkService: NetworkServiceProtocol?
    private var modelDetail: ResultPhoto?
    
    // MARK: - Init
    init(modelDetail: ResultPhoto, router: RouterProtocol, networkService: NetworkServiceProtocol) {
        self.modelDetail = modelDetail
        self.router = router
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func viewDidLoad() {
        if let url = URL(string:  modelDetail?.urls?.regular ?? ConstantUrl.defaultUrl) {
            self.networkService?.downloadImage(url:  url, completion: { image in
                self.view?.setContent(description: self.modelDetail?.description ?? "None", image: image ?? UIImage())
                self.view?.checkOut()
            })
        }
    }
}


