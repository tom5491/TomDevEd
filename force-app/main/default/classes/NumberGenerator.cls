public class NumberGenerator {
    //public class defined using class keyword and name NumberGenerator
    
    public List<Integer> fibonacci(Integer n){
    	//1st method defined with scope as private, static modifier (?), data type list of integers,
    	//name of fibonacci and input of data type integer call n 
        
        List<Integer> finalList = new List<Integer>();
        Integer a = 0, b = 1;
        Integer c;
        //define variables for use in later calculations
        
        finalList.add(a);
        finalList.add(b);
        //add variables to calculations outside for loop
        
        for(Integer i = 0; i < n-2; i++){
            c = a + b;
            finalList.add(c);
            a = b;
            b = c;
        }
        //inside for loop, add a and b together to get c, add c to List of integers, change value of
        // a to b and b to c for next interation in for loop and repeat until for loop exit condition = true
        
        return finalList;
        // return list of integers
    }
    
    public List<Integer> fibonacci(Integer n, Integer s){
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

    	return returnList;
        
    }

}