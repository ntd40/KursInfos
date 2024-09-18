import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

// Lookup-Feld in Auftrag__c, das auf Kurs__c verweist
import KURS_FIELD from '@salesforce/schema/Auftrag__c.Kurs__c';

// Felder aus Kurs__c
import SOFTWARELINKS_FIELD from '@salesforce/schema/Kurs__c.Softwarelinks__c';
import ARBEITSBLATTER_FIELD from '@salesforce/schema/Kurs__c.Arbeitsbl_tter__c';
import BASTELMATERIAL_FIELD from '@salesforce/schema/Kurs__c.Bastelmaterial__c';
import HARDWARE_FIELD from '@salesforce/schema/Kurs__c.Hardware__c';



export default class AuftragKursDetails extends LightningElement {
    @api recordId; // Auftrag__c Datensatz-ID

    kursId;

    @wire(getRecord, { recordId: '$recordId', fields: [KURS_FIELD] })
    wiredAuftrag({ error, data }) {
        if (data) {
            this.kursId = getFieldValue(data, KURS_FIELD);
        } else if (error) {
            console.error('Error loading Auftrag:', error);
        }
    }

    @wire(getRecord, { recordId: '$kursId', fields: [SOFTWARELINKS_FIELD, ARBEITSBLATTER_FIELD, BASTELMATERIAL_FIELD, HARDWARE_FIELD]})
    kursRecord;

    get softwareLinks() {
        return getFieldValue(this.kursRecord.data, SOFTWARELINKS_FIELD);
    }

    get arbeitsblaetter() {
        return getFieldValue(this.kursRecord.data, ARBEITSBLATTER_FIELD);
    }

    get bastelmaterial() {
        return getFieldValue(this.kursRecord.data, BASTELMATERIAL_FIELD);
    }

    get hardware() {
        return getFieldValue(this.kursRecord.data, HARDWARE_FIELD);
    }

    get hasData() {
        return this.kursRecord?.data && this.kursId;
    }

    get hasError() {
        return this.kursRecord?.error;
    }
}

