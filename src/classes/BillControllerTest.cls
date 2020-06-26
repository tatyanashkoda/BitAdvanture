/**
 * Created by tshkoda on 6/26/2020.
 */

@IsTest
private class BillControllerTest {
    @TestSetup
    static void setup(){
        Developer__c developer = DataForTests.createDeveloper();
        DataForTests.createBill(Constants.DEVELOPER_PAYMENT_RECORD_TYPE, developer);
    }
    @IsTest
    static void checkOnGettingRecordType() {
        Bill__c bill = [SELECT Id, RecordType.Name FROM Bill__c];
//        BillController.getRecordTypeName(bill.Id);
        System.assertEquals(bill.RecordType.Name, BillController.getRecordTypeName(bill.Id));


    }
}