import 'dart:math';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _Calculator();
}

class _Calculator extends State<Calculator> {
  List hitung = []; //hitung
  List<String> angka = []; //angka
  List<String> kondisi = []; //kondisi
  num hasil = 0; //hasil
  bool angkaNeg = false;

  ///angkanegatif
  bool mode = false;
  bool is_C_pressed = false;
  bool history_opened = false;
  bool dot_pressed = false;
  bool addionals = false;

  Map history = {
    'hitung': [], //hitung
    'hasil': [], //hasil
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chageColor(mode),
      body: Column(
        children: [
          Expanded(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                margin: const EdgeInsets.only(top: 40),
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      hitung.map((e) => e).join(),
                      style: TextStyle(fontSize: 35, color: chageColor(!mode)),
                    )
                  ],
                )),
          ),
          const Divider(
            color: Colors.black26,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () {
                    history_opened
                        ? history_opened = false
                        : history_opened = true;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.access_time_outlined,
                    color: chageColor(!mode),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    mode ? mode = false : mode = true;
                    setState(() {});
                  },
                  icon: Icon(
                    changeMode(),
                    color: chageColor(!mode),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    addionals ? addionals = false : addionals = true;
                    setState(() {});
                  },
                  icon:
                      Icon(Icons.calculate_outlined, color: chageColor(!mode)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                IconButton(
                  onPressed: () {
                    hitung.removeLast();
                    if (hitung.isEmpty) {
                      dot_pressed = false;
                    }

                    setState(() {});
                  },
                  icon:
                      Icon(Icons.backspace_outlined, color: chageColor(!mode)),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          Expanded(
            child: history_opened ? history_page() : main_page(),
          ),
        ],
      ),
      floatingActionButton: history_opened
          ? FloatingActionButton.extended(
              onPressed: () {
                history['hitung'].clear();
                history['hasil'].clear();
                setState(() {});
              },
              label: const Text("Clear history"),
              icon: const Icon(Icons.delete_forever_outlined),
            )
          : null,
    );
  }

  button_angka(int son) => ElevatedButton(
        onPressed: () {
          if (angkaNeg) {
            hitung.last = (-son);
            angkaNeg = false;
          } else {
            try {
              if (hitung.last != '²' || hitung.last != '!') {
                hitung.add(son);
              }
            } catch (e) {
              hitung.add(son);
            }
          }

          setState(() {});
        },
        child: Text("$son",
            style: const TextStyle(fontSize: 25, color: Colors.white)),
        style: ElevatedButton.styleFrom(
            primary:
                (mode) ? chageColor(mode) : Colors.grey.shade900, //blackmode
            shape: const CircleBorder(),
            fixedSize: const Size.fromRadius(35)),
      );

  // ignore: non_constant_identifier_names
  kondisi_buttoni(String simbol, String simbol_toShow, Color color, double size,
          [bck_color = true]) =>
      ElevatedButton(
        onPressed: () {
          if (simbol == 'C') {
            dot_pressed = false;

            hitung = [];
            angka = [];
            kondisi = [];
            hasil = 0;
            setState(() {});
          } else if (simbol == '=') {
            hitung.add('=');
            calculate();
          } else if (simbol == '.') {
            if (!dot_pressed) {
              hitung.add('.');
              dot_pressed = true;
            }
          } else {
            if (simbol == '+/-') {
              if (hitung.isEmpty || hitung.last is! num) {
                angkaNeg = true;
                hitung.add('-');
              } else {
                num logWaktuingcha = num.parse(hitung.join(''));
                hitung.clear();
                hitung.add(-logWaktuingcha);
              }
            } else if (hitung.isEmpty) {
              if (simbol == '√') {
                hitung.add(simbol);
              } else if (simbol == 'π') {
                hitung.add(pi);
              }
            } else if (hitung.last is num) {
              if (simbol == '√' || simbol == 'π') {
                hitung.add('x');
                simbol == 'π' ? hitung.add(pi) : hitung.add(simbol);
              } else {
                hitung.add(simbol);
                debugPrint("$hitung");
              }

              dot_pressed = false;
            } else {
              if (hitung.last == '-' && hitung.length == 1) {
                hitung.removeLast();
              } else if (hitung.isNotEmpty) {
                if (simbol == '√') {
                  hitung.add(simbol);
                } else {
                  simbol == 'π' ? hitung.add(pi) : hitung.last = simbol;
                }
                dot_pressed = false;
              }
            }
          }

          setState(() {});
        },
        child: Text(
          "$simbol_toShow",
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w300,
            color: color,
          ),
        ),
        style: ElevatedButton.styleFrom(
            primary: kondisiButtonColor(bck_color),
            shape: CircleBorder(),
            fixedSize: Size.fromRadius(35)),
      );
  kondisiButtonColor(bool bckColor) {
    if (mode) {
      return bckColor ? Colors.white70 : Colors.green;
    } else {
      return bckColor ? Colors.grey.shade900 : Colors.green;
    }
  }

  changeMode() {
    if (mode) {
      return Icons.light_mode_outlined;
    } else {
      return Icons.dark_mode_outlined;
    }
  }

  chageColor(bool mode) {
    if (mode) {
      return Colors.white70;
    } else {
      return Colors.black;
    }
  }

  calculate() {
    String riwayat = '';
    String logWaktu = '';
    for (var element in hitung) {
      if (element is num || element == '.') {
        logWaktu += (element.toString());
      } else if (element == '=') {
        if (logWaktu != '') {
          angka.add(logWaktu);
          riwayat += logWaktu;
        }

        hasilber();
        history['hitung'].add(riwayat);
        history['hasil'].add('=' + hasil.toString());

        angka = [];
        kondisi = [];
        hitung = [];
        hitung.add(hasil);

        hasil = 0;

        setState(() {});
      } else {
        if (logWaktu != '') {
          angka.add(logWaktu);
          riwayat += logWaktu;
          logWaktu = '';
        }

        kondisi.add(element);
        riwayat += element;
      }
    }
  }

  hasilber() {
    debugPrint("$hitung");

    debugPrint("$kondisi");
    if (kondisi.contains('√')) {
      int index = kondisi.indexOf('√');
      angka[index] = sqrt(num.parse(angka[index])).toString();
      kondisi.remove('√');
    } else if (kondisi.contains('²')) {
      int index = kondisi.indexOf('²');
      angka[index] =
          (num.parse(angka[index]) * num.parse(angka[index])).toString();
      kondisi.remove('²');
    } else if (kondisi.contains('^')) {
      int index = kondisi.indexOf('^');
      num n = num.parse(angka[index]);
      for (var i = 1; i < int.parse(angka[index + 1]); i++) {
        n *= num.parse(angka[index]);
      }
      angka[index] = n.toString();
      angka.remove(angka[index + 1]);
      kondisi.remove('^');
    } else if (kondisi.contains('!')) {
      int index = kondisi.indexOf('!');
      angka[index] = fact((int.parse(angka[index]))).toString();
      kondisi.remove('!');
    }

    for (var i = 0; i < angka.length; i++) {
      if (i == 0) {
        hasil = num.parse(angka[i]);
        setState(() {});
      } else {
        rms(num.parse(angka[i]), kondisi[i - 1]);
      }
    }
  }

  rms(num s1, String btn) {
    switch (btn) {
      case '+':
        hasil = hasil + s1;
        break;
      case '-':
        hasil = hasil - s1;
        break;
      case 'x':
        hasil = hasil * s1;
        break;
      case '/':
        hasil = hasil / s1;
        break;
      case '%':
        hasil = hasil % s1;
        break;

      default:
    }
  }

  int fact(int n) {
    if (n <= 1) //Base Condition
      return 1;
    return n * fact(n - 1);
  }

  main_page() => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                kondisi_buttoni('C', 'C', Colors.red, 30),
                addionals
                    ? kondisi_buttoni('²', 'x²', Colors.green, 30)
                    : kondisi_buttoni('√', '√', Colors.green, 30),
                addionals
                    ? kondisi_buttoni('^', 'x^y', Colors.green, 25)
                    : kondisi_buttoni('%', '%', Colors.green, 30),
                addionals
                    ? kondisi_buttoni('π', 'π', Colors.green, 30)
                    : kondisi_buttoni('/', '/', Colors.green, 30),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                button_angka(7),
                button_angka(8),
                button_angka(9),
                addionals
                    ? kondisi_buttoni('!', 'x!', Colors.green, 30)
                    : kondisi_buttoni('x', 'x', Colors.green, 30),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                button_angka(4),
                button_angka(5),
                button_angka(6),
                kondisi_buttoni('-', '-', Colors.green, 30),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                button_angka(1),
                button_angka(2),
                button_angka(3),
                kondisi_buttoni('+', '+', Colors.green, 30),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                kondisi_buttoni('+/-', '-', Colors.white, 24),
                button_angka(0),
                kondisi_buttoni('.', '.', Colors.white, 30),
                kondisi_buttoni('=', '=', Colors.white, 30, false),
              ],
            ),
          ],
        ),
      );
  history_page() => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: history['hasil'].length,
          itemBuilder: (context, index) {
            return Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Text(
                    history['hitung'][index],
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    history['hasil'][index],
                    style: TextStyle(fontSize: 25, color: Colors.green),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
