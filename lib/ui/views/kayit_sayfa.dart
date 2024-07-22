import 'package:flutter/material.dart';
import 'package:sinirbozucu/data/repository/kisiler_dao_repository.dart';

import '../../data/repo/kisilerdao_repository.dart';

class KayitSayfa extends StatefulWidget {
  const KayitSayfa({super.key});

  @override
  State<KayitSayfa> createState() => _KayitSayfaState();
}

class _KayitSayfaState extends State<KayitSayfa> {
  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();
  var repository = KisilerDaoRepository();

  Future<void> kaydet(String kisi_ad, String kisi_tel) async {
    await repository.kaydet(kisi_ad, kisi_tel);
    Navigator.pop(context, true); // Veri kaydedildikten sonra önceki sayfaya dön
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Sayfa"),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfKisiAdi,
                decoration: const InputDecoration(hintText: "Kişi Ad"),
              ),
              TextField(
                controller: tfKisiTel,
                decoration: const InputDecoration(hintText: "Kişi Tel"),
              ),
              ElevatedButton(
                onPressed: () {
                  kaydet(tfKisiAdi.text, tfKisiTel.text);
                },
                child: const Text("KAYDET"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
