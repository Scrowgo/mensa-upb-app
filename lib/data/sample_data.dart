import '../models/dish.dart';

final List<Dish> sampleHauptgerichte = [
  Dish(
    name: 'Asiatische Bratnudeln',
    description: 'Mit buntem Gemüse, Tofu, Sojasprossen und Erdnuss-Crunch.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBfGgXklJvGv9H-YyggPIMHpBI0fbA5d5uvHuH7dJiAyI8Z5kfaLNH07-3qs9Ye2FUC70A-kFSmQxE4RJ4qbUAqQAAYx1YBEAgTgTjijCrrYVrS6bKeLAgL0lghE3BzfBuDzLl6I7DcbIri_BI5PDUVxGfAGqSCwIvZ3jA_Dm016-oZnRFg0j2F1-r9qvGnR0QsUXr20ej33Dzlq-0P5mR4nMt4TiZMui05OH-QPpyQROfmD6IZ7pCTpmZsbU8E3kFSn4U_bOkGJnuO',
    studentPrice: 3.40,
    staffPrice: 4.10,
    guestPrice: 5.80,
    tags: ['Vegan', 'Mild'],
    rating: 4.8,
    energy: '452 kcal',
    fat: '12g',
    carbs: '68g',
    protein: '15g',
    ingredients:
        'Weizennudeln, Chinakohl, Karotten, Lauch, Sojasprossen, Mungobohnen, Sesamöl, Sojasauce, Ingwer, Knoblauch, Chili, Koriander, geröstete Erdnüsse.',
    allergens: ['Glutenhaltiges Getreide', 'Soja', 'Erdnüsse', 'Sesam'],
    category: 'hauptgericht',
  ),
  Dish(
    name: 'Gegrillte Rippchen',
    description: 'Hausgemachte BBQ-Marinade mit Rosmarinkartoffeln.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuB6Wht7uolAdW02vCImcYqFMNIu1Dw816MIG2567DSljZUMVtcBxYho2acSM7lUWhTt7CikUaFWvuGvC76S1teagmYGMhq7HFFkb8rZhHlEmfBSaHBPbPVBa3ip62GAAZY1noybDPtcRzVeiD8xtVTaJfv1ZTuk58sT8Rjlr3vghMQiILzONrA_PwySvJKMkk5Hs0mbndODy2XrBE_NFAHhC9itjCCjl10VWECpUQMsl_er9Atgz78dgBJ4T1J4UXUh_R1vBOcFXbpe',
    studentPrice: 4.20,
    staffPrice: 5.50,
    guestPrice: 7.20,
    tags: ['Regional'],
    rating: 4.5,
    energy: '680 kcal',
    fat: '32g',
    carbs: '45g',
    protein: '38g',
    ingredients:
        'Schweinerippchen, BBQ-Sauce, Rosmarin, Kartoffeln, Knoblauch, Olivenöl, Paprika, Salz, Pfeffer.',
    allergens: ['Senf', 'Sellerie'],
    category: 'hauptgericht',
  ),
];

final List<Dish> sampleBeilagen = [
  Dish(
    name: 'Beilagensalat',
    description: 'Frischer grüner Salat',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBU2u_LWcltnvS1pgkR7WD40iPn8bnU7sDB-Lm6Xf06TxompQHzOCQd1z4eIIyyELfZL4ec4QTcvWyDpp1BsQo4HRocCVIss1n0u2rCxfcWgsyIt9QzfCaalJT3G3yiJbCZ4cwiG2JrKcj5c_W_e57eWXoKthjOb5o0Vu70biJX2VPC3rmJc-RyE-Exo-BND7hnTPNSGzgAS1RtNgxhXkYPpIBuOL7HDugv0GdB46tyrcEjxgifqIjbjpu-nPMsLz68w8BL0-22oj8q',
    studentPrice: 0.80,
    category: 'beilage',
  ),
  Dish(
    name: 'Tagessuppe',
    description: 'Cremige Kartoffelsuppe',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC2AobA-emZSakIWQwP8VMtZhwfqhpWgavVC24kgHh6FeeAOz0ia4XcPxbWtttkjjjp2TJQFYegLmop6LhKCHmDx3ztZS2fiJr0Wy-UaNJhoeJJ5skdnKU-p3ooEILw2xi1jPfN273wclbbgCfwlz87RT4QbCdfMInJmX62buOLOUcMF3SP6m3bWJ-vuSVnO7iPqJvKdn16PBBh2g0FAjHUTmGWTdAPjGlkgLxCXb0bKVd56n6zD4Y73hfJdpYSJnKya9ar3wjqzh6Z',
    studentPrice: 1.10,
    category: 'beilage',
  ),
];

final List<Dish> sampleDesserts = [
  Dish(
    name: 'Schokopudding',
    description: 'Schokoladenpudding mit Vanilleswirl',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD7ow1XrGTu1i-HTWsaHU1ovhItAPWj4NZaiJ_gCiDDmDDtYYog8oBABCanFEWaO5ctQQzVhWMyMP1BlCy7JObVz2qgD70cH_QcFNWnTP8x-75CdUldnS5NNaMyRqsW7l1BaP0Y0dnsKrfBAvcLm2mbxn3bQcR66KRX6vYOHfEpgOuBU6aFJObJXfQw7plcWTX2nFxgq1ffncohuTyTruulfiozIU5iTQW3migOt01p_WUhgrSMsMQXH2flYGg0qsJ8ujLQp90_rDv_',
    studentPrice: 0.90,
    category: 'dessert',
  ),
];
