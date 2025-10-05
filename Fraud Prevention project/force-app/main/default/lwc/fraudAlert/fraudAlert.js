import { LightningElement, wire } from 'lwc';
import getFraudAlert from '@salesforce/apex/FraudAlertController.getFraudAlert';

const COLUMNS = [
    { label: 'Alert Name', fieldName: 'Name' },
    { label: 'Alert status', fieldName: 'status__c' },
    { label: 'transaction', fieldName: 'transaction__c' }
];

export default class FraudAlert extends LightningElement {
    columns = COLUMNS;

    @wire(getFraudAlert)
    alert;
}

