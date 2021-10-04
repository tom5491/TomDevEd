public without sharing class FlowFindCollection_WithoutSharing {
    public static list<sobject> FlowFindCollection_WithoutSharing(string soql, list<id> ListOfIds) {
        system.debug('FlowFindCollection_WithoutSharing');
        return Database.query(soql);
    }
    public static Search.SearchResults FlowSearchCollection_WithoutSharing(string sosl) {
        return Search.find(sosl);
    }    
}