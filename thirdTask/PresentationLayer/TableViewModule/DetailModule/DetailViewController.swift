//
//  DetailViewController.swift
//  thirdTask
//
//  Created by Владимир Курганов on 13.09.2022.
//

import UIKit

//MARK: - Constants
fileprivate enum Constants {
    static let imageSize: CGFloat = 240.0
    static let imageTopAnchor: CGFloat = 150.0
    static let imageCornerRadius: CGFloat = 20.0
    static let lableFont: CGFloat = 20.0
    static let lableСonstraint: CGFloat = 10.0
    static let lableRightСonstraint: CGFloat = -10.0
    static let lableNumberOfLines = 10
}

// MARK: - DetailViewControllerProtocol
protocol DetailViewControllerProtocol: AnyObject {
    func setContent(description: String, image: UIImage)
    func checkOut()
}

//MARK: - DetailViewController
final class DetailViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: DetailViewPresenterProtocol
    
    var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.lableFont)
        label.textAlignment = .center
        label.numberOfLines = Constants.lableNumberOfLines
        return label
    }()
    
    var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = Constants.imageCornerRadius
        photoImageView.layer.masksToBounds = true
        return photoImageView
    }()
    
    let indicator = UIActivityIndicatorView(style: .medium)
    
    init(presenter: DetailViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDetailViewController()
        indicatorSetup()
        indicator.startAnimating()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    //MARK: - Methods
    private func setupDetailViewController(){
        setupImage()
        setupLabel()
    }
    
    func indicatorSetup() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupLabel() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: Constants.lableСonstraint),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.lableСonstraint),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.lableRightСonstraint)
        ])
    }
    
    private func setupImage() {
        view.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.imageTopAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            photoImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }
}

//MARK: - Extension DetailView
extension DetailViewController: DetailViewControllerProtocol {
    func setContent(description: String, image: UIImage) {
        label.text = description
        photoImageView.image = image
    }
    
    func checkOut() {
        self.indicator.stopAnimating()
    }
}
