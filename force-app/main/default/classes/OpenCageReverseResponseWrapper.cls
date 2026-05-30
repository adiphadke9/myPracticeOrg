public class OpenCageReverseResponseWrapper{
	public results[] results;
	public class results {
		public components components;
		public String formatted;	//Office Club, Pappelallee 78/79, 10437 Berlin, Germany
		public geometry geometry;
	}
	public class components {
		public String borough;	//Pankow
		public String city;	//Berlin
		public String continent;	//Europe
		public String country;	//Germany
		public String country_code;	//de
		public String house_number;	//78/79
		public String neighbourhood;	//Bremer Höhe
		public String office;	//Office Club
		public String political_union;	//European Union
		public String postcode;	//10437
		public String quarter;	//Helmholtzkiez
		public String road;	//Pappelallee
		public String state;	//Berlin
		public String state_code;	//BE
		public String suburb;	//Prenzlauer Berg
	}

	class geometry {
		public Double lat;	//52.5432379
		public Double lng;	//13.4142133
	}
}