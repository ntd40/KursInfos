import { LightningElement, api, track } from 'lwc';
import getContactList from '@salesforce/apex/trainerListController.getContactList';
import updateTrainerEventStatus from '@salesforce/apex/trainerListController.updateTrainerEventStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text', editable: false },
    { label: 'Einsatzstatus', fieldName: 'Einsatzstatus__c', type: 'text', editable: true },
    { label: 'Trainertyp', fieldName: 'Trainertyp__c', type: 'text', editable: true }
];

export default class TrainerListe extends LightningElement {
    @api recordId;
    @track contacts = [];
    columns = columns;
    error;

    connectedCallback() {
        this.loadContacts();
    }

    loadContacts() {
        getContactList({ MD_to_Auftragevent: this.recordId })
            .then(data => {
                this.contacts = data.map(trainerEvent => ({
                    Id: trainerEvent.Id,
                    Name: trainerEvent.MD_to_Contact__r.Name,
                    Trainertyp__c: trainerEvent.Trainertyp__c,
                    Einsatzstatus__c: trainerEvent.Einsatzstatus__c
                }));
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.contacts = undefined;
                console.error('Error retrieving contacts:', error);
            });
    }

    handleSave(event) {
        // Speichern der Änderungen
        const updatedFields = event.detail.draftValues;

        updateTrainerEventStatus({ trainerEvents: updatedFields })
            .then(() => {
                this.showToast('Success', 'Einsatzstatus erfolgreich aktualisiert', 'success');
                this.loadContacts();  // Kontakte neu laden, um aktualisierte Daten zu erhalten
            })
            .catch(error => {
                this.showToast('Error', 'Fehler beim Speichern des Einsatzstatus', 'error');
                console.error('Error saving changes:', error);
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    /*async refresh() {
        await refreshApex(this.contacts);
    }*/
}
