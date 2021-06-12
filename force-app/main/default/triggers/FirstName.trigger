trigger FirstName on Contact(after update){
    FirstNameHelper.ReplaceName(trigger.old);
}