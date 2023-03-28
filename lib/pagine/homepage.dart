import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 10, bottom: 20, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network('https://www.radiopico.it/wp-content/uploads/2021/04/Scuola.jpg'),
              const SizedBox(height: 15),
              const Text('La nostra scuola', style: TextStyle(fontSize: 25, color: Colors.black, decoration: TextDecoration.none)),
              const SizedBox(height: 20),
              Text(descrizioneScuola(), style: const TextStyle(fontSize: 15,
                color: Colors.black,
                decoration: TextDecoration.none,
              )
              )
            ],
          ),
        ),
      ),
    );
  }

  String descrizioneScuola() {
    return "La scuola che presentiamo si chiama 'Istituto Comprensivo Statale XX'. Si tratta di una scuola di ordine primario e secondario, situata nel centro della città, in una posizione strategica per gli studenti. La scuola offre un'ampia gamma di attività, tra cui un'eccellente formazione accademica, sportiva e artistica. Gli studenti possono scegliere tra diverse materie e attività extracurriculari, come la musica, la danza, il teatro e le lingue straniere. L'istituto è dotato di moderne strutture, tra cui aule attrezzate, una palestra, una biblioteca, un laboratorio di informatica e un'area verde. Inoltre, dispone di un'equipe di insegnanti qualificati e dedicati, che offrono supporto agli studenti in ogni fase del loro percorso scolastico. L'istituto Comprensivo Statale XX si impegna a creare un ambiente di apprendimento distro e stimolante, dove gli studenti possono sviluppare le loro capacità e competenze. La scuola incoraggia gli studenti a diventare cittadini attivi e responsabili, attraverso l'educazione alla cittadinanza e l'impegno sociale. La scuola è aperta a tutti gli studenti della zona, indipendentemente dalle loro origini culturali o sociali. Siamo orgogliosi della diversità della nostra comunità scolastica e lavoriamo per creare un ambiente inclusivo e solidale. In sintesi, l'Istituto Comprensivo Statale XX è una scuola moderna e dinamica, che offre un'eccellente formazione accademica e un ambiente di apprendimento stimolante e sicuro. Siamo impegnati a sostenere gli studenti in ogni fase del loro percorso scolastico e a formare cittadini attivi e responsabili.";
  }
}
