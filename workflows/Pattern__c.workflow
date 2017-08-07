<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Set_Total_Pattern_Cost</fullName>
        <field>Total_Pattern_Cost__c</field>
        <formula>Subtotal__c +   NULLVALUE(Material_Cost__c, 0)</formula>
        <name>Set Total Pattern Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Set Total Pattern Cost</fullName>
        <actions>
            <name>Set_Total_Pattern_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Pattern__c.Total_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules></Workflow>