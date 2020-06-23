<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Currency</fullName>
        <field>Profit_Currency__c</field>
        <formula>Profit__c</formula>
        <name>Update Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_date_Milestone</fullName>
        <field>Due_date__c</field>
        <formula>TODAY()</formula>
        <name>Update Due date Milestone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Money_Without_Charges</fullName>
        <field>Money_without_charges_Currency__c</field>
        <formula>Money_without_charges__c</formula>
        <name>Update Money Without Charges</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Due date Milestone</fullName>
        <actions>
            <name>Update_Due_date_Milestone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>Finished__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update_Money_Without_Charges</fullName>
        <actions>
            <name>Update_Money_Without_Charges</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone__c.Money_without_charges_Currency__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update_Profite</fullName>
        <actions>
            <name>Update_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone__c.Profit__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
