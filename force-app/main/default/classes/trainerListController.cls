public with sharing class trainerListController {
    @AuraEnabled(cacheable=true)
    public static List<Trainer_Event__c> getContactList(String MD_to_Auftragevent) {
        System.debug('MD_to_Auftragevent: ' + MD_to_Auftragevent);

        // Abrufen von Trainer Events direkt basierend auf der Überprüfung von Auftrag__c
        List<Trainer_Event__c> trainerEvents;

        // Eine SOQL-Abfrage zum Abrufen von Auftragsereignissen
        List<Auftragevent__c> auftragEvents = [
            SELECT Id
            FROM Auftragevent__c
            WHERE Auftrag__c = :MD_to_Auftragevent
        ];

        // Wenn keine Auftragsereignisse gefunden werden, suchen wir direkt nach Trainer Events
        if (auftragEvents.isEmpty()) {
            trainerEvents = [
                SELECT Id, MD_to_Contact__r.Name, Einsatzstatus__c,Trainertyp__c
                FROM Trainer_Event__c
                WHERE MD_to_Auftragevent__c = :MD_to_Auftragevent
            ];
        } else {
            // Abrufen von Trainer Events für alle gefundenen Auftragsereignisse
   

            trainerEvents = [
                SELECT Id, MD_to_Contact__r.Name, Einsatzstatus__c, Trainertyp__c
                FROM Trainer_Event__c
                WHERE MD_to_Auftragevent__c IN :auftragEvents
            ];
        }

        System.debug('Trainer Events: ' + trainerEvents);
        return trainerEvents;
    }

    @AuraEnabled
    public static void updateTrainerEventStatus(List<Trainer_Event__c> trainerEvents) {
        try {
            update trainerEvents;
        } catch (DmlException e) {
            throw new AuraHandledException('Fehler beim Speichern des Einsatzstatus: ' + e.getMessage());
        }
    }
}
