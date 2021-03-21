//
//  ViewController.swift
//  TP1Groupe6Mada
//
//  Created by mbds on 19/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    

    @IBOutlet weak var resultat: UILabel!
    
    
    
    @IBAction func buttonClicked(sender: UIButton){
        
        print(sender.tag)
        var temp = String(sender.tag)
        var boulean = true
        switch sender.tag{
            case 10 :
                temp = "+"
            case 11 :
                temp = "-"
            case 12 :
                temp = "/"
            case 13 :
                temp = "*"
            case 14 :
                boulean = false
                resultat.text = ""
            case 15 :
                boulean = false
                let stringWithMathematicalOperation: String = resultat.text!
                let exp: NSExpression = NSExpression(format: stringWithMathematicalOperation)
                let result: Double = exp.toFloatingPoint().expressionValue(with:nil, context: nil) as! Double
                resultat.text = String(result)
            case 16 :
                temp = "."
            default:
                print("Default")
        }
        if boulean{
            resultat.text = resultat.text! + temp
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension NSExpression {

    func toFloatingPoint() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
           let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
           return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
           return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .anyKey:
            fatalError("anyKey not yet implemented")
        case .block:
            fatalError("block not yet implemented")
        case .evaluatedObject, .variable, .keyPath:
            break // Nothing to do here
        }
        return self
    }
}
