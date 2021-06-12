public class FirstNameHelper{

    public static void ReplaceName(List<Contact> con){
        
        List<Contact> newList = [SELECT Id, FirstName FROM Contact WHERE Id IN :con];
        
        List<Contact> finalList = new List<Contact>();
		        
        for (Contact iterator: newList){
            if(iterator.FirstName == 'John'){
                iterator.FirstName = 'Test';
                finalList.add(iterator);
            }
        }

        update finalList;
    }
}