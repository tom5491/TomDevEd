public class ParkLocator {
    public static String[] country(String country){
        ParkService.ParksImplPort psbc = new ParkService.ParksImplPort();
        String[] countryList = psbc.byCountry(country);
        return countryList;
    }
}