public with sharing class FlowFindCollection{
    
    // defines the input parameters of this flow element in the canvas designer
    public class Requests { 
        
        @InvocableVariable(label='FieldApiIName - to return' description='Comma serperated list of api names' required=true)
        public string FieldApiINames;
        
        @InvocableVariable(label='Where Clause' description='eg. where createddate = last_n_years:2' required=false)
        public string WhereClause;
        
        @InvocableVariable(label='ObJect API Name' description='eg. Account or custom__c' required=true)
        public string sObjectName;
        
        @InvocableVariable(label='List Of Ids' description='' required=false)
        public list<Id> IdsList;
        
        @InvocableVariable(label='Bypass sharing rules' description='' required=false)
        public boolean BypassSharing;
        
        @InvocableVariable(label='Search Queries - list of values to search for' description='A list of queries / search terms to apply to the SOSL search' required=false)
        public List<String> queries;
        
        @InvocableVariable(label='Search Scope' description='The scope of the SOSL search (default ALL FIELDS)')
        public String scope;
    } 
    
    public class Results {     
        @InvocableVariable
        public list<SObject> outputCollection;
    }   
    
    @InvocableMethod(label='Get Collection as SObject' description=' ')
    public static List <Results>  execute( List<Requests> requests ) {
        
        //Ini repsonse
        List<Results> responseWrapper= new List<Results>();
        
        //Start loop
        for ( Requests request : requests ) {
            //Vars
            List<Id> ListOfIds = request.IdsList;
            Results response = new Results();
            response.outputCollection = new list<SObject>();
            //add ID field to apinames if missing
            request.FieldApiINames = string.isBlank(request.FieldApiINames) ? 'id' : request.FieldApiINames;
            string fieldAPINames_commaSepereated =  request.FieldApiINames.containsIgnoreCase('id') ?  request.FieldApiINames : ' Id,'+ request.FieldApiINames ;
            
            //SELECT
            if(request.queries==null){
                string WhereClause = '';
                WhereClause += request.WhereClause == null ? '' : request.WhereClause;
                //Has IN LISt
                if(request.IdsList!=null){
                    WhereClause += request.WhereClause == null ? '' : ' AND ';
                    WhereClause +=  ' Id IN :ListOfIds';
                }
                
                //Where not blank so add in WHERE
                WhereClause = WhereClause == '' ? '' :  ' WHERE '+WhereClause; 
                string selectClause =  fieldAPINames_commaSepereated;
                
                //create soql string
                string soql =  'SELECT '+selectClause+' FROM '+request.sObjectName+' '+WhereClause;
                system.debug('FlowFindCollectiong____'+soql);
                
                //---SHARING---//
                //Run query with or without sharing
                if(request.BypassSharing==true){
                    response.outputCollection = FlowFindCollection_WithoutSharing.FlowFindCollection_WithoutSharing(soql,ListOfIds);
                }else{
                    //No sharing
                    response.outputCollection =  Database.query(soql);
                }
                
                //system.debug(response.outputCollection);
                responseWrapper.add(response);
            }
            
            //------------SEARCH-------------//
            // Build Query String
            if(request.queries!=null){
                String queryString = '\'' + String.join(request.queries, ' OR ') + '\'';
                System.debug('FlowFindCollection__execute queryString >>>'+queryString);
                // Build SOSL
                String sosl = String.format('FIND {0}{1} RETURNING {2}('+fieldAPINames_commaSepereated+'{3})', new String[]{
                    queryString,
                        String.isNotBlank(request.scope) ? ' IN ' + request.scope : '', request.sObjectName,
                            String.isNotBlank(request.whereClause) ? ' WHERE ' + request.whereClause : ''
                                });
                System.debug('FlowFindCollection__execute sosl >>>'+sosl);
                // Execute the SOSL search
                Search.SearchResults searchResults;
                if(request.BypassSharing==true){
                    searchResults = FlowFindCollection_WithoutSharing.FlowSearchCollection_WithoutSharing(sosl);
                }
                else{
                    searchResults = Search.find(sosl);
                }
                
                // Get the list of SObject results
                List<Search.SearchResult> recordList = searchResults.get(request.sObjectName);
                // populate the sobject
                for (Search.SearchResult searchResult : recordList) {
                    SObject record = searchResult.getSObject();
                    response.outputCollection.add(record);
                } 
                
                responseWrapper.add(response);
            }
        } 
        //end loop   
        
        return responseWrapper;
    }
}