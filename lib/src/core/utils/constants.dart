String BASE_URL = "https://api.openweathermap.org/data/2.5/";
enum FontFamily {
  ABHAYABOLD,
  ABHAYAREGULAR,
  ABHAYAMEDIUM,
  ABHAYASEMIBOLD,
  ABHAYAEXTRABOLD,
}

extension FontFamilyExtention on FontFamily {
  String get name {
    switch (this) {
      case FontFamily.ABHAYABOLD:
        return "ABHAYABOLD";
      case FontFamily.ABHAYAMEDIUM:
        return "ABHAYAMEDIUM";
      case FontFamily.ABHAYAREGULAR:
        return "ABHAYAREGULAR";
      case FontFamily.ABHAYASEMIBOLD:
        return "ABHAYASEMIBOLD";
      case FontFamily.ABHAYAEXTRABOLD:
        return "ABHAYAEXTRABOLD";
      default:
        return "ABHAYAREGULAR";
    }
  }
}
