/**
 * Created by tshkoda on 6/29/2020.
 */

@IsTest
private class TransactionControllerTest {
    @TestSetup
    static void setup(){

    }

    @IsTest
    static void testSaveTrans() {
        Customer__c customer = DataForTests.createCustomer();
        DataForTests.createCompanyBudget();
        Project__c project = DataForTests.createProject(customer);
        Milestone__c milestone = DataForTests.createMilestone('Upwork', project);
        Developer__c developer = DataForTests.createDeveloper();
        Bank_Account__c bankAccount = DataForTests.createBankAccount(10000);
        Transactions__c transDP = new Transactions__c(
                Date_of_Payment__c = Date.today(),
                Budget__c = 10,
                Developer__c = developer.Id,
                Milestone__c = milestone.Id,
                From_Account__c = bankAccount.Id
        );
        TransactionController.saveTransaction(transDP, Constants.DEVELOPER_PAYMENT_RECORD_TYPE);
        List<Transactions__c> geTransactions = [SELECT Id FROM Transactions__c];
        System.assertEquals(1, geTransactions.size());
    }

}