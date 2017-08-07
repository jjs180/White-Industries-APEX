<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>Set_Calculated_Margin</fullName>
        <description>Set Calculated Margin</description>
        <field>Margin__c</field>
        <formula>(Price__c -  Factory_Price__c) / Factory_Price__c</formula>
        <name>Set Calculated Margin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Set_Calculated_Selling_Price</fullName>
        <field>Price__c</field>
        <formula>(Factory_Price__c * Margin__c) + Factory_Price__c</formula>
        <name>Set Calculated Selling Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Calculate Margin</fullName>
        <actions>
            <name>Set_Calculated_Margin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculate Margin when Selling Price is Changed</description>
        <formula>ISCHANGED( Price__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules><rules>
        <fullName>Calculate Selling Price</fullName>
        <actions>
            <name>Set_Calculated_Selling_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculate Selling Price when Margin is Changed</description>
        <formula>ISCHANGED( Margin__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules></Workflow>