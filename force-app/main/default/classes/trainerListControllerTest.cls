@isTest
private class trainerListControllerTest {
    @isTest
    static void testGetContactList() {
        // Testdaten erstellen
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Auftrag__c testAuftrag = new Auftrag__c(Online__c = true, Unternehmensbereich__c = 'Tech and Teach');
        insert testAuftrag;
        
        Auftragevent__c testAuftragevent = new Auftragevent__c(Auftrag__c = testAuftrag.Id, Startzeit__c = Datetime.now(), Endzeit__c = Datetime.now());
        insert testAuftragevent;
        
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testAccount.Id);
        insert testContact;

        Trainer_Event__c testTrainerEvent = new Trainer_Event__c(
            MD_to_Auftragevent__c = testAuftragevent.Id,
            MD_to_Contact__c = testContact.Id,
            Einsatzstatus__c = 'Eingeteilt',
            Trainertyp__c = 'Hauptrainer*in'
        );
        insert testTrainerEvent;

        Test.startTest();
        
        // Testen der getContactList Methode
        List<Trainer_Event__c> result = trainerListController.getContactList(testAuftragevent.Id);
        System.assertEquals(1, result.size(), 'Expected 1 Trainer Event');
        System.assertEquals(testTrainerEvent.Id, result[0].Id, 'Trainer Event ID should match');
        
        Test.stopTest();
    }

    @isTest
    static void testUpdateTrainerEventStatus() {
        // Testdaten erstellen
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Auftrag__c testAuftrag = new Auftrag__c(Online__c = true, Unternehmensbereich__c = 'Tech and Teach');
        insert testAuftrag;
        
        Auftragevent__c testAuftragevent = new Auftragevent__c(Auftrag__c = testAuftrag.Id,  Startzeit__c = Datetime.now(), Endzeit__c = Datetime.now());
        insert testAuftragevent;

        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testAccount.Id);
        insert testContact;
        
        Trainer_Event__c testTrainerEvent = new Trainer_Event__c(
            MD_to_Auftragevent__c = testAuftragevent.Id,
            MD_to_Contact__c = testContact.Id,
            Einsatzstatus__c = 'Eingeteilt',
            Trainertyp__c = 'Hauptrainer*in'
        );
        insert testTrainerEvent;

        // Änderungen vorbereiten
        testTrainerEvent.Einsatzstatus__c = 'Abgelehnt';
        testTrainerEvent.Trainertyp__c = 'Co-Trainer*in';

        Test.startTest();
        
        // Testen der updateTrainerEventStatus Methode
        trainerListController.updateTrainerEventStatus(new List<Trainer_Event__c> { testTrainerEvent });
        
        // Holen des aktualisierten Datensatzes
        Trainer_Event__c updatedEvent = [SELECT Einsatzstatus__c, Trainertyp__c FROM Trainer_Event__c WHERE Id = :testTrainerEvent.Id];
        System.assertEquals('Abgelehnt', updatedEvent.Einsatzstatus__c, 'Einsatzstatus should be updated');
        System.assertEquals('Co-Trainer*in', updatedEvent.Trainertyp__c, 'Trainertyp should be updated');
        
        Test.stopTest();
    }
}