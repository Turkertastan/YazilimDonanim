import 'package:cloud_firestore/cloud_firestore.dart';

class IsMakinesiModel {
  String? aciklama;
  Timestamp? tarih;
  String? baslamaSaati;
  String? bitisSaati;
  String? konum;
  String? kullanilacakIs;
  String? hangiArac;
  String? ilanSahibi;

  IsMakinesiModel(
      {this.aciklama,
      this.tarih,
      this.baslamaSaati,
      this.bitisSaati,
      this.konum,
      this.kullanilacakIs,
      this.hangiArac,
      this.ilanSahibi});

  IsMakinesiModel.fromJson(Map<String, dynamic> json) {
    aciklama = json['aciklama'];
    tarih = json['tarih'];
    baslamaSaati = json['baslamaSaati'];
    bitisSaati = json['bitisSaati'];
    konum = json['konum'];
    kullanilacakIs = json['kullanilacakIs'];
    hangiArac = json['hangiArac'];
    ilanSahibi = json['ilanSahibi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aciklama'] = aciklama;
    data['tarih'] = tarih;
    data['baslamaSaati'] = baslamaSaati;
    data['bitisSaati'] = bitisSaati;
    data['konum'] = konum;
    data['kullanilacakIs'] = kullanilacakIs;
    data['hangiArac'] = hangiArac;
    data['ilanSahibi'] = ilanSahibi;
    return data;
  }
}
