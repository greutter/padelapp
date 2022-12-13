import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "spinnerDiv", "contentDiv" ]
    
    connect() {
        console.log("Spinner controller connected", this.element);
        spinnerDiv.style.display = "none"
    }
    show() {
        console.log("Spinner show", this.element);
        contentDiv.style.display = "none" 
        spinnerDiv.style.display = "block";
    }
    hidde() {
        console.log("Spinner hidde", this.element);
        contentDiv.style.display = "block" 
        spinnerDiv.style.display = "none";
    }

}