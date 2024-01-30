class Fonts {
  Roboto roboto;
  Caros caros;
  Visby visby;

  Fonts () {
    roboto = new Roboto ();
    caros = new Caros ();
    visby = new Visby ();
  }
}

class Roboto {
  PFont regular, medium, bold;

  Roboto () {
    regular = createFont ("/data/fonts/roboto/roboto-regular.ttf", 17);
    medium = createFont ("/data/fonts/roboto/roboto-medium.ttf", 17);
    bold = createFont ("/data/fonts/roboto/roboto-bold.ttf", 17);
  }
}
class Caros {
  PFont regular, medium, bold;

  Caros () {
    regular = createFont ("/data/fonts/caros/caros-regular.otf", 17);
    medium = createFont ("/data/fonts/caros/caros-medium.otf", 17);
    bold = createFont ("/data/fonts/caros/caros-bold.otf", 17);
  }
}
class Visby {
  PFont demiBold;

  Visby () {
    demiBold  = createFont ("data/fonts/visby/VisbyRoundCF-DemiBold.otf", 17);
  }
}
