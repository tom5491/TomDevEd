public class fibonacciFinder {
    //public class defined using class keyword and name NumberGenerator
    
    public static void fibonacci(Integer p){
    	//1st method defined with scope as private, static modifier (?), data type list of integers,
    	//name of fibonacci and input of data type integer call n 
        
        List<Integer> finalList = new List<Integer>();
        Integer a = 0, b = 1;
        Integer c;
        Integer d = 0;
        Integer e;
        Integer f;
        Integer count = 1;
        //define variables for use in later calculations
        
        finalList.add(a);
        finalList.add(b);
        //add variables to calculations outside for loop
        
        do {
            c = a + b;
            if(c < p) {             	                                             
                finalList.add(c);
            	a = b;
            	b = c;
                count = count + 1;
                
            } else {
                count = count + 1;
            }
            
        } while(c<p);
        
        	e = c - p;
          	f = p - b;
        
        if(e < f) {
                    System.debug('The nearest Finonacci Number is: ' + c + ', Count: ' + count);
                    finalList.add(c);
                } else {
                    count = count - 1;
                    System.debug('The nearest Fibonacci Number is: ' + b + ', Count: ' + count);
                    finalList.add(b);
                }
        
        system.debug(finalList);
    
    /*private void fOne(Integer n, Integer s){
    //Define method (Scope, Modifier, Return_dataType, Name(Input Parameters))

    	List<Integer> returnList = new List<Integer>();
    	Integer a = 1, b = s;
    	Integer c;
    	//Define variables needed for later calculations, adding input parameter s as 2nd Integer value

    	returnList.add(a);
    	returnList.add(b);
    	//add first two sequence numbers to list outside of forLoop 
    
    	for(Integer i = 0; i < n-2; i++){
      		c = a + b;
      		returnList.add(c);
      		a = b;
      		b = c;
    	}
        
    }
    */
        
    
    
        
        
       
    }
	    
}