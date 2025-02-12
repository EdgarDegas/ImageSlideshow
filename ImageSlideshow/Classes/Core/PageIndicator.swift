//
//  PageIndicator.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 27.05.18.
//

import UIKit

/// Cusotm Page Indicator can be used by implementing this protocol
public protocol PageIndicatorView: class {
    /// View of the page indicator
    var view: UIView { get }

    /// Current page of the page indicator
    var page: Int { get set }

    /// Total number of pages of the page indicator
    var numberOfPages: Int { get set}
}

extension UIPageControl: PageIndicatorView {
    public var view: UIView {
        return self
    }

    public var page: Int {
        get {
            return currentPage
        }
        set {
            currentPage = newValue
        }
    }

    open override func sizeToFit() {
        var frame = self.frame
        frame.size = size(forNumberOfPages: numberOfPages)
        frame.size.height = 30
        self.frame = frame
    }

    public static func withSlideshowColors() -> UIPageControl {
        let pageControl = UIPageControl()

        if #available(iOS 13.0, *) {
            pageControl.currentPageIndicatorTintColor = UIColor { traits in
                traits.userInterfaceStyle == .dark ? .white : .lightGray
            }
        } else {
            pageControl.currentPageIndicatorTintColor = .lightGray
        }
        
        if #available(iOS 13.0, *) {
            pageControl.pageIndicatorTintColor = UIColor { traits in
                traits.userInterfaceStyle == .dark ? .systemGray : .black
            }
        } else {
            pageControl.pageIndicatorTintColor = .black
        }

        return pageControl
    }
}

/// Page indicator that shows page in numeric style, eg. "5/21"
public class LabelPageIndicator: UILabel, PageIndicatorView {
    public var view: UIView {
        return self
    }

    public var numberOfPages: Int = 0 {
        didSet {
            updateLabel()
        }
    }

    public var page: Int = 0 {
        didSet {
            updateLabel()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        self.textAlignment = .center
    }

    private func updateLabel() {
        text = "\(page+1)/\(numberOfPages)"
    }

    public override func sizeToFit() {
        // e.g. there're 10 pages, use 88/88 as the possible widest string,
        // which is 2 digits and a slash sign
        let maximumDigitCount = String(numberOfPages).count * 2 + 1
        let maximumString = String(repeating: "8", count: maximumDigitCount)
        self.frame.size = maximumString.size(withAttributes: [.font: font as Any])
    }
}
