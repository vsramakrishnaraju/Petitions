//
//  DetailViewController.swift
//  Project7
//
//  Created by Venkata K on 1/10/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    var heading: String = ""
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        // Define the HTML string
        let html = """
        <html>
        <head>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <script src="script.js"></script>
        </head>
        <body>
        <h1> \(heading) </h1>
        <p id="textToChange">This text will change when the button is clicked.</p>
        <button onclick="updateText()">Click me to change text</button>
        <h2> \(detailItem.body) </h2>
        </body>
        </html>
        """
        
        // Load the HTML string into the web view
        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
}
