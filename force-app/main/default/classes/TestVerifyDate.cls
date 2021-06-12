@isTest
public class TestVerifyDate{
    static testMethod void TestCheckDates(){
        Date Date1 = Date.newInstance(2020, 07, 09);
        Date Date2 = Date.newInstance(2020, 07, 27);

        Date result = VerifyDate.CheckDates(Date1, Date2);
        
        System.assertEquals(Date2, result, 'Date 2 not within next 30 Days of Date 1');
    }
    static testMethod void TestCheckDates2(){
        Date Date1 = Date.newInstance(2020, 07, 09);
        Date Date2 = Date.newInstance(2020, 08, 15);

        Date result = VerifyDate.CheckDates(Date1, Date2);
        
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
        Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, result, 'Date 2 is within next 30 Days of Date 1');
    }
}