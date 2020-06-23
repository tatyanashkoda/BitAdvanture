<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_BS_less0</fullName>
        <field>Budget_Status__c</field>
        <formula>&quot;Failed&quot;</formula>
        <name>Update BS less0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BS_less10</fullName>
        <field>Budget_Status__c</field>
        <formula>&quot;Normal&quot;</formula>
        <name>Update BS less10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BS_more10</fullName>
        <field>Budget_Status__c</field>
        <formula>&quot;Successful&quot;</formula>
        <name>Update BS more10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check_B_S_More_10</fullName>
        <actions>
            <name>Update_BS_more10</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Margin__c</field>
            <operation>greaterOrEqual</operation>
            <value>10</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update BS less0</fullName>
        <actions>
            <name>Update_BS_less0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Margin__c</field>
            <operation>lessThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update BS less10</fullName>
        <actions>
            <name>Update_BS_less10</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.Margin__c</field>
            <operation>lessThan</operation>
            <value>10</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Margin__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
