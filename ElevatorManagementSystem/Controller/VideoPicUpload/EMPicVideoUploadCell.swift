//
//  EMPicVideoUploadCell.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/12.
//

import UIKit

enum EMPicVideoUploadCellType {
    case category
    case textInput
    case videoUpload
    case picUpload
    case noteInput
}

typealias InputCallBack = (_ text:String)->Void

class EMPicVideoUploadCell: UITableViewCell {
    
    //MARK: category
    private lazy var calibrationLabel: UILabel = {
        let lab = UILabel()
        lab.text = "*选择记录类型:"
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.textColor = UIColor.B3
        return lab
    }()
    
    private lazy var doorLabel: UILabel = {
        let lab = UILabel()
        lab.text = "*零件类别:"
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.textColor = UIColor.B3
        return lab
    }()
    
    private lazy var calibrationBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 161, height: 60))
        btn.sg.setImage(location: .right, space: 60) { (btn) in
            btn.setImage(UIImage(named: "selected_arrow"), for: .selected)
            btn.setImage(UIImage(named: "deselect_arrow"), for: .normal)
            btn.setTitle(EMLocalizable("record_type"), for: .normal)
            btn.setTitleColor(UIColor.B3, for: .normal)
            btn.setTitleColor(UIColor.Main, for: .selected)
            btn.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
            btn.layer.cornerRadius = 8
            btn.layer.masksToBounds = true
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.tag = 100
            btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
        }
        return btn
    }()
    
    private  lazy  var doorBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 161, height: 60))
        btn.sg.setImage(location: .right, space: 60) { (btn) in
            btn.setImage(UIImage(named: "selected_arrow"), for: .selected)
            btn.setImage(UIImage(named: "deselect_arrow"), for: .normal)
            btn.setTitle(EMLocalizable("record_type"), for: .normal)
            btn.setTitleColor(UIColor.B3, for: .normal)
            btn.setTitleColor(UIColor.Main, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
            btn.layer.cornerRadius = 8
            btn.layer.masksToBounds = true
            btn.tag = 101
            btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
        }
        return btn
    }()
    
    //点击事件
    @objc private func didClickButton(sender:UIButton){
        EMAlertService.show(title: nil, message: nil, cancelTitle: "取消", otherTitles:["拍摄", "视频"] , style: .actionSheet) { title, index in
                NSLog("\(index) ---\(title)")
            }
    }
    
    private func setUpChooseTypeUI(){
        contentView.addSubview(self.calibrationLabel)
        contentView.addSubview(self.doorLabel)

        contentView.addSubview(self.calibrationBtn)
        contentView.addSubview(self.doorBtn)
        
        self.calibrationLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.width.equalTo(161)
            make.height.equalTo(20)
        }
        
        self.doorLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-20)
            make.width.equalTo(161)
            make.height.equalTo(20)
        }
        
        self.calibrationBtn.snp.makeConstraints { make in
            make.top.equalTo(self.calibrationLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.width.equalTo(161)
            make.height.equalTo(60)
        }
        
        self.doorBtn.snp.makeConstraints { make in
            make.top.equalTo(self.calibrationLabel.snp.bottom).offset(10)
            make.right.equalTo(-20)
            make.width.equalTo(161)
            make.height.equalTo(60)
        }

    }

    //MARK: textInput
    var inputCallBack:InputCallBack?

    var titleName:String = "" {

        didSet {
            self.titleLab.text = titleName
        }
    }
    
    var placeholder:String? {
        didSet {
            self.textField.placeholder = placeholder
        }
    }
    
    
    
    var data:String? {
        didSet {
            textField.text = data
        }
    }
    
    private lazy var titleLab:UILabel = {
        
        let lab = UILabel.init(frame: .zero)
        lab.textColor = UIColor.colorFormHex(0x333333)
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.text = "门与手机之间的距离："
        return lab
    }()
    
    private lazy var textField:UITextField = {
        
        let tf = UITextField()
        tf.textColor = UIColor.colorFormHex(0x333333)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .decimalPad
        tf.delegate = self
        return tf
    }()
    
    private lazy var desc:UILabel = {
        
        let lab = UILabel()
        lab.text = "CM"
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.B3
        return lab
    }()
    
    //MARK: videoUpload
    private lazy var videoTitleLab:UILabel = {
        
        let lab = UILabel.init(frame: .zero)
        lab.textColor = UIColor.colorFormHex(0x333333)
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.text = "视频："
        return lab
    }()
    
    private lazy var bgImageV: UIImageView = {
        
        let imagV = UIImageView.init(frame: .zero)
        imagV.image = UIImage(named: "")
        imagV.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
        return imagV
    }()
    
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if reuseIdentifier == EMPicVideoUploadController.kCategoryCell {
            setupUI(type: .category)
        }else if reuseIdentifier == EMPicVideoUploadController.kTextInputCell {
            setupUI(type: .textInput)
        }else if reuseIdentifier == EMPicVideoUploadController.kVideoUploadCell {
            setupUI(type: .videoUpload)
        }else if reuseIdentifier == EMPicVideoUploadController.kPicUploadCell {
            setupUI(type: .picUpload)
        }else if reuseIdentifier == EMPicVideoUploadController.kNoteInputCell {
            setupUI(type: .noteInput)
        }
    }
    
    func setupUI(type: EMPicVideoUploadCellType) -> Void {
        switch type {
        case .category:
            setUpChooseTypeUI()
            break
        case .textInput:
            setupTextFieldUI()
            break
        case .videoUpload:
            break
        case .picUpload:
            break
        case .noteInput:
            break
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension EMPicVideoUploadCell :UITextFieldDelegate {
    
    func setupTextFieldUI() {
        
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.colorFormHex(0xf7f7f7)
        bgView.layer.cornerRadius = 8
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20))
            make.top.equalTo(titleLab.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        
        bgView.addSubview(desc)
        desc.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
        
        bgView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.right.equalTo(desc.snp.left).offset(-10)
        }
        
    }
    
    ///MARK: textField delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let handler = inputCallBack {
            handler(textField.text ?? "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if string.count == 0{
            return true
        }
        // 被替换字符串的range 即将键入或者粘贴的string
        let checkStr = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let regex = "^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$"
        return self.isValid(checkStr: checkStr!, regex: regex)
    }
    
    func isValid(checkStr:String, regex:String) ->Bool {
        
        let predicte = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicte.evaluate(with: checkStr)
    }
}
