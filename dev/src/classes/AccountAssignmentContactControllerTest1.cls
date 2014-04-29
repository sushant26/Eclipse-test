/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData= true)
private class AccountAssignmentContactControllerTest1 {
    static testMethod void positiveTest() {
         
        List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
        List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
        
        Address__c addr  = new Address__c();
        addr.name='test1';
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
        
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
        
    //    RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger');
        kundeChildAccount.Type = 'Kunde';
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
   
               
       Contact contact = new Contact(); 
       contact.FirstName = 'TestContactFirstname';
       contact.LastName = 'TestContactLastname';
       contact.Email = 'test.TestClase@test1.com';
       contact.Phone = '2222221';
       contact.MobilePhone = '3333331';
       contact.HomePhone = '4444441';
       contact.HierarchyAccount__c = acc.id;
       contact.Street_P__c = addr.Id;
       contact.KissPartyId__c = 'KAS.P2---4015110456';
       insert contact;
       
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];
         Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        String paswd = 'temp';
       u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u;  
        
       Contact contactTest = new Contact(); 
       contactTest.FirstName = 'TestContactFN';
       contactTest.LastName = 'TestContactLN';
       contactTest.Email = 'test.TestCls@test1.com';
       contactTest.Phone = '2222221';
       contactTest.MobilePhone = '3333331';
       contactTest.HomePhone = '4444441';
       contactTest.HierarchyAccount__c = acc.id;
       contactTest.Street_P__c = addr.Id;
       contactTest.KissPartyId__c = 'KAS.P2---4015113456';
       contactTest.Status__c = 'Aktv';
       contactTest.Enable_Customer_Portal_User__c = false;
       contactTest.accountId = acc.Id;
       
       insert contactTest;
       
       /*Contact contactTest=[select id, Name, FirstName, LastName, Email, Phone, MobilePhone, HomePhone, 
       HierarchyAccount__c, Street_P__c, KissPartyId__c, Status__c, Enable_Customer_Portal_User__c, 
       accountId, UserProfile__c from Contact where id='003M000000IMIld'];*/
       
       user u1 = new User(alias = 'fortest', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contactTest.Id,
            timezonesidkey='America/Los_Angeles', username='fortest@test.com',MID__c = 'M87655');        
            u.setOptions(dmo);
        insert u1; 
        system.debug('..................................................user............................................'+u1);
        
        update contactTest;
       
       
       System.runAs(u){
            String portalUserProfile;
            ApexPages.StandardController sc = new ApexPages.StandardController(contactTest);
            ApexPages.CurrentPage().getParameters().put('contactId', contactTest.id);
            AccountAssignmentContactController aacc = new AccountAssignmentContactController(sc);
       
            
            
            
            /*sc = new ApexPages.StandardController(contactTest1);
            ApexPages.CurrentPage().getParameters().put('contactId', contactTest1.id);
            aacc = new AccountAssignmentContactController(sc);*/
       //       aacc.getObjectStructure();
            aacc.setUser(u1);
            aacc.getAccounts();
        //  aacc.save();
            contactTest.Enable_Customer_Portal_User__c = true;
            aacc.setContact(contactTest);
            aacc.tempFlag = true;
            //aacc.saveOne();
            portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
            contactTest.UserProfile__c = portalUserProfile;
            aacc.setContact(contactTest);
            aacc.getContact();
            aacc.GetTopElement(acc.Id);
            aacc.getObjectStructure();
            //aacc.callAdditionalMethods();
            //aacc.getTestObjectStructure();
            //aacc.testformatObjectStructure(acc.id);
            
          aacc.save();
            //aacc.saveOne();
       }
    } 
    
    static testMethod void positiveTest1() {
    	
        List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
        List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
       
        Address__c addr  = new Address__c();
        addr.name='Name11111';
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Hierarki';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
        
       
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
        
    //    RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger');
        kundeChildAccount.Type = 'Kunde';
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
   
               
       Contact contact = new Contact(); 
       contact.FirstName = 'TestContactFirstname';
       contact.LastName = 'TestContactLastname';
       contact.Email = 'test.TestClase@test1.com';
       contact.Phone = '2222221';
       contact.MobilePhone = '3333331';
       contact.HomePhone = '4444441';
       contact.HierarchyAccount__c = acc.id;
       contact.Street_P__c = addr.Id;
       contact.KissPartyId__c = 'KAS.P2---4015110456';
       insert contact;
       
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];
         Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        String paswd = 'temp';
       u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u;  
        
       /* Contact contactTest = new Contact(); 
       contactTest.FirstName = 'TestContactFN';
       contactTest.LastName = 'TestContactLN';
       contactTest.Email = 'test.TestCls@test1.com';
       contactTest.Phone = '2222221';
       contactTest.MobilePhone = '3333331';
       contactTest.HomePhone = '4444441';
       contactTest.HierarchyAccount__c = acc.id;
       contactTest.Street_P__c = addr.Id;
       contactTest.KissPartyId__c = 'KAS.P2---4015113456';
       contactTest.Status__c = 'Aktv';
       contactTest.Enable_Customer_Portal_User__c = false;
       contactTest.accountId = acc.Id;
       
       insert contactTest;*/
       
       
       Account acc1 = new Account();
       acc1.Name = 'TestHierarchy1';
       acc1.Type='Hierarki';
       acc1.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1();
       acc1.Street_YK__c = addr.Id;
       acc1.Street_YK__r = addr;
       System.debug(' Address----- '+acc.Street_YK__r);
       insert acc1;
       
       
       
       Contact contactTest1 = new Contact(); 
       contactTest1.FirstName = 'TestContactFN';
       contactTest1.LastName = 'TestContactLN';
       //contactTest.Email = 'test.TestCls@test1.com';
       contactTest1.Phone = '2222221';
       contactTest1.MobilePhone = '3333331';
       contactTest1.HomePhone = '4444441';
       contactTest1.HierarchyAccount__c = acc1.id;
       contactTest1.Street_P__c = addr.Id;
       contactTest1.KissPartyId__c = 'KAS.P2---4015113456';
       contactTest1.Status__c = 'Aktv';
       contactTest1.Enable_Customer_Portal_User__c = false;
       contactTest1.accountId = acc1.Id;
       
       
       
       
       insert contactTest1;
       
       user u1 = new User(alias = 'fortest', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contactTest1.Id,
            timezonesidkey='America/Los_Angeles', username='fortest@test.com',MID__c = 'M87655');        
            u.setOptions(dmo);
        insert u1; 
        system.debug('..................................................user............................................'+u1);
        
        update contactTest1;
       
       
    } 
    
    static testMethod void positiveTest123() {
        
        List<cObjectStructureMap> objectStrListtemp = new List<cObjectStructureMap>();
        List<cObjectStructureMap> objectStrList = new List<cObjectStructureMap>();
        
        
        Address__c addr  = new Address__c();
        //addr.name='test';
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        
        
        
         Account acc = new Account();
         acc.Name = 'TestHierarchy';
         acc.Type='Hierarki';
         acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
         acc.Street_YK__c = addr.Id;
         acc.Street_YK__r = addr;
         System.debug(' Address----- '+acc.Street_YK__r);
         insert acc;
        
       
        Cable_Unit__c cableUnitTest = new Cable_Unit__c();
        cableUnitTest.Name = 'cu_kundeCust_testing'; 
        cableUnitTest.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest;
        
    //    RecordType recordType = [Select Id From RecordType Where Name = 'YS Customer Account'];
        Account kundeChildAccount = new Account();
        kundeChildAccount = new Account( Name = 'TestAccountContactRoleTrigger');
        kundeChildAccount.Type = 'Kunde';
        kundeChildAccount.Cable_Unit__c = cableUnitTest.Id;  
        kundeChildAccount.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1();
        kundeChildAccount.ParentId = acc.Id;
        insert kundeChildAccount;
   
               
       Contact contact = new Contact(); 
       contact.FirstName = 'TestContactFirstname';
       contact.LastName = 'TestContactLastname';
       contact.Email = 'test.TestClase@test1.com';
       contact.Phone = '2222221';
       contact.MobilePhone = '3333331';
       contact.HomePhone = '4444441';
       contact.HierarchyAccount__c = acc.id;
       contact.Street_P__c = addr.Id;
       contact.KissPartyId__c = 'KAS.P2---4015110456';
       insert contact;
       
        Profile[] profiles = [Select p.name, p.id From Profile p where p.Name like '%ServiceCenter Portal Administrator%'];
         Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        User u = new User();
        String paswd = 'temp';
       u = new User(alias = 'standt', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contact.Id,
            timezonesidkey='America/Los_Angeles', username='testClassUser@test.com',MID__c = 'M87654');        
            u.setOptions(dmo);
        insert u;  
        
        Contact contactTest = new Contact(); 
       contactTest.FirstName = 'TestContactFN';
       contactTest.LastName = 'TestContactLN';
       contactTest.Email = 'test.TestCls@test1.com';
       contactTest.Phone = '2222221';
       contactTest.MobilePhone = '3333331';
       contactTest.HomePhone = '4444441';
       contactTest.HierarchyAccount__c = acc.id;
       contactTest.Street_P__c = addr.Id;
       contactTest.KissPartyId__c = 'KAS.P2---4015113456';
       contactTest.Status__c = 'Aktv';
       contactTest.Enable_Customer_Portal_User__c = false;
       contactTest.accountId = acc.Id;
       
       insert contactTest;
       
       user u1 = new User(alias = 'fortest', email='testClassUser@test.com',title='kunderådgiver',
            emailencodingkey='UTF-8', lastname='Chawla', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profiles[0].Id, contactId=contactTest.Id,
            timezonesidkey='America/Los_Angeles', username='fortest@test.com',MID__c = 'M87655');        
            u.setOptions(dmo);
        insert u1; 
        system.debug('..................................................user............................................'+u1);
        
        update contactTest;
       
       
       System.runAs(u){
            String portalUserProfile;
            ApexPages.StandardController sc = new ApexPages.StandardController(contactTest);
            ApexPages.CurrentPage().getParameters().put('contactId', contactTest.id);
            AccountAssignmentContactController aacc = new AccountAssignmentContactController(sc);
       
            
            
            
            /*sc = new ApexPages.StandardController(contactTest1);
            ApexPages.CurrentPage().getParameters().put('contactId', contactTest1.id);
            aacc = new AccountAssignmentContactController(sc);*/
       //       aacc.getObjectStructure();
            aacc.setUser(u1);
            aacc.getAccounts();
        //  aacc.save();
            contactTest.Enable_Customer_Portal_User__c = true;
            aacc.setContact(contactTest);
            aacc.tempFlag = true;
            //aacc.saveOne();
            portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
            contactTest.UserProfile__c = portalUserProfile;
            aacc.setContact(contactTest);
            aacc.getContact();
            aacc.GetTopElement(acc.Id);
            aacc.getObjectStructure();
            //aacc.callAdditionalMethods();
            //aacc.getTestObjectStructure();
            //aacc.testformatObjectStructure(acc.id);
            
          aacc.save();
            //aacc.saveOne();
       }
    } 
    
}