//
//  TableViewCustomFooter.swift
//  thirdTask
//
//  Created by Владимир Курганов on 22.09.2022.
//

import UIKit

//MARK: - TableViewCustomFooter

//UIView <-UITableViewHeaderFooterView
final class TableViewCustomFooter: UIView {
    
    let indicator = UIActivityIndicatorView(style: .medium)
    
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
        setupIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupIndicator() {
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
