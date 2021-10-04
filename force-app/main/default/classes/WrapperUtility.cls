/**
 * @description       :
 * @author            : Tom Philippou
 * @group             :
 * @last modified on  : 27-08-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   25-08-2021   Tom Philippou   Initial Version
 **/
public with sharing class WrapperUtility {
    public class AllCharityDetailsWrapperClass {
        public Integer organisation_number;
        public Integer reg_charity_number;
        public Integer group_subsid_suffix;
        public String charity_name;
        public String charity_type;
        public Boolean insolvent;
        public Boolean in_administration;
        public Boolean prev_excepted_ind;
        public Object cif_cdf_ind;
        public Boolean cio_dissolution_ind;
        public Object interim_manager_ind;
        public Object date_of_interim_manager_appt;
        public String reg_status;
        public String date_of_registration;
        public Object date_of_removal;
        public String latest_acc_fin_year_start_date;
        public String latest_acc_fin_year_end_date;
        public Double latest_income;
        public Double latest_expenditure;
        public String address_line_one;
        public String address_line_two;
        public String address_line_three;
        public String address_line_four;
        public Object address_line_five;
        public String address_post_code;
        public String phone;
        public String email;
        public String web;
        public String charity_co_reg_number;
        public String reporting_status;
        public Object removal_reason;
        public Boolean cio_ind;
        public String last_modified_time;
        public List<Trustee_names> trustee_names;
        public List<Who_what_where> who_what_where;
        public List<CharityAoOCountryContinent> CharityAoOCountryContinent;
        public List<CharityAoOLocalAuthority> CharityAoOLocalAuthority;
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

    public class CharityAoOLocalAuthority {
    }

    public class CharityAoORegion {
        public String region;
    }

    public class SearchCharityName {
        public Integer organisation_number;
        public Integer reg_charity_number;
        public Integer group_subsid_suffix;
        public String charity_name;
        public String reg_status;
        public String date_of_registration;
        public String date_of_removal;
    }

    public class SimpleWrapperClass {
        @AuraEnabled
        public String result;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public List<Account> resultList;
        @AuraEnabled
        public List<Map<String, String>> resultMapList;
    }
}