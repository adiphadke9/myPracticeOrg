public with sharing class QB_CustomerInput {
	public String FullyQualifiedName;	//{{$randomCompanyName}}
	public PrimaryEmailAddr PrimaryEmailAddr;
	public String DisplayName;	//{{$randomCompanyName}}
	public String Suffix;	//Jr
	public String Title;	//Mr
	public String MiddleName;	//B
	public String Notes;	//{{$randomLoremText}}
	public String FamilyName;	//{{$randomLastName}}
	public PrimaryPhone PrimaryPhone;
	public String CompanyName;	//{{$randomCompanyName}}
	public BillAddr BillAddr;
	public String GivenName;	//{{$randomFirstName}}
	public class PrimaryEmailAddr {
		public String Address;	//{{$randomEmail}}
	}
	public class PrimaryPhone {
		public String FreeFormNumber;	//{{$randomPhoneNumber}}
	}
	public class BillAddr {
		public String CountrySubDivisionCode;	//CA
		public String City;	//Mountain View
		public String PostalCode;	//94042
		public String Line1;	//123 Main Street
		public String Country;	//USA
	}
}