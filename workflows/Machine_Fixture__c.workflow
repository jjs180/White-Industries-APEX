<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Set_Machine_Fixture_Total_Cost</fullName>
        <description>Set Machine Fixture Total Cost</description>
        <field>Total_Machine_Fixture_Cost__c</field>
        <formula>Total_Labor_Cost__c +  Total_Materials_Cost__c</formula>
        <name>Set Machine Fixture Total Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Set Total Machine Fixture Cost</fullName>
        <actions>
            <name>Set_Machine_Fixture_Total_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Machine_Fixture__c.Total_Hours__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set Total Machine Fixture Cost</description>
        <triggerType>onAllChanges</triggerType>
    </rules></Workflow>