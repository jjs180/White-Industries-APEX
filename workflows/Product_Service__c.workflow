<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Set_Service_Price</fullName>
        <description>Set Service Price</description>
        <field>Service_Price__c</field>
        <formula>Service__r.Price__c</formula>
        <name>Set Service Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Set Service Cost</fullName>
        <actions>
            <name>Set_Service_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(!ISBLANK(Service__c), !ISCHANGED( Service_Price__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules></Workflow>