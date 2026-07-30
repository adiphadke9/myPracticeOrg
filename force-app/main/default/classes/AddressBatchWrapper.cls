public class AddressBatchWrapper{
	public String status;	//success
	public String message;	//Verified address batch successfully.
	public Data data;
	public class Data {
		public Results[] results;
	}
	public class Results {
		public VerifiedAddress verifiedAddress;
	}
	public class VerifiedAddress {
		public String line1;	//145 MULBERRY ST PH D
		public String city;	//NEW YORK
		public String postalOrZip;	//10013
		public String provinceOrState;	//NY
		public String provinceOrStateName;	//NEW YORK
		public String country;	//us
		public String countryName;	//UNITED STATES
		public String zipPlus4;	//5230
		public String status;	//corrected
		public Map<String, List<String>> errors;
	}
}