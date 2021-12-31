//
//  EMPicVideoUploadCell+Data.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/28.
//

import Foundation
import UIKit

//用于数据处理
//处理记录类型和零件类别
extension EMPicVideoUploadCell {
    
    
    func chooseRecordOrPart(type: EMPubType) {
            
            EMPubRequestService.fetchPubType(type) {[weak self] entity in
                
                guard let self = self else {
                    return
                }
                if let dataArray = entity.data {
                    
                    var tempDict :[String: String] = Dictionary()
                    var tempArray: [String] = Array()
                    
                    for entity in dataArray {
                        
                        let entityItem = entity as EMChooseTypeItemEntity
                        
                        tempDict.updateValue(entityItem.sysId!, forKey: entityItem.sysValue!)
                        
                        tempArray.append(entityItem.sysValue!)
                    }
                    
                    EMAlertService.show(title: nil, message: nil, cancelTitle: EMLocalizable("alert_cancel"), otherTitles:tempArray , style: .actionSheet) { action, index in
                        
                        
                        NSLog("\(index) ---\(action)")
                        
                        if let title = action.title, index != 0 {
                            
                            if type == .records {
                                
                                self.calibrationBtn.setTitle(title, for: .normal)
                               
                                self.selectRecordPartCallBack?(tempDict[title] ?? "", .records)

                            }else {
                                
                                self.doorBtn.setTitle(title, for: .normal)
                                
                                self.selectRecordPartCallBack?(tempDict[title] ?? "", .part)


                            }
                            
                        }
                        

                    }
                }
                
            }
        }
    
}

//处理门与手机之间的距离输入
extension EMPicVideoUploadCell :UITextFieldDelegate {
    
    
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

//处理备注信息
extension EMPicVideoUploadCell: UITextViewDelegate {
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        UIView.animate(withDuration: 0.25) {
            self.superTableView()?.y = self.superTableView()!.y - 200
            self.superTableView()?.scrollToRow(at: IndexPath(row: 4, section: 0), at: .top, animated: true)
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        self.remarkInputCallBack?(textView.text)
        
        UIView.animate(withDuration: 0.25) {
            self.superTableView()?.y = self.superTableView()!.y + 200
        }
        return true
    }
    
    func  superTableView() ->  UITableView? {
             for  view  in  sequence(first:  self .superview, next: { $0?.superview }) {
                 if  let  tableView = view  as?  UITableView  {
                     return  tableView
                 }
             }
             return  nil
         }
}



