<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Calculate_Quote_Price</fullName>
        <description>Presets a markup of 30% for Quote Price field.</description>
        <field>Price_for_Quote__c</field>
        <formula>Material__r.Latest_Price__c * 1.3</formula>
        <name>Calculate Quote Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Set Quote Price</fullName>
        <actions>
            <name>Calculate_Quote_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Presets a markup of 30% for Quote Price field.</description>
        <formula>ISBLANK(Price_for_Quote__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules></Workflow>