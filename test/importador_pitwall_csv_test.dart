// Verifica que el CSV exportado por PitWall (/races/:id/results/control.csv)
// es legible por el importador de resultados (formato TicTacSlot).
// El fixture se genera con: curl http://localhost:3000/races/:id/results/control.csv
import 'package:flutter_test/flutter_test.dart';
import 'package:pitwall/features/resultados/importador_resultados.dart';

void main() {
  test('parsea el CSV exportado por PitWall', () async {
    final filas = await ImportadorResultados.leerArchivo('/tmp/test1_control.csv');
    expect(filas, isNotEmpty);
    expect(filas.first.posicion, 1);
    expect(filas.first.nombreEquipoCsv, 'Besay Porta');
    expect(filas.first.vueltas, 146);
    expect(filas.first.milesimas, 0);
    // ignore: avoid_print
    for (final f in filas) {
      print('${f.posicion}. ${f.nombreEquipoNormalizado}'
          ' copa=${f.copaDetectada} vueltas=${f.vueltas} ms=${f.milesimas} pole=${f.pole}');
    }
  });
}
