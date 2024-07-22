import 'package:flutter/material.dart';
import 'package:sinirbozucu/data/entity/kisiler.dart';
import 'package:sinirbozucu/data/repo/kisilerdao_repository.dart';
import 'package:sinirbozucu/ui/views/detay_sayfa.dart';
import 'package:sinirbozucu/ui/views/kayit_sayfa.dart';
import 'package:sinirbozucu/data/repository/kisiler_dao_repository.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});
  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;
  var repository = KisilerDaoRepository();
  late Future<List<Kisiler>> kisilerListesiFuture;

  @override
  void initState() {
    super.initState();
    kisilerListesiFuture = kisileriYukle();
  }

  Future<void> ara(String aramaKelimesi) async {
    setState(() {
      kisilerListesiFuture = repository.ara(aramaKelimesi);
    });
  }

  Future<List<Kisiler>> kisileriYukle() async {
    return await repository.kisileriYukle();
  }

  Future<void> sil(int kisi_id) async {
    await repository.sil(kisi_id);
    setState(() {
      kisilerListesiFuture = kisileriYukle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
          decoration: const InputDecoration(hintText: "Ara"),
          onChanged: (aramaSonucu) {
            ara(aramaSonucu);
          },
        )
            : const Text("Kişiler"),
        actions: [
          aramaYapiliyorMu
              ? IconButton(
              onPressed: () {
                setState(() {
                  aramaYapiliyorMu = false;
                  kisilerListesiFuture = kisileriYukle();
                });
              },
              icon: const Icon(Icons.clear))
              : IconButton(
              onPressed: () {
                setState(() {
                  aramaYapiliyorMu = true;
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: FutureBuilder<List<Kisiler>>(
        future: kisilerListesiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var kisilerListesi = snapshot.data!;
            return ListView.builder(
              itemCount: kisilerListesi.length,
              itemBuilder: (context, indeks) {
                var kisi = kisilerListesi[indeks];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetaySayfa(kisi: kisi)))
                        .then((value) {
                      setState(() {
                        kisilerListesiFuture = kisileriYukle();
                      });
                    });
                  },
                  child: Card(
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kisi.kisi_ad,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(kisi.kisi_tel),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${kisi.kisi_ad} silinsin mi?"),
                                  action: SnackBarAction(
                                    label: "Evet",
                                    onPressed: () {
                                      sil(kisi.kisi_id);
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Veri yok"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const KayitSayfa()))
              .then((value) {
            setState(() {
              kisilerListesiFuture = kisileriYukle();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
