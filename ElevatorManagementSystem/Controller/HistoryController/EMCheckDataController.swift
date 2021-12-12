//
//  EMCheckDataController.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/12.
//

import UIKit

class EMCheckDataController: EMBaseViewController {
    
    static let kEMCheckDataCell = "kEMCheckDataCell"

    var historyDataArray: [String] = Array()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: EMCheckDataController.kEMCheckDataCell)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorColor = .clear
        tableview.backgroundColor = .white
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = EMLocalizable("check_data")
        
       historyDataArray = ["https://img2.baidu.com/it/u=3875536202,2172052105&fm=26&fmt=auto","https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2Fmn02%2F123120155408%2F201231155408-0.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641873945&t=f7077a55b9768286acbe6a88867ef1b6","https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2Ftp03%2F1Z92419315I401-0-lp.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641873945&t=efff33d77f3ea673afe666b4addb7708","https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2F1011%2F01031Q45917%2F1P103145917-10.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641874128&t=dd90f1f56f43f2d832916e4913bd67c3","https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_source%2Fc5%2F89%2F0e%2Fc5890ee0b2472f75fa1a91d9305d5f09.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641874180&t=ba89a499a9d9e6c311222b8f3bc64065","https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg01.taopic.com%2F141206%2F318758-1412060G34858.jpg&refer=http%3A%2F%2Fimg01.taopic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641874180&t=4f3f33a76432b3f979ac4ed58f5a5c06"]
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        
    }
}

extension EMCheckDataController : UITableViewDataSource, UITableViewDelegate {
    //MARK:UITableViewDataSource&& UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: EMCheckDataCell? = tableView.dequeueReusableCell(withIdentifier: EMCheckDataController.kEMCheckDataCell) as? EMCheckDataCell
        if cell == nil {
            cell = EMCheckDataCell(style: .default, reuseIdentifier: EMCheckDataController.kEMCheckDataCell)
        }
        
        cell!.updateData(imageUrl: historyDataArray[indexPath.section])
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 292
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 17
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

