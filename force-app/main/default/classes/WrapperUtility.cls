/**
 * @description       :
 * @author            : Tom Philippou
 * @group             :
 * @last modified on  : 17-09-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   25-08-2021   Tom Philippou   Initial Version
 **/
public class WrapperUtility {
    // START getCharityName wrapper class
    public class AllCharityDetailsWrapperClass {
        public Integer organisation_number;
        public Integer reg_charity_number;
        public Integer group_subsid_suffix;
        public String charity_name;
        public String charity_type;
        public Boolean insolvent;
        public Boolean in_administration;
        public Boolean prev_excepted_ind;
        //public Object cif_cdf_ind;
        public Boolean cio_dissolution_ind;
        //public Object interim_manager_ind;
        //public Object date_of_interim_manager_appt;
        public String reg_status;
        public String date_of_registration;
        public String date_of_removal;
        public String latest_acc_fin_year_start_date;
        public String latest_acc_fin_year_end_date;
        public Double latest_income;
        public Double latest_expenditure;
        public String address_line_one;
        public String address_line_two;
        public String address_line_three;
        public String address_line_four;
        //public Object address_line_five;
        public String address_post_code;
        public String phone;
        public String email;
        public String web;
        public String charity_co_reg_number;
        public String reporting_status;
        //public Object removal_reason;
        public Boolean cio_ind;
        public String last_modified_time;
        public List<Trustee_names> trustee_names;
        public List<Who_what_where> who_what_where;
        public List<CharityAoOCountryContinent> CharityAoOCountryContinent;
        public List<CharityAoORegion> CharityAoORegion;
        public List<Other_names> other_names;
        public List<Constituency_name> constituency_name;
    }

    public class Trustee_names {
        public Integer organisation_number;
        public String trustee_name;
    }

    public class Who_what_where {
        public String classification_code;
        public String classification_type;
        public String classification_desc;
    }

    public class Other_names {
        public String other_name;
        public String name_type;
    }

    public class CharityAoOCountryContinent {
        public String country;
        public String continent;
    }

    public class Constituency_name {
        public String constituency_name;
    }

    public class CharityAoORegion {
        public String region;
    }
    // END getCharityName wrapper class

    // public class SearchCharityName {
    //     public Integer organisation_number;
    //     public Integer reg_charity_number;
    //     public Integer group_subsid_suffix;
    //     public String charity_name;
    //     public String reg_status;
    //     public String date_of_registration;
    //     public String date_of_removal;
    // }

    // START getCharityDetailsMulti wrapper class
    public class GetCharityDetailsMulti {
        public Integer organisation_number;
        public Integer reg_charity_number;
        public Integer group_subsid_suffix;
        public String charity_name;
        public String charity_type;
        public Boolean insolvent;
        public Boolean in_administration;
        public Boolean prev_excepted_ind;
        // public Object cif_cdf_ind;
        public Boolean cio_dissolution_ind;
        // public Object interim_manager_ind;
        // public Object date_of_interim_manager_appt;
        public String reg_status;
        public String date_of_registration;
        // public Date date_of_removal;
        public String latest_acc_fin_year_start_date;
        public String latest_acc_fin_year_end_date;
        public Double latest_income;
        public Double latest_expenditure;
        public String address_line_one;
        public String address_line_two;
        public String address_line_three;
        public String address_line_four;
        // public Object address_line_five;
        public String address_post_code;
        public String phone;
        public String email;
        public String web;
        public String charity_co_reg_number;
        public String reporting_status;
        // public Object removal_reason;
        public Boolean cio_ind;
        public String last_modified_time;
    }
    // END getCharityDetailsMulti wrapper class

    // START CharityArAccounts
    public class Charityaraccounts {
        public String title;
        public String reporting_period_year_end;
        public String date_received;
        public String date_due;
        // public Object document_name;
        // public Object accounts_qualified;
        public Boolean suppression_ind;
        public Object suppression_type;
    }
    // END CharityArAccounts

    // START Charitygoverningdocument
    public class Charitygoverningdocument {
        public String governing_document_description;
        public String charitable_objects;
        public String area_of_benefit;
    }
    // END Charitygoverningdocument

    // START SearchByCharityName
    public class SearchByCharityName {
        public Integer organisation_number;
        public Integer reg_charity_number;
        public Integer group_subsid_suffix;
        public String charity_name;
        public String reg_status;
        public String date_of_registration;
        public String date_of_removal;
    }
    // END SearchByCharityName

    public class SimpleWrapperClass {
        @AuraEnabled
        public String result;
        @AuraEnabled
        public Integer statusCode;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public Account account;
        @AuraEnabled
        public AllCharityDetailsWrapperClass acdwc;
        @AuraEnabled
        public List<SearchByCharityName> sbcnList;
        @AuraEnabled
        public List<RadioEntry> radioEntryList;
    }

    public class CalloutDetails {
        @AuraEnabled
        public String parameter;
        @AuraEnabled
        public String apiService;
        @AuraEnabled
        public Map<String, Account> charityNumberToAccountMap;
        @AuraEnabled
        public Integration__c integrationObject;
    }

    public class CharityCommissionComponentWrapper {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public List<String> fieldsToUpdate;
        @AuraEnabled
        public String errorMessage;
    }

    // public class InitialAccountWrapper {
    //     @AuraEnabled
    //     public Account account;
    //     @AuraEnabled
    //     public List<RadioEntry> radioEntryList;
    // }

    public class RadioEntry {
        @AuraEnabled
        public String rowTitle;
        @AuraEnabled
        public String accValue;
        @AuraEnabled
        public String accLabel;
        @AuraEnabled
        public String ccValue;
        @AuraEnabled
        public String ccLabel;
        @AuraEnabled
        public String fieldType;
    }
}