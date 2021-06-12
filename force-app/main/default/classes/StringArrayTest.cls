public class StringArrayTest {
	// public method
        
    public static List<String> generateStringArray(Integer n){
        
        List<String> c = new List<String>();
        String testName;
        
        for(Integer i = 0; i < n; i++){
        	
            testName = ('Test ' + i);
        	c.add(testName);
        }	
	
        return c;
        
     }
         
}