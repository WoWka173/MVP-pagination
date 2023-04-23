//
//  TableViewCustomHeader.swift
//  thirdTask
//
//  Created by Владимир Курганов on 13.09.2022.
//

import UIKit

//MARK: - Constants
fileprivate enum Constants {
    static let labelConstraits: CGFloat = 15.0
    static let labelFontSize: CGFloat = 20.0
    static let labelNumberOfLines = 0
}

//MARK: - TableViewCustomHeader
final class TableViewCustomHeader: UITableViewHeaderFooterView {
    
    //MARK: - Properties
    var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.labelNumberOfLines
        label.font = .systemFont(ofSize: Constants.labelFontSize)
        label.textColor = .black
        label.text = "Friends"
        return label
    }()
    
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super .init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray5
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setupLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.labelConstraits),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.labelConstraits)
        ])
    }
}
