<aura:application extends="force:slds">
<!--    <c:updateBill/>-->
    <aura:attribute name="selectedLookUpRecord" type="sObject" default="{}"/>

    <c:CustomLookup objectAPIName="account" IconName="standard:account" selectedRecord="{!v.selectedLookUpRecord}" label="Account Name"/>
</aura:application>