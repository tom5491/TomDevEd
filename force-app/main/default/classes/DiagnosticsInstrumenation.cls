/**
 * @description       : 
 * @author            : Tom Philippou
 * @last modified on  : 27-06-2021
 * @last modified by  : Tom Philippou
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   27-06-2021   Tom Philippou   Initial Version
**/
public with sharing class DiagnosticsInstrumenation {
    public static Boolean diagnosticsEnabled = DiagnosticsCustomSetting.diagnosticsEnabled;
    private static List<DiagnosticEntry> diagnosticLog;
    private static Integer currentLevel = 0;

    private static List<String> stackTrace = new List<String>();
    public static String exceptionTrace = '';

    private static class DiagnosticEntry {
        Integer level;
        String description;

        public diagnosticEntry(String entryDescription) {
            level = currentLevel;
            description = entryDescription;
        }
    }

    public static void push(String functionName) {
        debug('Entering: ' + functionName);
        currentLevel += 1;
        stacktrace.add(functionName);
    }

    public static void debug(String debugString) {
        if (!diagnosticsEnabled){
            return;
        }
        if (diagnosticLog == null) {
            diagnosticLog = new List<DiagnosticEntry>();
        }
        diagnosticLog.add(new DiagnosticEntry(debugString));
    }

    public static void pop() {
        if (currentLevel > 0) {
            currentLevel -= 1;
        }
        if (currentLevel == 0) {
            System.Debug(LoggingLevel.Info, 'Diagnostic Log\n' + currentLog());
        }
        if (stackTrace.size() > 0) {
            stackTrace.remove(stackTrace.size() - 1);
        }
    }

    public static void popAll() {
        while (currentLevel > o)
            pop();
    }

    public static String currentLog() {
        if(diagnosticLog == null) {
            return null;
        }

        String spaces = '                    ';
        String result = ' ';
        for(DiagnosticEntry de : diagnosticLog){
            Integer endIndex = 3 * de.level;
            if(endIndex >= spaces.length()){
                endIndex = spaces.length() -1;
                result += spaces.subString(0, endIndex) + de.description + '\n';
            }
        }
    }
}
