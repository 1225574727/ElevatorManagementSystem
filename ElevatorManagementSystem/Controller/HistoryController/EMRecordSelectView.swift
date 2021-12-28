//
//  EMRecordSelectView.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/12/11.
//

import UIKit

enum SeletType {
    case record
    case part
    case result
    case time
}

struct ScreenInfo {
    static let Frame = UIScreen.main.bounds
    static let Height = Frame.height
    static let Width = Frame.width
    static let navigationHeight:CGFloat = navBarHeight()

    static func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    static private func navBarHeight() -> CGFloat {
        return isIphoneX() ? 88 : 64
    }
}


class EMRecordSelectView: UIView {
    
    typealias SelectCallBack = (_ type: SeletType, _ isSelected: Bool) -> ()
    
    var selectCallBack: SelectCallBack?
    
    var recordBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 82, height: 17))
        btn.sg.setImage(location: .right, space: 2) { (btn) in
            btn.setImage(UIImage(named: "selected_arrow"), for: .selected)
            btn.setImage(UIImage(named: "deselect_arrow"), for: .normal)
            btn.setTitle(EMLocalizable("record_type"), for: .normal)
            btn.setTitleColor(UIColor.B9, for: .normal)
            btn.setTitleColor(UIColor.Main, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.tag = 100
            btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
        }
        return btn
    }()
    
    var typeBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 82, height: 17))
        btn.sg.setImage(location: .right, space: 2) { (btn) in
            btn.setImage(UIImage(named: "selected_arrow"), for: .selected)
            btn.setImage(UIImage(named: "deselect_arrow"), for: .normal)
            btn.setTitle(EMLocalizable("parts_category"), for: .normal)
            btn.setTitleColor(UIColor.B9, for: .normal)
            btn.setTitleColor(UIColor.Main, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.tag = 101
            btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
        }
        return btn
    }()
    
    var resultBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 82, height: 17))
        btn.sg.setImage(location: .right, space: 2) { (btn) in
            btn.setImage(UIImage(named: "selected_arrow"), for: .selected)
            btn.setImage(UIImage(named: "deselect_arrow"), for: .normal)
            btn.setTitle(EMLocalizable("result_state"), for: .normal)
            btn.setTitleColor(UIColor.B9, for: .normal)
            btn.setTitleColor(UIColor.Main, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.tag = 102
            btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
        }
        return btn
    }()
    
    var timeBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 82, height: 17))
        btn.sg.setImage(location: .right, space: 2) { (btn) in
            btn.setImage(UIImage(named: "selected_arrow"), for: .selected)
            btn.setImage(UIImage(named: "deselect_arrow"), for: .normal)
            btn.setTitle(EMLocalizable("record_time"), for: .normal)
            btn.setTitleColor(UIColor.B9, for: .normal)
            btn.setTitleColor(UIColor.Main, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.tag = 103
            btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
        }
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubViews()
    }
    
    private func addSubViews() {
        self.addSubview(recordBtn)
        self.addSubview(typeBtn)
        self.addSubview(resultBtn)
        self.addSubview(timeBtn)

        let intervalDistance = (self.frame.width - 305) / 5
        recordBtn.snp.makeConstraints { make in
            make.width.equalTo(82)
            make.height.equalTo(56)
            make.centerY.equalToSuperview()
            make.left.equalTo(intervalDistance)
        }
        
        typeBtn.snp.makeConstraints { make in
            make.width.equalTo(82)
            make.height.equalTo(56)
            make.centerY.equalToSuperview()
            make.left.equalTo(recordBtn.snp.right).offset(intervalDistance)
        }
        
        resultBtn.snp.makeConstraints { make in
            make.width.equalTo(82)
            make.height.equalTo(56)
            make.centerY.equalToSuperview()
            make.left.equalTo(typeBtn.snp.right).offset(intervalDistance)
        }
        
        timeBtn.snp.makeConstraints { make in
            make.width.equalTo(59)
            make.height.equalTo(56)
            make.centerY.equalToSuperview()
            make.left.equalTo(resultBtn.snp.right).offset(intervalDistance)
        }
    }
    
    @objc private func didClickButton(sender:UIButton){
        
        var type: SeletType = .record
        var isSelected: Bool = false
        
        switch sender.tag {
            case 100:
                self.recordBtn.isSelected = !self.recordBtn.isSelected
                self.typeBtn.isSelected = false
                self.resultBtn.isSelected = false
                self.timeBtn.isSelected = false
                type = .record
                isSelected = self.recordBtn.isSelected
                break
            case 101:
                self.recordBtn.isSelected = false
                self.typeBtn.isSelected = !self.typeBtn.isSelected
                self.resultBtn.isSelected = false
                self.timeBtn.isSelected = false
                type = .part
                isSelected = self.typeBtn.isSelected

                break
            case 102:
                self.recordBtn.isSelected = false
                self.typeBtn.isSelected = false
                self.resultBtn.isSelected = !self.resultBtn.isSelected
                self.timeBtn.isSelected = false
                type = .result
                isSelected = self.resultBtn.isSelected

                break
            case 103:
                self.recordBtn.isSelected = false
                self.typeBtn.isSelected = false
                self.resultBtn.isSelected = false
                self.timeBtn.isSelected = !self.timeBtn.isSelected
                type = .time
                isSelected = self.timeBtn.isSelected

                break
            
            default:
                break
        }
        
        if let select = selectCallBack {
            select(type, isSelected)
        }
//        self.dismissAnimation()
//        if let handler = actionHandler {
//            handler(sender.tag - 2017)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EMRecordResultView: UIView {
    
    static let kEMRecordResultViewCell = "kEMRecordResultViewCell"
    
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())
    
    var backDate: ((Date) -> Void)?
    
    var selectCallBack: ((_ type: SeletType, _ item: EMChooseTypeItemEntity) -> Void)?
    
    var msgArray: [EMChooseTypeItemEntity] = []
    
    var currentSelectType: SeletType = .record
    
    var selectView: EMRecordSelectView?

    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: EMRecordResultView.kEMRecordResultViewCell)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorColor = .clear
        tableview.backgroundColor = .white
        tableview.sectionFooterHeight = 0
        tableview.sectionHeaderHeight = 0
        return tableview
    }()
    
    lazy var datePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.clear
        picker.clipsToBounds = true
        return picker
    }()
    
    lazy var sureBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("确认选择", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .Main
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 24
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
//        self.msgArray = [
//            EMLocalizable("elevator_management"),
//            EMLocalizable("video_upload"),
//            EMLocalizable("history"),
//            EMLocalizable("video_upload"),
//            EMLocalizable("history")
//        ]
        
        self.addSubview(tableView)
        self.addSubview(datePicker)
        self.addSubview(sureBtn)
        datePicker.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(150)
        }
        
        sureBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(48)
            make.bottom.equalTo(-26)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
       

        
    }
    
    func reloadDatePicker() {
        self.datePicker.selectRow(11, inComponent: 1, animated: true)
        self.datePicker.selectRow(10, inComponent: 2, animated: true)
        self.datePicker.selectRow(2021, inComponent: 0, animated: false)
    }
    
    func chooseDatePicker(isSelected: Bool) -> Void {
        if isSelected {
            tableView.isHidden = true
            datePicker.isHidden = false
            sureBtn.isHidden = false
        }else {
            tableView.isHidden = false
            datePicker.isHidden = true
            sureBtn.isHidden = true
        }
    }
    
    func reloadRecordViewData(view: EMRecordSelectView, type: SeletType, dataArray: [EMChooseTypeItemEntity]?){
        
        selectView = view
        
        currentSelectType = type
        
        if dataArray != nil {
            
            self.msgArray = dataArray!
            
            self.msgArray.insert(EMChooseTypeItemEntity(color: nil, judgeType: nil, number: nil, sysCategory: nil, sysId: nil, sysValue: "不限", updateDate: nil), at: 0)
            
            EMEventAtMain {
                self.tableView.reloadData()
            }
        }
    }
    
    //点击事件
    @objc private func didClickButton(sender:UIButton){
        let dateString = String(format: "%02ld-%02ld-%02ld", self.datePicker.selectedRow(inComponent: 0) + (self.currentDateCom.year!), self.datePicker.selectedRow(inComponent: 1) + 1, self.datePicker.selectedRow(inComponent: 2) + 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        /// 直接回调显示
        if self.backDate != nil {
            self.backDate!(dateFormatter.date(from: dateString) ?? Date())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EMRecordResultView: UITableViewDataSource, UITableViewDelegate {
    
    //MARK:UITableViewDataSource&& UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: EMRecordResultView.kEMRecordResultViewCell, for: indexPath)
        
        let model: EMChooseTypeItemEntity = msgArray[indexPath.row]
        cell.textLabel?.text = model.sysValue
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.B3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model: EMChooseTypeItemEntity = msgArray[indexPath.row]
        
        var defalutValue: String = EMLocalizable("record_type")
        
        let btnStyle: UIControl.State =  .normal
        
        if currentSelectType == .record {
            defalutValue = EMLocalizable("record_type")
            
            let selectValue = indexPath.row == 0 ? defalutValue : model.sysValue

            if selectView != nil {
                selectView?.recordBtn.setTitle(selectValue, for: btnStyle)
                selectView?.recordBtn.isSelected = false
            }
        }else if currentSelectType == .part {
            defalutValue = EMLocalizable("parts_category")
            
            let selectValue = indexPath.row == 0 ? defalutValue : model.sysValue

            if selectView != nil {
                selectView?.typeBtn.setTitle(selectValue, for: btnStyle)
                selectView?.typeBtn.isSelected = false
            }
        }else if currentSelectType == .result {
            defalutValue = EMLocalizable("result_state")
            
            let selectValue = indexPath.row == 0 ? defalutValue : model.sysValue

            if selectView != nil {
                selectView?.resultBtn.setTitle(selectValue, for: btnStyle)
                selectView?.resultBtn.isSelected = false
            }
        }
        
       
        selectCallBack?(currentSelectType, model)
        
        
    }

}

extension EMRecordResultView: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 20
        } else if component == 1 {
            return 12
        } else {
            let year: Int = pickerView.selectedRow(inComponent: 0) + currentDateCom.year!
            let month: Int = pickerView.selectedRow(inComponent: 1) + 1
            let days: Int = howManyDays(inThisYear: year, withMonth: month)
            return days
        }
    }
    private func howManyDays(inThisYear year: Int, withMonth month: Int) -> Int {
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31
        }
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30
        }
        if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return ScreenInfo.Width / 3
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\((currentDateCom.year! - 10) + row)\("年")"
        } else if component == 1 {
            return "\(row + 1)\("月")"
        } else {
            return "\(row + 1)\("日")"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            pickerView.reloadComponent(2)
    }
}
