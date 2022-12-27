//
//  FirstScreenTableViewCell.swift
//  CostTracking
//
//  Created by Ян Нурков on 24.12.2022.
//

import UIKit
import Foundation
import SnapKit

final class FirstScreenTableViewCell: UITableViewCell {
    static let cellName = "cell"
    private weak var controller: FirstScreenViewController?
    
    lazy var timeLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .white
        obj.textAlignment = .left
        return obj
    }()
    
    lazy var moneyLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .white
        obj.textAlignment = .center
        return obj
    }()
    
    lazy var categoryLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .white
        obj.textAlignment = .right
        return obj
    }()
}

private extension FirstScreenTableViewCell {
    func makeConstraint() {
        self.timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.left16)
            make.top.equalToSuperview().offset(Metric.top16)
            make.bottom.equalToSuperview().offset(Metric.bottom16)
            make.width.equalTo(50)
        }
        
        self.moneyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().offset(Metric.top16)
            make.bottom.equalToSuperview().offset(Metric.bottom16)
            make.width.equalTo(130)
        }
        
        self.categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.top16)
            make.bottom.equalToSuperview().offset(Metric.bottom16)
            make.right.equalToSuperview().offset(Metric.right16)
            make.width.equalTo(100)
        }
    }
}

extension FirstScreenTableViewCell {
    func configView(with controller: FirstScreenViewController?) {
        self.controller = controller
        backgroundColor = Colors.lightGray
        contentView.addSubview(timeLabel)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(categoryLabel)
        makeConstraint()
    }
}

private extension FirstScreenTableViewCell {
    var tableView: UITableView? {
        self.superview as? UITableView
    }
    
    var indexPath: IndexPath? {
        self.tableView?.indexPath(for: self)
    }
}
