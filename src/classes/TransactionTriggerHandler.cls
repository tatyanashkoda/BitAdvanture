public with sharing class TransactionTriggerHandler extends TriggerHandler {

    Company_Budget__c companyBudget = [
            SELECT Id, Total_Developers_Payment__c,Total_Income__c, Total_Other_Expense__c, Current_Amount__c
            FROM Company_Budget__c
            Where Name = :Constants.COMPANY_NAME
    ];

//    Id customerRecordType = GetRecordType.getRecordType(Constants.INCOMING_PAYMENT_RECORD_TYPE);
//    Id salaryRecordType = GetRecordType.getRecordType(Constants.DEVELOPER_PAYMENT_RECORD_TYPE);
//    Id otherExpenseRecordType = GetRecordType.getRecordType(Constants.TRANSACTION_RECORD_TYPE_OTHER_EXPENSE);
//    Id moneyFlowRecordType = GetRecordType.getRecordType(Constants.MONEY_FLOW_RECORD_TYPE);
    Id customerRecordType = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(Constants.INCOMING_PAYMENT_RECORD_TYPE).getRecordTypeId();
    Id salaryRecordType = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(Constants.DEVELOPER_PAYMENT_RECORD_TYPE).getRecordTypeId();
    Id otherExpenseRecordType = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(Constants.TRANSACTION_RECORD_TYPE_OTHER_EXPENSE).getRecordTypeId();
    Id moneyFlowRecordType = Schema.SObjectType.Transactions__c.getRecordTypeInfosByName().get(Constants.MONEY_FLOW_RECORD_TYPE).getRecordTypeId();


    public override void beforeInsert() {
        checkProjectBudget((List<Transactions__c>) Trigger.new);
    }

    public override void beforeUpdate() {
        rollbackTransactions((List<Transactions__c>) Trigger.new);
        checkProjectBudget((List<Transactions__c>) Trigger.new);
    }

    private void checkUpdate(List<Transactions__c> transactions) {
        Transactions__c trans = new Transactions__c();

        for (Transactions__c tr : transactions) {
            trans = tr;
        }

        if (trans.RecordTypeId == moneyFlowRecordType) {
            updateMoneyFlow(trans);
        }

    }

    private void checkProjectBudget(List<Transactions__c> transactions) {

        Transactions__c trans = new Transactions__c();

        for (Transactions__c tr : transactions) {
            trans = tr;
        }


        if (trans.RecordTypeId == customerRecordType) {
            if (trans.Milestone__c != null) {
                Milestone__c milestone = [SELECT Id, Project__c FROM Milestone__c WHERE Id = :trans.Milestone__c];
                Project__c project = [SELECT Id, Project_budget__c, Name, Whole_Amount__c, Developer_Salary__c FROM Project__c WHERE Id = :milestone.Project__c];
                updateBudgetForCustomer(project, trans);
            } else {
                trans.addError('Can not null field "Milestone"');
            }

        }

        if (trans.RecordTypeId == salaryRecordType) {
            if (trans.Milestone__c != null) {
                Milestone__c milestone = [SELECT Id, Project__c FROM Milestone__c WHERE Id = :trans.Milestone__c];
                Project__c project = [SELECT Id, Project_budget__c, Name, Whole_Amount__c, Developer_Salary__c FROM Project__c WHERE Id = :milestone.Project__c];
                updateBudgetForSalaty(project, trans);
            } else {
                trans.addError('Can not null field "Milestone"');
            }
        }

        if (trans.RecordTypeId == otherExpenseRecordType) {
            updateBudgetForOtherExpense(companyBudget, trans);
        }

        if (trans.RecordTypeId == moneyFlowRecordType) {
            updateMoneyFlow(trans);
        }
    }

    private void rollbackTransactions(List<Transactions__c> trs) {
        for (Transactions__c tr : trs) {
            List<Transactions__c> oldTransactions = new List<Transactions__c>();
            oldTransactions.add((Transactions__c) System.Trigger.oldMap.get(tr.Id));
            if (oldTransactions.isEmpty()) {
                return;
            }

            for (Transactions__c trans : oldTransactions) {
                if (trans.RecordTypeId == customerRecordType) {
                    if (trans.To_Account__c == null) {
                        continue;
                    }

                    Bank_Account__c toBankAccount = [
                            SELECT Id, Current_Amount__c
                            FROM Bank_Account__c
                            WHERE Id = :trans.To_Account__c
                    ];

                    toBankAccount.Current_Amount__c = toBankAccount.Current_Amount__c - trans.Budget__c;
                    update toBankAccount;
                }

                if (trans.RecordTypeId == salaryRecordType || trans.RecordTypeId == otherExpenseRecordType) {
                    if (trans.From_Account__c == null) {
                        continue;
                    }

                    Bank_Account__c fromBankAccount = [
                            SELECT Id, Current_Amount__c
                            FROM Bank_Account__c
                            WHERE Id = :trans.To_Account__c
                    ];
                    fromBankAccount.Current_Amount__c = fromBankAccount.Current_Amount__c + trans.Budget__c;
                    update fromBankAccount;
                }
            }
        }
    }

    private void updateMoneyFlow(Transactions__c transactions) {
        if (transactions.From_Account__c != null || transactions.To_Account__c != null) {
            Bank_Account__c fromBankAccount = [
                    SELECT Id, Current_Amount__c
                    FROM Bank_Account__c
                    WHERE Id = :transactions.From_Account__c
            ];
            Bank_Account__c toBankAccount = [
                    SELECT Id, Current_Amount__c
                    FROM Bank_Account__c
                    WHERE Id = :transactions.To_Account__c
            ];
            if (fromBankAccount.Current_Amount__c != null) {
                if (fromBankAccount.Current_Amount__c < transactions.Budget__c) {
                    transactions.addError('There are not enough funds in the account to complete the transaction');
                } else {
                    fromBankAccount.Current_Amount__c = fromBankAccount.Current_Amount__c - transactions.Budget__c;
                }
            } else {
                transactions.addError('There are not enough funds in the account to complete the transaction');
            }

            if (toBankAccount.Current_Amount__c != null) {
                toBankAccount.Current_Amount__c = toBankAccount.Current_Amount__c + transactions.Budget__c;
            } else {
                toBankAccount.Current_Amount__c = transactions.Budget__c;
            }

            update fromBankAccount;
            update toBankAccount;
        } else {
            transactions.addError('Can not null field "From Bank Account" or "To Bank Account"');
        }
    }

    private void updateBudgetForCustomer(Project__c project, Transactions__c transactions) {
        if (transactions.To_Account__c != null) {
            Bank_Account__c toBankAccount = [
                    SELECT Id, Current_Amount__c
                    FROM Bank_Account__c
                    WHERE Id = :transactions.To_Account__c
            ];
            if (toBankAccount.Current_Amount__c != null) {
                toBankAccount.Current_Amount__c = toBankAccount.Current_Amount__c + transactions.Budget__c;
            } else {
                toBankAccount.Current_Amount__c = transactions.Budget__c;
            }
            if (project.Whole_Amount__c == null) {
                project.Whole_Amount__c = transactions.Budget__c;
            } else {
                project.Whole_Amount__c = project.Whole_Amount__c + transactions.Budget__c;
            }
            companyBudget.Total_Income__c = companyBudget.Total_Income__c + transactions.Budget__c;
            update companyBudget;
            update toBankAccount;
            update project;
        } else {
            transactions.addError('Can not null field "To Bank Account"');
        }
    }

    private void updateBudgetForOtherExpense(Company_Budget__c companyBudget, Transactions__c transactions) {
        if (transactions.From_Account__c != null) {
            Bank_Account__c fromBankAccount = [
                    SELECT Id, Current_Amount__c
                    FROM Bank_Account__c
                    WHERE Id = :transactions.From_Account__c
            ];

            if (fromBankAccount.Current_Amount__c != null) {
                if (fromBankAccount.Current_Amount__c < transactions.Budget__c) {
                    transactions.addError('There are not enough funds in the account to complete the transaction');
                } else {
                    companyBudget.Total_Developers_Payment__c = transactions.Budget__c + companyBudget.Total_Developers_Payment__c;
                    update companyBudget;
                    fromBankAccount.Current_Amount__c = fromBankAccount.Current_Amount__c - transactions.Budget__c;
                    update fromBankAccount;
                }
            } else {
                transactions.addError('There are not enough funds in the account to complete the transaction');
            }

        } else {
            transactions.addError('Can not null field "From Bank Account"');
        }
    }

    private void updateBudgetForSalaty(Project__c project, Transactions__c transactions) {
        if (transactions.From_Account__c != null) {
            Bank_Account__c fromBankAccount = [
                    SELECT Id, Current_Amount__c
                    FROM Bank_Account__c
                    WHERE Id = :transactions.From_Account__c
            ];

            if (transactions.Developer__c != null) {
                Developer__c developer = [SELECT Id, Salary__c FROM Developer__c WHERE Id = :transactions.Developer__c];
                if (fromBankAccount.Current_Amount__c != null) {
                    if (fromBankAccount.Current_Amount__c < transactions.Budget__c) {
                        transactions.addError('There are not enough funds in the account to complete the transaction');
                    } else {
                        if (project.Developer_Salary__c == null) {
                            project.Developer_Salary__c = transactions.Budget__c;
                        } else {
                            project.Developer_Salary__c = project.Developer_Salary__c + transactions.Budget__c;
                        }
                        if (developer.Salary__c == null) {
                            developer.Salary__c = transactions.Budget__c;
                        } else {
                            developer.Salary__c = developer.Salary__c + transactions.Budget__c;
                        }
                        companyBudget.Total_Developers_Payment__c = companyBudget.Total_Developers_Payment__c + transactions.Budget__c;
                        update companyBudget;
                        update developer;
                        update project;
                        fromBankAccount.Current_Amount__c = fromBankAccount.Current_Amount__c - transactions.Budget__c;
                        update fromBankAccount;
                    }
                } else {
                    transactions.addError('There are not enough funds in the account to complete the transaction');
                }
            } else {
                transactions.addError('Can not null field "Developer"');
            }
        } else {
            transactions.addError('Can not null field "From Bank Account"');
        }
    }
}