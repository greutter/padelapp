import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "spinnerDiv", "contentDiv" ]
    
    connect() {
        console.log(spinnerDiv.textContent, this.element);
        spinnerDiv.style.display = "none"
    }
    show() {
        contentDiv.style.display = "none" 
        spinnerDiv.style.display = "block";
    }
    hidde() {
        console.log(spinnerDiv.textContent, this.element);
        contentDiv.style.display = "block" 
        spinnerDiv.style.display = "none";
    }

}