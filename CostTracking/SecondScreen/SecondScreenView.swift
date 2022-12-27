//
//  SecondScreenView.swift
//  CostTracking
//
//  Created by Ян Нурков on 24.12.2022.
//

import UIKit
import SnapKit

class SecondScreenView: UIView {
    
    private weak var secondScreenViewController: SecondScreenViewController?
    private weak var secondScreenModel: SecondScreenModel?
    
    lazy var customeViewImage: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "card")
        obj.contentMode = .scaleAspectFill
        return obj
    }()
    
    lazy var textField: UITextField = {
        let obj = UITextField()
        obj.backgroundColor = Colors.lightGray
        obj.textColor = .white
        obj.textAlignment = .center
        obj.placeholder = "Add new transaction"
        obj.font = .boldSystemFont(ofSize: 30)
        obj.keyboardType = .numberPad
        return obj
    }()
    
    lazy var categoryPicker: UIPickerView = {
        let obj = UIPickerView()
        obj.backgroundColor = .clear
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.layer.cornerRadius = 10
        obj.delegate = secondScreenViewController
        obj.dataSource = secondScreenViewController
        return obj
    }()
    
    lazy var buttonAddTransaction: UIButton = {
        let obj = UIButton()
        obj.backgroundColor = .clear
        obj.setTitle("Add transaction", for: .normal)
        obj.titleLabel?.font = .systemFont(ofSize: 15)
        obj.setTitleColor(UIColor.white, for: .normal)
        obj.layer.cornerRadius = 10
        obj.addTarget(self, action: #selector(addNewTransaction), for: .touchDown)
        return obj
    }()
    
    lazy var image: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "boy")
        return obj
    }()
}

private extension SecondScreenView {
    func configView() {
        backgroundColor = Colors.black
        addSubview(customeViewImage)
        addSubview(textField)
        addSubview(categoryPicker)
        addSubview(buttonAddTransaction)
        addSubview(image)
    }
    
    func makeConstraints() {
        self.customeViewImage.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.top).offset(-10)
            make.left.equalTo(textField.snp.left)
            make.right.equalTo(textField.snp.right).offset(1)
            make.bottom.equalTo(buttonAddTransaction.snp.bottom).offset(-20)
        }
        
        self.textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(70)
            make.left.equalToSuperview().offset(Metric.left16)
            make.right.equalToSuperview().offset(Metric.right16)
        }
        
        self.categoryPicker.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(23)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.buttonAddTransaction.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.left16)
            make.right.equalToSuperview().offset(Metric.right16)
            make.height.equalTo(40)
            make.top.equalTo(categoryPicker.snp.bottom).offset(20)
        }
        
        self.image.snp.makeConstraints { make in
            make.top.equalTo(customeViewImage.snp.bottom).offset(40)
            make.width.height.equalTo(250)
            make.centerX.equalToSuperview()
        }
    }
}

extension SecondScreenView {
    func didLoadUI(controller: SecondScreenViewController) {
        self.secondScreenViewController = controller
        configView()
        makeConstraints()
        super.updateConstraints()
    }
    
    @objc func addNewTransaction() {
        secondScreenViewController?.addNewTransaction()
    }
}

