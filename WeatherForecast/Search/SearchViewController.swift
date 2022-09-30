//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 30/9/2022.
//

import UIKit

class SearchViewController: UIViewController {

    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Palette.mainTextColor
    
        setupViews()
        setupNavButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - subviews
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    private lazy var searchTextField: UITextField = {
        let text = UITextField()
//        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = Palette.mainTextColor
//        text.layer.borderColor = Palette.mainTextColor.cgColor
//        text.layer.borderWidth = 1
        text.layer.cornerRadius = 4
        text.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        text.tintColor = .lightGray
//        text.autocapitalizationType = .none
        text.textColor = Palette.secondTextColor
        text.placeholder = "Enter some city..."
        text.placeholderColor(color: .lightGray)
        text.textAlignment = .left
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: text.frame.height))
        text.leftViewMode = .always
        text.becomeFirstResponder()
        
        text.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return text
    }()
    
    //MARK: - methods
    private func setupNavButtons() {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_back") , style: .done, target: self, action: #selector(leftBtnTapped))
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_search"), style: .plain, target: self, action: #selector(rightBtnTapped))
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc private func textChanged() {
        if searchTextField.text?.count ?? 0 > 2 {
            print(searchTextField.text ?? "nil")
            ForecastViewModel(dataModel: ForecastDataModel().self).getForecastFromCityName(searchTextField.text ?? "") { data in
                
                
            }
        }
        
//        print(self.searchTextField.actions(forTarget: self, forControlEvent: .editingDidEnd))
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            print(self.searchTextField.isEditing)
//        }
    }
    
    @objc private func leftBtnTapped() {
        print("left tapped")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightBtnTapped() {
        print("right tapped")
    }

}
// MARK: - setup views
extension SearchViewController {
    private func setupViews() {
        self.navigationItem.titleView = searchTextField
        self.searchTextField.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 30)
        view.backgroundColor = Palette.mainTintColor
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.backgroundColor = Palette.mainTextColor
//        contentView.addSubview(searchTextField)
//        contentView.addSubview(cancelButton)
//        contentView.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
//            searchTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            searchTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
//            searchTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            searchTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
// MARK: - setupKeyboard
private extension SearchViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}
