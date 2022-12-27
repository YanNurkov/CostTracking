//
//  FirstScreenViewController.swift
//  CostTracking
//
//  Created by Ян Нурков on 24.12.2022.
//

import UIKit
import CoreData

class FirstScreenViewController: UIViewController, UITextFieldDelegate {
    
    private let firstScreenView = FirstScreenView()
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    var timer = Timer()
    var dataInfo: [Payments] = []
    var dataTimer: [TimeUpdate] = []
    var isSelected = Bool()
    var totalAmount = "$ 0"
    private var currentPage = 1
    
    override func loadView() {
        super.loadView()
        view = firstScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstScreenView.didLoadUI(controller: self)
        firstScreenView.textField.delegate = self
        rateWhenLoad()
        rateWhenFirstLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name("updateView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        firstScreenView.tableView.reloadData()
        configViewBitcoin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(serviceCall), userInfo: nil, repeats: true)
    }
    
    func configViewBitcoin() {
        self.firstScreenView.lableTransaction.text = totalAmount
    }
    
    func saveLastServiceCalledDate() {
        
        do {
                let data = TimeUpdate(context: context)
                data.timer = Date()
                data.rate = firstScreenView.lableBitcoin.text
            if dataTimer.count >= 1 {
                context.delete(data)
            }
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func isCalledInLast60Min() -> Bool {
        var timer = Int()
        do {
            dataTimer = try context.fetch(TimeUpdate.fetchRequest())
            var bitcoinRate: String = ""
            var time = Date()
            for i in 0 ..< dataTimer.count {
                bitcoinRate = dataTimer[i].rate ?? ""
                time = dataTimer[i].timer ?? Date()
            }
            if  firstScreenView.lableBitcoin.text == "" {
                firstScreenView.lableBitcoin.text = bitcoinRate
            }
            let timeElapsed: Int = Int(Date().timeIntervalSince(time))
            timer = timeElapsed
        }
        catch {
            print("Fetching Failed")
        }
        return timer < 60 * 60
    }
    
    @objc func serviceCall() {
        if isCalledInLast60Min() { return }
        saveLastServiceCalledDate()
        getDataJSON()
    }
    
    func rateWhenFirstLoad() {
        if dataTimer.isEmpty {
            getDataJSON()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.saveLastServiceCalledDate()
            })
            print("First load")
        }
    }
    
    func rateWhenLoad() {
        do {
            dataTimer = try context.fetch(TimeUpdate.fetchRequest())
            var total: String = ""
            for i in 0 ..< dataTimer.count {
                total = dataTimer[i].rate ?? ""
                print("FFFFFFF\(total)")
            }
            firstScreenView.lableBitcoin.text = total
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func getData() -> Void {
        do {
            dataInfo = try context.fetch(Payments.fetchRequest()).reversed()
            var total: Double = 0.00
            for i in 0 ..< dataInfo.count {
                total += dataInfo[i].totalMoney as? Double ?? 0
                total -= dataInfo[i].transactions as? Double ?? 0
            }
            totalAmount = "$ " + (NSString(format: "%.2f", total as CVarArg) as String)
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    @objc func updateView() {
        viewWillAppear(true)
    }
}


extension FirstScreenViewController {
    
    func secondScreenView() {
        present(SecondScreenViewController(), animated: true)
    }
    
    func addMoneyPush() {
        firstScreenView.infoView.alpha = 1
        firstScreenView.tableView.isScrollEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return NumberFormatter().number(from: (firstScreenView.textField.text ?? "") + string) != nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != firstScreenView.infoView
        { UIView.transition(with: (view)!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.firstScreenView.infoView.alpha = 0
            self.firstScreenView.textField.text = ""
            self.firstScreenView.infoView.endEditing(true)
            self.firstScreenView.tableView.isScrollEnabled = true
        }) }
    }
    
    func closeAddMenu() {
        do { UIView.transition(with: (view), duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.firstScreenView.infoView.alpha = 0
            self.firstScreenView.textField.text = ""
            self.firstScreenView.infoView.endEditing(true)
            self.firstScreenView.tableView.isScrollEnabled = true
        }) }
    }
    
    func addMoney() {
        if firstScreenView.textField.text == "" {
            closeAddMenu()
        } else {
            do {
                let data = Payments(context: context)
                data.totalMoney = Decimal(string: firstScreenView.textField.text ?? "0") as? NSDecimalNumber
                data.date = NSDate() as Date
                try context.save()
                print("saved")
                print(data)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            viewWillAppear(true)
            closeAddMenu()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension FirstScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstScreenTableViewCell.cellName, for: indexPath) as? FirstScreenTableViewCell else {return UITableViewCell() }
        cell.configView(with: self)
        if dataInfo[indexPath.row].totalMoney == 0 {
            cell.moneyLabel.text =  "- $" + (NSString(format: "%.2f", (dataInfo[indexPath.row].transactions as! Double) as CVarArg) as String)
        } else {
            cell.moneyLabel.text =  "$" + (NSString(format: "%.2f", (dataInfo[indexPath.row].totalMoney as! Double) as CVarArg) as String)
        }
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formatteddate = formatter.string(from: (dataInfo[indexPath.row].date ?? time as Date) as Date)
        cell.timeLabel.text = "\(formatteddate)"
        if dataInfo[indexPath.row].category == nil {
            cell.categoryLabel.text = "Add Money"
            cell.categoryLabel.textColor = .red
        } else {
            cell.categoryLabel.text = dataInfo[indexPath.row].category
            cell.categoryLabel.textColor = .white
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if firstScreenView.infoView.alpha == 1 {
            closeAddMenu()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension FirstScreenViewController {
    
    func getDataJSON() {
        let infoUrl = "https://api.coindesk.com/v1/bpi/currentprice.json"
        guard let url = URL(string: infoUrl) else {return}
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
            }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(Product.self, from: data)
                    DispatchQueue.main.async {
                        self.firstScreenView.lableBitcoin.text = String(response.bpi.USD.rate_float)
                    }
                    print(response.bpi.USD.rate)
                    let date = NSDate()
                    print(date)
                }
                catch {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
}
