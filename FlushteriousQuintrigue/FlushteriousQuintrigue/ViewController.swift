//
//  ViewController.swift
//  FlushteriousQuintrigue
//
//  Created by Sun on 2025/3/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension UIViewController {
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
                              
import UIKit

@IBDesignable
class ResponsiveLabel: UILabel {
    
    @IBInspectable var baseFontSize: CGFloat = 17 {
        didSet {
            adjustFontSize()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        adjustFontSize()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        adjustFontSize()
    }
    
    private func adjustFontSize() {
        let screenHeight = UIScreen.main.bounds.height
        let referenceHeight: CGFloat = 812 // Reference height for iPhone 11/12/13/14
        let scaleFactor = screenHeight / referenceHeight
        
        self.font = self.font.withSize(screenHeight / baseFontSize)
    }
}
import UIKit

//MARK: - View Properties (radius, border, shadow)
@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            
            // If masksToBounds is true, subviews will be
            // clipped to the rounded corners.
            layer.masksToBounds = (newValue > 0)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
