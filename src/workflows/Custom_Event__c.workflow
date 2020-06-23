<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Meeting_is_approved_by_the_leader</fullName>
        <description>Meeting is approved by the leader</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Meeting_is_approved_by_the_leader_VF</template>
    </alerts>
    <alerts>
        <fullName>Meeting_is_disapproved_by_the_leader</fullName>
        <description>Meeting is disapproved by the leader</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Meeting_is_disapproved_by_the_leader_VF</template>
    </alerts>
    <alerts>
        <fullName>Meeting_waiting_for_approval_of_the_leader</fullName>
        <description>Meeting waiting for approval of the leader</description>
        <protected>false</protected>
        <recipients>
            <field>Attached_to__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Waiting_for_approval_of_the_leader_VF</template>
    </alerts>
    <rules>
        <fullName>Meeting is approved by the leader</fullName>
        <actions>
            <name>Meeting_is_approved_by_the_leader</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Meeting is disapproved by the leader</fullName>
        <actions>
            <name>Meeting_is_disapproved_by_the_leader</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Denied</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Meeting waiting for approval of the leader VF</fullName>
        <actions>
            <name>Meeting_waiting_for_approval_of_the_leader</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Contact_Email__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
