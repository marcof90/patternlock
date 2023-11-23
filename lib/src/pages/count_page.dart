import 'package:flutter/material.dart';
import 'package:flutter_pcsc/flutter_pcsc.dart';

class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  final _estiloTexto = const TextStyle(fontSize: 20);
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Titulo usando stateful'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Número de clicks:', style: _estiloTexto),
            Text('$_count', style: _estiloTexto)
          ],
        ),
      ),
      floatingActionButton: _crearBotones(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _crearBotones() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      const SizedBox(width: 20),
      FloatingActionButton(
          onPressed: _reiniciar, child: const Icon(Icons.exposure_zero)),
      const Expanded(child: SizedBox()),
      FloatingActionButton(onPressed: _restar, child: const Icon(Icons.remove)),
      const SizedBox(width: 20),
      FloatingActionButton(onPressed: _agregar, child: const Icon(Icons.add))
    ]);
  }

  void _agregar() {
    setState(() => _count++);
  }

  void _restar() {
    setState(() => _count--);
  }

  _reiniciar() async {
    // setState(() => _count = 0);
    int ctx = await Pcsc.establishContext(PcscSCope.user);
    List<String> readers = await Pcsc.listReaders(ctx);

    if (readers.isEmpty) {
      print('Could not detect any reader');
    } else {
      String reader = readers[0]; // let's use the first available reader

      CardStruct card = await Pcsc.cardConnect(
          ctx, reader, PcscShare.shared, PcscProtocol.any);
      var response = await Pcsc.transmit(card, [0xFF, 0xCA, 0x00, 0x00, 0x00]);
      print('Response: $response');

      await Pcsc.cardDisconnect(card.hCard, PcscDisposition.resetCard);
    }
    await Pcsc.releaseContext(ctx);
  }
}
