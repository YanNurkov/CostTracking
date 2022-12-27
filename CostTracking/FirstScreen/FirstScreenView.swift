//
//  FirstScreenView.swift
//  CostTracking
//
//  Created by Ян Нурков on 24.12.2022.
//

import UIKit
import SnapKit

class FirstScreenView: UIView {
    
    private weak var controller: FirstScreenViewController?
    
    lazy var viewBitcoin: UIView = {
        let obj = UIView()
        obj.backgroundColor = .red
        obj.layer.cornerRadius = 10
        obj.layer.masksToBounds = true
        return obj
    }()
    
    lazy var lableBitcoin: UILabel = {
        let obj = UILabel()
        obj.backgroundColor = .red
        obj.layer.cornerRadius = 10
        obj.layer.masksToBounds = true
        obj.textColor = .white
        obj.font = .boldSystemFont(ofSize: 10)
        obj.textAlignment = .center
        return obj
    }()
    
    lazy var imageBitcoin: UIImageView = {
        let obj = UIImageView()
        obj.tintColor = .white
        obj.image = UIImage(systemName: "bitcoinsign.circle")
        return obj
    }()
    
    lazy var imageUSD: UIImageView = {
        let obj = UIImageView()
        obj.tintColor = .white
        obj.image = UIImage(systemName: "dollarsign.circle")
        return obj
    }()
    
    lazy var imageArrow: UIImageView = {
        let obj = UIImageView()
        obj.tintColor = .white
        obj.image = UIImage(systemName: "arrow.right")
        return obj
    }()
    
    lazy var viewTransaction: UIView = {
        let obj = UIView()
        obj.backgroundColor = Colors.gray
        obj.layer.cornerRadius = 10
        obj.layer.masksToBounds = true
        return obj
    }()
    
    lazy var lableTransaction: UILabel = {
        let obj = UILabel()
        obj.backgroundColor = .clear
        obj.layer.cornerRadius = 10
        obj.layer.masksToBounds = true
        obj.textColor = .white
        obj.font = .boldSystemFont(ofSize: 30)
        obj.textAlignment = .left
        return obj
    }()
    
    lazy var buttonAddMoney: UIButton = {
        let obj = UIButton()
        obj.backgroundColor = .red
        obj.setImage(UIImage(systemName: "plus"), for: .normal)
        obj.tintColor = .white
        obj.layer.cornerRadius = 25
        obj.addTarget(self, action: #selector(addMoneyPush), for: .touchDown)
        return obj
    }()
    
    lazy var buttonAddTransaction: UIButton = {
        let obj = UIButton()
        obj.backgroundColor = .red
        obj.setTitle("Add Transaction", for: .normal)
        obj.titleLabel?.font = .systemFont(ofSize: 15)
        obj.setTitleColor(UIColor.white, for: .normal)
        obj.layer.cornerRadius = 10
        obj.addTarget(self, action: #selector(addTransaction), for: .touchDown)
        return obj
    }()
    
    lazy var tableView: UITableView = {
        let obj = UITableView()
        obj.register(FirstScreenTableViewCell.self, forCellReuseIdentifier: "cell")
        obj.dataSource = controller
        obj.rowHeight = 100
        obj.layer.cornerRadius = 10
        obj.showsVerticalScrollIndicator = false
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    lazy var infoView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .darkGray
        obj.layer.cornerRadius = 20
        obj.alpha = 0
        return obj
    }()
    
    lazy var customeViewImage: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "card")
        obj.contentMode = .scaleAspectFill
        return obj
    }()
    
    lazy var textField: UITextField = {
        let obj = UITextField()
        obj.backgroundColor = .clear
        obj.textColor = .white
        obj.textAlignment = .center
        obj.placeholder = "Add money"
        obj.font = .boldSystemFont(ofSize: 20)
        obj.keyboardType = .numberPad
        return obj
    }()
    
    lazy var buttonAdd: UIButton = {
        let obj = UIButton()
        obj.backgroundColor = .clear
        obj.setTitle("Add", for: .normal)
        obj.titleLabel?.font = .systemFont(ofSize: 20)
        obj.setTitleColor(UIColor.white, for: .normal)
        obj.addTarget(self, action: #selector(addMoneyAndClose), for: .touchDown)
        return obj
    }()
}


private extension FirstScreenView {
    func configView() {
        backgroundColor = Colors.black
        addSubview(self.viewBitcoin)
        viewBitcoin.addSubview(self.lableBitcoin)
        viewBitcoin.addSubview(self.imageBitcoin)
        viewBitcoin.addSubview(self.imageUSD)
        viewBitcoin.addSubview(self.imageArrow)
        addSubview(self.viewTransaction)
        viewTransaction.addSubview(self.lableTransaction)
        viewTransaction.addSubview(self.buttonAddMoney)
        viewTransaction.addSubview(self.buttonAddTransaction)
        addSubview(self.tableView)
        addSubview(self.infoView)
        infoView.addSubview(self.customeViewImage)
        infoView.addSubview(self.textField)
        infoView.addSubview(self.buttonAdd)
        
    }
    
    func makeConstraints() {
        self.viewBitcoin.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(Metric.right16)
            make.top.equalToSuperview().offset(60)
            make.width.equalTo(70)
            make.height.equalTo(50)
        }
        
        self.lableBitcoin.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview()
        }
        
        self.imageBitcoin.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-2)
            make.width.height.equalTo(15)
        }
        
        self.imageArrow.snp.makeConstraints { make in
            make.height.width.equalTo(15)
            make.bottom.equalToSuperview().offset(-2)
            make.centerX.equalToSuperview()
        }
        
        self.imageUSD.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-2)
            make.width.height.equalTo(15)
        }
        
        self.viewTransaction.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.left16)
            make.top.equalToSuperview().offset(130)
            make.right.equalToSuperview().offset(Metric.right16)
            make.height.equalTo(150)
        }
        
        self.lableTransaction.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.top16)
            make.right.equalTo(buttonAddMoney.snp.left).offset(Metric.right16)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(Metric.left16)
        }
        
        self.buttonAddMoney.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.right.equalToSuperview().offset(Metric.right16)
            make.centerY.equalTo(lableTransaction.snp.centerY)
            make.height.equalTo(50)
        }
        
        self.buttonAddTransaction.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.left16)
            make.right.equalToSuperview().offset(Metric.right16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(Metric.bottom16)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.left16)
            make.right.equalToSuperview().offset(Metric.right16)
            make.top.equalTo(viewTransaction.snp.bottom).offset(Metric.top16)
            make.bottom.equalToSuperview()
        }
        
        self.infoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(200)
        }
        
        self.customeViewImage.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(25)
            make.height.equalTo(40)
        }
        
        self.buttonAdd.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-7)
        }
    }
    
    @objc func addTransaction () {
        controller?.secondScreenView()
    }
    
    @objc func addMoneyPush() {
        controller?.addMoneyPush()
    }
    
    @objc func addMoneyAndClose() {
        controller?.addMoney()
    }
}

extension FirstScreenView {
    func didLoadUI(controller: FirstScreenViewController) {
        self.controller = controller
        configView()
        makeConstraints()
        super.updateConstraints()
    }
}



