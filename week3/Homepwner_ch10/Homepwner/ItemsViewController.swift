//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by User on 2017. 7. 14..
//  Copyright © 2017년 Ji-Yong Jeong. All rights reserved.
//

//import Foundation
import UIKit


class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    var expensiveItem = [Item?]()
    var cheapItem = [Item?]()
    let sectionArray = ["고가", "저가"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 상태 바의 높이를 얻는다.
        tableViewLocationSetting()
        
        // 아이템 리스트를 초기화 하고 가격대별로 구분한다.
        initializeDictionary()
        
        // 항상 마지막 행에 특정 셀을 추가하기.
        addLastRow()
        
        // 테이블 뷰 배경이미지 설정
        setBackgroundImage()
    }
    
    func setBackgroundImage(){
        let imageView = UIImageView(image: UIImage(named: "sky.jpeg"))
        imageView.frame = self.tableView.frame
        self.tableView.backgroundView = imageView
    }
    
    // ch9 금메댤 과제 - 각 셀의 배경을 지움.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    // ch9 은메달 과제.
    func addLastRow() {
        expensiveItem.append(nil)
        cheapItem.append(nil)
        dump(expensiveItem)
        dump(cheapItem)
        print(expensiveItem.count)
        print(cheapItem.count)
    }

    func initializeDictionary(){
        let item2 = itemStore.allItems
        
        for i in 0..<item2.count {
            if item2[i].valueInDollars >= 50 {
                expensiveItem.append(item2[i])
            } else {
                cheapItem.append(item2[i])
            }
        }
    }
    
    // TableView에 필요한 정보를 넘겨주기위한 메서드 , 테이블뷰의 행 수 , 행 내용
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 각 섹션의 포함된 row 갯수만큼 출력.
        let rows = [expensiveItem, cheapItem]
        return rows[section].count
    }
    
    // 섹션 몇개?
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 섹션레이블의 값을 각각 리턴 [고가,저가]
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 재사용식별자의 셀인지 아닌지 확인하기 위해 Queue를 검사.
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        if indexPath.section == 0 {
            
            // ch9 은메달 과제. // 금메달 과제 폰트사이즈 조절.
            guard let checkedItem = expensiveItem[indexPath.row] else {
                cell.textLabel?.text = "No More Items!"
                cell.detailTextLabel?.text = ""
                return cell
            }
                cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
                cell.textLabel?.text = checkedItem.name
                cell.detailTextLabel?.text = "$\(checkedItem.valueInDollars)"
                return cell
            
        } else {
            if let checkedItem = cheapItem[indexPath.row] {
                
                cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
                cell.textLabel?.text = checkedItem.name
                cell.detailTextLabel?.text = "$\(checkedItem.valueInDollars)"
                return cell
            } else {
                cell.textLabel?.text = "No More Items!"
                cell.detailTextLabel?.text = ""
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // ch9 금메달과제 , 행 높이 설정하기. 중첩if안쓰는 방법생각해보기.
        if indexPath.section == 0 {
            if expensiveItem[indexPath.row] == nil {
                return 44
            } else {
                return 60
            }
        } else {
            if cheapItem[indexPath.row] == nil {
                return 44
            }
            return 60
        }
    }
    
    // 상태 바의 높이를 조정한다.
    func tableViewLocationSetting() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    // ch10 은메달 과제
    @IBAction func addNewItem(sender: AnyObject) {
        let newItem = itemStore.createItem()
        print(newItem.valueInDollars) // 확인용
        if newItem.valueInDollars >= 50 {
            expensiveItem.insert(newItem, at: expensiveItem.count - 1)
            let indexPath = IndexPath(row: expensiveItem.count - 2, section: 0)
            print(indexPath) // 확인용
            tableView.insertRows(at: [indexPath] , with: .automatic)
            
        } else {
                cheapItem.insert(newItem, at: cheapItem.count - 1 )
                let indexPath = IndexPath(row: cheapItem.count - 2, section: 1)
                print(indexPath) // 확인용
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                if indexPath.section == 0 {
                    let title = "Delete \(expensiveItem[indexPath.row]!.name)?"
                    let message = " Are you sure you want to delete this item ?"
                    let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    ac.addAction(cancelAction)
                    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                        (action) -> Void in
                        self.expensiveItem.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    })
                    ac.addAction(deleteAction)
                    self.present(ac, animated: true, completion: nil)
                    
            } else {
                    let title = "Delete \(cheapItem[indexPath.row]!.name)?"
                    let message = " Are you sure you want to delete this item ?"
                    let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    ac.addAction(cancelAction)
                    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                        (action) -> Void in
                        self.cheapItem.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    })
                    ac.addAction(deleteAction)
                    self.present(ac, animated: true, completion: nil)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath == IndexPath(row: expensiveItem.count - 1, section: 0) {
            return false
        } else if indexPath == IndexPath(row: cheapItem.count - 1, section: 1) {
            return false
        } else {
            return true
        }

    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
       
        if indexPath == IndexPath(row: expensiveItem.count - 1, section: 0) {
            return false
        } else if indexPath == IndexPath(row: cheapItem.count - 1, section: 1) {
            return false
        } else {
            return true
        }
    }

    // 줄 수정.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
    // ch10 동메달 과제
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if indexPath == IndexPath(row: expensiveItem.count - 1, section: 0) {
            return false
        } else if indexPath == IndexPath(row: cheapItem.count - 1, section: 1) {
            return false
        } else {
            return true
        }
    }
    
    // ch10 금메달 과제
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if proposedDestinationIndexPath == IndexPath(row: expensiveItem.count - 1, section: 0) {
            return sourceIndexPath
        } else if proposedDestinationIndexPath == IndexPath(row: cheapItem.count - 1, section: 1){
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
}
