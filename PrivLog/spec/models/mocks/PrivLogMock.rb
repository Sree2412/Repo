module PrivLogUrl
	Local = "http://mlvtwsrv01:8082"
	QA = "http://mlvtwsrv01:8082"
end

module PrivLogEnum

	FirstName = 4

	MiddleName = 5

	LastName = 6

end


module PrivLogSampleData

	#Filtered table
	FilteredTable = [{" Id"=>"77", " Raw Entry"=>"cook, brian (bcook@usg.com)", " Email Address"=>"bcook@usg.com", " First Name"=>"Brian", " Middle Name"=>" ", " Last Name"=>"Cook", " Is Attorney"=>"", " Count"=>"2"}, {" Id"=>"63", " Raw Entry"=>"deely, brendan (bdeely@lwsupply.com)", " Email Address"=>"bdeely@lwsupply.com", " First Name"=>"Brendan", " Middle Name"=>" ", " Last Name"=>"Deely", " Is Attorney"=>"", " Count"=>"3"}, {" Id"=>"67", " Raw Entry"=>"seppa, brent (bseppa@usg.com)", " Email Address"=>"bseppa@usg.com", " First Name"=>"Brent", " Middle Name"=>" ", " Last Name"=>"Seppa", " Is Attorney"=>"", " Count"=>"1"}, {" Id"=>"87", " Raw Entry"=>"statler, barbara (bstatler@usg.com)", " Email Address"=>"bstatler@usg.com", " First Name"=>"Barbara", " Middle Name"=>" ", " Last Name"=>"Statler", " Is Attorney"=>"", " Count"=>"1"}, {" Id"=>"95", " Raw Entry"=>"williams, robert e (rewilliams@usg.com)", " Email Address"=>"rewilliams@usg.com", " First Name"=>"Robert E", " Middle Name"=>"TestUpdate", " Last Name"=>"Williams", " Is Attorney"=>"", " Count"=>"1"}, {" Id"=>"65", " Raw Entry"=>"waterhouse, rob (rwaterhouse@lwsupply.com)", " Email Address"=>"rwaterhouse@lwsupply.com", " First Name"=>"Rob", " Middle Name"=>" ", " Last Name"=>"Waterhouse", " Is Attorney"=>"", " Count"=>"2"}]
	#Default export options
	Sample = [["\xC3\xBEDocumentID\xC3\xBE\x14\xC3\xBEFrom\xC3\xBE\x14\xC3\xBETo\xC3\xBE\x14\xC3\xBECC\xC3\xBE\x14\xC3\xBEBCC\xC3\xBE"], ["\xC3\xBEH10760RE0010.018.766\xC3\xBE\x14\xC3\xBEDonahue,", "John\xC3\xBE\x14\xC3\xBEMetcalf,", "James*;", "Griffin,", "Christopher;", "Deely,", "Brendan;", "Salah,", "Greg;", "Waterhouse,", "Rob;", "Reale,", "John;", "Seppa,", "Brent;", "Lawson,", "Chris;", "Byrne,", "Matt;", "Courtney,", "Kevin;", "Berntsen,", "Lina;", "Moyer,", "Kevin", "W;", "Bjorklund,", "Steve;", "Rzonca,", "Judy\xC3\xBE\x14\xC3\xBEMartin,", "Mary;", "King,", "Donnetta", "D\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.019.236\xC3\xBE\x14\xC3\xBEFarley,", "Karol\xC3\xBE\x14\xC3\xBECook,", "Brian;", "Dannessa,", "Dominic;", "Deely,", "Brendan;", "Ferguson,", "Stan;", "Griffin,", "Christopher;", "Hilzinger,", "Matt", "F;", "Metcalf,", "James*;", "Lowes,", "Rick;", "Scanlon,", "Jennifer\xC3\xBE\x14\xC3\xBEClark,", "Margaret;", "Farley,", "Karol;", "Guzman,", "Jeanne;", "Rzonca,", "Judy;", "Statler,", "Barbara;", "Tousana,", "Vivian;", "Trussell,", "Celeste;", "Trapp,", "Wendy", "M;", "Rutti,", "Sue\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.019.237\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.020.574\xC3\xBE\x14\xC3\xBESalah,", "Greg\xC3\xBE\x14\xC3\xBEGriffin,", "Christopher\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.023.252\xC3\xBE\x14\xC3\xBEBanas,", "Ken\xC3\xBE\x14\xC3\xBECook,", "Brian;", "Dannessa,", "Dominic;", "Deely,", "Brendan;", "Ferguson,", "Stan;", "Gordon,", "Daniel", "G;", "Griffin,", "Christopher;", "Hilzinger,", "Matt", "F;", "Lowes,", "Rick;", "Martin,", "Mary;", "Metcalf,", "James*;", "Rodewald,", "Jeff;", "Salah,", "Greg;", "Scanlon,", "Jennifer;", "Waterhouse,", "Rob;", "Williams,", "Robert", "E\xC3\xBE\x14\xC3\xBEKellogg,", "Sylvia*\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.057.392\xC3\xBE\x14\xC3\xBEGriffin,", "Christopher\xC3\xBE\x14\xC3\xBEBanas,", "Ken\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.041\xC3\xBE\x14\xC3\xBEKellogg,", "Sylvia*\xC3\xBE\x14\xC3\xBESalah,", "Greg;", "Chapa,", "Elaine\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.042\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.043\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.044\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"]]

	#First Last Name Format; Different Special Characters
	Sample1 = [["\xC3\xBEDocumentID\xC3\xBE\x14\xC3\xBEFrom\xC3\xBE\x14\xC3\xBETo\xC3\xBE\x14\xC3\xBECC\xC3\xBE\x14\xC3\xBEBCC\xC3\xBE"], ["\xC3\xBEH10760RE0010.018.766\xC3\xBE\x14\xC3\xBEJohn", "Donahue\xC3\xBE\x14\xC3\xBEJames", "Metcalf!;", "Christopher", "Griffin;", "Brendan", "Deely;", "Greg", "Salah;", "Rob", "Waterhouse;", "John", "Reale;", "Brent", "Seppa;", "Chris", "Lawson;", "Matt", "Byrne;", "Kevin", "Courtney;", "Lina", "Berntsen;", "Kevin", "W", "Moyer;", "Steve", "Bjorklund;", "Judy", "Rzonca\xC3\xBE\x14\xC3\xBEMary", "Martin;", "Donnetta", "D", "King\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.019.236\xC3\xBE\x14\xC3\xBEKarol", "Farley\xC3\xBE\x14\xC3\xBEBrian", "Cook;", "Dominic", "Dannessa;", "Brendan", "Deely;", "Stan", "Ferguson;", "Christopher", "Griffin;", "Matt", "F", "Hilzinger;", "James", "Metcalf!;", "Rick", "Lowes;", "Jennifer", "Scanlon\xC3\xBE\x14\xC3\xBEMargaret", "Clark;", "Karol", "Farley;", "Jeanne", "Guzman;", "Judy", "Rzonca;", "Barbara", "Statler;", "Vivian", "Tousana;", "Celeste", "Trussell;", "Wendy", "M", "Trapp;", "Sue", "Rutti\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.019.237\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.020.574\xC3\xBE\x14\xC3\xBEGreg", "Salah\xC3\xBE\x14\xC3\xBEChristopher", "Griffin\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.023.252\xC3\xBE\x14\xC3\xBEKen", "Banas\xC3\xBE\x14\xC3\xBEBrian", "Cook;", "Dominic", "Dannessa;", "Brendan", "Deely;", "Stan", "Ferguson;", "Daniel", "G", "Gordon;", "Christopher", "Griffin;", "Matt", "F", "Hilzinger;", "Rick", "Lowes;", "Mary", "Martin;", "James", "Metcalf!;", "Jeff", "Rodewald;", "Greg", "Salah;", "Jennifer", "Scanlon;", "Rob", "Waterhouse;", "Robert", "E", "Williams\xC3\xBE\x14\xC3\xBESylvia", "Kellogg!\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.057.392\xC3\xBE\x14\xC3\xBEChristopher", "Griffin\xC3\xBE\x14\xC3\xBEKen", "Banas\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.041\xC3\xBE\x14\xC3\xBESylvia", "Kellogg!\xC3\xBE\x14\xC3\xBEGreg", "Salah;", "Elaine", "Chapa\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.042\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.043\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.044\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"]]

	#First_Last Name Format; Different Special Characters
	Sample2 = [["\xC3\xBEDocumentID\xC3\xBE\x14\xC3\xBEFrom\xC3\xBE\x14\xC3\xBETo\xC3\xBE\x14\xC3\xBECC\xC3\xBE\x14\xC3\xBEBCC\xC3\xBE"], ["\xC3\xBEH10760RE0010.018.766\xC3\xBE\x14\xC3\xBEJohn_Donahue\xC3\xBE\x14\xC3\xBEJames_Metcalf!?", "Christopher_Griffin?", "Brendan_Deely?", "Greg_Salah?", "Rob_Waterhouse?", "John_Reale?", "Brent_Seppa?", "Chris_Lawson?", "Matt_Byrne?", "Kevin_Courtney?", "Lina_Berntsen?", "Kevin_W_Moyer?", "Steve_Bjorklund?", "Judy_Rzonca\xC3\xBE\x14\xC3\xBEMary_Martin?", "Donnetta_D_King\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.019.236\xC3\xBE\x14\xC3\xBEKarol_Farley\xC3\xBE\x14\xC3\xBEBrian_Cook?", "Dominic_Dannessa?", "Brendan_Deely?", "Stan_Ferguson?", "Christopher_Griffin?", "Matt_F_Hilzinger?", "James_Metcalf!?", "Rick_Lowes?", "Jennifer_Scanlon\xC3\xBE\x14\xC3\xBEMargaret_Clark?", "Karol_Farley?", "Jeanne_Guzman?", "Judy_Rzonca?", "Barbara_Statler?", "Vivian_Tousana?", "Celeste_Trussell?", "Wendy_M_Trapp?", "Sue_Rutti\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.019.237\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.020.574\xC3\xBE\x14\xC3\xBEGreg_Salah\xC3\xBE\x14\xC3\xBEChristopher_Griffin\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.023.252\xC3\xBE\x14\xC3\xBEKen_Banas\xC3\xBE\x14\xC3\xBEBrian_Cook?", "Dominic_Dannessa?", "Brendan_Deely?", "Stan_Ferguson?", "Daniel_G_Gordon?", "Christopher_Griffin?", "Matt_F_Hilzinger?", "Rick_Lowes?", "Mary_Martin?", "James_Metcalf!?", "Jeff_Rodewald?", "Greg_Salah?", "Jennifer_Scanlon?", "Rob_Waterhouse?", "Robert_E_Williams\xC3\xBE\x14\xC3\xBESylvia_Kellogg!\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0010.057.392\xC3\xBE\x14\xC3\xBEChristopher_Griffin\xC3\xBE\x14\xC3\xBEKen_Banas\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.041\xC3\xBE\x14\xC3\xBESylvia_Kellogg!\xC3\xBE\x14\xC3\xBEGreg_Salah?", "Elaine_Chapa\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.042\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.043\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"], ["\xC3\xBEH10760RE0011.010.044\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE\x14\xC3\xBE\xC3\xBE"]]

end


module PrivLogTestFiles
	
	TestFile1 = "C:/Users/cxmiller/Documents/TestAutomation/PrivLog/spec/models/assets/PrivLogSample.csv"

	ErrorFile1 = "C:/Users/cxmiller/Documents/TestAutomation/PrivLog/spec/models/assets/Sample-Filetype-Error.txt"
		
	ErrorFile2 = "C:/Users/cxmiller/Documents/TestAutomation/PrivLog/spec/models/assets/Sample-Header-Error.csv"
		
	ErrorFile3 = "C:/Users/cxmiller/Documents/TestAutomation/PrivLog/spec/models/assets/Sample-Header-Error2.csv"

end

module PrivLogUIElements

	IsAttorneyChecked = 'glyphicon glyphicon-check'

	IsAttorneyUnchecked = 'glyphicon glyphicon-unchecked'

end