public class CookieCutter {

    private Decimal cir(Decimal r){
        Decimal fence = 2 * 3.14 * r;
        
        return fence;
	}
    
    private Decimal area(Decimal r){
        Decimal finalArea = 2 * 3.14 * r * r;
        
        return finalArea;
    }
    
    public List<Decimal> radius(Decimal r){
        List<Decimal> returnList = new List<Decimal>();

        returnList.add(area(r));
        returnList.add(cir(r));

        return returnList;
    }

}