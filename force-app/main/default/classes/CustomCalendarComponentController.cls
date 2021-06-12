public class CustomCalendarComponentController {

    @AuraEnabled
    public static WrapperClass initialMethod(){
        Date todayDate = System.today();
		WrapperClass wc = getDates(todayDate);
        wc.currentDate = todayDate;
        wc.monthName = getMonthName(wc.currentDate.month()) + ' ' + wc.currentDate.year();
            
        return wc;
    }
    
    @AuraEnabled
    public static WrapperClass changeMonthMethod(Date currentDate, String direction){
        
        Integer month = currentDate.month();
        Integer year = currentDate.year();
        
        Date newDate;
        
        if(direction == 'Previous'){
            if(month == 1){
                newDate = date.newInstance(year-1, 12, 1);
            } else {
                newDate = date.newInstance(year, month-1, 1);
            }
        } else {
            if(month == 12){
                newDate = date.newInstance(year+1, 1, 1);
            } else {
                newDate = date.newInstance(year, month+1, 1);
            }
        }
		WrapperClass wc = getDates(newDate);
        wc.currentDate = newDate;
        wc.monthName = getMonthName(wc.currentDate.month()) + ' ' + wc.currentDate.year();
        
        
        
        return wc;
    }
    
    private static WrapperClass getDates(Date currentlyInUseDate){
        Date firstDayDate = currentlyInUseDate.toStartOfMonth();
        //system.debug('firstDayDate: ' + firstDayDate);
        Date firstDayofWeekDate = firstDayDate.toStartOfWeek();
        //system.debug('firstDayofWeekDate: ' + firstDayofWeekDate);
        
        Integer daysInMonth = Date.daysInMonth(currentlyInUseDate.year(), currentlyInUseDate.month());
        Date firstDayinLastWeekDate = Date.newInstance(currentlyInUseDate.year(), currentlyInUseDate.month(), daysInMonth).toStartOfWeek();
        //system.debug('firstDayinLastWeekDate: ' + firstDayinLastWeekDate);
        Date lastDayInLastWeekDate = firstDayinLastWeekDate.addDays(+6);
        //system.debug('lastDayInLastWeekDate: ' + lastDayInLastWeekDate);
        
        List<Topic__c> topList = [SELECT Id, Name, Planner__c, Planner__r.Study_Date__c, Component__r.Name FROM Topic__c WHERE Planner__r.Study_Date__c >= :firstDayofWeekDate AND Planner__r.Study_Date__c <= :lastDayInLastWeekDate ORDER BY Planner__r.Study_Date__c ASC];
        Map<Date, List<Topic__c>> topMap = new Map<Date, List<Topic__c>>();
        
        /*Date tempDate;
        List<Topic__c> tempTopList = new List<Topic__c>();
        Integer topCount = 0;
        for(Topic__c top :topList){
            System.debug('Name: ' + top.Name);
            System.debug('Component: ' + top.Component__c);
            topCount++;
            if(tempDate == null){
                tempDate = top.Planner__r.Study_Date__c;
            }
            if(tempDate != top.Planner__r.Study_Date__c){
                System.debug('Name: ' + top.Name);
                System.debug('Component: ' + top.Component__r.Name);
                List<Topic__c> newTopList = tempTopList;
                topMap.put(tempDate, newTopList);
                system.debug(tempTopList.size());
                tempTopList.clear();
                system.debug(tempTopList.size());
                tempDate = top.Planner__r.Study_Date__c;
                system.debug(tempDate);
            }
            system.debug(tempTopList.size());
            tempTopList.add(top);
            system.debug(tempTopList.size());
            System.debug(tempTopList[0].Name + ' ' + tempTopList[0].Component__c);
            if(topCount == topList.size()){
                topMap.put(tempDate, tempTopList);
            }
        }
        
        Date tempDate;
        List<Topic__c> tempTopList = new List<Topic__c>();
        Integer topCount = 0;
        for(Topic__c top :topList){
            topCount++;
            if(tempDate == null || tempDate != top.Planner__r.Study_Date__c){
                if(tempTopList.size() != 0){
                    topMap.put(tempDate, tempTopList);
                    tempTopList.clear();
                    tempDate = top.Planner__r.Study_Date__c;
                } else {
                    tempDate = top.Planner__r.Study_Date__c;
                    tempTopList.add(top);
                }
            } else {
                tempTopList.add(top);
            }
            if(topCount == topList.size()){
                topMap.put(tempDate, tempTopList);
            }
        }
        
        Set<Date> keyset = topMap.keyset();
        Integer keysetCount = 0;
        for(Date dt :keyset){
            System.debug('keysetCount: ' + keysetCount++);
            System.debug(dt);
            System.debug(topMap.get(dt));
        }*/
        
        Integer count = 0;
        WrapperClass wc = new WrapperClass();
        
        List<Dates> dateList = new List<Dates>();
        List<Date> currentMonthDateList = new List<Date>();
        Boolean isFirst = true;
        for(Date d = firstDayofWeekDate; d<= lastDayInLastWeekDate; d=d.addDays(+1)){
            Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
            Dates newDate = new Dates();
            if(isFirst || d.day() == 1){
                newDate.calendarDate = String.valueOf(dt.format('dd MMM'));
            } else {
                newDate.calendarDate = String.valueOf(dt.format('dd'));
            }
            System.debug('wc.calendarDate: ' + newDate.calendarDate);
            List<Topic__c> newTopList = new List<Topic__c>();
            Integer topCount = 0;
            for(Topic__c top :topList){
                topCount++;
                if(top.Planner__r.Study_Date__c == d){
                    System.debug('///////' + top.Planner__r.Study_Date__c + d);
                    newTopList.add(top);
                    if(topCount == topList.size()){
                        newDate.topList = newTopList;
                    }
                } else {
                    if(newTopList.size()>0){
                        newDate.topList = newTopList;
                        system.debug('newDate.topList.size(): ' + newDate.topList.size());
                    }
                }
                //system.debug('newDate.topList.size(): ' + newDate.topList.size());
            }
            newDate.realDate = d;
            System.debug('topMap.get(d): ' + topMap.get(d));
            count++;
            isFirst = false;
            System.debug(count + ' ' + d);
            dateList.add(newDate);
        }
        
        wc.dateList = dateList;
        
        System.debug('dateList.size(): ' + dateList.size());
        
        return wc;
    }
    public static String getMonthName(Integer monthNumber){
        
        String monthName = '';
        
        Switch on monthNumber {
            when 1 {
                monthName = 'January';
            }
            when 2 {
                monthName = 'February';
            }
            when 3 {
                monthName = 'March';
            }
            when 4 {
                monthName = 'April';
            }
            when 5 {
                monthName = 'May';
            }
            when 6 {
                monthName = 'June';
            }
            when 7 {
                monthName = 'July';
            }
            when 8 {
                monthName = 'August';
            }
            when 9 {
                monthName = 'September';
            }
            when 10 {
                monthName = 'October';
            }
            when 11 {
                monthName = 'November';
            }
            when 12 {
                monthName = 'December';
            }
        }
        
        return monthName;
    }
    public class WrapperClass{
        @AuraEnabled
        public Date currentDate;
        @AuraEnabled
        public String monthName;
        @AuraEnabled
        public List<Dates> dateList;
    }
    public class Dates{
        @AuraEnabled
        public String calendarDate;
        @AuraEnabled
        public Date realDate;
        @AuraEnabled
        public List<Topic__c> topList;
    }
}