public class JWT {
    
    public String iss{get;set;}
    public String sub{get;set;}
    public String aud{get;set;}
    public Long exp{get;set;}

    public JWT(String iss,String sub, String aud, Long exp) {
        this.iss = iss;
        this.sub = sub;
        this.aud = aud;
        this.exp = exp;
    }

    private static final String JWT_Header='{"alg":"RS256"}';

    public static String retrievePrivateKey(){
        return null;
    }
}