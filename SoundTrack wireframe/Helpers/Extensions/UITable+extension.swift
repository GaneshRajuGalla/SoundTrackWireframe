//
//  UITable+extension.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//


import Foundation
import UIKit


extension UITableView
{
    func addEmptyLabel(_ msg: String)
    {
        let emptyLabel            = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        emptyLabel.textColor      = .appBlack
        emptyLabel.text           = msg
        emptyLabel.font           = UIFont.systemFont(ofSize: 12.0)
        emptyLabel.textAlignment  = .center
        emptyLabel.numberOfLines  = 0
        self.backgroundView       = emptyLabel
        self.separatorStyle       = .none
    }
    
    func removeEmptyLabel(){
        self.backgroundView       = nil
    }
    
    func registerNib<Cell: UITableViewCell>(cell: Cell.Type) {
        let nibName = String(describing: Cell.self)
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func scrollToBottom(animated: Bool) {
        let indexPath = IndexPath(
            row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
            section: self.numberOfSections - 1)
        if self.hasRowAtIndexPath(indexPath: indexPath) {
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
extension UICollectionView{
    func registerNib<Cell: UICollectionViewCell>(cell: Cell.Type) {
        let nibName = String(describing: Cell.self)
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
