//
//  EMPicVideoUploadCell+Data.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/28.
//

import Foundation
import UIKit

//用于数据处理
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

