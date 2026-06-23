// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CampeonatosTable extends Campeonatos
    with TableInfo<$CampeonatosTable, Campeonato> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CampeonatosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatoMeta = const VerificationMeta(
    'formato',
  );
  @override
  late final GeneratedColumn<String> formato = GeneratedColumn<String>(
    'formato',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anioMeta = const VerificationMeta('anio');
  @override
  late final GeneratedColumn<int> anio = GeneratedColumn<int>(
    'anio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizacionMeta = const VerificationMeta(
    'organizacion',
  );
  @override
  late final GeneratedColumn<String> organizacion = GeneratedColumn<String>(
    'organizacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Resisbarna'),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _topeRegularizacionMeta =
      const VerificationMeta('topeRegularizacion');
  @override
  late final GeneratedColumn<int> topeRegularizacion = GeneratedColumn<int>(
    'tope_regularizacion',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(28),
  );
  static const VerificationMeta _numDescartesMeta = const VerificationMeta(
    'numDescartes',
  );
  @override
  late final GeneratedColumn<int> numDescartes = GeneratedColumn<int>(
    'num_descartes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _usaCreditosMeta = const VerificationMeta(
    'usaCreditos',
  );
  @override
  late final GeneratedColumn<bool> usaCreditos = GeneratedColumn<bool>(
    'usa_creditos',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("usa_creditos" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _usaTesoreriaMeta = const VerificationMeta(
    'usaTesoreria',
  );
  @override
  late final GeneratedColumn<bool> usaTesoreria = GeneratedColumn<bool>(
    'usa_tesoreria',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("usa_tesoreria" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _finalizadoMeta = const VerificationMeta(
    'finalizado',
  );
  @override
  late final GeneratedColumn<bool> finalizado = GeneratedColumn<bool>(
    'finalizado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("finalizado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _copasJsonMeta = const VerificationMeta(
    'copasJson',
  );
  @override
  late final GeneratedColumn<String> copasJson = GeneratedColumn<String>(
    'copas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _cuotaPagatMeta = const VerificationMeta(
    'cuotaPagat',
  );
  @override
  late final GeneratedColumn<double> cuotaPagat = GeneratedColumn<double>(
    'cuota_pagat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(25.0),
  );
  static const VerificationMeta _cuotaCoordinadoraMeta = const VerificationMeta(
    'cuotaCoordinadora',
  );
  @override
  late final GeneratedColumn<double> cuotaCoordinadora =
      GeneratedColumn<double>(
        'cuota_coordinadora',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(11.0),
      );
  static const VerificationMeta _cuotaClubMeta = const VerificationMeta(
    'cuotaClub',
  );
  @override
  late final GeneratedColumn<double> cuotaClub = GeneratedColumn<double>(
    'cuota_club',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(14.0),
  );
  static const VerificationMeta _motorSorteoMinMeta = const VerificationMeta(
    'motorSorteoMin',
  );
  @override
  late final GeneratedColumn<int> motorSorteoMin = GeneratedColumn<int>(
    'motor_sorteo_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motorSorteoMaxMeta = const VerificationMeta(
    'motorSorteoMax',
  );
  @override
  late final GeneratedColumn<int> motorSorteoMax = GeneratedColumn<int>(
    'motor_sorteo_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinonDientesMinMeta = const VerificationMeta(
    'pinonDientesMin',
  );
  @override
  late final GeneratedColumn<int> pinonDientesMin = GeneratedColumn<int>(
    'pinon_dientes_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _pinonDientesMaxMeta = const VerificationMeta(
    'pinonDientesMax',
  );
  @override
  late final GeneratedColumn<int> pinonDientesMax = GeneratedColumn<int>(
    'pinon_dientes_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _coronaDientesMinMeta = const VerificationMeta(
    'coronaDientesMin',
  );
  @override
  late final GeneratedColumn<int> coronaDientesMin = GeneratedColumn<int>(
    'corona_dientes_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(24),
  );
  static const VerificationMeta _coronaDientesMaxMeta = const VerificationMeta(
    'coronaDientesMax',
  );
  @override
  late final GeneratedColumn<int> coronaDientesMax = GeneratedColumn<int>(
    'corona_dientes_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _marcaTituloMeta = const VerificationMeta(
    'marcaTitulo',
  );
  @override
  late final GeneratedColumn<String> marcaTitulo = GeneratedColumn<String>(
    'marca_titulo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _marcaLemaMeta = const VerificationMeta(
    'marcaLema',
  );
  @override
  late final GeneratedColumn<String> marcaLema = GeneratedColumn<String>(
    'marca_lema',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    formato,
    anio,
    organizacion,
    activo,
    topeRegularizacion,
    numDescartes,
    usaCreditos,
    usaTesoreria,
    finalizado,
    copasJson,
    cuotaPagat,
    cuotaCoordinadora,
    cuotaClub,
    motorSorteoMin,
    motorSorteoMax,
    pinonDientesMin,
    pinonDientesMax,
    coronaDientesMin,
    coronaDientesMax,
    marcaTitulo,
    marcaLema,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'campeonatos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Campeonato> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('formato')) {
      context.handle(
        _formatoMeta,
        formato.isAcceptableOrUnknown(data['formato']!, _formatoMeta),
      );
    } else if (isInserting) {
      context.missing(_formatoMeta);
    }
    if (data.containsKey('anio')) {
      context.handle(
        _anioMeta,
        anio.isAcceptableOrUnknown(data['anio']!, _anioMeta),
      );
    } else if (isInserting) {
      context.missing(_anioMeta);
    }
    if (data.containsKey('organizacion')) {
      context.handle(
        _organizacionMeta,
        organizacion.isAcceptableOrUnknown(
          data['organizacion']!,
          _organizacionMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('tope_regularizacion')) {
      context.handle(
        _topeRegularizacionMeta,
        topeRegularizacion.isAcceptableOrUnknown(
          data['tope_regularizacion']!,
          _topeRegularizacionMeta,
        ),
      );
    }
    if (data.containsKey('num_descartes')) {
      context.handle(
        _numDescartesMeta,
        numDescartes.isAcceptableOrUnknown(
          data['num_descartes']!,
          _numDescartesMeta,
        ),
      );
    }
    if (data.containsKey('usa_creditos')) {
      context.handle(
        _usaCreditosMeta,
        usaCreditos.isAcceptableOrUnknown(
          data['usa_creditos']!,
          _usaCreditosMeta,
        ),
      );
    }
    if (data.containsKey('usa_tesoreria')) {
      context.handle(
        _usaTesoreriaMeta,
        usaTesoreria.isAcceptableOrUnknown(
          data['usa_tesoreria']!,
          _usaTesoreriaMeta,
        ),
      );
    }
    if (data.containsKey('finalizado')) {
      context.handle(
        _finalizadoMeta,
        finalizado.isAcceptableOrUnknown(data['finalizado']!, _finalizadoMeta),
      );
    }
    if (data.containsKey('copas_json')) {
      context.handle(
        _copasJsonMeta,
        copasJson.isAcceptableOrUnknown(data['copas_json']!, _copasJsonMeta),
      );
    }
    if (data.containsKey('cuota_pagat')) {
      context.handle(
        _cuotaPagatMeta,
        cuotaPagat.isAcceptableOrUnknown(data['cuota_pagat']!, _cuotaPagatMeta),
      );
    }
    if (data.containsKey('cuota_coordinadora')) {
      context.handle(
        _cuotaCoordinadoraMeta,
        cuotaCoordinadora.isAcceptableOrUnknown(
          data['cuota_coordinadora']!,
          _cuotaCoordinadoraMeta,
        ),
      );
    }
    if (data.containsKey('cuota_club')) {
      context.handle(
        _cuotaClubMeta,
        cuotaClub.isAcceptableOrUnknown(data['cuota_club']!, _cuotaClubMeta),
      );
    }
    if (data.containsKey('motor_sorteo_min')) {
      context.handle(
        _motorSorteoMinMeta,
        motorSorteoMin.isAcceptableOrUnknown(
          data['motor_sorteo_min']!,
          _motorSorteoMinMeta,
        ),
      );
    }
    if (data.containsKey('motor_sorteo_max')) {
      context.handle(
        _motorSorteoMaxMeta,
        motorSorteoMax.isAcceptableOrUnknown(
          data['motor_sorteo_max']!,
          _motorSorteoMaxMeta,
        ),
      );
    }
    if (data.containsKey('pinon_dientes_min')) {
      context.handle(
        _pinonDientesMinMeta,
        pinonDientesMin.isAcceptableOrUnknown(
          data['pinon_dientes_min']!,
          _pinonDientesMinMeta,
        ),
      );
    }
    if (data.containsKey('pinon_dientes_max')) {
      context.handle(
        _pinonDientesMaxMeta,
        pinonDientesMax.isAcceptableOrUnknown(
          data['pinon_dientes_max']!,
          _pinonDientesMaxMeta,
        ),
      );
    }
    if (data.containsKey('corona_dientes_min')) {
      context.handle(
        _coronaDientesMinMeta,
        coronaDientesMin.isAcceptableOrUnknown(
          data['corona_dientes_min']!,
          _coronaDientesMinMeta,
        ),
      );
    }
    if (data.containsKey('corona_dientes_max')) {
      context.handle(
        _coronaDientesMaxMeta,
        coronaDientesMax.isAcceptableOrUnknown(
          data['corona_dientes_max']!,
          _coronaDientesMaxMeta,
        ),
      );
    }
    if (data.containsKey('marca_titulo')) {
      context.handle(
        _marcaTituloMeta,
        marcaTitulo.isAcceptableOrUnknown(
          data['marca_titulo']!,
          _marcaTituloMeta,
        ),
      );
    }
    if (data.containsKey('marca_lema')) {
      context.handle(
        _marcaLemaMeta,
        marcaLema.isAcceptableOrUnknown(data['marca_lema']!, _marcaLemaMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Campeonato map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Campeonato(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      formato: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formato'],
      )!,
      anio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anio'],
      )!,
      organizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organizacion'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      topeRegularizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tope_regularizacion'],
      )!,
      numDescartes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_descartes'],
      )!,
      usaCreditos: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}usa_creditos'],
      )!,
      usaTesoreria: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}usa_tesoreria'],
      )!,
      finalizado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}finalizado'],
      )!,
      copasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copas_json'],
      )!,
      cuotaPagat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cuota_pagat'],
      )!,
      cuotaCoordinadora: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cuota_coordinadora'],
      )!,
      cuotaClub: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cuota_club'],
      )!,
      motorSorteoMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motor_sorteo_min'],
      ),
      motorSorteoMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motor_sorteo_max'],
      ),
      pinonDientesMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pinon_dientes_min'],
      )!,
      pinonDientesMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pinon_dientes_max'],
      )!,
      coronaDientesMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corona_dientes_min'],
      )!,
      coronaDientesMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corona_dientes_max'],
      )!,
      marcaTitulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca_titulo'],
      ),
      marcaLema: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca_lema'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $CampeonatosTable createAlias(String alias) {
    return $CampeonatosTable(attachedDatabase, alias);
  }
}

class Campeonato extends DataClass implements Insertable<Campeonato> {
  final int id;
  final String nombre;
  final String formato;
  final int anio;
  final String organizacion;
  final bool activo;
  final int topeRegularizacion;
  final int numDescartes;

  /// Si true, el campeonato usa el sistema de créditos/handicap (Resisbarna).
  /// Si false, se ocultan todos los campos relacionados con créditos.
  final bool usaCreditos;

  /// Si true, el campeonato gestiona tesorería (cuotas/pagos por prueba).
  final bool usaTesoreria;

  /// Si true, el campeonato está finalizado (temporada cerrada).
  final bool finalizado;

  /// Lista de copas/categorías activas para este campeonato (JSON array de strings).
  /// Ej: ["GT","GT2","SLOT.IT"] o ["Grupo C","Clásicos"].
  final String copasJson;

  /// Cuota total que paga un equipo por prueba en este campeonato.
  final double cuotaPagat;

  /// De esa cuota, la parte que va a coordinadora.
  final double cuotaCoordinadora;

  /// De esa cuota, la parte que va al club.
  final double cuotaClub;

  /// Rango de números de motor de organización para el sorteo (inclusive).
  /// Si están a null, el sorteo de motores no está configurado.
  final int? motorSorteoMin;
  final int? motorSorteoMax;

  /// Rango de dientes permitido en la verificación (inclusive). Por defecto el
  /// histórico de Resisbarna: piñón 12 fijo, corona 24-30.
  final int pinonDientesMin;
  final int pinonDientesMax;
  final int coronaDientesMin;
  final int coronaDientesMax;

  /// Marca propia del campeonato en los PDF (título de cabecera y lema del
  /// pie). Si están vacíos se usa la marca global de la app.
  final String? marcaTitulo;
  final String? marcaLema;
  final DateTime creadoEn;
  const Campeonato({
    required this.id,
    required this.nombre,
    required this.formato,
    required this.anio,
    required this.organizacion,
    required this.activo,
    required this.topeRegularizacion,
    required this.numDescartes,
    required this.usaCreditos,
    required this.usaTesoreria,
    required this.finalizado,
    required this.copasJson,
    required this.cuotaPagat,
    required this.cuotaCoordinadora,
    required this.cuotaClub,
    this.motorSorteoMin,
    this.motorSorteoMax,
    required this.pinonDientesMin,
    required this.pinonDientesMax,
    required this.coronaDientesMin,
    required this.coronaDientesMax,
    this.marcaTitulo,
    this.marcaLema,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['formato'] = Variable<String>(formato);
    map['anio'] = Variable<int>(anio);
    map['organizacion'] = Variable<String>(organizacion);
    map['activo'] = Variable<bool>(activo);
    map['tope_regularizacion'] = Variable<int>(topeRegularizacion);
    map['num_descartes'] = Variable<int>(numDescartes);
    map['usa_creditos'] = Variable<bool>(usaCreditos);
    map['usa_tesoreria'] = Variable<bool>(usaTesoreria);
    map['finalizado'] = Variable<bool>(finalizado);
    map['copas_json'] = Variable<String>(copasJson);
    map['cuota_pagat'] = Variable<double>(cuotaPagat);
    map['cuota_coordinadora'] = Variable<double>(cuotaCoordinadora);
    map['cuota_club'] = Variable<double>(cuotaClub);
    if (!nullToAbsent || motorSorteoMin != null) {
      map['motor_sorteo_min'] = Variable<int>(motorSorteoMin);
    }
    if (!nullToAbsent || motorSorteoMax != null) {
      map['motor_sorteo_max'] = Variable<int>(motorSorteoMax);
    }
    map['pinon_dientes_min'] = Variable<int>(pinonDientesMin);
    map['pinon_dientes_max'] = Variable<int>(pinonDientesMax);
    map['corona_dientes_min'] = Variable<int>(coronaDientesMin);
    map['corona_dientes_max'] = Variable<int>(coronaDientesMax);
    if (!nullToAbsent || marcaTitulo != null) {
      map['marca_titulo'] = Variable<String>(marcaTitulo);
    }
    if (!nullToAbsent || marcaLema != null) {
      map['marca_lema'] = Variable<String>(marcaLema);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  CampeonatosCompanion toCompanion(bool nullToAbsent) {
    return CampeonatosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      formato: Value(formato),
      anio: Value(anio),
      organizacion: Value(organizacion),
      activo: Value(activo),
      topeRegularizacion: Value(topeRegularizacion),
      numDescartes: Value(numDescartes),
      usaCreditos: Value(usaCreditos),
      usaTesoreria: Value(usaTesoreria),
      finalizado: Value(finalizado),
      copasJson: Value(copasJson),
      cuotaPagat: Value(cuotaPagat),
      cuotaCoordinadora: Value(cuotaCoordinadora),
      cuotaClub: Value(cuotaClub),
      motorSorteoMin: motorSorteoMin == null && nullToAbsent
          ? const Value.absent()
          : Value(motorSorteoMin),
      motorSorteoMax: motorSorteoMax == null && nullToAbsent
          ? const Value.absent()
          : Value(motorSorteoMax),
      pinonDientesMin: Value(pinonDientesMin),
      pinonDientesMax: Value(pinonDientesMax),
      coronaDientesMin: Value(coronaDientesMin),
      coronaDientesMax: Value(coronaDientesMax),
      marcaTitulo: marcaTitulo == null && nullToAbsent
          ? const Value.absent()
          : Value(marcaTitulo),
      marcaLema: marcaLema == null && nullToAbsent
          ? const Value.absent()
          : Value(marcaLema),
      creadoEn: Value(creadoEn),
    );
  }

  factory Campeonato.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Campeonato(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      formato: serializer.fromJson<String>(json['formato']),
      anio: serializer.fromJson<int>(json['anio']),
      organizacion: serializer.fromJson<String>(json['organizacion']),
      activo: serializer.fromJson<bool>(json['activo']),
      topeRegularizacion: serializer.fromJson<int>(json['topeRegularizacion']),
      numDescartes: serializer.fromJson<int>(json['numDescartes']),
      usaCreditos: serializer.fromJson<bool>(json['usaCreditos']),
      usaTesoreria: serializer.fromJson<bool>(json['usaTesoreria']),
      finalizado: serializer.fromJson<bool>(json['finalizado']),
      copasJson: serializer.fromJson<String>(json['copasJson']),
      cuotaPagat: serializer.fromJson<double>(json['cuotaPagat']),
      cuotaCoordinadora: serializer.fromJson<double>(json['cuotaCoordinadora']),
      cuotaClub: serializer.fromJson<double>(json['cuotaClub']),
      motorSorteoMin: serializer.fromJson<int?>(json['motorSorteoMin']),
      motorSorteoMax: serializer.fromJson<int?>(json['motorSorteoMax']),
      pinonDientesMin: serializer.fromJson<int>(json['pinonDientesMin']),
      pinonDientesMax: serializer.fromJson<int>(json['pinonDientesMax']),
      coronaDientesMin: serializer.fromJson<int>(json['coronaDientesMin']),
      coronaDientesMax: serializer.fromJson<int>(json['coronaDientesMax']),
      marcaTitulo: serializer.fromJson<String?>(json['marcaTitulo']),
      marcaLema: serializer.fromJson<String?>(json['marcaLema']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'formato': serializer.toJson<String>(formato),
      'anio': serializer.toJson<int>(anio),
      'organizacion': serializer.toJson<String>(organizacion),
      'activo': serializer.toJson<bool>(activo),
      'topeRegularizacion': serializer.toJson<int>(topeRegularizacion),
      'numDescartes': serializer.toJson<int>(numDescartes),
      'usaCreditos': serializer.toJson<bool>(usaCreditos),
      'usaTesoreria': serializer.toJson<bool>(usaTesoreria),
      'finalizado': serializer.toJson<bool>(finalizado),
      'copasJson': serializer.toJson<String>(copasJson),
      'cuotaPagat': serializer.toJson<double>(cuotaPagat),
      'cuotaCoordinadora': serializer.toJson<double>(cuotaCoordinadora),
      'cuotaClub': serializer.toJson<double>(cuotaClub),
      'motorSorteoMin': serializer.toJson<int?>(motorSorteoMin),
      'motorSorteoMax': serializer.toJson<int?>(motorSorteoMax),
      'pinonDientesMin': serializer.toJson<int>(pinonDientesMin),
      'pinonDientesMax': serializer.toJson<int>(pinonDientesMax),
      'coronaDientesMin': serializer.toJson<int>(coronaDientesMin),
      'coronaDientesMax': serializer.toJson<int>(coronaDientesMax),
      'marcaTitulo': serializer.toJson<String?>(marcaTitulo),
      'marcaLema': serializer.toJson<String?>(marcaLema),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Campeonato copyWith({
    int? id,
    String? nombre,
    String? formato,
    int? anio,
    String? organizacion,
    bool? activo,
    int? topeRegularizacion,
    int? numDescartes,
    bool? usaCreditos,
    bool? usaTesoreria,
    bool? finalizado,
    String? copasJson,
    double? cuotaPagat,
    double? cuotaCoordinadora,
    double? cuotaClub,
    Value<int?> motorSorteoMin = const Value.absent(),
    Value<int?> motorSorteoMax = const Value.absent(),
    int? pinonDientesMin,
    int? pinonDientesMax,
    int? coronaDientesMin,
    int? coronaDientesMax,
    Value<String?> marcaTitulo = const Value.absent(),
    Value<String?> marcaLema = const Value.absent(),
    DateTime? creadoEn,
  }) => Campeonato(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    formato: formato ?? this.formato,
    anio: anio ?? this.anio,
    organizacion: organizacion ?? this.organizacion,
    activo: activo ?? this.activo,
    topeRegularizacion: topeRegularizacion ?? this.topeRegularizacion,
    numDescartes: numDescartes ?? this.numDescartes,
    usaCreditos: usaCreditos ?? this.usaCreditos,
    usaTesoreria: usaTesoreria ?? this.usaTesoreria,
    finalizado: finalizado ?? this.finalizado,
    copasJson: copasJson ?? this.copasJson,
    cuotaPagat: cuotaPagat ?? this.cuotaPagat,
    cuotaCoordinadora: cuotaCoordinadora ?? this.cuotaCoordinadora,
    cuotaClub: cuotaClub ?? this.cuotaClub,
    motorSorteoMin: motorSorteoMin.present
        ? motorSorteoMin.value
        : this.motorSorteoMin,
    motorSorteoMax: motorSorteoMax.present
        ? motorSorteoMax.value
        : this.motorSorteoMax,
    pinonDientesMin: pinonDientesMin ?? this.pinonDientesMin,
    pinonDientesMax: pinonDientesMax ?? this.pinonDientesMax,
    coronaDientesMin: coronaDientesMin ?? this.coronaDientesMin,
    coronaDientesMax: coronaDientesMax ?? this.coronaDientesMax,
    marcaTitulo: marcaTitulo.present ? marcaTitulo.value : this.marcaTitulo,
    marcaLema: marcaLema.present ? marcaLema.value : this.marcaLema,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  Campeonato copyWithCompanion(CampeonatosCompanion data) {
    return Campeonato(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      formato: data.formato.present ? data.formato.value : this.formato,
      anio: data.anio.present ? data.anio.value : this.anio,
      organizacion: data.organizacion.present
          ? data.organizacion.value
          : this.organizacion,
      activo: data.activo.present ? data.activo.value : this.activo,
      topeRegularizacion: data.topeRegularizacion.present
          ? data.topeRegularizacion.value
          : this.topeRegularizacion,
      numDescartes: data.numDescartes.present
          ? data.numDescartes.value
          : this.numDescartes,
      usaCreditos: data.usaCreditos.present
          ? data.usaCreditos.value
          : this.usaCreditos,
      usaTesoreria: data.usaTesoreria.present
          ? data.usaTesoreria.value
          : this.usaTesoreria,
      finalizado: data.finalizado.present
          ? data.finalizado.value
          : this.finalizado,
      copasJson: data.copasJson.present ? data.copasJson.value : this.copasJson,
      cuotaPagat: data.cuotaPagat.present
          ? data.cuotaPagat.value
          : this.cuotaPagat,
      cuotaCoordinadora: data.cuotaCoordinadora.present
          ? data.cuotaCoordinadora.value
          : this.cuotaCoordinadora,
      cuotaClub: data.cuotaClub.present ? data.cuotaClub.value : this.cuotaClub,
      motorSorteoMin: data.motorSorteoMin.present
          ? data.motorSorteoMin.value
          : this.motorSorteoMin,
      motorSorteoMax: data.motorSorteoMax.present
          ? data.motorSorteoMax.value
          : this.motorSorteoMax,
      pinonDientesMin: data.pinonDientesMin.present
          ? data.pinonDientesMin.value
          : this.pinonDientesMin,
      pinonDientesMax: data.pinonDientesMax.present
          ? data.pinonDientesMax.value
          : this.pinonDientesMax,
      coronaDientesMin: data.coronaDientesMin.present
          ? data.coronaDientesMin.value
          : this.coronaDientesMin,
      coronaDientesMax: data.coronaDientesMax.present
          ? data.coronaDientesMax.value
          : this.coronaDientesMax,
      marcaTitulo: data.marcaTitulo.present
          ? data.marcaTitulo.value
          : this.marcaTitulo,
      marcaLema: data.marcaLema.present ? data.marcaLema.value : this.marcaLema,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Campeonato(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('formato: $formato, ')
          ..write('anio: $anio, ')
          ..write('organizacion: $organizacion, ')
          ..write('activo: $activo, ')
          ..write('topeRegularizacion: $topeRegularizacion, ')
          ..write('numDescartes: $numDescartes, ')
          ..write('usaCreditos: $usaCreditos, ')
          ..write('usaTesoreria: $usaTesoreria, ')
          ..write('finalizado: $finalizado, ')
          ..write('copasJson: $copasJson, ')
          ..write('cuotaPagat: $cuotaPagat, ')
          ..write('cuotaCoordinadora: $cuotaCoordinadora, ')
          ..write('cuotaClub: $cuotaClub, ')
          ..write('motorSorteoMin: $motorSorteoMin, ')
          ..write('motorSorteoMax: $motorSorteoMax, ')
          ..write('pinonDientesMin: $pinonDientesMin, ')
          ..write('pinonDientesMax: $pinonDientesMax, ')
          ..write('coronaDientesMin: $coronaDientesMin, ')
          ..write('coronaDientesMax: $coronaDientesMax, ')
          ..write('marcaTitulo: $marcaTitulo, ')
          ..write('marcaLema: $marcaLema, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    nombre,
    formato,
    anio,
    organizacion,
    activo,
    topeRegularizacion,
    numDescartes,
    usaCreditos,
    usaTesoreria,
    finalizado,
    copasJson,
    cuotaPagat,
    cuotaCoordinadora,
    cuotaClub,
    motorSorteoMin,
    motorSorteoMax,
    pinonDientesMin,
    pinonDientesMax,
    coronaDientesMin,
    coronaDientesMax,
    marcaTitulo,
    marcaLema,
    creadoEn,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Campeonato &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.formato == this.formato &&
          other.anio == this.anio &&
          other.organizacion == this.organizacion &&
          other.activo == this.activo &&
          other.topeRegularizacion == this.topeRegularizacion &&
          other.numDescartes == this.numDescartes &&
          other.usaCreditos == this.usaCreditos &&
          other.usaTesoreria == this.usaTesoreria &&
          other.finalizado == this.finalizado &&
          other.copasJson == this.copasJson &&
          other.cuotaPagat == this.cuotaPagat &&
          other.cuotaCoordinadora == this.cuotaCoordinadora &&
          other.cuotaClub == this.cuotaClub &&
          other.motorSorteoMin == this.motorSorteoMin &&
          other.motorSorteoMax == this.motorSorteoMax &&
          other.pinonDientesMin == this.pinonDientesMin &&
          other.pinonDientesMax == this.pinonDientesMax &&
          other.coronaDientesMin == this.coronaDientesMin &&
          other.coronaDientesMax == this.coronaDientesMax &&
          other.marcaTitulo == this.marcaTitulo &&
          other.marcaLema == this.marcaLema &&
          other.creadoEn == this.creadoEn);
}

class CampeonatosCompanion extends UpdateCompanion<Campeonato> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> formato;
  final Value<int> anio;
  final Value<String> organizacion;
  final Value<bool> activo;
  final Value<int> topeRegularizacion;
  final Value<int> numDescartes;
  final Value<bool> usaCreditos;
  final Value<bool> usaTesoreria;
  final Value<bool> finalizado;
  final Value<String> copasJson;
  final Value<double> cuotaPagat;
  final Value<double> cuotaCoordinadora;
  final Value<double> cuotaClub;
  final Value<int?> motorSorteoMin;
  final Value<int?> motorSorteoMax;
  final Value<int> pinonDientesMin;
  final Value<int> pinonDientesMax;
  final Value<int> coronaDientesMin;
  final Value<int> coronaDientesMax;
  final Value<String?> marcaTitulo;
  final Value<String?> marcaLema;
  final Value<DateTime> creadoEn;
  const CampeonatosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.formato = const Value.absent(),
    this.anio = const Value.absent(),
    this.organizacion = const Value.absent(),
    this.activo = const Value.absent(),
    this.topeRegularizacion = const Value.absent(),
    this.numDescartes = const Value.absent(),
    this.usaCreditos = const Value.absent(),
    this.usaTesoreria = const Value.absent(),
    this.finalizado = const Value.absent(),
    this.copasJson = const Value.absent(),
    this.cuotaPagat = const Value.absent(),
    this.cuotaCoordinadora = const Value.absent(),
    this.cuotaClub = const Value.absent(),
    this.motorSorteoMin = const Value.absent(),
    this.motorSorteoMax = const Value.absent(),
    this.pinonDientesMin = const Value.absent(),
    this.pinonDientesMax = const Value.absent(),
    this.coronaDientesMin = const Value.absent(),
    this.coronaDientesMax = const Value.absent(),
    this.marcaTitulo = const Value.absent(),
    this.marcaLema = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  CampeonatosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String formato,
    required int anio,
    this.organizacion = const Value.absent(),
    this.activo = const Value.absent(),
    this.topeRegularizacion = const Value.absent(),
    this.numDescartes = const Value.absent(),
    this.usaCreditos = const Value.absent(),
    this.usaTesoreria = const Value.absent(),
    this.finalizado = const Value.absent(),
    this.copasJson = const Value.absent(),
    this.cuotaPagat = const Value.absent(),
    this.cuotaCoordinadora = const Value.absent(),
    this.cuotaClub = const Value.absent(),
    this.motorSorteoMin = const Value.absent(),
    this.motorSorteoMax = const Value.absent(),
    this.pinonDientesMin = const Value.absent(),
    this.pinonDientesMax = const Value.absent(),
    this.coronaDientesMin = const Value.absent(),
    this.coronaDientesMax = const Value.absent(),
    this.marcaTitulo = const Value.absent(),
    this.marcaLema = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       formato = Value(formato),
       anio = Value(anio);
  static Insertable<Campeonato> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? formato,
    Expression<int>? anio,
    Expression<String>? organizacion,
    Expression<bool>? activo,
    Expression<int>? topeRegularizacion,
    Expression<int>? numDescartes,
    Expression<bool>? usaCreditos,
    Expression<bool>? usaTesoreria,
    Expression<bool>? finalizado,
    Expression<String>? copasJson,
    Expression<double>? cuotaPagat,
    Expression<double>? cuotaCoordinadora,
    Expression<double>? cuotaClub,
    Expression<int>? motorSorteoMin,
    Expression<int>? motorSorteoMax,
    Expression<int>? pinonDientesMin,
    Expression<int>? pinonDientesMax,
    Expression<int>? coronaDientesMin,
    Expression<int>? coronaDientesMax,
    Expression<String>? marcaTitulo,
    Expression<String>? marcaLema,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (formato != null) 'formato': formato,
      if (anio != null) 'anio': anio,
      if (organizacion != null) 'organizacion': organizacion,
      if (activo != null) 'activo': activo,
      if (topeRegularizacion != null) 'tope_regularizacion': topeRegularizacion,
      if (numDescartes != null) 'num_descartes': numDescartes,
      if (usaCreditos != null) 'usa_creditos': usaCreditos,
      if (usaTesoreria != null) 'usa_tesoreria': usaTesoreria,
      if (finalizado != null) 'finalizado': finalizado,
      if (copasJson != null) 'copas_json': copasJson,
      if (cuotaPagat != null) 'cuota_pagat': cuotaPagat,
      if (cuotaCoordinadora != null) 'cuota_coordinadora': cuotaCoordinadora,
      if (cuotaClub != null) 'cuota_club': cuotaClub,
      if (motorSorteoMin != null) 'motor_sorteo_min': motorSorteoMin,
      if (motorSorteoMax != null) 'motor_sorteo_max': motorSorteoMax,
      if (pinonDientesMin != null) 'pinon_dientes_min': pinonDientesMin,
      if (pinonDientesMax != null) 'pinon_dientes_max': pinonDientesMax,
      if (coronaDientesMin != null) 'corona_dientes_min': coronaDientesMin,
      if (coronaDientesMax != null) 'corona_dientes_max': coronaDientesMax,
      if (marcaTitulo != null) 'marca_titulo': marcaTitulo,
      if (marcaLema != null) 'marca_lema': marcaLema,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  CampeonatosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? formato,
    Value<int>? anio,
    Value<String>? organizacion,
    Value<bool>? activo,
    Value<int>? topeRegularizacion,
    Value<int>? numDescartes,
    Value<bool>? usaCreditos,
    Value<bool>? usaTesoreria,
    Value<bool>? finalizado,
    Value<String>? copasJson,
    Value<double>? cuotaPagat,
    Value<double>? cuotaCoordinadora,
    Value<double>? cuotaClub,
    Value<int?>? motorSorteoMin,
    Value<int?>? motorSorteoMax,
    Value<int>? pinonDientesMin,
    Value<int>? pinonDientesMax,
    Value<int>? coronaDientesMin,
    Value<int>? coronaDientesMax,
    Value<String?>? marcaTitulo,
    Value<String?>? marcaLema,
    Value<DateTime>? creadoEn,
  }) {
    return CampeonatosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      formato: formato ?? this.formato,
      anio: anio ?? this.anio,
      organizacion: organizacion ?? this.organizacion,
      activo: activo ?? this.activo,
      topeRegularizacion: topeRegularizacion ?? this.topeRegularizacion,
      numDescartes: numDescartes ?? this.numDescartes,
      usaCreditos: usaCreditos ?? this.usaCreditos,
      usaTesoreria: usaTesoreria ?? this.usaTesoreria,
      finalizado: finalizado ?? this.finalizado,
      copasJson: copasJson ?? this.copasJson,
      cuotaPagat: cuotaPagat ?? this.cuotaPagat,
      cuotaCoordinadora: cuotaCoordinadora ?? this.cuotaCoordinadora,
      cuotaClub: cuotaClub ?? this.cuotaClub,
      motorSorteoMin: motorSorteoMin ?? this.motorSorteoMin,
      motorSorteoMax: motorSorteoMax ?? this.motorSorteoMax,
      pinonDientesMin: pinonDientesMin ?? this.pinonDientesMin,
      pinonDientesMax: pinonDientesMax ?? this.pinonDientesMax,
      coronaDientesMin: coronaDientesMin ?? this.coronaDientesMin,
      coronaDientesMax: coronaDientesMax ?? this.coronaDientesMax,
      marcaTitulo: marcaTitulo ?? this.marcaTitulo,
      marcaLema: marcaLema ?? this.marcaLema,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (formato.present) {
      map['formato'] = Variable<String>(formato.value);
    }
    if (anio.present) {
      map['anio'] = Variable<int>(anio.value);
    }
    if (organizacion.present) {
      map['organizacion'] = Variable<String>(organizacion.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (topeRegularizacion.present) {
      map['tope_regularizacion'] = Variable<int>(topeRegularizacion.value);
    }
    if (numDescartes.present) {
      map['num_descartes'] = Variable<int>(numDescartes.value);
    }
    if (usaCreditos.present) {
      map['usa_creditos'] = Variable<bool>(usaCreditos.value);
    }
    if (usaTesoreria.present) {
      map['usa_tesoreria'] = Variable<bool>(usaTesoreria.value);
    }
    if (finalizado.present) {
      map['finalizado'] = Variable<bool>(finalizado.value);
    }
    if (copasJson.present) {
      map['copas_json'] = Variable<String>(copasJson.value);
    }
    if (cuotaPagat.present) {
      map['cuota_pagat'] = Variable<double>(cuotaPagat.value);
    }
    if (cuotaCoordinadora.present) {
      map['cuota_coordinadora'] = Variable<double>(cuotaCoordinadora.value);
    }
    if (cuotaClub.present) {
      map['cuota_club'] = Variable<double>(cuotaClub.value);
    }
    if (motorSorteoMin.present) {
      map['motor_sorteo_min'] = Variable<int>(motorSorteoMin.value);
    }
    if (motorSorteoMax.present) {
      map['motor_sorteo_max'] = Variable<int>(motorSorteoMax.value);
    }
    if (pinonDientesMin.present) {
      map['pinon_dientes_min'] = Variable<int>(pinonDientesMin.value);
    }
    if (pinonDientesMax.present) {
      map['pinon_dientes_max'] = Variable<int>(pinonDientesMax.value);
    }
    if (coronaDientesMin.present) {
      map['corona_dientes_min'] = Variable<int>(coronaDientesMin.value);
    }
    if (coronaDientesMax.present) {
      map['corona_dientes_max'] = Variable<int>(coronaDientesMax.value);
    }
    if (marcaTitulo.present) {
      map['marca_titulo'] = Variable<String>(marcaTitulo.value);
    }
    if (marcaLema.present) {
      map['marca_lema'] = Variable<String>(marcaLema.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CampeonatosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('formato: $formato, ')
          ..write('anio: $anio, ')
          ..write('organizacion: $organizacion, ')
          ..write('activo: $activo, ')
          ..write('topeRegularizacion: $topeRegularizacion, ')
          ..write('numDescartes: $numDescartes, ')
          ..write('usaCreditos: $usaCreditos, ')
          ..write('usaTesoreria: $usaTesoreria, ')
          ..write('finalizado: $finalizado, ')
          ..write('copasJson: $copasJson, ')
          ..write('cuotaPagat: $cuotaPagat, ')
          ..write('cuotaCoordinadora: $cuotaCoordinadora, ')
          ..write('cuotaClub: $cuotaClub, ')
          ..write('motorSorteoMin: $motorSorteoMin, ')
          ..write('motorSorteoMax: $motorSorteoMax, ')
          ..write('pinonDientesMin: $pinonDientesMin, ')
          ..write('pinonDientesMax: $pinonDientesMax, ')
          ..write('coronaDientesMin: $coronaDientesMin, ')
          ..write('coronaDientesMax: $coronaDientesMax, ')
          ..write('marcaTitulo: $marcaTitulo, ')
          ..write('marcaLema: $marcaLema, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $TablaPuntosTable extends TablaPuntos
    with TableInfo<$TablaPuntosTable, TablaPunto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TablaPuntosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campeonatos (id)',
    ),
  );
  static const VerificationMeta _posicionMeta = const VerificationMeta(
    'posicion',
  );
  @override
  late final GeneratedColumn<int> posicion = GeneratedColumn<int>(
    'posicion',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _puntosMeta = const VerificationMeta('puntos');
  @override
  late final GeneratedColumn<int> puntos = GeneratedColumn<int>(
    'puntos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [campeonatoId, posicion, puntos];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tabla_puntos';
  @override
  VerificationContext validateIntegrity(
    Insertable<TablaPunto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campeonatoIdMeta);
    }
    if (data.containsKey('posicion')) {
      context.handle(
        _posicionMeta,
        posicion.isAcceptableOrUnknown(data['posicion']!, _posicionMeta),
      );
    } else if (isInserting) {
      context.missing(_posicionMeta);
    }
    if (data.containsKey('puntos')) {
      context.handle(
        _puntosMeta,
        puntos.isAcceptableOrUnknown(data['puntos']!, _puntosMeta),
      );
    } else if (isInserting) {
      context.missing(_puntosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {campeonatoId, posicion};
  @override
  TablaPunto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TablaPunto(
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      )!,
      posicion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posicion'],
      )!,
      puntos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}puntos'],
      )!,
    );
  }

  @override
  $TablaPuntosTable createAlias(String alias) {
    return $TablaPuntosTable(attachedDatabase, alias);
  }
}

class TablaPunto extends DataClass implements Insertable<TablaPunto> {
  final int campeonatoId;
  final int posicion;
  final int puntos;
  const TablaPunto({
    required this.campeonatoId,
    required this.posicion,
    required this.puntos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['campeonato_id'] = Variable<int>(campeonatoId);
    map['posicion'] = Variable<int>(posicion);
    map['puntos'] = Variable<int>(puntos);
    return map;
  }

  TablaPuntosCompanion toCompanion(bool nullToAbsent) {
    return TablaPuntosCompanion(
      campeonatoId: Value(campeonatoId),
      posicion: Value(posicion),
      puntos: Value(puntos),
    );
  }

  factory TablaPunto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TablaPunto(
      campeonatoId: serializer.fromJson<int>(json['campeonatoId']),
      posicion: serializer.fromJson<int>(json['posicion']),
      puntos: serializer.fromJson<int>(json['puntos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'campeonatoId': serializer.toJson<int>(campeonatoId),
      'posicion': serializer.toJson<int>(posicion),
      'puntos': serializer.toJson<int>(puntos),
    };
  }

  TablaPunto copyWith({int? campeonatoId, int? posicion, int? puntos}) =>
      TablaPunto(
        campeonatoId: campeonatoId ?? this.campeonatoId,
        posicion: posicion ?? this.posicion,
        puntos: puntos ?? this.puntos,
      );
  TablaPunto copyWithCompanion(TablaPuntosCompanion data) {
    return TablaPunto(
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      posicion: data.posicion.present ? data.posicion.value : this.posicion,
      puntos: data.puntos.present ? data.puntos.value : this.puntos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TablaPunto(')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('posicion: $posicion, ')
          ..write('puntos: $puntos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(campeonatoId, posicion, puntos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TablaPunto &&
          other.campeonatoId == this.campeonatoId &&
          other.posicion == this.posicion &&
          other.puntos == this.puntos);
}

class TablaPuntosCompanion extends UpdateCompanion<TablaPunto> {
  final Value<int> campeonatoId;
  final Value<int> posicion;
  final Value<int> puntos;
  final Value<int> rowid;
  const TablaPuntosCompanion({
    this.campeonatoId = const Value.absent(),
    this.posicion = const Value.absent(),
    this.puntos = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TablaPuntosCompanion.insert({
    required int campeonatoId,
    required int posicion,
    required int puntos,
    this.rowid = const Value.absent(),
  }) : campeonatoId = Value(campeonatoId),
       posicion = Value(posicion),
       puntos = Value(puntos);
  static Insertable<TablaPunto> custom({
    Expression<int>? campeonatoId,
    Expression<int>? posicion,
    Expression<int>? puntos,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (posicion != null) 'posicion': posicion,
      if (puntos != null) 'puntos': puntos,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TablaPuntosCompanion copyWith({
    Value<int>? campeonatoId,
    Value<int>? posicion,
    Value<int>? puntos,
    Value<int>? rowid,
  }) {
    return TablaPuntosCompanion(
      campeonatoId: campeonatoId ?? this.campeonatoId,
      posicion: posicion ?? this.posicion,
      puntos: puntos ?? this.puntos,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (posicion.present) {
      map['posicion'] = Variable<int>(posicion.value);
    }
    if (puntos.present) {
      map['puntos'] = Variable<int>(puntos.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TablaPuntosCompanion(')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('posicion: $posicion, ')
          ..write('puntos: $puntos, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TablaBonificacionTable extends TablaBonificacion
    with TableInfo<$TablaBonificacionTable, TablaBonificacionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TablaBonificacionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campeonatos (id)',
    ),
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carrerasMinMeta = const VerificationMeta(
    'carrerasMin',
  );
  @override
  late final GeneratedColumn<int> carrerasMin = GeneratedColumn<int>(
    'carreras_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carrerasMaxMeta = const VerificationMeta(
    'carrerasMax',
  );
  @override
  late final GeneratedColumn<int> carrerasMax = GeneratedColumn<int>(
    'carreras_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bonificacionMeta = const VerificationMeta(
    'bonificacion',
  );
  @override
  late final GeneratedColumn<int> bonificacion = GeneratedColumn<int>(
    'bonificacion',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    campeonatoId,
    categoria,
    carrerasMin,
    carrerasMax,
    bonificacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tabla_bonificacion';
  @override
  VerificationContext validateIntegrity(
    Insertable<TablaBonificacionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campeonatoIdMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('carreras_min')) {
      context.handle(
        _carrerasMinMeta,
        carrerasMin.isAcceptableOrUnknown(
          data['carreras_min']!,
          _carrerasMinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carrerasMinMeta);
    }
    if (data.containsKey('carreras_max')) {
      context.handle(
        _carrerasMaxMeta,
        carrerasMax.isAcceptableOrUnknown(
          data['carreras_max']!,
          _carrerasMaxMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carrerasMaxMeta);
    }
    if (data.containsKey('bonificacion')) {
      context.handle(
        _bonificacionMeta,
        bonificacion.isAcceptableOrUnknown(
          data['bonificacion']!,
          _bonificacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bonificacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    campeonatoId,
    categoria,
    carrerasMin,
  };
  @override
  TablaBonificacionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TablaBonificacionData(
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      carrerasMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carreras_min'],
      )!,
      carrerasMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carreras_max'],
      )!,
      bonificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonificacion'],
      )!,
    );
  }

  @override
  $TablaBonificacionTable createAlias(String alias) {
    return $TablaBonificacionTable(attachedDatabase, alias);
  }
}

class TablaBonificacionData extends DataClass
    implements Insertable<TablaBonificacionData> {
  final int campeonatoId;
  final String categoria;
  final int carrerasMin;
  final int carrerasMax;
  final int bonificacion;
  const TablaBonificacionData({
    required this.campeonatoId,
    required this.categoria,
    required this.carrerasMin,
    required this.carrerasMax,
    required this.bonificacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['campeonato_id'] = Variable<int>(campeonatoId);
    map['categoria'] = Variable<String>(categoria);
    map['carreras_min'] = Variable<int>(carrerasMin);
    map['carreras_max'] = Variable<int>(carrerasMax);
    map['bonificacion'] = Variable<int>(bonificacion);
    return map;
  }

  TablaBonificacionCompanion toCompanion(bool nullToAbsent) {
    return TablaBonificacionCompanion(
      campeonatoId: Value(campeonatoId),
      categoria: Value(categoria),
      carrerasMin: Value(carrerasMin),
      carrerasMax: Value(carrerasMax),
      bonificacion: Value(bonificacion),
    );
  }

  factory TablaBonificacionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TablaBonificacionData(
      campeonatoId: serializer.fromJson<int>(json['campeonatoId']),
      categoria: serializer.fromJson<String>(json['categoria']),
      carrerasMin: serializer.fromJson<int>(json['carrerasMin']),
      carrerasMax: serializer.fromJson<int>(json['carrerasMax']),
      bonificacion: serializer.fromJson<int>(json['bonificacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'campeonatoId': serializer.toJson<int>(campeonatoId),
      'categoria': serializer.toJson<String>(categoria),
      'carrerasMin': serializer.toJson<int>(carrerasMin),
      'carrerasMax': serializer.toJson<int>(carrerasMax),
      'bonificacion': serializer.toJson<int>(bonificacion),
    };
  }

  TablaBonificacionData copyWith({
    int? campeonatoId,
    String? categoria,
    int? carrerasMin,
    int? carrerasMax,
    int? bonificacion,
  }) => TablaBonificacionData(
    campeonatoId: campeonatoId ?? this.campeonatoId,
    categoria: categoria ?? this.categoria,
    carrerasMin: carrerasMin ?? this.carrerasMin,
    carrerasMax: carrerasMax ?? this.carrerasMax,
    bonificacion: bonificacion ?? this.bonificacion,
  );
  TablaBonificacionData copyWithCompanion(TablaBonificacionCompanion data) {
    return TablaBonificacionData(
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      carrerasMin: data.carrerasMin.present
          ? data.carrerasMin.value
          : this.carrerasMin,
      carrerasMax: data.carrerasMax.present
          ? data.carrerasMax.value
          : this.carrerasMax,
      bonificacion: data.bonificacion.present
          ? data.bonificacion.value
          : this.bonificacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TablaBonificacionData(')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('categoria: $categoria, ')
          ..write('carrerasMin: $carrerasMin, ')
          ..write('carrerasMax: $carrerasMax, ')
          ..write('bonificacion: $bonificacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    campeonatoId,
    categoria,
    carrerasMin,
    carrerasMax,
    bonificacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TablaBonificacionData &&
          other.campeonatoId == this.campeonatoId &&
          other.categoria == this.categoria &&
          other.carrerasMin == this.carrerasMin &&
          other.carrerasMax == this.carrerasMax &&
          other.bonificacion == this.bonificacion);
}

class TablaBonificacionCompanion
    extends UpdateCompanion<TablaBonificacionData> {
  final Value<int> campeonatoId;
  final Value<String> categoria;
  final Value<int> carrerasMin;
  final Value<int> carrerasMax;
  final Value<int> bonificacion;
  final Value<int> rowid;
  const TablaBonificacionCompanion({
    this.campeonatoId = const Value.absent(),
    this.categoria = const Value.absent(),
    this.carrerasMin = const Value.absent(),
    this.carrerasMax = const Value.absent(),
    this.bonificacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TablaBonificacionCompanion.insert({
    required int campeonatoId,
    required String categoria,
    required int carrerasMin,
    required int carrerasMax,
    required int bonificacion,
    this.rowid = const Value.absent(),
  }) : campeonatoId = Value(campeonatoId),
       categoria = Value(categoria),
       carrerasMin = Value(carrerasMin),
       carrerasMax = Value(carrerasMax),
       bonificacion = Value(bonificacion);
  static Insertable<TablaBonificacionData> custom({
    Expression<int>? campeonatoId,
    Expression<String>? categoria,
    Expression<int>? carrerasMin,
    Expression<int>? carrerasMax,
    Expression<int>? bonificacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (categoria != null) 'categoria': categoria,
      if (carrerasMin != null) 'carreras_min': carrerasMin,
      if (carrerasMax != null) 'carreras_max': carrerasMax,
      if (bonificacion != null) 'bonificacion': bonificacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TablaBonificacionCompanion copyWith({
    Value<int>? campeonatoId,
    Value<String>? categoria,
    Value<int>? carrerasMin,
    Value<int>? carrerasMax,
    Value<int>? bonificacion,
    Value<int>? rowid,
  }) {
    return TablaBonificacionCompanion(
      campeonatoId: campeonatoId ?? this.campeonatoId,
      categoria: categoria ?? this.categoria,
      carrerasMin: carrerasMin ?? this.carrerasMin,
      carrerasMax: carrerasMax ?? this.carrerasMax,
      bonificacion: bonificacion ?? this.bonificacion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (carrerasMin.present) {
      map['carreras_min'] = Variable<int>(carrerasMin.value);
    }
    if (carrerasMax.present) {
      map['carreras_max'] = Variable<int>(carrerasMax.value);
    }
    if (bonificacion.present) {
      map['bonificacion'] = Variable<int>(bonificacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TablaBonificacionCompanion(')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('categoria: $categoria, ')
          ..write('carrerasMin: $carrerasMin, ')
          ..write('carrerasMax: $carrerasMax, ')
          ..write('bonificacion: $bonificacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PilotosTable extends Pilotos with TableInfo<$PilotosTable, Piloto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PilotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _palmaresGlobalMeta = const VerificationMeta(
    'palmaresGlobal',
  );
  @override
  late final GeneratedColumn<String> palmaresGlobal = GeneratedColumn<String>(
    'palmares_global',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _esCoordinadoraMeta = const VerificationMeta(
    'esCoordinadora',
  );
  @override
  late final GeneratedColumn<bool> esCoordinadora = GeneratedColumn<bool>(
    'es_coordinadora',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_coordinadora" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    palmaresGlobal,
    telefono,
    email,
    esCoordinadora,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pilotos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Piloto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('palmares_global')) {
      context.handle(
        _palmaresGlobalMeta,
        palmaresGlobal.isAcceptableOrUnknown(
          data['palmares_global']!,
          _palmaresGlobalMeta,
        ),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('es_coordinadora')) {
      context.handle(
        _esCoordinadoraMeta,
        esCoordinadora.isAcceptableOrUnknown(
          data['es_coordinadora']!,
          _esCoordinadoraMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Piloto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Piloto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      palmaresGlobal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}palmares_global'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      esCoordinadora: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_coordinadora'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $PilotosTable createAlias(String alias) {
    return $PilotosTable(attachedDatabase, alias);
  }
}

class Piloto extends DataClass implements Insertable<Piloto> {
  final int id;
  final String nombre;
  final String? palmaresGlobal;
  final String? telefono;
  final String? email;

  /// Si true, este piloto es de coordinadora y su equipo no paga cuota.
  final bool esCoordinadora;
  final DateTime creadoEn;
  const Piloto({
    required this.id,
    required this.nombre,
    this.palmaresGlobal,
    this.telefono,
    this.email,
    required this.esCoordinadora,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || palmaresGlobal != null) {
      map['palmares_global'] = Variable<String>(palmaresGlobal);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['es_coordinadora'] = Variable<bool>(esCoordinadora);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  PilotosCompanion toCompanion(bool nullToAbsent) {
    return PilotosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      palmaresGlobal: palmaresGlobal == null && nullToAbsent
          ? const Value.absent()
          : Value(palmaresGlobal),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      esCoordinadora: Value(esCoordinadora),
      creadoEn: Value(creadoEn),
    );
  }

  factory Piloto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Piloto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      palmaresGlobal: serializer.fromJson<String?>(json['palmaresGlobal']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      esCoordinadora: serializer.fromJson<bool>(json['esCoordinadora']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'palmaresGlobal': serializer.toJson<String?>(palmaresGlobal),
      'telefono': serializer.toJson<String?>(telefono),
      'email': serializer.toJson<String?>(email),
      'esCoordinadora': serializer.toJson<bool>(esCoordinadora),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Piloto copyWith({
    int? id,
    String? nombre,
    Value<String?> palmaresGlobal = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
    Value<String?> email = const Value.absent(),
    bool? esCoordinadora,
    DateTime? creadoEn,
  }) => Piloto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    palmaresGlobal: palmaresGlobal.present
        ? palmaresGlobal.value
        : this.palmaresGlobal,
    telefono: telefono.present ? telefono.value : this.telefono,
    email: email.present ? email.value : this.email,
    esCoordinadora: esCoordinadora ?? this.esCoordinadora,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  Piloto copyWithCompanion(PilotosCompanion data) {
    return Piloto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      palmaresGlobal: data.palmaresGlobal.present
          ? data.palmaresGlobal.value
          : this.palmaresGlobal,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      esCoordinadora: data.esCoordinadora.present
          ? data.esCoordinadora.value
          : this.esCoordinadora,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Piloto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('palmaresGlobal: $palmaresGlobal, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('esCoordinadora: $esCoordinadora, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    palmaresGlobal,
    telefono,
    email,
    esCoordinadora,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Piloto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.palmaresGlobal == this.palmaresGlobal &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.esCoordinadora == this.esCoordinadora &&
          other.creadoEn == this.creadoEn);
}

class PilotosCompanion extends UpdateCompanion<Piloto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> palmaresGlobal;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<bool> esCoordinadora;
  final Value<DateTime> creadoEn;
  const PilotosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.palmaresGlobal = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.esCoordinadora = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  PilotosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.palmaresGlobal = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.esCoordinadora = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Piloto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? palmaresGlobal,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<bool>? esCoordinadora,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (palmaresGlobal != null) 'palmares_global': palmaresGlobal,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (esCoordinadora != null) 'es_coordinadora': esCoordinadora,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  PilotosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? palmaresGlobal,
    Value<String?>? telefono,
    Value<String?>? email,
    Value<bool>? esCoordinadora,
    Value<DateTime>? creadoEn,
  }) {
    return PilotosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      palmaresGlobal: palmaresGlobal ?? this.palmaresGlobal,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      esCoordinadora: esCoordinadora ?? this.esCoordinadora,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (palmaresGlobal.present) {
      map['palmares_global'] = Variable<String>(palmaresGlobal.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (esCoordinadora.present) {
      map['es_coordinadora'] = Variable<bool>(esCoordinadora.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PilotosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('palmaresGlobal: $palmaresGlobal, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('esCoordinadora: $esCoordinadora, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $PilotoCampeonatoTable extends PilotoCampeonato
    with TableInfo<$PilotoCampeonatoTable, PilotoCampeonatoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PilotoCampeonatoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pilotoIdMeta = const VerificationMeta(
    'pilotoId',
  );
  @override
  late final GeneratedColumn<int> pilotoId = GeneratedColumn<int>(
    'piloto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pilotos (id)',
    ),
  );
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campeonatos (id)',
    ),
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaFinalMeta = const VerificationMeta(
    'categoriaFinal',
  );
  @override
  late final GeneratedColumn<String> categoriaFinal = GeneratedColumn<String>(
    'categoria_final',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creditosInicialesMeta = const VerificationMeta(
    'creditosIniciales',
  );
  @override
  late final GeneratedColumn<int> creditosIniciales = GeneratedColumn<int>(
    'creditos_iniciales',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditosActualesMeta = const VerificationMeta(
    'creditosActuales',
  );
  @override
  late final GeneratedColumn<int> creditosActuales = GeneratedColumn<int>(
    'creditos_actuales',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoTemporadaAnteriorMeta =
      const VerificationMeta('saldoTemporadaAnterior');
  @override
  late final GeneratedColumn<int> saldoTemporadaAnterior = GeneratedColumn<int>(
    'saldo_temporada_anterior',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bonificacionAplicadaMeta =
      const VerificationMeta('bonificacionAplicada');
  @override
  late final GeneratedColumn<int> bonificacionAplicada = GeneratedColumn<int>(
    'bonificacion_aplicada',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _palmaresLocalMeta = const VerificationMeta(
    'palmaresLocal',
  );
  @override
  late final GeneratedColumn<String> palmaresLocal = GeneratedColumn<String>(
    'palmares_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    pilotoId,
    campeonatoId,
    categoria,
    categoriaFinal,
    creditosIniciales,
    creditosActuales,
    saldoTemporadaAnterior,
    bonificacionAplicada,
    palmaresLocal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'piloto_campeonato';
  @override
  VerificationContext validateIntegrity(
    Insertable<PilotoCampeonatoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('piloto_id')) {
      context.handle(
        _pilotoIdMeta,
        pilotoId.isAcceptableOrUnknown(data['piloto_id']!, _pilotoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pilotoIdMeta);
    }
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campeonatoIdMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('categoria_final')) {
      context.handle(
        _categoriaFinalMeta,
        categoriaFinal.isAcceptableOrUnknown(
          data['categoria_final']!,
          _categoriaFinalMeta,
        ),
      );
    }
    if (data.containsKey('creditos_iniciales')) {
      context.handle(
        _creditosInicialesMeta,
        creditosIniciales.isAcceptableOrUnknown(
          data['creditos_iniciales']!,
          _creditosInicialesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditosInicialesMeta);
    }
    if (data.containsKey('creditos_actuales')) {
      context.handle(
        _creditosActualesMeta,
        creditosActuales.isAcceptableOrUnknown(
          data['creditos_actuales']!,
          _creditosActualesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditosActualesMeta);
    }
    if (data.containsKey('saldo_temporada_anterior')) {
      context.handle(
        _saldoTemporadaAnteriorMeta,
        saldoTemporadaAnterior.isAcceptableOrUnknown(
          data['saldo_temporada_anterior']!,
          _saldoTemporadaAnteriorMeta,
        ),
      );
    }
    if (data.containsKey('bonificacion_aplicada')) {
      context.handle(
        _bonificacionAplicadaMeta,
        bonificacionAplicada.isAcceptableOrUnknown(
          data['bonificacion_aplicada']!,
          _bonificacionAplicadaMeta,
        ),
      );
    }
    if (data.containsKey('palmares_local')) {
      context.handle(
        _palmaresLocalMeta,
        palmaresLocal.isAcceptableOrUnknown(
          data['palmares_local']!,
          _palmaresLocalMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pilotoId, campeonatoId};
  @override
  PilotoCampeonatoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PilotoCampeonatoData(
      pilotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piloto_id'],
      )!,
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      categoriaFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_final'],
      ),
      creditosIniciales: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creditos_iniciales'],
      )!,
      creditosActuales: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creditos_actuales'],
      )!,
      saldoTemporadaAnterior: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saldo_temporada_anterior'],
      )!,
      bonificacionAplicada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonificacion_aplicada'],
      )!,
      palmaresLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}palmares_local'],
      ),
    );
  }

  @override
  $PilotoCampeonatoTable createAlias(String alias) {
    return $PilotoCampeonatoTable(attachedDatabase, alias);
  }
}

class PilotoCampeonatoData extends DataClass
    implements Insertable<PilotoCampeonatoData> {
  final int pilotoId;
  final int campeonatoId;
  final String categoria;

  /// Categoría tras la revisión de cierre (promoción/descenso). Si es null no
  /// se ha revisado y se usa [categoria]. Se usa para la bonificación de cierre
  /// y como categoría inicial al importar al siguiente campeonato.
  final String? categoriaFinal;
  final int creditosIniciales;
  final int creditosActuales;
  final int saldoTemporadaAnterior;
  final int bonificacionAplicada;
  final String? palmaresLocal;
  const PilotoCampeonatoData({
    required this.pilotoId,
    required this.campeonatoId,
    required this.categoria,
    this.categoriaFinal,
    required this.creditosIniciales,
    required this.creditosActuales,
    required this.saldoTemporadaAnterior,
    required this.bonificacionAplicada,
    this.palmaresLocal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['piloto_id'] = Variable<int>(pilotoId);
    map['campeonato_id'] = Variable<int>(campeonatoId);
    map['categoria'] = Variable<String>(categoria);
    if (!nullToAbsent || categoriaFinal != null) {
      map['categoria_final'] = Variable<String>(categoriaFinal);
    }
    map['creditos_iniciales'] = Variable<int>(creditosIniciales);
    map['creditos_actuales'] = Variable<int>(creditosActuales);
    map['saldo_temporada_anterior'] = Variable<int>(saldoTemporadaAnterior);
    map['bonificacion_aplicada'] = Variable<int>(bonificacionAplicada);
    if (!nullToAbsent || palmaresLocal != null) {
      map['palmares_local'] = Variable<String>(palmaresLocal);
    }
    return map;
  }

  PilotoCampeonatoCompanion toCompanion(bool nullToAbsent) {
    return PilotoCampeonatoCompanion(
      pilotoId: Value(pilotoId),
      campeonatoId: Value(campeonatoId),
      categoria: Value(categoria),
      categoriaFinal: categoriaFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaFinal),
      creditosIniciales: Value(creditosIniciales),
      creditosActuales: Value(creditosActuales),
      saldoTemporadaAnterior: Value(saldoTemporadaAnterior),
      bonificacionAplicada: Value(bonificacionAplicada),
      palmaresLocal: palmaresLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(palmaresLocal),
    );
  }

  factory PilotoCampeonatoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PilotoCampeonatoData(
      pilotoId: serializer.fromJson<int>(json['pilotoId']),
      campeonatoId: serializer.fromJson<int>(json['campeonatoId']),
      categoria: serializer.fromJson<String>(json['categoria']),
      categoriaFinal: serializer.fromJson<String?>(json['categoriaFinal']),
      creditosIniciales: serializer.fromJson<int>(json['creditosIniciales']),
      creditosActuales: serializer.fromJson<int>(json['creditosActuales']),
      saldoTemporadaAnterior: serializer.fromJson<int>(
        json['saldoTemporadaAnterior'],
      ),
      bonificacionAplicada: serializer.fromJson<int>(
        json['bonificacionAplicada'],
      ),
      palmaresLocal: serializer.fromJson<String?>(json['palmaresLocal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pilotoId': serializer.toJson<int>(pilotoId),
      'campeonatoId': serializer.toJson<int>(campeonatoId),
      'categoria': serializer.toJson<String>(categoria),
      'categoriaFinal': serializer.toJson<String?>(categoriaFinal),
      'creditosIniciales': serializer.toJson<int>(creditosIniciales),
      'creditosActuales': serializer.toJson<int>(creditosActuales),
      'saldoTemporadaAnterior': serializer.toJson<int>(saldoTemporadaAnterior),
      'bonificacionAplicada': serializer.toJson<int>(bonificacionAplicada),
      'palmaresLocal': serializer.toJson<String?>(palmaresLocal),
    };
  }

  PilotoCampeonatoData copyWith({
    int? pilotoId,
    int? campeonatoId,
    String? categoria,
    Value<String?> categoriaFinal = const Value.absent(),
    int? creditosIniciales,
    int? creditosActuales,
    int? saldoTemporadaAnterior,
    int? bonificacionAplicada,
    Value<String?> palmaresLocal = const Value.absent(),
  }) => PilotoCampeonatoData(
    pilotoId: pilotoId ?? this.pilotoId,
    campeonatoId: campeonatoId ?? this.campeonatoId,
    categoria: categoria ?? this.categoria,
    categoriaFinal: categoriaFinal.present
        ? categoriaFinal.value
        : this.categoriaFinal,
    creditosIniciales: creditosIniciales ?? this.creditosIniciales,
    creditosActuales: creditosActuales ?? this.creditosActuales,
    saldoTemporadaAnterior:
        saldoTemporadaAnterior ?? this.saldoTemporadaAnterior,
    bonificacionAplicada: bonificacionAplicada ?? this.bonificacionAplicada,
    palmaresLocal: palmaresLocal.present
        ? palmaresLocal.value
        : this.palmaresLocal,
  );
  PilotoCampeonatoData copyWithCompanion(PilotoCampeonatoCompanion data) {
    return PilotoCampeonatoData(
      pilotoId: data.pilotoId.present ? data.pilotoId.value : this.pilotoId,
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      categoriaFinal: data.categoriaFinal.present
          ? data.categoriaFinal.value
          : this.categoriaFinal,
      creditosIniciales: data.creditosIniciales.present
          ? data.creditosIniciales.value
          : this.creditosIniciales,
      creditosActuales: data.creditosActuales.present
          ? data.creditosActuales.value
          : this.creditosActuales,
      saldoTemporadaAnterior: data.saldoTemporadaAnterior.present
          ? data.saldoTemporadaAnterior.value
          : this.saldoTemporadaAnterior,
      bonificacionAplicada: data.bonificacionAplicada.present
          ? data.bonificacionAplicada.value
          : this.bonificacionAplicada,
      palmaresLocal: data.palmaresLocal.present
          ? data.palmaresLocal.value
          : this.palmaresLocal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PilotoCampeonatoData(')
          ..write('pilotoId: $pilotoId, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('categoria: $categoria, ')
          ..write('categoriaFinal: $categoriaFinal, ')
          ..write('creditosIniciales: $creditosIniciales, ')
          ..write('creditosActuales: $creditosActuales, ')
          ..write('saldoTemporadaAnterior: $saldoTemporadaAnterior, ')
          ..write('bonificacionAplicada: $bonificacionAplicada, ')
          ..write('palmaresLocal: $palmaresLocal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    pilotoId,
    campeonatoId,
    categoria,
    categoriaFinal,
    creditosIniciales,
    creditosActuales,
    saldoTemporadaAnterior,
    bonificacionAplicada,
    palmaresLocal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PilotoCampeonatoData &&
          other.pilotoId == this.pilotoId &&
          other.campeonatoId == this.campeonatoId &&
          other.categoria == this.categoria &&
          other.categoriaFinal == this.categoriaFinal &&
          other.creditosIniciales == this.creditosIniciales &&
          other.creditosActuales == this.creditosActuales &&
          other.saldoTemporadaAnterior == this.saldoTemporadaAnterior &&
          other.bonificacionAplicada == this.bonificacionAplicada &&
          other.palmaresLocal == this.palmaresLocal);
}

class PilotoCampeonatoCompanion extends UpdateCompanion<PilotoCampeonatoData> {
  final Value<int> pilotoId;
  final Value<int> campeonatoId;
  final Value<String> categoria;
  final Value<String?> categoriaFinal;
  final Value<int> creditosIniciales;
  final Value<int> creditosActuales;
  final Value<int> saldoTemporadaAnterior;
  final Value<int> bonificacionAplicada;
  final Value<String?> palmaresLocal;
  final Value<int> rowid;
  const PilotoCampeonatoCompanion({
    this.pilotoId = const Value.absent(),
    this.campeonatoId = const Value.absent(),
    this.categoria = const Value.absent(),
    this.categoriaFinal = const Value.absent(),
    this.creditosIniciales = const Value.absent(),
    this.creditosActuales = const Value.absent(),
    this.saldoTemporadaAnterior = const Value.absent(),
    this.bonificacionAplicada = const Value.absent(),
    this.palmaresLocal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PilotoCampeonatoCompanion.insert({
    required int pilotoId,
    required int campeonatoId,
    required String categoria,
    this.categoriaFinal = const Value.absent(),
    required int creditosIniciales,
    required int creditosActuales,
    this.saldoTemporadaAnterior = const Value.absent(),
    this.bonificacionAplicada = const Value.absent(),
    this.palmaresLocal = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : pilotoId = Value(pilotoId),
       campeonatoId = Value(campeonatoId),
       categoria = Value(categoria),
       creditosIniciales = Value(creditosIniciales),
       creditosActuales = Value(creditosActuales);
  static Insertable<PilotoCampeonatoData> custom({
    Expression<int>? pilotoId,
    Expression<int>? campeonatoId,
    Expression<String>? categoria,
    Expression<String>? categoriaFinal,
    Expression<int>? creditosIniciales,
    Expression<int>? creditosActuales,
    Expression<int>? saldoTemporadaAnterior,
    Expression<int>? bonificacionAplicada,
    Expression<String>? palmaresLocal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pilotoId != null) 'piloto_id': pilotoId,
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (categoria != null) 'categoria': categoria,
      if (categoriaFinal != null) 'categoria_final': categoriaFinal,
      if (creditosIniciales != null) 'creditos_iniciales': creditosIniciales,
      if (creditosActuales != null) 'creditos_actuales': creditosActuales,
      if (saldoTemporadaAnterior != null)
        'saldo_temporada_anterior': saldoTemporadaAnterior,
      if (bonificacionAplicada != null)
        'bonificacion_aplicada': bonificacionAplicada,
      if (palmaresLocal != null) 'palmares_local': palmaresLocal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PilotoCampeonatoCompanion copyWith({
    Value<int>? pilotoId,
    Value<int>? campeonatoId,
    Value<String>? categoria,
    Value<String?>? categoriaFinal,
    Value<int>? creditosIniciales,
    Value<int>? creditosActuales,
    Value<int>? saldoTemporadaAnterior,
    Value<int>? bonificacionAplicada,
    Value<String?>? palmaresLocal,
    Value<int>? rowid,
  }) {
    return PilotoCampeonatoCompanion(
      pilotoId: pilotoId ?? this.pilotoId,
      campeonatoId: campeonatoId ?? this.campeonatoId,
      categoria: categoria ?? this.categoria,
      categoriaFinal: categoriaFinal ?? this.categoriaFinal,
      creditosIniciales: creditosIniciales ?? this.creditosIniciales,
      creditosActuales: creditosActuales ?? this.creditosActuales,
      saldoTemporadaAnterior:
          saldoTemporadaAnterior ?? this.saldoTemporadaAnterior,
      bonificacionAplicada: bonificacionAplicada ?? this.bonificacionAplicada,
      palmaresLocal: palmaresLocal ?? this.palmaresLocal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pilotoId.present) {
      map['piloto_id'] = Variable<int>(pilotoId.value);
    }
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (categoriaFinal.present) {
      map['categoria_final'] = Variable<String>(categoriaFinal.value);
    }
    if (creditosIniciales.present) {
      map['creditos_iniciales'] = Variable<int>(creditosIniciales.value);
    }
    if (creditosActuales.present) {
      map['creditos_actuales'] = Variable<int>(creditosActuales.value);
    }
    if (saldoTemporadaAnterior.present) {
      map['saldo_temporada_anterior'] = Variable<int>(
        saldoTemporadaAnterior.value,
      );
    }
    if (bonificacionAplicada.present) {
      map['bonificacion_aplicada'] = Variable<int>(bonificacionAplicada.value);
    }
    if (palmaresLocal.present) {
      map['palmares_local'] = Variable<String>(palmaresLocal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PilotoCampeonatoCompanion(')
          ..write('pilotoId: $pilotoId, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('categoria: $categoria, ')
          ..write('categoriaFinal: $categoriaFinal, ')
          ..write('creditosIniciales: $creditosIniciales, ')
          ..write('creditosActuales: $creditosActuales, ')
          ..write('saldoTemporadaAnterior: $saldoTemporadaAnterior, ')
          ..write('bonificacionAplicada: $bonificacionAplicada, ')
          ..write('palmaresLocal: $palmaresLocal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquiposTable extends Equipos with TableInfo<$EquiposTable, Equipo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquiposTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campeonatos (id)',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _copaMeta = const VerificationMeta('copa');
  @override
  late final GeneratedColumn<String> copa = GeneratedColumn<String>(
    'copa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _piloto1IdMeta = const VerificationMeta(
    'piloto1Id',
  );
  @override
  late final GeneratedColumn<int> piloto1Id = GeneratedColumn<int>(
    'piloto1_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pilotos (id)',
    ),
  );
  static const VerificationMeta _piloto2IdMeta = const VerificationMeta(
    'piloto2Id',
  );
  @override
  late final GeneratedColumn<int> piloto2Id = GeneratedColumn<int>(
    'piloto2_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pilotos (id)',
    ),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    campeonatoId,
    nombre,
    copa,
    piloto1Id,
    piloto2Id,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Equipo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campeonatoIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('copa')) {
      context.handle(
        _copaMeta,
        copa.isAcceptableOrUnknown(data['copa']!, _copaMeta),
      );
    } else if (isInserting) {
      context.missing(_copaMeta);
    }
    if (data.containsKey('piloto1_id')) {
      context.handle(
        _piloto1IdMeta,
        piloto1Id.isAcceptableOrUnknown(data['piloto1_id']!, _piloto1IdMeta),
      );
    } else if (isInserting) {
      context.missing(_piloto1IdMeta);
    }
    if (data.containsKey('piloto2_id')) {
      context.handle(
        _piloto2IdMeta,
        piloto2Id.isAcceptableOrUnknown(data['piloto2_id']!, _piloto2IdMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Equipo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Equipo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      copa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copa'],
      )!,
      piloto1Id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piloto1_id'],
      )!,
      piloto2Id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piloto2_id'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $EquiposTable createAlias(String alias) {
    return $EquiposTable(attachedDatabase, alias);
  }
}

class Equipo extends DataClass implements Insertable<Equipo> {
  final int id;
  final int campeonatoId;
  final String nombre;
  final String copa;
  final int piloto1Id;
  final int? piloto2Id;
  final bool activo;
  const Equipo({
    required this.id,
    required this.campeonatoId,
    required this.nombre,
    required this.copa,
    required this.piloto1Id,
    this.piloto2Id,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['campeonato_id'] = Variable<int>(campeonatoId);
    map['nombre'] = Variable<String>(nombre);
    map['copa'] = Variable<String>(copa);
    map['piloto1_id'] = Variable<int>(piloto1Id);
    if (!nullToAbsent || piloto2Id != null) {
      map['piloto2_id'] = Variable<int>(piloto2Id);
    }
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  EquiposCompanion toCompanion(bool nullToAbsent) {
    return EquiposCompanion(
      id: Value(id),
      campeonatoId: Value(campeonatoId),
      nombre: Value(nombre),
      copa: Value(copa),
      piloto1Id: Value(piloto1Id),
      piloto2Id: piloto2Id == null && nullToAbsent
          ? const Value.absent()
          : Value(piloto2Id),
      activo: Value(activo),
    );
  }

  factory Equipo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Equipo(
      id: serializer.fromJson<int>(json['id']),
      campeonatoId: serializer.fromJson<int>(json['campeonatoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      copa: serializer.fromJson<String>(json['copa']),
      piloto1Id: serializer.fromJson<int>(json['piloto1Id']),
      piloto2Id: serializer.fromJson<int?>(json['piloto2Id']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'campeonatoId': serializer.toJson<int>(campeonatoId),
      'nombre': serializer.toJson<String>(nombre),
      'copa': serializer.toJson<String>(copa),
      'piloto1Id': serializer.toJson<int>(piloto1Id),
      'piloto2Id': serializer.toJson<int?>(piloto2Id),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Equipo copyWith({
    int? id,
    int? campeonatoId,
    String? nombre,
    String? copa,
    int? piloto1Id,
    Value<int?> piloto2Id = const Value.absent(),
    bool? activo,
  }) => Equipo(
    id: id ?? this.id,
    campeonatoId: campeonatoId ?? this.campeonatoId,
    nombre: nombre ?? this.nombre,
    copa: copa ?? this.copa,
    piloto1Id: piloto1Id ?? this.piloto1Id,
    piloto2Id: piloto2Id.present ? piloto2Id.value : this.piloto2Id,
    activo: activo ?? this.activo,
  );
  Equipo copyWithCompanion(EquiposCompanion data) {
    return Equipo(
      id: data.id.present ? data.id.value : this.id,
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      copa: data.copa.present ? data.copa.value : this.copa,
      piloto1Id: data.piloto1Id.present ? data.piloto1Id.value : this.piloto1Id,
      piloto2Id: data.piloto2Id.present ? data.piloto2Id.value : this.piloto2Id,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Equipo(')
          ..write('id: $id, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('nombre: $nombre, ')
          ..write('copa: $copa, ')
          ..write('piloto1Id: $piloto1Id, ')
          ..write('piloto2Id: $piloto2Id, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, campeonatoId, nombre, copa, piloto1Id, piloto2Id, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Equipo &&
          other.id == this.id &&
          other.campeonatoId == this.campeonatoId &&
          other.nombre == this.nombre &&
          other.copa == this.copa &&
          other.piloto1Id == this.piloto1Id &&
          other.piloto2Id == this.piloto2Id &&
          other.activo == this.activo);
}

class EquiposCompanion extends UpdateCompanion<Equipo> {
  final Value<int> id;
  final Value<int> campeonatoId;
  final Value<String> nombre;
  final Value<String> copa;
  final Value<int> piloto1Id;
  final Value<int?> piloto2Id;
  final Value<bool> activo;
  const EquiposCompanion({
    this.id = const Value.absent(),
    this.campeonatoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.copa = const Value.absent(),
    this.piloto1Id = const Value.absent(),
    this.piloto2Id = const Value.absent(),
    this.activo = const Value.absent(),
  });
  EquiposCompanion.insert({
    this.id = const Value.absent(),
    required int campeonatoId,
    required String nombre,
    required String copa,
    required int piloto1Id,
    this.piloto2Id = const Value.absent(),
    this.activo = const Value.absent(),
  }) : campeonatoId = Value(campeonatoId),
       nombre = Value(nombre),
       copa = Value(copa),
       piloto1Id = Value(piloto1Id);
  static Insertable<Equipo> custom({
    Expression<int>? id,
    Expression<int>? campeonatoId,
    Expression<String>? nombre,
    Expression<String>? copa,
    Expression<int>? piloto1Id,
    Expression<int>? piloto2Id,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (nombre != null) 'nombre': nombre,
      if (copa != null) 'copa': copa,
      if (piloto1Id != null) 'piloto1_id': piloto1Id,
      if (piloto2Id != null) 'piloto2_id': piloto2Id,
      if (activo != null) 'activo': activo,
    });
  }

  EquiposCompanion copyWith({
    Value<int>? id,
    Value<int>? campeonatoId,
    Value<String>? nombre,
    Value<String>? copa,
    Value<int>? piloto1Id,
    Value<int?>? piloto2Id,
    Value<bool>? activo,
  }) {
    return EquiposCompanion(
      id: id ?? this.id,
      campeonatoId: campeonatoId ?? this.campeonatoId,
      nombre: nombre ?? this.nombre,
      copa: copa ?? this.copa,
      piloto1Id: piloto1Id ?? this.piloto1Id,
      piloto2Id: piloto2Id ?? this.piloto2Id,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (copa.present) {
      map['copa'] = Variable<String>(copa.value);
    }
    if (piloto1Id.present) {
      map['piloto1_id'] = Variable<int>(piloto1Id.value);
    }
    if (piloto2Id.present) {
      map['piloto2_id'] = Variable<int>(piloto2Id.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquiposCompanion(')
          ..write('id: $id, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('nombre: $nombre, ')
          ..write('copa: $copa, ')
          ..write('piloto1Id: $piloto1Id, ')
          ..write('piloto2Id: $piloto2Id, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $PruebasTable extends Pruebas with TableInfo<$PruebasTable, Prueba> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PruebasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campeonatos (id)',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sedeMeta = const VerificationMeta('sede');
  @override
  late final GeneratedColumn<String> sede = GeneratedColumn<String>(
    'sede',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PROGRAMADA'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    campeonatoId,
    nombre,
    sede,
    fecha,
    orden,
    estado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pruebas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Prueba> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campeonatoIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('sede')) {
      context.handle(
        _sedeMeta,
        sede.isAcceptableOrUnknown(data['sede']!, _sedeMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prueba map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prueba(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      sede: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sede'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      ),
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
    );
  }

  @override
  $PruebasTable createAlias(String alias) {
    return $PruebasTable(attachedDatabase, alias);
  }
}

class Prueba extends DataClass implements Insertable<Prueba> {
  final int id;
  final int campeonatoId;
  final String nombre;
  final String? sede;
  final DateTime? fecha;
  final int orden;
  final String estado;
  const Prueba({
    required this.id,
    required this.campeonatoId,
    required this.nombre,
    this.sede,
    this.fecha,
    required this.orden,
    required this.estado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['campeonato_id'] = Variable<int>(campeonatoId);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || sede != null) {
      map['sede'] = Variable<String>(sede);
    }
    if (!nullToAbsent || fecha != null) {
      map['fecha'] = Variable<DateTime>(fecha);
    }
    map['orden'] = Variable<int>(orden);
    map['estado'] = Variable<String>(estado);
    return map;
  }

  PruebasCompanion toCompanion(bool nullToAbsent) {
    return PruebasCompanion(
      id: Value(id),
      campeonatoId: Value(campeonatoId),
      nombre: Value(nombre),
      sede: sede == null && nullToAbsent ? const Value.absent() : Value(sede),
      fecha: fecha == null && nullToAbsent
          ? const Value.absent()
          : Value(fecha),
      orden: Value(orden),
      estado: Value(estado),
    );
  }

  factory Prueba.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prueba(
      id: serializer.fromJson<int>(json['id']),
      campeonatoId: serializer.fromJson<int>(json['campeonatoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      sede: serializer.fromJson<String?>(json['sede']),
      fecha: serializer.fromJson<DateTime?>(json['fecha']),
      orden: serializer.fromJson<int>(json['orden']),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'campeonatoId': serializer.toJson<int>(campeonatoId),
      'nombre': serializer.toJson<String>(nombre),
      'sede': serializer.toJson<String?>(sede),
      'fecha': serializer.toJson<DateTime?>(fecha),
      'orden': serializer.toJson<int>(orden),
      'estado': serializer.toJson<String>(estado),
    };
  }

  Prueba copyWith({
    int? id,
    int? campeonatoId,
    String? nombre,
    Value<String?> sede = const Value.absent(),
    Value<DateTime?> fecha = const Value.absent(),
    int? orden,
    String? estado,
  }) => Prueba(
    id: id ?? this.id,
    campeonatoId: campeonatoId ?? this.campeonatoId,
    nombre: nombre ?? this.nombre,
    sede: sede.present ? sede.value : this.sede,
    fecha: fecha.present ? fecha.value : this.fecha,
    orden: orden ?? this.orden,
    estado: estado ?? this.estado,
  );
  Prueba copyWithCompanion(PruebasCompanion data) {
    return Prueba(
      id: data.id.present ? data.id.value : this.id,
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      sede: data.sede.present ? data.sede.value : this.sede,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      orden: data.orden.present ? data.orden.value : this.orden,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prueba(')
          ..write('id: $id, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('nombre: $nombre, ')
          ..write('sede: $sede, ')
          ..write('fecha: $fecha, ')
          ..write('orden: $orden, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, campeonatoId, nombre, sede, fecha, orden, estado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prueba &&
          other.id == this.id &&
          other.campeonatoId == this.campeonatoId &&
          other.nombre == this.nombre &&
          other.sede == this.sede &&
          other.fecha == this.fecha &&
          other.orden == this.orden &&
          other.estado == this.estado);
}

class PruebasCompanion extends UpdateCompanion<Prueba> {
  final Value<int> id;
  final Value<int> campeonatoId;
  final Value<String> nombre;
  final Value<String?> sede;
  final Value<DateTime?> fecha;
  final Value<int> orden;
  final Value<String> estado;
  const PruebasCompanion({
    this.id = const Value.absent(),
    this.campeonatoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.sede = const Value.absent(),
    this.fecha = const Value.absent(),
    this.orden = const Value.absent(),
    this.estado = const Value.absent(),
  });
  PruebasCompanion.insert({
    this.id = const Value.absent(),
    required int campeonatoId,
    required String nombre,
    this.sede = const Value.absent(),
    this.fecha = const Value.absent(),
    required int orden,
    this.estado = const Value.absent(),
  }) : campeonatoId = Value(campeonatoId),
       nombre = Value(nombre),
       orden = Value(orden);
  static Insertable<Prueba> custom({
    Expression<int>? id,
    Expression<int>? campeonatoId,
    Expression<String>? nombre,
    Expression<String>? sede,
    Expression<DateTime>? fecha,
    Expression<int>? orden,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (nombre != null) 'nombre': nombre,
      if (sede != null) 'sede': sede,
      if (fecha != null) 'fecha': fecha,
      if (orden != null) 'orden': orden,
      if (estado != null) 'estado': estado,
    });
  }

  PruebasCompanion copyWith({
    Value<int>? id,
    Value<int>? campeonatoId,
    Value<String>? nombre,
    Value<String?>? sede,
    Value<DateTime?>? fecha,
    Value<int>? orden,
    Value<String>? estado,
  }) {
    return PruebasCompanion(
      id: id ?? this.id,
      campeonatoId: campeonatoId ?? this.campeonatoId,
      nombre: nombre ?? this.nombre,
      sede: sede ?? this.sede,
      fecha: fecha ?? this.fecha,
      orden: orden ?? this.orden,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (sede.present) {
      map['sede'] = Variable<String>(sede.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PruebasCompanion(')
          ..write('id: $id, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('nombre: $nombre, ')
          ..write('sede: $sede, ')
          ..write('fecha: $fecha, ')
          ..write('orden: $orden, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $MangasTable extends Mangas with TableInfo<$MangasTable, Manga> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MangasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pruebaIdMeta = const VerificationMeta(
    'pruebaId',
  );
  @override
  late final GeneratedColumn<int> pruebaId = GeneratedColumn<int>(
    'prueba_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pruebas (id)',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaHoraMeta = const VerificationMeta(
    'fechaHora',
  );
  @override
  late final GeneratedColumn<DateTime> fechaHora = GeneratedColumn<DateTime>(
    'fecha_hora',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numCarrilesMeta = const VerificationMeta(
    'numCarriles',
  );
  @override
  late final GeneratedColumn<int> numCarriles = GeneratedColumn<int>(
    'num_carriles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PROGRAMADA'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pruebaId,
    nombre,
    fechaHora,
    numCarriles,
    estado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mangas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Manga> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prueba_id')) {
      context.handle(
        _pruebaIdMeta,
        pruebaId.isAcceptableOrUnknown(data['prueba_id']!, _pruebaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pruebaIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('fecha_hora')) {
      context.handle(
        _fechaHoraMeta,
        fechaHora.isAcceptableOrUnknown(data['fecha_hora']!, _fechaHoraMeta),
      );
    }
    if (data.containsKey('num_carriles')) {
      context.handle(
        _numCarrilesMeta,
        numCarriles.isAcceptableOrUnknown(
          data['num_carriles']!,
          _numCarrilesMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Manga map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Manga(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pruebaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prueba_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      fechaHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_hora'],
      ),
      numCarriles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_carriles'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
    );
  }

  @override
  $MangasTable createAlias(String alias) {
    return $MangasTable(attachedDatabase, alias);
  }
}

class Manga extends DataClass implements Insertable<Manga> {
  final int id;
  final int pruebaId;
  final String nombre;
  final DateTime? fechaHora;
  final int numCarriles;
  final String estado;
  const Manga({
    required this.id,
    required this.pruebaId,
    required this.nombre,
    this.fechaHora,
    required this.numCarriles,
    required this.estado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prueba_id'] = Variable<int>(pruebaId);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || fechaHora != null) {
      map['fecha_hora'] = Variable<DateTime>(fechaHora);
    }
    map['num_carriles'] = Variable<int>(numCarriles);
    map['estado'] = Variable<String>(estado);
    return map;
  }

  MangasCompanion toCompanion(bool nullToAbsent) {
    return MangasCompanion(
      id: Value(id),
      pruebaId: Value(pruebaId),
      nombre: Value(nombre),
      fechaHora: fechaHora == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaHora),
      numCarriles: Value(numCarriles),
      estado: Value(estado),
    );
  }

  factory Manga.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Manga(
      id: serializer.fromJson<int>(json['id']),
      pruebaId: serializer.fromJson<int>(json['pruebaId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      fechaHora: serializer.fromJson<DateTime?>(json['fechaHora']),
      numCarriles: serializer.fromJson<int>(json['numCarriles']),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pruebaId': serializer.toJson<int>(pruebaId),
      'nombre': serializer.toJson<String>(nombre),
      'fechaHora': serializer.toJson<DateTime?>(fechaHora),
      'numCarriles': serializer.toJson<int>(numCarriles),
      'estado': serializer.toJson<String>(estado),
    };
  }

  Manga copyWith({
    int? id,
    int? pruebaId,
    String? nombre,
    Value<DateTime?> fechaHora = const Value.absent(),
    int? numCarriles,
    String? estado,
  }) => Manga(
    id: id ?? this.id,
    pruebaId: pruebaId ?? this.pruebaId,
    nombre: nombre ?? this.nombre,
    fechaHora: fechaHora.present ? fechaHora.value : this.fechaHora,
    numCarriles: numCarriles ?? this.numCarriles,
    estado: estado ?? this.estado,
  );
  Manga copyWithCompanion(MangasCompanion data) {
    return Manga(
      id: data.id.present ? data.id.value : this.id,
      pruebaId: data.pruebaId.present ? data.pruebaId.value : this.pruebaId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      fechaHora: data.fechaHora.present ? data.fechaHora.value : this.fechaHora,
      numCarriles: data.numCarriles.present
          ? data.numCarriles.value
          : this.numCarriles,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Manga(')
          ..write('id: $id, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('nombre: $nombre, ')
          ..write('fechaHora: $fechaHora, ')
          ..write('numCarriles: $numCarriles, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pruebaId, nombre, fechaHora, numCarriles, estado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Manga &&
          other.id == this.id &&
          other.pruebaId == this.pruebaId &&
          other.nombre == this.nombre &&
          other.fechaHora == this.fechaHora &&
          other.numCarriles == this.numCarriles &&
          other.estado == this.estado);
}

class MangasCompanion extends UpdateCompanion<Manga> {
  final Value<int> id;
  final Value<int> pruebaId;
  final Value<String> nombre;
  final Value<DateTime?> fechaHora;
  final Value<int> numCarriles;
  final Value<String> estado;
  const MangasCompanion({
    this.id = const Value.absent(),
    this.pruebaId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.fechaHora = const Value.absent(),
    this.numCarriles = const Value.absent(),
    this.estado = const Value.absent(),
  });
  MangasCompanion.insert({
    this.id = const Value.absent(),
    required int pruebaId,
    required String nombre,
    this.fechaHora = const Value.absent(),
    this.numCarriles = const Value.absent(),
    this.estado = const Value.absent(),
  }) : pruebaId = Value(pruebaId),
       nombre = Value(nombre);
  static Insertable<Manga> custom({
    Expression<int>? id,
    Expression<int>? pruebaId,
    Expression<String>? nombre,
    Expression<DateTime>? fechaHora,
    Expression<int>? numCarriles,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pruebaId != null) 'prueba_id': pruebaId,
      if (nombre != null) 'nombre': nombre,
      if (fechaHora != null) 'fecha_hora': fechaHora,
      if (numCarriles != null) 'num_carriles': numCarriles,
      if (estado != null) 'estado': estado,
    });
  }

  MangasCompanion copyWith({
    Value<int>? id,
    Value<int>? pruebaId,
    Value<String>? nombre,
    Value<DateTime?>? fechaHora,
    Value<int>? numCarriles,
    Value<String>? estado,
  }) {
    return MangasCompanion(
      id: id ?? this.id,
      pruebaId: pruebaId ?? this.pruebaId,
      nombre: nombre ?? this.nombre,
      fechaHora: fechaHora ?? this.fechaHora,
      numCarriles: numCarriles ?? this.numCarriles,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pruebaId.present) {
      map['prueba_id'] = Variable<int>(pruebaId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (fechaHora.present) {
      map['fecha_hora'] = Variable<DateTime>(fechaHora.value);
    }
    if (numCarriles.present) {
      map['num_carriles'] = Variable<int>(numCarriles.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MangasCompanion(')
          ..write('id: $id, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('nombre: $nombre, ')
          ..write('fechaHora: $fechaHora, ')
          ..write('numCarriles: $numCarriles, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $InscripcionesTable extends Inscripciones
    with TableInfo<$InscripcionesTable, Inscripcione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InscripcionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mangaIdMeta = const VerificationMeta(
    'mangaId',
  );
  @override
  late final GeneratedColumn<int> mangaId = GeneratedColumn<int>(
    'manga_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mangas (id)',
    ),
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
    'equipo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipos (id)',
    ),
  );
  static const VerificationMeta _carrilSalidaMeta = const VerificationMeta(
    'carrilSalida',
  );
  @override
  late final GeneratedColumn<String> carrilSalida = GeneratedColumn<String>(
    'carril_salida',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seedDirectoMeta = const VerificationMeta(
    'seedDirecto',
  );
  @override
  late final GeneratedColumn<bool> seedDirecto = GeneratedColumn<bool>(
    'seed_directo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("seed_directo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mangaId,
    equipoId,
    carrilSalida,
    seedDirecto,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inscripciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Inscripcione> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(
        _mangaIdMeta,
        mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('carril_salida')) {
      context.handle(
        _carrilSalidaMeta,
        carrilSalida.isAcceptableOrUnknown(
          data['carril_salida']!,
          _carrilSalidaMeta,
        ),
      );
    }
    if (data.containsKey('seed_directo')) {
      context.handle(
        _seedDirectoMeta,
        seedDirecto.isAcceptableOrUnknown(
          data['seed_directo']!,
          _seedDirectoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inscripcione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inscripcione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mangaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manga_id'],
      )!,
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipo_id'],
      )!,
      carrilSalida: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}carril_salida'],
      ),
      seedDirecto: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}seed_directo'],
      )!,
    );
  }

  @override
  $InscripcionesTable createAlias(String alias) {
    return $InscripcionesTable(attachedDatabase, alias);
  }
}

class Inscripcione extends DataClass implements Insertable<Inscripcione> {
  final int id;
  final int mangaId;
  final int equipoId;
  final String? carrilSalida;
  final bool seedDirecto;
  const Inscripcione({
    required this.id,
    required this.mangaId,
    required this.equipoId,
    this.carrilSalida,
    required this.seedDirecto,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<int>(mangaId);
    map['equipo_id'] = Variable<int>(equipoId);
    if (!nullToAbsent || carrilSalida != null) {
      map['carril_salida'] = Variable<String>(carrilSalida);
    }
    map['seed_directo'] = Variable<bool>(seedDirecto);
    return map;
  }

  InscripcionesCompanion toCompanion(bool nullToAbsent) {
    return InscripcionesCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      equipoId: Value(equipoId),
      carrilSalida: carrilSalida == null && nullToAbsent
          ? const Value.absent()
          : Value(carrilSalida),
      seedDirecto: Value(seedDirecto),
    );
  }

  factory Inscripcione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inscripcione(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<int>(json['mangaId']),
      equipoId: serializer.fromJson<int>(json['equipoId']),
      carrilSalida: serializer.fromJson<String?>(json['carrilSalida']),
      seedDirecto: serializer.fromJson<bool>(json['seedDirecto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<int>(mangaId),
      'equipoId': serializer.toJson<int>(equipoId),
      'carrilSalida': serializer.toJson<String?>(carrilSalida),
      'seedDirecto': serializer.toJson<bool>(seedDirecto),
    };
  }

  Inscripcione copyWith({
    int? id,
    int? mangaId,
    int? equipoId,
    Value<String?> carrilSalida = const Value.absent(),
    bool? seedDirecto,
  }) => Inscripcione(
    id: id ?? this.id,
    mangaId: mangaId ?? this.mangaId,
    equipoId: equipoId ?? this.equipoId,
    carrilSalida: carrilSalida.present ? carrilSalida.value : this.carrilSalida,
    seedDirecto: seedDirecto ?? this.seedDirecto,
  );
  Inscripcione copyWithCompanion(InscripcionesCompanion data) {
    return Inscripcione(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      carrilSalida: data.carrilSalida.present
          ? data.carrilSalida.value
          : this.carrilSalida,
      seedDirecto: data.seedDirecto.present
          ? data.seedDirecto.value
          : this.seedDirecto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inscripcione(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('equipoId: $equipoId, ')
          ..write('carrilSalida: $carrilSalida, ')
          ..write('seedDirecto: $seedDirecto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mangaId, equipoId, carrilSalida, seedDirecto);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inscripcione &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.equipoId == this.equipoId &&
          other.carrilSalida == this.carrilSalida &&
          other.seedDirecto == this.seedDirecto);
}

class InscripcionesCompanion extends UpdateCompanion<Inscripcione> {
  final Value<int> id;
  final Value<int> mangaId;
  final Value<int> equipoId;
  final Value<String?> carrilSalida;
  final Value<bool> seedDirecto;
  const InscripcionesCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.carrilSalida = const Value.absent(),
    this.seedDirecto = const Value.absent(),
  });
  InscripcionesCompanion.insert({
    this.id = const Value.absent(),
    required int mangaId,
    required int equipoId,
    this.carrilSalida = const Value.absent(),
    this.seedDirecto = const Value.absent(),
  }) : mangaId = Value(mangaId),
       equipoId = Value(equipoId);
  static Insertable<Inscripcione> custom({
    Expression<int>? id,
    Expression<int>? mangaId,
    Expression<int>? equipoId,
    Expression<String>? carrilSalida,
    Expression<bool>? seedDirecto,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (equipoId != null) 'equipo_id': equipoId,
      if (carrilSalida != null) 'carril_salida': carrilSalida,
      if (seedDirecto != null) 'seed_directo': seedDirecto,
    });
  }

  InscripcionesCompanion copyWith({
    Value<int>? id,
    Value<int>? mangaId,
    Value<int>? equipoId,
    Value<String?>? carrilSalida,
    Value<bool>? seedDirecto,
  }) {
    return InscripcionesCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      equipoId: equipoId ?? this.equipoId,
      carrilSalida: carrilSalida ?? this.carrilSalida,
      seedDirecto: seedDirecto ?? this.seedDirecto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<int>(mangaId.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (carrilSalida.present) {
      map['carril_salida'] = Variable<String>(carrilSalida.value);
    }
    if (seedDirecto.present) {
      map['seed_directo'] = Variable<bool>(seedDirecto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InscripcionesCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('equipoId: $equipoId, ')
          ..write('carrilSalida: $carrilSalida, ')
          ..write('seedDirecto: $seedDirecto')
          ..write(')'))
        .toString();
  }
}

class $InscripcionesPruebaTable extends InscripcionesPrueba
    with TableInfo<$InscripcionesPruebaTable, InscripcionesPruebaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InscripcionesPruebaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pruebaIdMeta = const VerificationMeta(
    'pruebaId',
  );
  @override
  late final GeneratedColumn<int> pruebaId = GeneratedColumn<int>(
    'prueba_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pruebas (id)',
    ),
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
    'equipo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipos (id)',
    ),
  );
  static const VerificationMeta _fechaInscripcionMeta = const VerificationMeta(
    'fechaInscripcion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInscripcion =
      GeneratedColumn<DateTime>(
        'fecha_inscripcion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _preferenciaDiaMeta = const VerificationMeta(
    'preferenciaDia',
  );
  @override
  late final GeneratedColumn<String> preferenciaDia = GeneratedColumn<String>(
    'preferencia_dia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _asignadaMeta = const VerificationMeta(
    'asignada',
  );
  @override
  late final GeneratedColumn<bool> asignada = GeneratedColumn<bool>(
    'asignada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("asignada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _wildcardMeta = const VerificationMeta(
    'wildcard',
  );
  @override
  late final GeneratedColumn<bool> wildcard = GeneratedColumn<bool>(
    'wildcard',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("wildcard" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _copaMeta = const VerificationMeta('copa');
  @override
  late final GeneratedColumn<String> copa = GeneratedColumn<String>(
    'copa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pruebaId,
    equipoId,
    fechaInscripcion,
    preferenciaDia,
    notas,
    asignada,
    wildcard,
    copa,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inscripciones_prueba';
  @override
  VerificationContext validateIntegrity(
    Insertable<InscripcionesPruebaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prueba_id')) {
      context.handle(
        _pruebaIdMeta,
        pruebaId.isAcceptableOrUnknown(data['prueba_id']!, _pruebaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pruebaIdMeta);
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('fecha_inscripcion')) {
      context.handle(
        _fechaInscripcionMeta,
        fechaInscripcion.isAcceptableOrUnknown(
          data['fecha_inscripcion']!,
          _fechaInscripcionMeta,
        ),
      );
    }
    if (data.containsKey('preferencia_dia')) {
      context.handle(
        _preferenciaDiaMeta,
        preferenciaDia.isAcceptableOrUnknown(
          data['preferencia_dia']!,
          _preferenciaDiaMeta,
        ),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('asignada')) {
      context.handle(
        _asignadaMeta,
        asignada.isAcceptableOrUnknown(data['asignada']!, _asignadaMeta),
      );
    }
    if (data.containsKey('wildcard')) {
      context.handle(
        _wildcardMeta,
        wildcard.isAcceptableOrUnknown(data['wildcard']!, _wildcardMeta),
      );
    }
    if (data.containsKey('copa')) {
      context.handle(
        _copaMeta,
        copa.isAcceptableOrUnknown(data['copa']!, _copaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InscripcionesPruebaData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InscripcionesPruebaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pruebaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prueba_id'],
      )!,
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipo_id'],
      )!,
      fechaInscripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inscripcion'],
      )!,
      preferenciaDia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferencia_dia'],
      ),
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      asignada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}asignada'],
      )!,
      wildcard: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}wildcard'],
      )!,
      copa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copa'],
      ),
    );
  }

  @override
  $InscripcionesPruebaTable createAlias(String alias) {
    return $InscripcionesPruebaTable(attachedDatabase, alias);
  }
}

class InscripcionesPruebaData extends DataClass
    implements Insertable<InscripcionesPruebaData> {
  final int id;
  final int pruebaId;
  final int equipoId;
  final DateTime fechaInscripcion;
  final String? preferenciaDia;
  final String? notas;
  final bool asignada;

  /// Si true, el equipo participa como invitado / wildcard y no paga.
  final bool wildcard;

  /// Copa en la que el equipo compitió en ESTA prueba. Permite cambiar de copa
  /// a mitad de campeonato sin perder los puntos de las pruebas anteriores.
  /// Si es null, se usa la copa actual del equipo.
  final String? copa;
  const InscripcionesPruebaData({
    required this.id,
    required this.pruebaId,
    required this.equipoId,
    required this.fechaInscripcion,
    this.preferenciaDia,
    this.notas,
    required this.asignada,
    required this.wildcard,
    this.copa,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prueba_id'] = Variable<int>(pruebaId);
    map['equipo_id'] = Variable<int>(equipoId);
    map['fecha_inscripcion'] = Variable<DateTime>(fechaInscripcion);
    if (!nullToAbsent || preferenciaDia != null) {
      map['preferencia_dia'] = Variable<String>(preferenciaDia);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['asignada'] = Variable<bool>(asignada);
    map['wildcard'] = Variable<bool>(wildcard);
    if (!nullToAbsent || copa != null) {
      map['copa'] = Variable<String>(copa);
    }
    return map;
  }

  InscripcionesPruebaCompanion toCompanion(bool nullToAbsent) {
    return InscripcionesPruebaCompanion(
      id: Value(id),
      pruebaId: Value(pruebaId),
      equipoId: Value(equipoId),
      fechaInscripcion: Value(fechaInscripcion),
      preferenciaDia: preferenciaDia == null && nullToAbsent
          ? const Value.absent()
          : Value(preferenciaDia),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      asignada: Value(asignada),
      wildcard: Value(wildcard),
      copa: copa == null && nullToAbsent ? const Value.absent() : Value(copa),
    );
  }

  factory InscripcionesPruebaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InscripcionesPruebaData(
      id: serializer.fromJson<int>(json['id']),
      pruebaId: serializer.fromJson<int>(json['pruebaId']),
      equipoId: serializer.fromJson<int>(json['equipoId']),
      fechaInscripcion: serializer.fromJson<DateTime>(json['fechaInscripcion']),
      preferenciaDia: serializer.fromJson<String?>(json['preferenciaDia']),
      notas: serializer.fromJson<String?>(json['notas']),
      asignada: serializer.fromJson<bool>(json['asignada']),
      wildcard: serializer.fromJson<bool>(json['wildcard']),
      copa: serializer.fromJson<String?>(json['copa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pruebaId': serializer.toJson<int>(pruebaId),
      'equipoId': serializer.toJson<int>(equipoId),
      'fechaInscripcion': serializer.toJson<DateTime>(fechaInscripcion),
      'preferenciaDia': serializer.toJson<String?>(preferenciaDia),
      'notas': serializer.toJson<String?>(notas),
      'asignada': serializer.toJson<bool>(asignada),
      'wildcard': serializer.toJson<bool>(wildcard),
      'copa': serializer.toJson<String?>(copa),
    };
  }

  InscripcionesPruebaData copyWith({
    int? id,
    int? pruebaId,
    int? equipoId,
    DateTime? fechaInscripcion,
    Value<String?> preferenciaDia = const Value.absent(),
    Value<String?> notas = const Value.absent(),
    bool? asignada,
    bool? wildcard,
    Value<String?> copa = const Value.absent(),
  }) => InscripcionesPruebaData(
    id: id ?? this.id,
    pruebaId: pruebaId ?? this.pruebaId,
    equipoId: equipoId ?? this.equipoId,
    fechaInscripcion: fechaInscripcion ?? this.fechaInscripcion,
    preferenciaDia: preferenciaDia.present
        ? preferenciaDia.value
        : this.preferenciaDia,
    notas: notas.present ? notas.value : this.notas,
    asignada: asignada ?? this.asignada,
    wildcard: wildcard ?? this.wildcard,
    copa: copa.present ? copa.value : this.copa,
  );
  InscripcionesPruebaData copyWithCompanion(InscripcionesPruebaCompanion data) {
    return InscripcionesPruebaData(
      id: data.id.present ? data.id.value : this.id,
      pruebaId: data.pruebaId.present ? data.pruebaId.value : this.pruebaId,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      fechaInscripcion: data.fechaInscripcion.present
          ? data.fechaInscripcion.value
          : this.fechaInscripcion,
      preferenciaDia: data.preferenciaDia.present
          ? data.preferenciaDia.value
          : this.preferenciaDia,
      notas: data.notas.present ? data.notas.value : this.notas,
      asignada: data.asignada.present ? data.asignada.value : this.asignada,
      wildcard: data.wildcard.present ? data.wildcard.value : this.wildcard,
      copa: data.copa.present ? data.copa.value : this.copa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InscripcionesPruebaData(')
          ..write('id: $id, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('equipoId: $equipoId, ')
          ..write('fechaInscripcion: $fechaInscripcion, ')
          ..write('preferenciaDia: $preferenciaDia, ')
          ..write('notas: $notas, ')
          ..write('asignada: $asignada, ')
          ..write('wildcard: $wildcard, ')
          ..write('copa: $copa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pruebaId,
    equipoId,
    fechaInscripcion,
    preferenciaDia,
    notas,
    asignada,
    wildcard,
    copa,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InscripcionesPruebaData &&
          other.id == this.id &&
          other.pruebaId == this.pruebaId &&
          other.equipoId == this.equipoId &&
          other.fechaInscripcion == this.fechaInscripcion &&
          other.preferenciaDia == this.preferenciaDia &&
          other.notas == this.notas &&
          other.asignada == this.asignada &&
          other.wildcard == this.wildcard &&
          other.copa == this.copa);
}

class InscripcionesPruebaCompanion
    extends UpdateCompanion<InscripcionesPruebaData> {
  final Value<int> id;
  final Value<int> pruebaId;
  final Value<int> equipoId;
  final Value<DateTime> fechaInscripcion;
  final Value<String?> preferenciaDia;
  final Value<String?> notas;
  final Value<bool> asignada;
  final Value<bool> wildcard;
  final Value<String?> copa;
  const InscripcionesPruebaCompanion({
    this.id = const Value.absent(),
    this.pruebaId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.fechaInscripcion = const Value.absent(),
    this.preferenciaDia = const Value.absent(),
    this.notas = const Value.absent(),
    this.asignada = const Value.absent(),
    this.wildcard = const Value.absent(),
    this.copa = const Value.absent(),
  });
  InscripcionesPruebaCompanion.insert({
    this.id = const Value.absent(),
    required int pruebaId,
    required int equipoId,
    this.fechaInscripcion = const Value.absent(),
    this.preferenciaDia = const Value.absent(),
    this.notas = const Value.absent(),
    this.asignada = const Value.absent(),
    this.wildcard = const Value.absent(),
    this.copa = const Value.absent(),
  }) : pruebaId = Value(pruebaId),
       equipoId = Value(equipoId);
  static Insertable<InscripcionesPruebaData> custom({
    Expression<int>? id,
    Expression<int>? pruebaId,
    Expression<int>? equipoId,
    Expression<DateTime>? fechaInscripcion,
    Expression<String>? preferenciaDia,
    Expression<String>? notas,
    Expression<bool>? asignada,
    Expression<bool>? wildcard,
    Expression<String>? copa,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pruebaId != null) 'prueba_id': pruebaId,
      if (equipoId != null) 'equipo_id': equipoId,
      if (fechaInscripcion != null) 'fecha_inscripcion': fechaInscripcion,
      if (preferenciaDia != null) 'preferencia_dia': preferenciaDia,
      if (notas != null) 'notas': notas,
      if (asignada != null) 'asignada': asignada,
      if (wildcard != null) 'wildcard': wildcard,
      if (copa != null) 'copa': copa,
    });
  }

  InscripcionesPruebaCompanion copyWith({
    Value<int>? id,
    Value<int>? pruebaId,
    Value<int>? equipoId,
    Value<DateTime>? fechaInscripcion,
    Value<String?>? preferenciaDia,
    Value<String?>? notas,
    Value<bool>? asignada,
    Value<bool>? wildcard,
    Value<String?>? copa,
  }) {
    return InscripcionesPruebaCompanion(
      id: id ?? this.id,
      pruebaId: pruebaId ?? this.pruebaId,
      equipoId: equipoId ?? this.equipoId,
      fechaInscripcion: fechaInscripcion ?? this.fechaInscripcion,
      preferenciaDia: preferenciaDia ?? this.preferenciaDia,
      notas: notas ?? this.notas,
      asignada: asignada ?? this.asignada,
      wildcard: wildcard ?? this.wildcard,
      copa: copa ?? this.copa,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pruebaId.present) {
      map['prueba_id'] = Variable<int>(pruebaId.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (fechaInscripcion.present) {
      map['fecha_inscripcion'] = Variable<DateTime>(fechaInscripcion.value);
    }
    if (preferenciaDia.present) {
      map['preferencia_dia'] = Variable<String>(preferenciaDia.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (asignada.present) {
      map['asignada'] = Variable<bool>(asignada.value);
    }
    if (wildcard.present) {
      map['wildcard'] = Variable<bool>(wildcard.value);
    }
    if (copa.present) {
      map['copa'] = Variable<String>(copa.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InscripcionesPruebaCompanion(')
          ..write('id: $id, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('equipoId: $equipoId, ')
          ..write('fechaInscripcion: $fechaInscripcion, ')
          ..write('preferenciaDia: $preferenciaDia, ')
          ..write('notas: $notas, ')
          ..write('asignada: $asignada, ')
          ..write('wildcard: $wildcard, ')
          ..write('copa: $copa')
          ..write(')'))
        .toString();
  }
}

class $ResultadosTable extends Resultados
    with TableInfo<$ResultadosTable, Resultado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResultadosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mangaIdMeta = const VerificationMeta(
    'mangaId',
  );
  @override
  late final GeneratedColumn<int> mangaId = GeneratedColumn<int>(
    'manga_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mangas (id)',
    ),
  );
  static const VerificationMeta _pilotoIdMeta = const VerificationMeta(
    'pilotoId',
  );
  @override
  late final GeneratedColumn<int> pilotoId = GeneratedColumn<int>(
    'piloto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pilotos (id)',
    ),
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
    'equipo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipos (id)',
    ),
  );
  static const VerificationMeta _puntosMeta = const VerificationMeta('puntos');
  @override
  late final GeneratedColumn<int> puntos = GeneratedColumn<int>(
    'puntos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _posicionMeta = const VerificationMeta(
    'posicion',
  );
  @override
  late final GeneratedColumn<int> posicion = GeneratedColumn<int>(
    'posicion',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aRestarMeta = const VerificationMeta(
    'aRestar',
  );
  @override
  late final GeneratedColumn<int> aRestar = GeneratedColumn<int>(
    'a_restar',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mangaId,
    pilotoId,
    equipoId,
    puntos,
    posicion,
    aRestar,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resultados';
  @override
  VerificationContext validateIntegrity(
    Insertable<Resultado> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(
        _mangaIdMeta,
        mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('piloto_id')) {
      context.handle(
        _pilotoIdMeta,
        pilotoId.isAcceptableOrUnknown(data['piloto_id']!, _pilotoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pilotoIdMeta);
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('puntos')) {
      context.handle(
        _puntosMeta,
        puntos.isAcceptableOrUnknown(data['puntos']!, _puntosMeta),
      );
    }
    if (data.containsKey('posicion')) {
      context.handle(
        _posicionMeta,
        posicion.isAcceptableOrUnknown(data['posicion']!, _posicionMeta),
      );
    }
    if (data.containsKey('a_restar')) {
      context.handle(
        _aRestarMeta,
        aRestar.isAcceptableOrUnknown(data['a_restar']!, _aRestarMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Resultado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Resultado(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mangaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manga_id'],
      )!,
      pilotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piloto_id'],
      )!,
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipo_id'],
      )!,
      puntos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}puntos'],
      )!,
      posicion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posicion'],
      ),
      aRestar: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}a_restar'],
      )!,
    );
  }

  @override
  $ResultadosTable createAlias(String alias) {
    return $ResultadosTable(attachedDatabase, alias);
  }
}

class Resultado extends DataClass implements Insertable<Resultado> {
  final int id;
  final int mangaId;
  final int pilotoId;
  final int equipoId;
  final int puntos;
  final int? posicion;
  final int aRestar;
  const Resultado({
    required this.id,
    required this.mangaId,
    required this.pilotoId,
    required this.equipoId,
    required this.puntos,
    this.posicion,
    required this.aRestar,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<int>(mangaId);
    map['piloto_id'] = Variable<int>(pilotoId);
    map['equipo_id'] = Variable<int>(equipoId);
    map['puntos'] = Variable<int>(puntos);
    if (!nullToAbsent || posicion != null) {
      map['posicion'] = Variable<int>(posicion);
    }
    map['a_restar'] = Variable<int>(aRestar);
    return map;
  }

  ResultadosCompanion toCompanion(bool nullToAbsent) {
    return ResultadosCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      pilotoId: Value(pilotoId),
      equipoId: Value(equipoId),
      puntos: Value(puntos),
      posicion: posicion == null && nullToAbsent
          ? const Value.absent()
          : Value(posicion),
      aRestar: Value(aRestar),
    );
  }

  factory Resultado.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Resultado(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<int>(json['mangaId']),
      pilotoId: serializer.fromJson<int>(json['pilotoId']),
      equipoId: serializer.fromJson<int>(json['equipoId']),
      puntos: serializer.fromJson<int>(json['puntos']),
      posicion: serializer.fromJson<int?>(json['posicion']),
      aRestar: serializer.fromJson<int>(json['aRestar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<int>(mangaId),
      'pilotoId': serializer.toJson<int>(pilotoId),
      'equipoId': serializer.toJson<int>(equipoId),
      'puntos': serializer.toJson<int>(puntos),
      'posicion': serializer.toJson<int?>(posicion),
      'aRestar': serializer.toJson<int>(aRestar),
    };
  }

  Resultado copyWith({
    int? id,
    int? mangaId,
    int? pilotoId,
    int? equipoId,
    int? puntos,
    Value<int?> posicion = const Value.absent(),
    int? aRestar,
  }) => Resultado(
    id: id ?? this.id,
    mangaId: mangaId ?? this.mangaId,
    pilotoId: pilotoId ?? this.pilotoId,
    equipoId: equipoId ?? this.equipoId,
    puntos: puntos ?? this.puntos,
    posicion: posicion.present ? posicion.value : this.posicion,
    aRestar: aRestar ?? this.aRestar,
  );
  Resultado copyWithCompanion(ResultadosCompanion data) {
    return Resultado(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      pilotoId: data.pilotoId.present ? data.pilotoId.value : this.pilotoId,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      puntos: data.puntos.present ? data.puntos.value : this.puntos,
      posicion: data.posicion.present ? data.posicion.value : this.posicion,
      aRestar: data.aRestar.present ? data.aRestar.value : this.aRestar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Resultado(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('pilotoId: $pilotoId, ')
          ..write('equipoId: $equipoId, ')
          ..write('puntos: $puntos, ')
          ..write('posicion: $posicion, ')
          ..write('aRestar: $aRestar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mangaId, pilotoId, equipoId, puntos, posicion, aRestar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Resultado &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.pilotoId == this.pilotoId &&
          other.equipoId == this.equipoId &&
          other.puntos == this.puntos &&
          other.posicion == this.posicion &&
          other.aRestar == this.aRestar);
}

class ResultadosCompanion extends UpdateCompanion<Resultado> {
  final Value<int> id;
  final Value<int> mangaId;
  final Value<int> pilotoId;
  final Value<int> equipoId;
  final Value<int> puntos;
  final Value<int?> posicion;
  final Value<int> aRestar;
  const ResultadosCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.pilotoId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.puntos = const Value.absent(),
    this.posicion = const Value.absent(),
    this.aRestar = const Value.absent(),
  });
  ResultadosCompanion.insert({
    this.id = const Value.absent(),
    required int mangaId,
    required int pilotoId,
    required int equipoId,
    this.puntos = const Value.absent(),
    this.posicion = const Value.absent(),
    this.aRestar = const Value.absent(),
  }) : mangaId = Value(mangaId),
       pilotoId = Value(pilotoId),
       equipoId = Value(equipoId);
  static Insertable<Resultado> custom({
    Expression<int>? id,
    Expression<int>? mangaId,
    Expression<int>? pilotoId,
    Expression<int>? equipoId,
    Expression<int>? puntos,
    Expression<int>? posicion,
    Expression<int>? aRestar,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (pilotoId != null) 'piloto_id': pilotoId,
      if (equipoId != null) 'equipo_id': equipoId,
      if (puntos != null) 'puntos': puntos,
      if (posicion != null) 'posicion': posicion,
      if (aRestar != null) 'a_restar': aRestar,
    });
  }

  ResultadosCompanion copyWith({
    Value<int>? id,
    Value<int>? mangaId,
    Value<int>? pilotoId,
    Value<int>? equipoId,
    Value<int>? puntos,
    Value<int?>? posicion,
    Value<int>? aRestar,
  }) {
    return ResultadosCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      pilotoId: pilotoId ?? this.pilotoId,
      equipoId: equipoId ?? this.equipoId,
      puntos: puntos ?? this.puntos,
      posicion: posicion ?? this.posicion,
      aRestar: aRestar ?? this.aRestar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<int>(mangaId.value);
    }
    if (pilotoId.present) {
      map['piloto_id'] = Variable<int>(pilotoId.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (puntos.present) {
      map['puntos'] = Variable<int>(puntos.value);
    }
    if (posicion.present) {
      map['posicion'] = Variable<int>(posicion.value);
    }
    if (aRestar.present) {
      map['a_restar'] = Variable<int>(aRestar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResultadosCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('pilotoId: $pilotoId, ')
          ..write('equipoId: $equipoId, ')
          ..write('puntos: $puntos, ')
          ..write('posicion: $posicion, ')
          ..write('aRestar: $aRestar')
          ..write(')'))
        .toString();
  }
}

class $DescartesPruebaTable extends DescartesPrueba
    with TableInfo<$DescartesPruebaTable, DescartesPruebaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DescartesPruebaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pilotoIdMeta = const VerificationMeta(
    'pilotoId',
  );
  @override
  late final GeneratedColumn<int> pilotoId = GeneratedColumn<int>(
    'piloto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pilotos (id)',
    ),
  );
  static const VerificationMeta _pruebaIdMeta = const VerificationMeta(
    'pruebaId',
  );
  @override
  late final GeneratedColumn<int> pruebaId = GeneratedColumn<int>(
    'prueba_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pruebas (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [pilotoId, pruebaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'descartes_prueba';
  @override
  VerificationContext validateIntegrity(
    Insertable<DescartesPruebaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('piloto_id')) {
      context.handle(
        _pilotoIdMeta,
        pilotoId.isAcceptableOrUnknown(data['piloto_id']!, _pilotoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pilotoIdMeta);
    }
    if (data.containsKey('prueba_id')) {
      context.handle(
        _pruebaIdMeta,
        pruebaId.isAcceptableOrUnknown(data['prueba_id']!, _pruebaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pruebaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pilotoId, pruebaId};
  @override
  DescartesPruebaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DescartesPruebaData(
      pilotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piloto_id'],
      )!,
      pruebaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prueba_id'],
      )!,
    );
  }

  @override
  $DescartesPruebaTable createAlias(String alias) {
    return $DescartesPruebaTable(attachedDatabase, alias);
  }
}

class DescartesPruebaData extends DataClass
    implements Insertable<DescartesPruebaData> {
  final int pilotoId;
  final int pruebaId;
  const DescartesPruebaData({required this.pilotoId, required this.pruebaId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['piloto_id'] = Variable<int>(pilotoId);
    map['prueba_id'] = Variable<int>(pruebaId);
    return map;
  }

  DescartesPruebaCompanion toCompanion(bool nullToAbsent) {
    return DescartesPruebaCompanion(
      pilotoId: Value(pilotoId),
      pruebaId: Value(pruebaId),
    );
  }

  factory DescartesPruebaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DescartesPruebaData(
      pilotoId: serializer.fromJson<int>(json['pilotoId']),
      pruebaId: serializer.fromJson<int>(json['pruebaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pilotoId': serializer.toJson<int>(pilotoId),
      'pruebaId': serializer.toJson<int>(pruebaId),
    };
  }

  DescartesPruebaData copyWith({int? pilotoId, int? pruebaId}) =>
      DescartesPruebaData(
        pilotoId: pilotoId ?? this.pilotoId,
        pruebaId: pruebaId ?? this.pruebaId,
      );
  DescartesPruebaData copyWithCompanion(DescartesPruebaCompanion data) {
    return DescartesPruebaData(
      pilotoId: data.pilotoId.present ? data.pilotoId.value : this.pilotoId,
      pruebaId: data.pruebaId.present ? data.pruebaId.value : this.pruebaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DescartesPruebaData(')
          ..write('pilotoId: $pilotoId, ')
          ..write('pruebaId: $pruebaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pilotoId, pruebaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DescartesPruebaData &&
          other.pilotoId == this.pilotoId &&
          other.pruebaId == this.pruebaId);
}

class DescartesPruebaCompanion extends UpdateCompanion<DescartesPruebaData> {
  final Value<int> pilotoId;
  final Value<int> pruebaId;
  final Value<int> rowid;
  const DescartesPruebaCompanion({
    this.pilotoId = const Value.absent(),
    this.pruebaId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DescartesPruebaCompanion.insert({
    required int pilotoId,
    required int pruebaId,
    this.rowid = const Value.absent(),
  }) : pilotoId = Value(pilotoId),
       pruebaId = Value(pruebaId);
  static Insertable<DescartesPruebaData> custom({
    Expression<int>? pilotoId,
    Expression<int>? pruebaId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pilotoId != null) 'piloto_id': pilotoId,
      if (pruebaId != null) 'prueba_id': pruebaId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DescartesPruebaCompanion copyWith({
    Value<int>? pilotoId,
    Value<int>? pruebaId,
    Value<int>? rowid,
  }) {
    return DescartesPruebaCompanion(
      pilotoId: pilotoId ?? this.pilotoId,
      pruebaId: pruebaId ?? this.pruebaId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pilotoId.present) {
      map['piloto_id'] = Variable<int>(pilotoId.value);
    }
    if (pruebaId.present) {
      map['prueba_id'] = Variable<int>(pruebaId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DescartesPruebaCompanion(')
          ..write('pilotoId: $pilotoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OverridesCopaTable extends OverridesCopa
    with TableInfo<$OverridesCopaTable, OverridesCopaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OverridesCopaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campeonatos (id)',
    ),
  );
  static const VerificationMeta _copaMeta = const VerificationMeta('copa');
  @override
  late final GeneratedColumn<String> copa = GeneratedColumn<String>(
    'copa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pilotoIdMeta = const VerificationMeta(
    'pilotoId',
  );
  @override
  late final GeneratedColumn<int> pilotoId = GeneratedColumn<int>(
    'piloto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pilotos (id)',
    ),
  );
  static const VerificationMeta _pruebaIdMeta = const VerificationMeta(
    'pruebaId',
  );
  @override
  late final GeneratedColumn<int> pruebaId = GeneratedColumn<int>(
    'prueba_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pruebas (id)',
    ),
  );
  static const VerificationMeta _puntosMeta = const VerificationMeta('puntos');
  @override
  late final GeneratedColumn<int> puntos = GeneratedColumn<int>(
    'puntos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    campeonatoId,
    copa,
    pilotoId,
    pruebaId,
    puntos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'overrides_copa';
  @override
  VerificationContext validateIntegrity(
    Insertable<OverridesCopaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campeonatoIdMeta);
    }
    if (data.containsKey('copa')) {
      context.handle(
        _copaMeta,
        copa.isAcceptableOrUnknown(data['copa']!, _copaMeta),
      );
    } else if (isInserting) {
      context.missing(_copaMeta);
    }
    if (data.containsKey('piloto_id')) {
      context.handle(
        _pilotoIdMeta,
        pilotoId.isAcceptableOrUnknown(data['piloto_id']!, _pilotoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pilotoIdMeta);
    }
    if (data.containsKey('prueba_id')) {
      context.handle(
        _pruebaIdMeta,
        pruebaId.isAcceptableOrUnknown(data['prueba_id']!, _pruebaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pruebaIdMeta);
    }
    if (data.containsKey('puntos')) {
      context.handle(
        _puntosMeta,
        puntos.isAcceptableOrUnknown(data['puntos']!, _puntosMeta),
      );
    } else if (isInserting) {
      context.missing(_puntosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    campeonatoId,
    copa,
    pilotoId,
    pruebaId,
  };
  @override
  OverridesCopaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OverridesCopaData(
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      )!,
      copa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copa'],
      )!,
      pilotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piloto_id'],
      )!,
      pruebaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prueba_id'],
      )!,
      puntos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}puntos'],
      )!,
    );
  }

  @override
  $OverridesCopaTable createAlias(String alias) {
    return $OverridesCopaTable(attachedDatabase, alias);
  }
}

class OverridesCopaData extends DataClass
    implements Insertable<OverridesCopaData> {
  final int campeonatoId;
  final String copa;
  final int pilotoId;
  final int pruebaId;
  final int puntos;
  const OverridesCopaData({
    required this.campeonatoId,
    required this.copa,
    required this.pilotoId,
    required this.pruebaId,
    required this.puntos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['campeonato_id'] = Variable<int>(campeonatoId);
    map['copa'] = Variable<String>(copa);
    map['piloto_id'] = Variable<int>(pilotoId);
    map['prueba_id'] = Variable<int>(pruebaId);
    map['puntos'] = Variable<int>(puntos);
    return map;
  }

  OverridesCopaCompanion toCompanion(bool nullToAbsent) {
    return OverridesCopaCompanion(
      campeonatoId: Value(campeonatoId),
      copa: Value(copa),
      pilotoId: Value(pilotoId),
      pruebaId: Value(pruebaId),
      puntos: Value(puntos),
    );
  }

  factory OverridesCopaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OverridesCopaData(
      campeonatoId: serializer.fromJson<int>(json['campeonatoId']),
      copa: serializer.fromJson<String>(json['copa']),
      pilotoId: serializer.fromJson<int>(json['pilotoId']),
      pruebaId: serializer.fromJson<int>(json['pruebaId']),
      puntos: serializer.fromJson<int>(json['puntos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'campeonatoId': serializer.toJson<int>(campeonatoId),
      'copa': serializer.toJson<String>(copa),
      'pilotoId': serializer.toJson<int>(pilotoId),
      'pruebaId': serializer.toJson<int>(pruebaId),
      'puntos': serializer.toJson<int>(puntos),
    };
  }

  OverridesCopaData copyWith({
    int? campeonatoId,
    String? copa,
    int? pilotoId,
    int? pruebaId,
    int? puntos,
  }) => OverridesCopaData(
    campeonatoId: campeonatoId ?? this.campeonatoId,
    copa: copa ?? this.copa,
    pilotoId: pilotoId ?? this.pilotoId,
    pruebaId: pruebaId ?? this.pruebaId,
    puntos: puntos ?? this.puntos,
  );
  OverridesCopaData copyWithCompanion(OverridesCopaCompanion data) {
    return OverridesCopaData(
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      copa: data.copa.present ? data.copa.value : this.copa,
      pilotoId: data.pilotoId.present ? data.pilotoId.value : this.pilotoId,
      pruebaId: data.pruebaId.present ? data.pruebaId.value : this.pruebaId,
      puntos: data.puntos.present ? data.puntos.value : this.puntos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OverridesCopaData(')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('copa: $copa, ')
          ..write('pilotoId: $pilotoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('puntos: $puntos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(campeonatoId, copa, pilotoId, pruebaId, puntos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OverridesCopaData &&
          other.campeonatoId == this.campeonatoId &&
          other.copa == this.copa &&
          other.pilotoId == this.pilotoId &&
          other.pruebaId == this.pruebaId &&
          other.puntos == this.puntos);
}

class OverridesCopaCompanion extends UpdateCompanion<OverridesCopaData> {
  final Value<int> campeonatoId;
  final Value<String> copa;
  final Value<int> pilotoId;
  final Value<int> pruebaId;
  final Value<int> puntos;
  final Value<int> rowid;
  const OverridesCopaCompanion({
    this.campeonatoId = const Value.absent(),
    this.copa = const Value.absent(),
    this.pilotoId = const Value.absent(),
    this.pruebaId = const Value.absent(),
    this.puntos = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OverridesCopaCompanion.insert({
    required int campeonatoId,
    required String copa,
    required int pilotoId,
    required int pruebaId,
    required int puntos,
    this.rowid = const Value.absent(),
  }) : campeonatoId = Value(campeonatoId),
       copa = Value(copa),
       pilotoId = Value(pilotoId),
       pruebaId = Value(pruebaId),
       puntos = Value(puntos);
  static Insertable<OverridesCopaData> custom({
    Expression<int>? campeonatoId,
    Expression<String>? copa,
    Expression<int>? pilotoId,
    Expression<int>? pruebaId,
    Expression<int>? puntos,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (copa != null) 'copa': copa,
      if (pilotoId != null) 'piloto_id': pilotoId,
      if (pruebaId != null) 'prueba_id': pruebaId,
      if (puntos != null) 'puntos': puntos,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OverridesCopaCompanion copyWith({
    Value<int>? campeonatoId,
    Value<String>? copa,
    Value<int>? pilotoId,
    Value<int>? pruebaId,
    Value<int>? puntos,
    Value<int>? rowid,
  }) {
    return OverridesCopaCompanion(
      campeonatoId: campeonatoId ?? this.campeonatoId,
      copa: copa ?? this.copa,
      pilotoId: pilotoId ?? this.pilotoId,
      pruebaId: pruebaId ?? this.pruebaId,
      puntos: puntos ?? this.puntos,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (copa.present) {
      map['copa'] = Variable<String>(copa.value);
    }
    if (pilotoId.present) {
      map['piloto_id'] = Variable<int>(pilotoId.value);
    }
    if (pruebaId.present) {
      map['prueba_id'] = Variable<int>(pruebaId.value);
    }
    if (puntos.present) {
      map['puntos'] = Variable<int>(puntos.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OverridesCopaCompanion(')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('copa: $copa, ')
          ..write('pilotoId: $pilotoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('puntos: $puntos, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogoCochesTable extends CatalogoCoches
    with TableInfo<$CatalogoCochesTable, CatalogoCoche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoCochesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
    'modelo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pesoMinMeta = const VerificationMeta(
    'pesoMin',
  );
  @override
  late final GeneratedColumn<double> pesoMin = GeneratedColumn<double>(
    'peso_min',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditosCocheMeta = const VerificationMeta(
    'creditosCoche',
  );
  @override
  late final GeneratedColumn<int> creditosCoche = GeneratedColumn<int>(
    'creditos_coche',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _copasJsonMeta = const VerificationMeta(
    'copasJson',
  );
  @override
  late final GeneratedColumn<String> copasJson = GeneratedColumn<String>(
    'copas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _fotoPathMeta = const VerificationMeta(
    'fotoPath',
  );
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
    'foto_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    marca,
    modelo,
    pesoMin,
    creditosCoche,
    activo,
    copasJson,
    fotoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_coches';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoCoche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(
        _modeloMeta,
        modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta),
      );
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('peso_min')) {
      context.handle(
        _pesoMinMeta,
        pesoMin.isAcceptableOrUnknown(data['peso_min']!, _pesoMinMeta),
      );
    } else if (isInserting) {
      context.missing(_pesoMinMeta);
    }
    if (data.containsKey('creditos_coche')) {
      context.handle(
        _creditosCocheMeta,
        creditosCoche.isAcceptableOrUnknown(
          data['creditos_coche']!,
          _creditosCocheMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('copas_json')) {
      context.handle(
        _copasJsonMeta,
        copasJson.isAcceptableOrUnknown(data['copas_json']!, _copasJsonMeta),
      );
    }
    if (data.containsKey('foto_path')) {
      context.handle(
        _fotoPathMeta,
        fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoCoche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoCoche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      )!,
      modelo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modelo'],
      )!,
      pesoMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_min'],
      )!,
      creditosCoche: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creditos_coche'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      copasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copas_json'],
      )!,
      fotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_path'],
      ),
    );
  }

  @override
  $CatalogoCochesTable createAlias(String alias) {
    return $CatalogoCochesTable(attachedDatabase, alias);
  }
}

class CatalogoCoche extends DataClass implements Insertable<CatalogoCoche> {
  final int id;
  final String nombre;
  final String marca;
  final String modelo;
  final double pesoMin;
  final int creditosCoche;
  final bool activo;

  /// JSON array de copas donde aplica este coche. Vacío "[]" = aplica a todas.
  final String copasJson;

  /// Nombre de archivo de la foto del coche (en la carpeta de fotos local).
  /// Sirve para comprobar en la verificación que el coche entregado coincide.
  final String? fotoPath;
  const CatalogoCoche({
    required this.id,
    required this.nombre,
    required this.marca,
    required this.modelo,
    required this.pesoMin,
    required this.creditosCoche,
    required this.activo,
    required this.copasJson,
    this.fotoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['peso_min'] = Variable<double>(pesoMin);
    map['creditos_coche'] = Variable<int>(creditosCoche);
    map['activo'] = Variable<bool>(activo);
    map['copas_json'] = Variable<String>(copasJson);
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    return map;
  }

  CatalogoCochesCompanion toCompanion(bool nullToAbsent) {
    return CatalogoCochesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      marca: Value(marca),
      modelo: Value(modelo),
      pesoMin: Value(pesoMin),
      creditosCoche: Value(creditosCoche),
      activo: Value(activo),
      copasJson: Value(copasJson),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
    );
  }

  factory CatalogoCoche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoCoche(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      pesoMin: serializer.fromJson<double>(json['pesoMin']),
      creditosCoche: serializer.fromJson<int>(json['creditosCoche']),
      activo: serializer.fromJson<bool>(json['activo']),
      copasJson: serializer.fromJson<String>(json['copasJson']),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'pesoMin': serializer.toJson<double>(pesoMin),
      'creditosCoche': serializer.toJson<int>(creditosCoche),
      'activo': serializer.toJson<bool>(activo),
      'copasJson': serializer.toJson<String>(copasJson),
      'fotoPath': serializer.toJson<String?>(fotoPath),
    };
  }

  CatalogoCoche copyWith({
    int? id,
    String? nombre,
    String? marca,
    String? modelo,
    double? pesoMin,
    int? creditosCoche,
    bool? activo,
    String? copasJson,
    Value<String?> fotoPath = const Value.absent(),
  }) => CatalogoCoche(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    marca: marca ?? this.marca,
    modelo: modelo ?? this.modelo,
    pesoMin: pesoMin ?? this.pesoMin,
    creditosCoche: creditosCoche ?? this.creditosCoche,
    activo: activo ?? this.activo,
    copasJson: copasJson ?? this.copasJson,
    fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
  );
  CatalogoCoche copyWithCompanion(CatalogoCochesCompanion data) {
    return CatalogoCoche(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      pesoMin: data.pesoMin.present ? data.pesoMin.value : this.pesoMin,
      creditosCoche: data.creditosCoche.present
          ? data.creditosCoche.value
          : this.creditosCoche,
      activo: data.activo.present ? data.activo.value : this.activo,
      copasJson: data.copasJson.present ? data.copasJson.value : this.copasJson,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoCoche(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('pesoMin: $pesoMin, ')
          ..write('creditosCoche: $creditosCoche, ')
          ..write('activo: $activo, ')
          ..write('copasJson: $copasJson, ')
          ..write('fotoPath: $fotoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    marca,
    modelo,
    pesoMin,
    creditosCoche,
    activo,
    copasJson,
    fotoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoCoche &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.pesoMin == this.pesoMin &&
          other.creditosCoche == this.creditosCoche &&
          other.activo == this.activo &&
          other.copasJson == this.copasJson &&
          other.fotoPath == this.fotoPath);
}

class CatalogoCochesCompanion extends UpdateCompanion<CatalogoCoche> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<double> pesoMin;
  final Value<int> creditosCoche;
  final Value<bool> activo;
  final Value<String> copasJson;
  final Value<String?> fotoPath;
  const CatalogoCochesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.pesoMin = const Value.absent(),
    this.creditosCoche = const Value.absent(),
    this.activo = const Value.absent(),
    this.copasJson = const Value.absent(),
    this.fotoPath = const Value.absent(),
  });
  CatalogoCochesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String marca,
    required String modelo,
    required double pesoMin,
    this.creditosCoche = const Value.absent(),
    this.activo = const Value.absent(),
    this.copasJson = const Value.absent(),
    this.fotoPath = const Value.absent(),
  }) : nombre = Value(nombre),
       marca = Value(marca),
       modelo = Value(modelo),
       pesoMin = Value(pesoMin);
  static Insertable<CatalogoCoche> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<double>? pesoMin,
    Expression<int>? creditosCoche,
    Expression<bool>? activo,
    Expression<String>? copasJson,
    Expression<String>? fotoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (pesoMin != null) 'peso_min': pesoMin,
      if (creditosCoche != null) 'creditos_coche': creditosCoche,
      if (activo != null) 'activo': activo,
      if (copasJson != null) 'copas_json': copasJson,
      if (fotoPath != null) 'foto_path': fotoPath,
    });
  }

  CatalogoCochesCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? marca,
    Value<String>? modelo,
    Value<double>? pesoMin,
    Value<int>? creditosCoche,
    Value<bool>? activo,
    Value<String>? copasJson,
    Value<String?>? fotoPath,
  }) {
    return CatalogoCochesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      pesoMin: pesoMin ?? this.pesoMin,
      creditosCoche: creditosCoche ?? this.creditosCoche,
      activo: activo ?? this.activo,
      copasJson: copasJson ?? this.copasJson,
      fotoPath: fotoPath ?? this.fotoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (pesoMin.present) {
      map['peso_min'] = Variable<double>(pesoMin.value);
    }
    if (creditosCoche.present) {
      map['creditos_coche'] = Variable<int>(creditosCoche.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (copasJson.present) {
      map['copas_json'] = Variable<String>(copasJson.value);
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoCochesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('pesoMin: $pesoMin, ')
          ..write('creditosCoche: $creditosCoche, ')
          ..write('activo: $activo, ')
          ..write('copasJson: $copasJson, ')
          ..write('fotoPath: $fotoPath')
          ..write(')'))
        .toString();
  }
}

class $VerificacionesTable extends Verificaciones
    with TableInfo<$VerificacionesTable, Verificacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerificacionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mangaIdMeta = const VerificationMeta(
    'mangaId',
  );
  @override
  late final GeneratedColumn<int> mangaId = GeneratedColumn<int>(
    'manga_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mangas (id)',
    ),
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
    'equipo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipos (id)',
    ),
  );
  static const VerificationMeta _cocheCatalogoIdMeta = const VerificationMeta(
    'cocheCatalogoId',
  );
  @override
  late final GeneratedColumn<int> cocheCatalogoId = GeneratedColumn<int>(
    'coche_catalogo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES catalogo_coches (id)',
    ),
  );
  static const VerificationMeta _pesoInicialMeta = const VerificationMeta(
    'pesoInicial',
  );
  @override
  late final GeneratedColumn<double> pesoInicial = GeneratedColumn<double>(
    'peso_inicial',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pesoFinalMeta = const VerificationMeta(
    'pesoFinal',
  );
  @override
  late final GeneratedColumn<double> pesoFinal = GeneratedColumn<double>(
    'peso_final',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pesoMinMeta = const VerificationMeta(
    'pesoMin',
  );
  @override
  late final GeneratedColumn<double> pesoMin = GeneratedColumn<double>(
    'peso_min',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pesoInicialCocheMeta = const VerificationMeta(
    'pesoInicialCoche',
  );
  @override
  late final GeneratedColumn<double> pesoInicialCoche = GeneratedColumn<double>(
    'peso_inicial_coche',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pesoFinalCocheMeta = const VerificationMeta(
    'pesoFinalCoche',
  );
  @override
  late final GeneratedColumn<double> pesoFinalCoche = GeneratedColumn<double>(
    'peso_final_coche',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motorMeta = const VerificationMeta('motor');
  @override
  late final GeneratedColumn<String> motor = GeneratedColumn<String>(
    'motor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motorTipoMeta = const VerificationMeta(
    'motorTipo',
  );
  @override
  late final GeneratedColumn<String> motorTipo = GeneratedColumn<String>(
    'motor_tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ORGANIZACION'),
  );
  static const VerificationMeta _motorRpmMeta = const VerificationMeta(
    'motorRpm',
  );
  @override
  late final GeneratedColumn<int> motorRpm = GeneratedColumn<int>(
    'motor_rpm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motorUmsMeta = const VerificationMeta(
    'motorUms',
  );
  @override
  late final GeneratedColumn<double> motorUms = GeneratedColumn<double>(
    'motor_ums',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinonMarcaMeta = const VerificationMeta(
    'pinonMarca',
  );
  @override
  late final GeneratedColumn<String> pinonMarca = GeneratedColumn<String>(
    'pinon_marca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinonDientesMeta = const VerificationMeta(
    'pinonDientes',
  );
  @override
  late final GeneratedColumn<int> pinonDientes = GeneratedColumn<int>(
    'pinon_dientes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coronaMarcaMeta = const VerificationMeta(
    'coronaMarca',
  );
  @override
  late final GeneratedColumn<String> coronaMarca = GeneratedColumn<String>(
    'corona_marca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coronaDientesMeta = const VerificationMeta(
    'coronaDientes',
  );
  @override
  late final GeneratedColumn<int> coronaDientes = GeneratedColumn<int>(
    'corona_dientes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _llantaDelMarcaMeta = const VerificationMeta(
    'llantaDelMarca',
  );
  @override
  late final GeneratedColumn<String> llantaDelMarca = GeneratedColumn<String>(
    'llanta_del_marca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _llantaDelDimensionMeta =
      const VerificationMeta('llantaDelDimension');
  @override
  late final GeneratedColumn<String> llantaDelDimension =
      GeneratedColumn<String>(
        'llanta_del_dimension',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _llantaTraMarcaMeta = const VerificationMeta(
    'llantaTraMarca',
  );
  @override
  late final GeneratedColumn<String> llantaTraMarca = GeneratedColumn<String>(
    'llanta_tra_marca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _llantaTraDimensionMeta =
      const VerificationMeta('llantaTraDimension');
  @override
  late final GeneratedColumn<String> llantaTraDimension =
      GeneratedColumn<String>(
        'llanta_tra_dimension',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _trencillaMeta = const VerificationMeta(
    'trencilla',
  );
  @override
  late final GeneratedColumn<String> trencilla = GeneratedColumn<String>(
    'trencilla',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suspensionMeta = const VerificationMeta(
    'suspension',
  );
  @override
  late final GeneratedColumn<String> suspension = GeneratedColumn<String>(
    'suspension',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bancadaMeta = const VerificationMeta(
    'bancada',
  );
  @override
  late final GeneratedColumn<String> bancada = GeneratedColumn<String>(
    'bancada',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chasisMeta = const VerificationMeta('chasis');
  @override
  late final GeneratedColumn<String> chasis = GeneratedColumn<String>(
    'chasis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neumaticoMeta = const VerificationMeta(
    'neumatico',
  );
  @override
  late final GeneratedColumn<String> neumatico = GeneratedColumn<String>(
    'neumatico',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validadoMeta = const VerificationMeta(
    'validado',
  );
  @override
  late final GeneratedColumn<bool> validado = GeneratedColumn<bool>(
    'validado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("validado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fotosJsonMeta = const VerificationMeta(
    'fotosJson',
  );
  @override
  late final GeneratedColumn<String> fotosJson = GeneratedColumn<String>(
    'fotos_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _credAplicadoP1Meta = const VerificationMeta(
    'credAplicadoP1',
  );
  @override
  late final GeneratedColumn<int> credAplicadoP1 = GeneratedColumn<int>(
    'cred_aplicado_p1',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _credAplicadoP2Meta = const VerificationMeta(
    'credAplicadoP2',
  );
  @override
  late final GeneratedColumn<int> credAplicadoP2 = GeneratedColumn<int>(
    'cred_aplicado_p2',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mangaId,
    equipoId,
    cocheCatalogoId,
    pesoInicial,
    pesoFinal,
    pesoMin,
    pesoInicialCoche,
    pesoFinalCoche,
    motor,
    motorTipo,
    motorRpm,
    motorUms,
    pinonMarca,
    pinonDientes,
    coronaMarca,
    coronaDientes,
    llantaDelMarca,
    llantaDelDimension,
    llantaTraMarca,
    llantaTraDimension,
    trencilla,
    suspension,
    bancada,
    chasis,
    neumatico,
    observaciones,
    validado,
    fotosJson,
    fecha,
    credAplicadoP1,
    credAplicadoP2,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verificaciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verificacione> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(
        _mangaIdMeta,
        mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('coche_catalogo_id')) {
      context.handle(
        _cocheCatalogoIdMeta,
        cocheCatalogoId.isAcceptableOrUnknown(
          data['coche_catalogo_id']!,
          _cocheCatalogoIdMeta,
        ),
      );
    }
    if (data.containsKey('peso_inicial')) {
      context.handle(
        _pesoInicialMeta,
        pesoInicial.isAcceptableOrUnknown(
          data['peso_inicial']!,
          _pesoInicialMeta,
        ),
      );
    }
    if (data.containsKey('peso_final')) {
      context.handle(
        _pesoFinalMeta,
        pesoFinal.isAcceptableOrUnknown(data['peso_final']!, _pesoFinalMeta),
      );
    }
    if (data.containsKey('peso_min')) {
      context.handle(
        _pesoMinMeta,
        pesoMin.isAcceptableOrUnknown(data['peso_min']!, _pesoMinMeta),
      );
    }
    if (data.containsKey('peso_inicial_coche')) {
      context.handle(
        _pesoInicialCocheMeta,
        pesoInicialCoche.isAcceptableOrUnknown(
          data['peso_inicial_coche']!,
          _pesoInicialCocheMeta,
        ),
      );
    }
    if (data.containsKey('peso_final_coche')) {
      context.handle(
        _pesoFinalCocheMeta,
        pesoFinalCoche.isAcceptableOrUnknown(
          data['peso_final_coche']!,
          _pesoFinalCocheMeta,
        ),
      );
    }
    if (data.containsKey('motor')) {
      context.handle(
        _motorMeta,
        motor.isAcceptableOrUnknown(data['motor']!, _motorMeta),
      );
    }
    if (data.containsKey('motor_tipo')) {
      context.handle(
        _motorTipoMeta,
        motorTipo.isAcceptableOrUnknown(data['motor_tipo']!, _motorTipoMeta),
      );
    }
    if (data.containsKey('motor_rpm')) {
      context.handle(
        _motorRpmMeta,
        motorRpm.isAcceptableOrUnknown(data['motor_rpm']!, _motorRpmMeta),
      );
    }
    if (data.containsKey('motor_ums')) {
      context.handle(
        _motorUmsMeta,
        motorUms.isAcceptableOrUnknown(data['motor_ums']!, _motorUmsMeta),
      );
    }
    if (data.containsKey('pinon_marca')) {
      context.handle(
        _pinonMarcaMeta,
        pinonMarca.isAcceptableOrUnknown(data['pinon_marca']!, _pinonMarcaMeta),
      );
    }
    if (data.containsKey('pinon_dientes')) {
      context.handle(
        _pinonDientesMeta,
        pinonDientes.isAcceptableOrUnknown(
          data['pinon_dientes']!,
          _pinonDientesMeta,
        ),
      );
    }
    if (data.containsKey('corona_marca')) {
      context.handle(
        _coronaMarcaMeta,
        coronaMarca.isAcceptableOrUnknown(
          data['corona_marca']!,
          _coronaMarcaMeta,
        ),
      );
    }
    if (data.containsKey('corona_dientes')) {
      context.handle(
        _coronaDientesMeta,
        coronaDientes.isAcceptableOrUnknown(
          data['corona_dientes']!,
          _coronaDientesMeta,
        ),
      );
    }
    if (data.containsKey('llanta_del_marca')) {
      context.handle(
        _llantaDelMarcaMeta,
        llantaDelMarca.isAcceptableOrUnknown(
          data['llanta_del_marca']!,
          _llantaDelMarcaMeta,
        ),
      );
    }
    if (data.containsKey('llanta_del_dimension')) {
      context.handle(
        _llantaDelDimensionMeta,
        llantaDelDimension.isAcceptableOrUnknown(
          data['llanta_del_dimension']!,
          _llantaDelDimensionMeta,
        ),
      );
    }
    if (data.containsKey('llanta_tra_marca')) {
      context.handle(
        _llantaTraMarcaMeta,
        llantaTraMarca.isAcceptableOrUnknown(
          data['llanta_tra_marca']!,
          _llantaTraMarcaMeta,
        ),
      );
    }
    if (data.containsKey('llanta_tra_dimension')) {
      context.handle(
        _llantaTraDimensionMeta,
        llantaTraDimension.isAcceptableOrUnknown(
          data['llanta_tra_dimension']!,
          _llantaTraDimensionMeta,
        ),
      );
    }
    if (data.containsKey('trencilla')) {
      context.handle(
        _trencillaMeta,
        trencilla.isAcceptableOrUnknown(data['trencilla']!, _trencillaMeta),
      );
    }
    if (data.containsKey('suspension')) {
      context.handle(
        _suspensionMeta,
        suspension.isAcceptableOrUnknown(data['suspension']!, _suspensionMeta),
      );
    }
    if (data.containsKey('bancada')) {
      context.handle(
        _bancadaMeta,
        bancada.isAcceptableOrUnknown(data['bancada']!, _bancadaMeta),
      );
    }
    if (data.containsKey('chasis')) {
      context.handle(
        _chasisMeta,
        chasis.isAcceptableOrUnknown(data['chasis']!, _chasisMeta),
      );
    }
    if (data.containsKey('neumatico')) {
      context.handle(
        _neumaticoMeta,
        neumatico.isAcceptableOrUnknown(data['neumatico']!, _neumaticoMeta),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('validado')) {
      context.handle(
        _validadoMeta,
        validado.isAcceptableOrUnknown(data['validado']!, _validadoMeta),
      );
    }
    if (data.containsKey('fotos_json')) {
      context.handle(
        _fotosJsonMeta,
        fotosJson.isAcceptableOrUnknown(data['fotos_json']!, _fotosJsonMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('cred_aplicado_p1')) {
      context.handle(
        _credAplicadoP1Meta,
        credAplicadoP1.isAcceptableOrUnknown(
          data['cred_aplicado_p1']!,
          _credAplicadoP1Meta,
        ),
      );
    }
    if (data.containsKey('cred_aplicado_p2')) {
      context.handle(
        _credAplicadoP2Meta,
        credAplicadoP2.isAcceptableOrUnknown(
          data['cred_aplicado_p2']!,
          _credAplicadoP2Meta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Verificacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verificacione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mangaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manga_id'],
      )!,
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipo_id'],
      )!,
      cocheCatalogoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coche_catalogo_id'],
      ),
      pesoInicial: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_inicial'],
      ),
      pesoFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_final'],
      ),
      pesoMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_min'],
      ),
      pesoInicialCoche: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_inicial_coche'],
      ),
      pesoFinalCoche: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso_final_coche'],
      ),
      motor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motor'],
      ),
      motorTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motor_tipo'],
      )!,
      motorRpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motor_rpm'],
      ),
      motorUms: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}motor_ums'],
      ),
      pinonMarca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinon_marca'],
      ),
      pinonDientes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pinon_dientes'],
      ),
      coronaMarca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}corona_marca'],
      ),
      coronaDientes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corona_dientes'],
      ),
      llantaDelMarca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}llanta_del_marca'],
      ),
      llantaDelDimension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}llanta_del_dimension'],
      ),
      llantaTraMarca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}llanta_tra_marca'],
      ),
      llantaTraDimension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}llanta_tra_dimension'],
      ),
      trencilla: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trencilla'],
      ),
      suspension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suspension'],
      ),
      bancada: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bancada'],
      ),
      chasis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chasis'],
      ),
      neumatico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neumatico'],
      ),
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
      validado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}validado'],
      )!,
      fotosJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fotos_json'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      credAplicadoP1: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cred_aplicado_p1'],
      )!,
      credAplicadoP2: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cred_aplicado_p2'],
      )!,
    );
  }

  @override
  $VerificacionesTable createAlias(String alias) {
    return $VerificacionesTable(attachedDatabase, alias);
  }
}

class Verificacione extends DataClass implements Insertable<Verificacione> {
  final int id;
  final int mangaId;
  final int equipoId;
  final int? cocheCatalogoId;

  /// Peso de la carrocería (cumple con peso_min del coche).
  final double? pesoInicial;
  final double? pesoFinal;
  final double? pesoMin;

  /// Peso del coche entero (carrocería + chasis + componentes), al inicio
  /// y al final de la verificación.
  final double? pesoInicialCoche;
  final double? pesoFinalCoche;

  /// Identificador o número del motor (cuando es de organización).
  final String? motor;

  /// 'PROPIO' o 'ORGANIZACION'.
  final String motorTipo;

  /// Si motor propio: RPM medidas.
  final int? motorRpm;

  /// Si motor propio: uMs (medida específica).
  final double? motorUms;
  final String? pinonMarca;
  final int? pinonDientes;
  final String? coronaMarca;
  final int? coronaDientes;
  final String? llantaDelMarca;
  final String? llantaDelDimension;
  final String? llantaTraMarca;
  final String? llantaTraDimension;
  final String? trencilla;
  final String? suspension;
  final String? bancada;
  final String? chasis;
  final String? neumatico;
  final String? observaciones;
  final bool validado;

  /// JSON array con rutas de hasta 4 fotos del coche/equipo.
  final String fotosJson;
  final DateTime fecha;

  /// Créditos que se descontaron a piloto1 al validar la verificación.
  /// Se rellena solo cuando `validado` pasa a true. Sirve para devolverlos
  /// si la verificación se desvalida, se cambia de coche o se borra.
  final int credAplicadoP1;
  final int credAplicadoP2;
  const Verificacione({
    required this.id,
    required this.mangaId,
    required this.equipoId,
    this.cocheCatalogoId,
    this.pesoInicial,
    this.pesoFinal,
    this.pesoMin,
    this.pesoInicialCoche,
    this.pesoFinalCoche,
    this.motor,
    required this.motorTipo,
    this.motorRpm,
    this.motorUms,
    this.pinonMarca,
    this.pinonDientes,
    this.coronaMarca,
    this.coronaDientes,
    this.llantaDelMarca,
    this.llantaDelDimension,
    this.llantaTraMarca,
    this.llantaTraDimension,
    this.trencilla,
    this.suspension,
    this.bancada,
    this.chasis,
    this.neumatico,
    this.observaciones,
    required this.validado,
    required this.fotosJson,
    required this.fecha,
    required this.credAplicadoP1,
    required this.credAplicadoP2,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<int>(mangaId);
    map['equipo_id'] = Variable<int>(equipoId);
    if (!nullToAbsent || cocheCatalogoId != null) {
      map['coche_catalogo_id'] = Variable<int>(cocheCatalogoId);
    }
    if (!nullToAbsent || pesoInicial != null) {
      map['peso_inicial'] = Variable<double>(pesoInicial);
    }
    if (!nullToAbsent || pesoFinal != null) {
      map['peso_final'] = Variable<double>(pesoFinal);
    }
    if (!nullToAbsent || pesoMin != null) {
      map['peso_min'] = Variable<double>(pesoMin);
    }
    if (!nullToAbsent || pesoInicialCoche != null) {
      map['peso_inicial_coche'] = Variable<double>(pesoInicialCoche);
    }
    if (!nullToAbsent || pesoFinalCoche != null) {
      map['peso_final_coche'] = Variable<double>(pesoFinalCoche);
    }
    if (!nullToAbsent || motor != null) {
      map['motor'] = Variable<String>(motor);
    }
    map['motor_tipo'] = Variable<String>(motorTipo);
    if (!nullToAbsent || motorRpm != null) {
      map['motor_rpm'] = Variable<int>(motorRpm);
    }
    if (!nullToAbsent || motorUms != null) {
      map['motor_ums'] = Variable<double>(motorUms);
    }
    if (!nullToAbsent || pinonMarca != null) {
      map['pinon_marca'] = Variable<String>(pinonMarca);
    }
    if (!nullToAbsent || pinonDientes != null) {
      map['pinon_dientes'] = Variable<int>(pinonDientes);
    }
    if (!nullToAbsent || coronaMarca != null) {
      map['corona_marca'] = Variable<String>(coronaMarca);
    }
    if (!nullToAbsent || coronaDientes != null) {
      map['corona_dientes'] = Variable<int>(coronaDientes);
    }
    if (!nullToAbsent || llantaDelMarca != null) {
      map['llanta_del_marca'] = Variable<String>(llantaDelMarca);
    }
    if (!nullToAbsent || llantaDelDimension != null) {
      map['llanta_del_dimension'] = Variable<String>(llantaDelDimension);
    }
    if (!nullToAbsent || llantaTraMarca != null) {
      map['llanta_tra_marca'] = Variable<String>(llantaTraMarca);
    }
    if (!nullToAbsent || llantaTraDimension != null) {
      map['llanta_tra_dimension'] = Variable<String>(llantaTraDimension);
    }
    if (!nullToAbsent || trencilla != null) {
      map['trencilla'] = Variable<String>(trencilla);
    }
    if (!nullToAbsent || suspension != null) {
      map['suspension'] = Variable<String>(suspension);
    }
    if (!nullToAbsent || bancada != null) {
      map['bancada'] = Variable<String>(bancada);
    }
    if (!nullToAbsent || chasis != null) {
      map['chasis'] = Variable<String>(chasis);
    }
    if (!nullToAbsent || neumatico != null) {
      map['neumatico'] = Variable<String>(neumatico);
    }
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    map['validado'] = Variable<bool>(validado);
    map['fotos_json'] = Variable<String>(fotosJson);
    map['fecha'] = Variable<DateTime>(fecha);
    map['cred_aplicado_p1'] = Variable<int>(credAplicadoP1);
    map['cred_aplicado_p2'] = Variable<int>(credAplicadoP2);
    return map;
  }

  VerificacionesCompanion toCompanion(bool nullToAbsent) {
    return VerificacionesCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      equipoId: Value(equipoId),
      cocheCatalogoId: cocheCatalogoId == null && nullToAbsent
          ? const Value.absent()
          : Value(cocheCatalogoId),
      pesoInicial: pesoInicial == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoInicial),
      pesoFinal: pesoFinal == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoFinal),
      pesoMin: pesoMin == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoMin),
      pesoInicialCoche: pesoInicialCoche == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoInicialCoche),
      pesoFinalCoche: pesoFinalCoche == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoFinalCoche),
      motor: motor == null && nullToAbsent
          ? const Value.absent()
          : Value(motor),
      motorTipo: Value(motorTipo),
      motorRpm: motorRpm == null && nullToAbsent
          ? const Value.absent()
          : Value(motorRpm),
      motorUms: motorUms == null && nullToAbsent
          ? const Value.absent()
          : Value(motorUms),
      pinonMarca: pinonMarca == null && nullToAbsent
          ? const Value.absent()
          : Value(pinonMarca),
      pinonDientes: pinonDientes == null && nullToAbsent
          ? const Value.absent()
          : Value(pinonDientes),
      coronaMarca: coronaMarca == null && nullToAbsent
          ? const Value.absent()
          : Value(coronaMarca),
      coronaDientes: coronaDientes == null && nullToAbsent
          ? const Value.absent()
          : Value(coronaDientes),
      llantaDelMarca: llantaDelMarca == null && nullToAbsent
          ? const Value.absent()
          : Value(llantaDelMarca),
      llantaDelDimension: llantaDelDimension == null && nullToAbsent
          ? const Value.absent()
          : Value(llantaDelDimension),
      llantaTraMarca: llantaTraMarca == null && nullToAbsent
          ? const Value.absent()
          : Value(llantaTraMarca),
      llantaTraDimension: llantaTraDimension == null && nullToAbsent
          ? const Value.absent()
          : Value(llantaTraDimension),
      trencilla: trencilla == null && nullToAbsent
          ? const Value.absent()
          : Value(trencilla),
      suspension: suspension == null && nullToAbsent
          ? const Value.absent()
          : Value(suspension),
      bancada: bancada == null && nullToAbsent
          ? const Value.absent()
          : Value(bancada),
      chasis: chasis == null && nullToAbsent
          ? const Value.absent()
          : Value(chasis),
      neumatico: neumatico == null && nullToAbsent
          ? const Value.absent()
          : Value(neumatico),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      validado: Value(validado),
      fotosJson: Value(fotosJson),
      fecha: Value(fecha),
      credAplicadoP1: Value(credAplicadoP1),
      credAplicadoP2: Value(credAplicadoP2),
    );
  }

  factory Verificacione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verificacione(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<int>(json['mangaId']),
      equipoId: serializer.fromJson<int>(json['equipoId']),
      cocheCatalogoId: serializer.fromJson<int?>(json['cocheCatalogoId']),
      pesoInicial: serializer.fromJson<double?>(json['pesoInicial']),
      pesoFinal: serializer.fromJson<double?>(json['pesoFinal']),
      pesoMin: serializer.fromJson<double?>(json['pesoMin']),
      pesoInicialCoche: serializer.fromJson<double?>(json['pesoInicialCoche']),
      pesoFinalCoche: serializer.fromJson<double?>(json['pesoFinalCoche']),
      motor: serializer.fromJson<String?>(json['motor']),
      motorTipo: serializer.fromJson<String>(json['motorTipo']),
      motorRpm: serializer.fromJson<int?>(json['motorRpm']),
      motorUms: serializer.fromJson<double?>(json['motorUms']),
      pinonMarca: serializer.fromJson<String?>(json['pinonMarca']),
      pinonDientes: serializer.fromJson<int?>(json['pinonDientes']),
      coronaMarca: serializer.fromJson<String?>(json['coronaMarca']),
      coronaDientes: serializer.fromJson<int?>(json['coronaDientes']),
      llantaDelMarca: serializer.fromJson<String?>(json['llantaDelMarca']),
      llantaDelDimension: serializer.fromJson<String?>(
        json['llantaDelDimension'],
      ),
      llantaTraMarca: serializer.fromJson<String?>(json['llantaTraMarca']),
      llantaTraDimension: serializer.fromJson<String?>(
        json['llantaTraDimension'],
      ),
      trencilla: serializer.fromJson<String?>(json['trencilla']),
      suspension: serializer.fromJson<String?>(json['suspension']),
      bancada: serializer.fromJson<String?>(json['bancada']),
      chasis: serializer.fromJson<String?>(json['chasis']),
      neumatico: serializer.fromJson<String?>(json['neumatico']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      validado: serializer.fromJson<bool>(json['validado']),
      fotosJson: serializer.fromJson<String>(json['fotosJson']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      credAplicadoP1: serializer.fromJson<int>(json['credAplicadoP1']),
      credAplicadoP2: serializer.fromJson<int>(json['credAplicadoP2']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<int>(mangaId),
      'equipoId': serializer.toJson<int>(equipoId),
      'cocheCatalogoId': serializer.toJson<int?>(cocheCatalogoId),
      'pesoInicial': serializer.toJson<double?>(pesoInicial),
      'pesoFinal': serializer.toJson<double?>(pesoFinal),
      'pesoMin': serializer.toJson<double?>(pesoMin),
      'pesoInicialCoche': serializer.toJson<double?>(pesoInicialCoche),
      'pesoFinalCoche': serializer.toJson<double?>(pesoFinalCoche),
      'motor': serializer.toJson<String?>(motor),
      'motorTipo': serializer.toJson<String>(motorTipo),
      'motorRpm': serializer.toJson<int?>(motorRpm),
      'motorUms': serializer.toJson<double?>(motorUms),
      'pinonMarca': serializer.toJson<String?>(pinonMarca),
      'pinonDientes': serializer.toJson<int?>(pinonDientes),
      'coronaMarca': serializer.toJson<String?>(coronaMarca),
      'coronaDientes': serializer.toJson<int?>(coronaDientes),
      'llantaDelMarca': serializer.toJson<String?>(llantaDelMarca),
      'llantaDelDimension': serializer.toJson<String?>(llantaDelDimension),
      'llantaTraMarca': serializer.toJson<String?>(llantaTraMarca),
      'llantaTraDimension': serializer.toJson<String?>(llantaTraDimension),
      'trencilla': serializer.toJson<String?>(trencilla),
      'suspension': serializer.toJson<String?>(suspension),
      'bancada': serializer.toJson<String?>(bancada),
      'chasis': serializer.toJson<String?>(chasis),
      'neumatico': serializer.toJson<String?>(neumatico),
      'observaciones': serializer.toJson<String?>(observaciones),
      'validado': serializer.toJson<bool>(validado),
      'fotosJson': serializer.toJson<String>(fotosJson),
      'fecha': serializer.toJson<DateTime>(fecha),
      'credAplicadoP1': serializer.toJson<int>(credAplicadoP1),
      'credAplicadoP2': serializer.toJson<int>(credAplicadoP2),
    };
  }

  Verificacione copyWith({
    int? id,
    int? mangaId,
    int? equipoId,
    Value<int?> cocheCatalogoId = const Value.absent(),
    Value<double?> pesoInicial = const Value.absent(),
    Value<double?> pesoFinal = const Value.absent(),
    Value<double?> pesoMin = const Value.absent(),
    Value<double?> pesoInicialCoche = const Value.absent(),
    Value<double?> pesoFinalCoche = const Value.absent(),
    Value<String?> motor = const Value.absent(),
    String? motorTipo,
    Value<int?> motorRpm = const Value.absent(),
    Value<double?> motorUms = const Value.absent(),
    Value<String?> pinonMarca = const Value.absent(),
    Value<int?> pinonDientes = const Value.absent(),
    Value<String?> coronaMarca = const Value.absent(),
    Value<int?> coronaDientes = const Value.absent(),
    Value<String?> llantaDelMarca = const Value.absent(),
    Value<String?> llantaDelDimension = const Value.absent(),
    Value<String?> llantaTraMarca = const Value.absent(),
    Value<String?> llantaTraDimension = const Value.absent(),
    Value<String?> trencilla = const Value.absent(),
    Value<String?> suspension = const Value.absent(),
    Value<String?> bancada = const Value.absent(),
    Value<String?> chasis = const Value.absent(),
    Value<String?> neumatico = const Value.absent(),
    Value<String?> observaciones = const Value.absent(),
    bool? validado,
    String? fotosJson,
    DateTime? fecha,
    int? credAplicadoP1,
    int? credAplicadoP2,
  }) => Verificacione(
    id: id ?? this.id,
    mangaId: mangaId ?? this.mangaId,
    equipoId: equipoId ?? this.equipoId,
    cocheCatalogoId: cocheCatalogoId.present
        ? cocheCatalogoId.value
        : this.cocheCatalogoId,
    pesoInicial: pesoInicial.present ? pesoInicial.value : this.pesoInicial,
    pesoFinal: pesoFinal.present ? pesoFinal.value : this.pesoFinal,
    pesoMin: pesoMin.present ? pesoMin.value : this.pesoMin,
    pesoInicialCoche: pesoInicialCoche.present
        ? pesoInicialCoche.value
        : this.pesoInicialCoche,
    pesoFinalCoche: pesoFinalCoche.present
        ? pesoFinalCoche.value
        : this.pesoFinalCoche,
    motor: motor.present ? motor.value : this.motor,
    motorTipo: motorTipo ?? this.motorTipo,
    motorRpm: motorRpm.present ? motorRpm.value : this.motorRpm,
    motorUms: motorUms.present ? motorUms.value : this.motorUms,
    pinonMarca: pinonMarca.present ? pinonMarca.value : this.pinonMarca,
    pinonDientes: pinonDientes.present ? pinonDientes.value : this.pinonDientes,
    coronaMarca: coronaMarca.present ? coronaMarca.value : this.coronaMarca,
    coronaDientes: coronaDientes.present
        ? coronaDientes.value
        : this.coronaDientes,
    llantaDelMarca: llantaDelMarca.present
        ? llantaDelMarca.value
        : this.llantaDelMarca,
    llantaDelDimension: llantaDelDimension.present
        ? llantaDelDimension.value
        : this.llantaDelDimension,
    llantaTraMarca: llantaTraMarca.present
        ? llantaTraMarca.value
        : this.llantaTraMarca,
    llantaTraDimension: llantaTraDimension.present
        ? llantaTraDimension.value
        : this.llantaTraDimension,
    trencilla: trencilla.present ? trencilla.value : this.trencilla,
    suspension: suspension.present ? suspension.value : this.suspension,
    bancada: bancada.present ? bancada.value : this.bancada,
    chasis: chasis.present ? chasis.value : this.chasis,
    neumatico: neumatico.present ? neumatico.value : this.neumatico,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
    validado: validado ?? this.validado,
    fotosJson: fotosJson ?? this.fotosJson,
    fecha: fecha ?? this.fecha,
    credAplicadoP1: credAplicadoP1 ?? this.credAplicadoP1,
    credAplicadoP2: credAplicadoP2 ?? this.credAplicadoP2,
  );
  Verificacione copyWithCompanion(VerificacionesCompanion data) {
    return Verificacione(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      cocheCatalogoId: data.cocheCatalogoId.present
          ? data.cocheCatalogoId.value
          : this.cocheCatalogoId,
      pesoInicial: data.pesoInicial.present
          ? data.pesoInicial.value
          : this.pesoInicial,
      pesoFinal: data.pesoFinal.present ? data.pesoFinal.value : this.pesoFinal,
      pesoMin: data.pesoMin.present ? data.pesoMin.value : this.pesoMin,
      pesoInicialCoche: data.pesoInicialCoche.present
          ? data.pesoInicialCoche.value
          : this.pesoInicialCoche,
      pesoFinalCoche: data.pesoFinalCoche.present
          ? data.pesoFinalCoche.value
          : this.pesoFinalCoche,
      motor: data.motor.present ? data.motor.value : this.motor,
      motorTipo: data.motorTipo.present ? data.motorTipo.value : this.motorTipo,
      motorRpm: data.motorRpm.present ? data.motorRpm.value : this.motorRpm,
      motorUms: data.motorUms.present ? data.motorUms.value : this.motorUms,
      pinonMarca: data.pinonMarca.present
          ? data.pinonMarca.value
          : this.pinonMarca,
      pinonDientes: data.pinonDientes.present
          ? data.pinonDientes.value
          : this.pinonDientes,
      coronaMarca: data.coronaMarca.present
          ? data.coronaMarca.value
          : this.coronaMarca,
      coronaDientes: data.coronaDientes.present
          ? data.coronaDientes.value
          : this.coronaDientes,
      llantaDelMarca: data.llantaDelMarca.present
          ? data.llantaDelMarca.value
          : this.llantaDelMarca,
      llantaDelDimension: data.llantaDelDimension.present
          ? data.llantaDelDimension.value
          : this.llantaDelDimension,
      llantaTraMarca: data.llantaTraMarca.present
          ? data.llantaTraMarca.value
          : this.llantaTraMarca,
      llantaTraDimension: data.llantaTraDimension.present
          ? data.llantaTraDimension.value
          : this.llantaTraDimension,
      trencilla: data.trencilla.present ? data.trencilla.value : this.trencilla,
      suspension: data.suspension.present
          ? data.suspension.value
          : this.suspension,
      bancada: data.bancada.present ? data.bancada.value : this.bancada,
      chasis: data.chasis.present ? data.chasis.value : this.chasis,
      neumatico: data.neumatico.present ? data.neumatico.value : this.neumatico,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      validado: data.validado.present ? data.validado.value : this.validado,
      fotosJson: data.fotosJson.present ? data.fotosJson.value : this.fotosJson,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      credAplicadoP1: data.credAplicadoP1.present
          ? data.credAplicadoP1.value
          : this.credAplicadoP1,
      credAplicadoP2: data.credAplicadoP2.present
          ? data.credAplicadoP2.value
          : this.credAplicadoP2,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verificacione(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('equipoId: $equipoId, ')
          ..write('cocheCatalogoId: $cocheCatalogoId, ')
          ..write('pesoInicial: $pesoInicial, ')
          ..write('pesoFinal: $pesoFinal, ')
          ..write('pesoMin: $pesoMin, ')
          ..write('pesoInicialCoche: $pesoInicialCoche, ')
          ..write('pesoFinalCoche: $pesoFinalCoche, ')
          ..write('motor: $motor, ')
          ..write('motorTipo: $motorTipo, ')
          ..write('motorRpm: $motorRpm, ')
          ..write('motorUms: $motorUms, ')
          ..write('pinonMarca: $pinonMarca, ')
          ..write('pinonDientes: $pinonDientes, ')
          ..write('coronaMarca: $coronaMarca, ')
          ..write('coronaDientes: $coronaDientes, ')
          ..write('llantaDelMarca: $llantaDelMarca, ')
          ..write('llantaDelDimension: $llantaDelDimension, ')
          ..write('llantaTraMarca: $llantaTraMarca, ')
          ..write('llantaTraDimension: $llantaTraDimension, ')
          ..write('trencilla: $trencilla, ')
          ..write('suspension: $suspension, ')
          ..write('bancada: $bancada, ')
          ..write('chasis: $chasis, ')
          ..write('neumatico: $neumatico, ')
          ..write('observaciones: $observaciones, ')
          ..write('validado: $validado, ')
          ..write('fotosJson: $fotosJson, ')
          ..write('fecha: $fecha, ')
          ..write('credAplicadoP1: $credAplicadoP1, ')
          ..write('credAplicadoP2: $credAplicadoP2')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    mangaId,
    equipoId,
    cocheCatalogoId,
    pesoInicial,
    pesoFinal,
    pesoMin,
    pesoInicialCoche,
    pesoFinalCoche,
    motor,
    motorTipo,
    motorRpm,
    motorUms,
    pinonMarca,
    pinonDientes,
    coronaMarca,
    coronaDientes,
    llantaDelMarca,
    llantaDelDimension,
    llantaTraMarca,
    llantaTraDimension,
    trencilla,
    suspension,
    bancada,
    chasis,
    neumatico,
    observaciones,
    validado,
    fotosJson,
    fecha,
    credAplicadoP1,
    credAplicadoP2,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verificacione &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.equipoId == this.equipoId &&
          other.cocheCatalogoId == this.cocheCatalogoId &&
          other.pesoInicial == this.pesoInicial &&
          other.pesoFinal == this.pesoFinal &&
          other.pesoMin == this.pesoMin &&
          other.pesoInicialCoche == this.pesoInicialCoche &&
          other.pesoFinalCoche == this.pesoFinalCoche &&
          other.motor == this.motor &&
          other.motorTipo == this.motorTipo &&
          other.motorRpm == this.motorRpm &&
          other.motorUms == this.motorUms &&
          other.pinonMarca == this.pinonMarca &&
          other.pinonDientes == this.pinonDientes &&
          other.coronaMarca == this.coronaMarca &&
          other.coronaDientes == this.coronaDientes &&
          other.llantaDelMarca == this.llantaDelMarca &&
          other.llantaDelDimension == this.llantaDelDimension &&
          other.llantaTraMarca == this.llantaTraMarca &&
          other.llantaTraDimension == this.llantaTraDimension &&
          other.trencilla == this.trencilla &&
          other.suspension == this.suspension &&
          other.bancada == this.bancada &&
          other.chasis == this.chasis &&
          other.neumatico == this.neumatico &&
          other.observaciones == this.observaciones &&
          other.validado == this.validado &&
          other.fotosJson == this.fotosJson &&
          other.fecha == this.fecha &&
          other.credAplicadoP1 == this.credAplicadoP1 &&
          other.credAplicadoP2 == this.credAplicadoP2);
}

class VerificacionesCompanion extends UpdateCompanion<Verificacione> {
  final Value<int> id;
  final Value<int> mangaId;
  final Value<int> equipoId;
  final Value<int?> cocheCatalogoId;
  final Value<double?> pesoInicial;
  final Value<double?> pesoFinal;
  final Value<double?> pesoMin;
  final Value<double?> pesoInicialCoche;
  final Value<double?> pesoFinalCoche;
  final Value<String?> motor;
  final Value<String> motorTipo;
  final Value<int?> motorRpm;
  final Value<double?> motorUms;
  final Value<String?> pinonMarca;
  final Value<int?> pinonDientes;
  final Value<String?> coronaMarca;
  final Value<int?> coronaDientes;
  final Value<String?> llantaDelMarca;
  final Value<String?> llantaDelDimension;
  final Value<String?> llantaTraMarca;
  final Value<String?> llantaTraDimension;
  final Value<String?> trencilla;
  final Value<String?> suspension;
  final Value<String?> bancada;
  final Value<String?> chasis;
  final Value<String?> neumatico;
  final Value<String?> observaciones;
  final Value<bool> validado;
  final Value<String> fotosJson;
  final Value<DateTime> fecha;
  final Value<int> credAplicadoP1;
  final Value<int> credAplicadoP2;
  const VerificacionesCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.cocheCatalogoId = const Value.absent(),
    this.pesoInicial = const Value.absent(),
    this.pesoFinal = const Value.absent(),
    this.pesoMin = const Value.absent(),
    this.pesoInicialCoche = const Value.absent(),
    this.pesoFinalCoche = const Value.absent(),
    this.motor = const Value.absent(),
    this.motorTipo = const Value.absent(),
    this.motorRpm = const Value.absent(),
    this.motorUms = const Value.absent(),
    this.pinonMarca = const Value.absent(),
    this.pinonDientes = const Value.absent(),
    this.coronaMarca = const Value.absent(),
    this.coronaDientes = const Value.absent(),
    this.llantaDelMarca = const Value.absent(),
    this.llantaDelDimension = const Value.absent(),
    this.llantaTraMarca = const Value.absent(),
    this.llantaTraDimension = const Value.absent(),
    this.trencilla = const Value.absent(),
    this.suspension = const Value.absent(),
    this.bancada = const Value.absent(),
    this.chasis = const Value.absent(),
    this.neumatico = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.validado = const Value.absent(),
    this.fotosJson = const Value.absent(),
    this.fecha = const Value.absent(),
    this.credAplicadoP1 = const Value.absent(),
    this.credAplicadoP2 = const Value.absent(),
  });
  VerificacionesCompanion.insert({
    this.id = const Value.absent(),
    required int mangaId,
    required int equipoId,
    this.cocheCatalogoId = const Value.absent(),
    this.pesoInicial = const Value.absent(),
    this.pesoFinal = const Value.absent(),
    this.pesoMin = const Value.absent(),
    this.pesoInicialCoche = const Value.absent(),
    this.pesoFinalCoche = const Value.absent(),
    this.motor = const Value.absent(),
    this.motorTipo = const Value.absent(),
    this.motorRpm = const Value.absent(),
    this.motorUms = const Value.absent(),
    this.pinonMarca = const Value.absent(),
    this.pinonDientes = const Value.absent(),
    this.coronaMarca = const Value.absent(),
    this.coronaDientes = const Value.absent(),
    this.llantaDelMarca = const Value.absent(),
    this.llantaDelDimension = const Value.absent(),
    this.llantaTraMarca = const Value.absent(),
    this.llantaTraDimension = const Value.absent(),
    this.trencilla = const Value.absent(),
    this.suspension = const Value.absent(),
    this.bancada = const Value.absent(),
    this.chasis = const Value.absent(),
    this.neumatico = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.validado = const Value.absent(),
    this.fotosJson = const Value.absent(),
    this.fecha = const Value.absent(),
    this.credAplicadoP1 = const Value.absent(),
    this.credAplicadoP2 = const Value.absent(),
  }) : mangaId = Value(mangaId),
       equipoId = Value(equipoId);
  static Insertable<Verificacione> custom({
    Expression<int>? id,
    Expression<int>? mangaId,
    Expression<int>? equipoId,
    Expression<int>? cocheCatalogoId,
    Expression<double>? pesoInicial,
    Expression<double>? pesoFinal,
    Expression<double>? pesoMin,
    Expression<double>? pesoInicialCoche,
    Expression<double>? pesoFinalCoche,
    Expression<String>? motor,
    Expression<String>? motorTipo,
    Expression<int>? motorRpm,
    Expression<double>? motorUms,
    Expression<String>? pinonMarca,
    Expression<int>? pinonDientes,
    Expression<String>? coronaMarca,
    Expression<int>? coronaDientes,
    Expression<String>? llantaDelMarca,
    Expression<String>? llantaDelDimension,
    Expression<String>? llantaTraMarca,
    Expression<String>? llantaTraDimension,
    Expression<String>? trencilla,
    Expression<String>? suspension,
    Expression<String>? bancada,
    Expression<String>? chasis,
    Expression<String>? neumatico,
    Expression<String>? observaciones,
    Expression<bool>? validado,
    Expression<String>? fotosJson,
    Expression<DateTime>? fecha,
    Expression<int>? credAplicadoP1,
    Expression<int>? credAplicadoP2,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (equipoId != null) 'equipo_id': equipoId,
      if (cocheCatalogoId != null) 'coche_catalogo_id': cocheCatalogoId,
      if (pesoInicial != null) 'peso_inicial': pesoInicial,
      if (pesoFinal != null) 'peso_final': pesoFinal,
      if (pesoMin != null) 'peso_min': pesoMin,
      if (pesoInicialCoche != null) 'peso_inicial_coche': pesoInicialCoche,
      if (pesoFinalCoche != null) 'peso_final_coche': pesoFinalCoche,
      if (motor != null) 'motor': motor,
      if (motorTipo != null) 'motor_tipo': motorTipo,
      if (motorRpm != null) 'motor_rpm': motorRpm,
      if (motorUms != null) 'motor_ums': motorUms,
      if (pinonMarca != null) 'pinon_marca': pinonMarca,
      if (pinonDientes != null) 'pinon_dientes': pinonDientes,
      if (coronaMarca != null) 'corona_marca': coronaMarca,
      if (coronaDientes != null) 'corona_dientes': coronaDientes,
      if (llantaDelMarca != null) 'llanta_del_marca': llantaDelMarca,
      if (llantaDelDimension != null)
        'llanta_del_dimension': llantaDelDimension,
      if (llantaTraMarca != null) 'llanta_tra_marca': llantaTraMarca,
      if (llantaTraDimension != null)
        'llanta_tra_dimension': llantaTraDimension,
      if (trencilla != null) 'trencilla': trencilla,
      if (suspension != null) 'suspension': suspension,
      if (bancada != null) 'bancada': bancada,
      if (chasis != null) 'chasis': chasis,
      if (neumatico != null) 'neumatico': neumatico,
      if (observaciones != null) 'observaciones': observaciones,
      if (validado != null) 'validado': validado,
      if (fotosJson != null) 'fotos_json': fotosJson,
      if (fecha != null) 'fecha': fecha,
      if (credAplicadoP1 != null) 'cred_aplicado_p1': credAplicadoP1,
      if (credAplicadoP2 != null) 'cred_aplicado_p2': credAplicadoP2,
    });
  }

  VerificacionesCompanion copyWith({
    Value<int>? id,
    Value<int>? mangaId,
    Value<int>? equipoId,
    Value<int?>? cocheCatalogoId,
    Value<double?>? pesoInicial,
    Value<double?>? pesoFinal,
    Value<double?>? pesoMin,
    Value<double?>? pesoInicialCoche,
    Value<double?>? pesoFinalCoche,
    Value<String?>? motor,
    Value<String>? motorTipo,
    Value<int?>? motorRpm,
    Value<double?>? motorUms,
    Value<String?>? pinonMarca,
    Value<int?>? pinonDientes,
    Value<String?>? coronaMarca,
    Value<int?>? coronaDientes,
    Value<String?>? llantaDelMarca,
    Value<String?>? llantaDelDimension,
    Value<String?>? llantaTraMarca,
    Value<String?>? llantaTraDimension,
    Value<String?>? trencilla,
    Value<String?>? suspension,
    Value<String?>? bancada,
    Value<String?>? chasis,
    Value<String?>? neumatico,
    Value<String?>? observaciones,
    Value<bool>? validado,
    Value<String>? fotosJson,
    Value<DateTime>? fecha,
    Value<int>? credAplicadoP1,
    Value<int>? credAplicadoP2,
  }) {
    return VerificacionesCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      equipoId: equipoId ?? this.equipoId,
      cocheCatalogoId: cocheCatalogoId ?? this.cocheCatalogoId,
      pesoInicial: pesoInicial ?? this.pesoInicial,
      pesoFinal: pesoFinal ?? this.pesoFinal,
      pesoMin: pesoMin ?? this.pesoMin,
      pesoInicialCoche: pesoInicialCoche ?? this.pesoInicialCoche,
      pesoFinalCoche: pesoFinalCoche ?? this.pesoFinalCoche,
      motor: motor ?? this.motor,
      motorTipo: motorTipo ?? this.motorTipo,
      motorRpm: motorRpm ?? this.motorRpm,
      motorUms: motorUms ?? this.motorUms,
      pinonMarca: pinonMarca ?? this.pinonMarca,
      pinonDientes: pinonDientes ?? this.pinonDientes,
      coronaMarca: coronaMarca ?? this.coronaMarca,
      coronaDientes: coronaDientes ?? this.coronaDientes,
      llantaDelMarca: llantaDelMarca ?? this.llantaDelMarca,
      llantaDelDimension: llantaDelDimension ?? this.llantaDelDimension,
      llantaTraMarca: llantaTraMarca ?? this.llantaTraMarca,
      llantaTraDimension: llantaTraDimension ?? this.llantaTraDimension,
      trencilla: trencilla ?? this.trencilla,
      suspension: suspension ?? this.suspension,
      bancada: bancada ?? this.bancada,
      chasis: chasis ?? this.chasis,
      neumatico: neumatico ?? this.neumatico,
      observaciones: observaciones ?? this.observaciones,
      validado: validado ?? this.validado,
      fotosJson: fotosJson ?? this.fotosJson,
      fecha: fecha ?? this.fecha,
      credAplicadoP1: credAplicadoP1 ?? this.credAplicadoP1,
      credAplicadoP2: credAplicadoP2 ?? this.credAplicadoP2,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<int>(mangaId.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (cocheCatalogoId.present) {
      map['coche_catalogo_id'] = Variable<int>(cocheCatalogoId.value);
    }
    if (pesoInicial.present) {
      map['peso_inicial'] = Variable<double>(pesoInicial.value);
    }
    if (pesoFinal.present) {
      map['peso_final'] = Variable<double>(pesoFinal.value);
    }
    if (pesoMin.present) {
      map['peso_min'] = Variable<double>(pesoMin.value);
    }
    if (pesoInicialCoche.present) {
      map['peso_inicial_coche'] = Variable<double>(pesoInicialCoche.value);
    }
    if (pesoFinalCoche.present) {
      map['peso_final_coche'] = Variable<double>(pesoFinalCoche.value);
    }
    if (motor.present) {
      map['motor'] = Variable<String>(motor.value);
    }
    if (motorTipo.present) {
      map['motor_tipo'] = Variable<String>(motorTipo.value);
    }
    if (motorRpm.present) {
      map['motor_rpm'] = Variable<int>(motorRpm.value);
    }
    if (motorUms.present) {
      map['motor_ums'] = Variable<double>(motorUms.value);
    }
    if (pinonMarca.present) {
      map['pinon_marca'] = Variable<String>(pinonMarca.value);
    }
    if (pinonDientes.present) {
      map['pinon_dientes'] = Variable<int>(pinonDientes.value);
    }
    if (coronaMarca.present) {
      map['corona_marca'] = Variable<String>(coronaMarca.value);
    }
    if (coronaDientes.present) {
      map['corona_dientes'] = Variable<int>(coronaDientes.value);
    }
    if (llantaDelMarca.present) {
      map['llanta_del_marca'] = Variable<String>(llantaDelMarca.value);
    }
    if (llantaDelDimension.present) {
      map['llanta_del_dimension'] = Variable<String>(llantaDelDimension.value);
    }
    if (llantaTraMarca.present) {
      map['llanta_tra_marca'] = Variable<String>(llantaTraMarca.value);
    }
    if (llantaTraDimension.present) {
      map['llanta_tra_dimension'] = Variable<String>(llantaTraDimension.value);
    }
    if (trencilla.present) {
      map['trencilla'] = Variable<String>(trencilla.value);
    }
    if (suspension.present) {
      map['suspension'] = Variable<String>(suspension.value);
    }
    if (bancada.present) {
      map['bancada'] = Variable<String>(bancada.value);
    }
    if (chasis.present) {
      map['chasis'] = Variable<String>(chasis.value);
    }
    if (neumatico.present) {
      map['neumatico'] = Variable<String>(neumatico.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (validado.present) {
      map['validado'] = Variable<bool>(validado.value);
    }
    if (fotosJson.present) {
      map['fotos_json'] = Variable<String>(fotosJson.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (credAplicadoP1.present) {
      map['cred_aplicado_p1'] = Variable<int>(credAplicadoP1.value);
    }
    if (credAplicadoP2.present) {
      map['cred_aplicado_p2'] = Variable<int>(credAplicadoP2.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerificacionesCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('equipoId: $equipoId, ')
          ..write('cocheCatalogoId: $cocheCatalogoId, ')
          ..write('pesoInicial: $pesoInicial, ')
          ..write('pesoFinal: $pesoFinal, ')
          ..write('pesoMin: $pesoMin, ')
          ..write('pesoInicialCoche: $pesoInicialCoche, ')
          ..write('pesoFinalCoche: $pesoFinalCoche, ')
          ..write('motor: $motor, ')
          ..write('motorTipo: $motorTipo, ')
          ..write('motorRpm: $motorRpm, ')
          ..write('motorUms: $motorUms, ')
          ..write('pinonMarca: $pinonMarca, ')
          ..write('pinonDientes: $pinonDientes, ')
          ..write('coronaMarca: $coronaMarca, ')
          ..write('coronaDientes: $coronaDientes, ')
          ..write('llantaDelMarca: $llantaDelMarca, ')
          ..write('llantaDelDimension: $llantaDelDimension, ')
          ..write('llantaTraMarca: $llantaTraMarca, ')
          ..write('llantaTraDimension: $llantaTraDimension, ')
          ..write('trencilla: $trencilla, ')
          ..write('suspension: $suspension, ')
          ..write('bancada: $bancada, ')
          ..write('chasis: $chasis, ')
          ..write('neumatico: $neumatico, ')
          ..write('observaciones: $observaciones, ')
          ..write('validado: $validado, ')
          ..write('fotosJson: $fotosJson, ')
          ..write('fecha: $fecha, ')
          ..write('credAplicadoP1: $credAplicadoP1, ')
          ..write('credAplicadoP2: $credAplicadoP2')
          ..write(')'))
        .toString();
  }
}

class $PagosTable extends Pagos with TableInfo<$PagosTable, Pago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pruebaIdMeta = const VerificationMeta(
    'pruebaId',
  );
  @override
  late final GeneratedColumn<int> pruebaId = GeneratedColumn<int>(
    'prueba_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pruebas (id)',
    ),
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
    'equipo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipos (id)',
    ),
  );
  static const VerificationMeta _pagatMeta = const VerificationMeta('pagat');
  @override
  late final GeneratedColumn<double> pagat = GeneratedColumn<double>(
    'pagat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _coordinadoraMeta = const VerificationMeta(
    'coordinadora',
  );
  @override
  late final GeneratedColumn<double> coordinadora = GeneratedColumn<double>(
    'coordinadora',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _clubMeta = const VerificationMeta('club');
  @override
  late final GeneratedColumn<double> club = GeneratedColumn<double>(
    'club',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pruebaId,
    equipoId,
    pagat,
    coordinadora,
    club,
    fecha,
    observaciones,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pagos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pago> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prueba_id')) {
      context.handle(
        _pruebaIdMeta,
        pruebaId.isAcceptableOrUnknown(data['prueba_id']!, _pruebaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pruebaIdMeta);
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('pagat')) {
      context.handle(
        _pagatMeta,
        pagat.isAcceptableOrUnknown(data['pagat']!, _pagatMeta),
      );
    }
    if (data.containsKey('coordinadora')) {
      context.handle(
        _coordinadoraMeta,
        coordinadora.isAcceptableOrUnknown(
          data['coordinadora']!,
          _coordinadoraMeta,
        ),
      );
    }
    if (data.containsKey('club')) {
      context.handle(
        _clubMeta,
        club.isAcceptableOrUnknown(data['club']!, _clubMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pago(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pruebaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prueba_id'],
      )!,
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipo_id'],
      )!,
      pagat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pagat'],
      )!,
      coordinadora: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}coordinadora'],
      )!,
      club: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}club'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
    );
  }

  @override
  $PagosTable createAlias(String alias) {
    return $PagosTable(attachedDatabase, alias);
  }
}

class Pago extends DataClass implements Insertable<Pago> {
  final int id;
  final int pruebaId;
  final int equipoId;
  final double pagat;
  final double coordinadora;
  final double club;
  final DateTime fecha;
  final String? observaciones;
  const Pago({
    required this.id,
    required this.pruebaId,
    required this.equipoId,
    required this.pagat,
    required this.coordinadora,
    required this.club,
    required this.fecha,
    this.observaciones,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prueba_id'] = Variable<int>(pruebaId);
    map['equipo_id'] = Variable<int>(equipoId);
    map['pagat'] = Variable<double>(pagat);
    map['coordinadora'] = Variable<double>(coordinadora);
    map['club'] = Variable<double>(club);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    return map;
  }

  PagosCompanion toCompanion(bool nullToAbsent) {
    return PagosCompanion(
      id: Value(id),
      pruebaId: Value(pruebaId),
      equipoId: Value(equipoId),
      pagat: Value(pagat),
      coordinadora: Value(coordinadora),
      club: Value(club),
      fecha: Value(fecha),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
    );
  }

  factory Pago.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pago(
      id: serializer.fromJson<int>(json['id']),
      pruebaId: serializer.fromJson<int>(json['pruebaId']),
      equipoId: serializer.fromJson<int>(json['equipoId']),
      pagat: serializer.fromJson<double>(json['pagat']),
      coordinadora: serializer.fromJson<double>(json['coordinadora']),
      club: serializer.fromJson<double>(json['club']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pruebaId': serializer.toJson<int>(pruebaId),
      'equipoId': serializer.toJson<int>(equipoId),
      'pagat': serializer.toJson<double>(pagat),
      'coordinadora': serializer.toJson<double>(coordinadora),
      'club': serializer.toJson<double>(club),
      'fecha': serializer.toJson<DateTime>(fecha),
      'observaciones': serializer.toJson<String?>(observaciones),
    };
  }

  Pago copyWith({
    int? id,
    int? pruebaId,
    int? equipoId,
    double? pagat,
    double? coordinadora,
    double? club,
    DateTime? fecha,
    Value<String?> observaciones = const Value.absent(),
  }) => Pago(
    id: id ?? this.id,
    pruebaId: pruebaId ?? this.pruebaId,
    equipoId: equipoId ?? this.equipoId,
    pagat: pagat ?? this.pagat,
    coordinadora: coordinadora ?? this.coordinadora,
    club: club ?? this.club,
    fecha: fecha ?? this.fecha,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
  );
  Pago copyWithCompanion(PagosCompanion data) {
    return Pago(
      id: data.id.present ? data.id.value : this.id,
      pruebaId: data.pruebaId.present ? data.pruebaId.value : this.pruebaId,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      pagat: data.pagat.present ? data.pagat.value : this.pagat,
      coordinadora: data.coordinadora.present
          ? data.coordinadora.value
          : this.coordinadora,
      club: data.club.present ? data.club.value : this.club,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pago(')
          ..write('id: $id, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('equipoId: $equipoId, ')
          ..write('pagat: $pagat, ')
          ..write('coordinadora: $coordinadora, ')
          ..write('club: $club, ')
          ..write('fecha: $fecha, ')
          ..write('observaciones: $observaciones')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pruebaId,
    equipoId,
    pagat,
    coordinadora,
    club,
    fecha,
    observaciones,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pago &&
          other.id == this.id &&
          other.pruebaId == this.pruebaId &&
          other.equipoId == this.equipoId &&
          other.pagat == this.pagat &&
          other.coordinadora == this.coordinadora &&
          other.club == this.club &&
          other.fecha == this.fecha &&
          other.observaciones == this.observaciones);
}

class PagosCompanion extends UpdateCompanion<Pago> {
  final Value<int> id;
  final Value<int> pruebaId;
  final Value<int> equipoId;
  final Value<double> pagat;
  final Value<double> coordinadora;
  final Value<double> club;
  final Value<DateTime> fecha;
  final Value<String?> observaciones;
  const PagosCompanion({
    this.id = const Value.absent(),
    this.pruebaId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.pagat = const Value.absent(),
    this.coordinadora = const Value.absent(),
    this.club = const Value.absent(),
    this.fecha = const Value.absent(),
    this.observaciones = const Value.absent(),
  });
  PagosCompanion.insert({
    this.id = const Value.absent(),
    required int pruebaId,
    required int equipoId,
    this.pagat = const Value.absent(),
    this.coordinadora = const Value.absent(),
    this.club = const Value.absent(),
    this.fecha = const Value.absent(),
    this.observaciones = const Value.absent(),
  }) : pruebaId = Value(pruebaId),
       equipoId = Value(equipoId);
  static Insertable<Pago> custom({
    Expression<int>? id,
    Expression<int>? pruebaId,
    Expression<int>? equipoId,
    Expression<double>? pagat,
    Expression<double>? coordinadora,
    Expression<double>? club,
    Expression<DateTime>? fecha,
    Expression<String>? observaciones,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pruebaId != null) 'prueba_id': pruebaId,
      if (equipoId != null) 'equipo_id': equipoId,
      if (pagat != null) 'pagat': pagat,
      if (coordinadora != null) 'coordinadora': coordinadora,
      if (club != null) 'club': club,
      if (fecha != null) 'fecha': fecha,
      if (observaciones != null) 'observaciones': observaciones,
    });
  }

  PagosCompanion copyWith({
    Value<int>? id,
    Value<int>? pruebaId,
    Value<int>? equipoId,
    Value<double>? pagat,
    Value<double>? coordinadora,
    Value<double>? club,
    Value<DateTime>? fecha,
    Value<String?>? observaciones,
  }) {
    return PagosCompanion(
      id: id ?? this.id,
      pruebaId: pruebaId ?? this.pruebaId,
      equipoId: equipoId ?? this.equipoId,
      pagat: pagat ?? this.pagat,
      coordinadora: coordinadora ?? this.coordinadora,
      club: club ?? this.club,
      fecha: fecha ?? this.fecha,
      observaciones: observaciones ?? this.observaciones,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pruebaId.present) {
      map['prueba_id'] = Variable<int>(pruebaId.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (pagat.present) {
      map['pagat'] = Variable<double>(pagat.value);
    }
    if (coordinadora.present) {
      map['coordinadora'] = Variable<double>(coordinadora.value);
    }
    if (club.present) {
      map['club'] = Variable<double>(club.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagosCompanion(')
          ..write('id: $id, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('equipoId: $equipoId, ')
          ..write('pagat: $pagat, ')
          ..write('coordinadora: $coordinadora, ')
          ..write('club: $club, ')
          ..write('fecha: $fecha, ')
          ..write('observaciones: $observaciones')
          ..write(')'))
        .toString();
  }
}

class $MovimientosTesoreriaTable extends MovimientosTesoreria
    with TableInfo<$MovimientosTesoreriaTable, MovimientosTesoreriaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTesoreriaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campeonatos (id)',
    ),
  );
  static const VerificationMeta _pruebaIdMeta = const VerificationMeta(
    'pruebaId',
  );
  @override
  late final GeneratedColumn<int> pruebaId = GeneratedColumn<int>(
    'prueba_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pruebas (id)',
    ),
  );
  static const VerificationMeta _conceptoMeta = const VerificationMeta(
    'concepto',
  );
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
    'concepto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importeMeta = const VerificationMeta(
    'importe',
  );
  @override
  late final GeneratedColumn<double> importe = GeneratedColumn<double>(
    'importe',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    campeonatoId,
    pruebaId,
    concepto,
    importe,
    fecha,
    notas,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos_tesoreria';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientosTesoreriaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campeonatoIdMeta);
    }
    if (data.containsKey('prueba_id')) {
      context.handle(
        _pruebaIdMeta,
        pruebaId.isAcceptableOrUnknown(data['prueba_id']!, _pruebaIdMeta),
      );
    }
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptoMeta);
    }
    if (data.containsKey('importe')) {
      context.handle(
        _importeMeta,
        importe.isAcceptableOrUnknown(data['importe']!, _importeMeta),
      );
    } else if (isInserting) {
      context.missing(_importeMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientosTesoreriaData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientosTesoreriaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      )!,
      pruebaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prueba_id'],
      ),
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      )!,
      importe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importe'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
    );
  }

  @override
  $MovimientosTesoreriaTable createAlias(String alias) {
    return $MovimientosTesoreriaTable(attachedDatabase, alias);
  }
}

class MovimientosTesoreriaData extends DataClass
    implements Insertable<MovimientosTesoreriaData> {
  final int id;
  final int campeonatoId;
  final int? pruebaId;
  final String concepto;
  final double importe;
  final DateTime fecha;
  final String? notas;
  const MovimientosTesoreriaData({
    required this.id,
    required this.campeonatoId,
    this.pruebaId,
    required this.concepto,
    required this.importe,
    required this.fecha,
    this.notas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['campeonato_id'] = Variable<int>(campeonatoId);
    if (!nullToAbsent || pruebaId != null) {
      map['prueba_id'] = Variable<int>(pruebaId);
    }
    map['concepto'] = Variable<String>(concepto);
    map['importe'] = Variable<double>(importe);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    return map;
  }

  MovimientosTesoreriaCompanion toCompanion(bool nullToAbsent) {
    return MovimientosTesoreriaCompanion(
      id: Value(id),
      campeonatoId: Value(campeonatoId),
      pruebaId: pruebaId == null && nullToAbsent
          ? const Value.absent()
          : Value(pruebaId),
      concepto: Value(concepto),
      importe: Value(importe),
      fecha: Value(fecha),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
    );
  }

  factory MovimientosTesoreriaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientosTesoreriaData(
      id: serializer.fromJson<int>(json['id']),
      campeonatoId: serializer.fromJson<int>(json['campeonatoId']),
      pruebaId: serializer.fromJson<int?>(json['pruebaId']),
      concepto: serializer.fromJson<String>(json['concepto']),
      importe: serializer.fromJson<double>(json['importe']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      notas: serializer.fromJson<String?>(json['notas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'campeonatoId': serializer.toJson<int>(campeonatoId),
      'pruebaId': serializer.toJson<int?>(pruebaId),
      'concepto': serializer.toJson<String>(concepto),
      'importe': serializer.toJson<double>(importe),
      'fecha': serializer.toJson<DateTime>(fecha),
      'notas': serializer.toJson<String?>(notas),
    };
  }

  MovimientosTesoreriaData copyWith({
    int? id,
    int? campeonatoId,
    Value<int?> pruebaId = const Value.absent(),
    String? concepto,
    double? importe,
    DateTime? fecha,
    Value<String?> notas = const Value.absent(),
  }) => MovimientosTesoreriaData(
    id: id ?? this.id,
    campeonatoId: campeonatoId ?? this.campeonatoId,
    pruebaId: pruebaId.present ? pruebaId.value : this.pruebaId,
    concepto: concepto ?? this.concepto,
    importe: importe ?? this.importe,
    fecha: fecha ?? this.fecha,
    notas: notas.present ? notas.value : this.notas,
  );
  MovimientosTesoreriaData copyWithCompanion(
    MovimientosTesoreriaCompanion data,
  ) {
    return MovimientosTesoreriaData(
      id: data.id.present ? data.id.value : this.id,
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      pruebaId: data.pruebaId.present ? data.pruebaId.value : this.pruebaId,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      importe: data.importe.present ? data.importe.value : this.importe,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      notas: data.notas.present ? data.notas.value : this.notas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosTesoreriaData(')
          ..write('id: $id, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('concepto: $concepto, ')
          ..write('importe: $importe, ')
          ..write('fecha: $fecha, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, campeonatoId, pruebaId, concepto, importe, fecha, notas);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientosTesoreriaData &&
          other.id == this.id &&
          other.campeonatoId == this.campeonatoId &&
          other.pruebaId == this.pruebaId &&
          other.concepto == this.concepto &&
          other.importe == this.importe &&
          other.fecha == this.fecha &&
          other.notas == this.notas);
}

class MovimientosTesoreriaCompanion
    extends UpdateCompanion<MovimientosTesoreriaData> {
  final Value<int> id;
  final Value<int> campeonatoId;
  final Value<int?> pruebaId;
  final Value<String> concepto;
  final Value<double> importe;
  final Value<DateTime> fecha;
  final Value<String?> notas;
  const MovimientosTesoreriaCompanion({
    this.id = const Value.absent(),
    this.campeonatoId = const Value.absent(),
    this.pruebaId = const Value.absent(),
    this.concepto = const Value.absent(),
    this.importe = const Value.absent(),
    this.fecha = const Value.absent(),
    this.notas = const Value.absent(),
  });
  MovimientosTesoreriaCompanion.insert({
    this.id = const Value.absent(),
    required int campeonatoId,
    this.pruebaId = const Value.absent(),
    required String concepto,
    required double importe,
    this.fecha = const Value.absent(),
    this.notas = const Value.absent(),
  }) : campeonatoId = Value(campeonatoId),
       concepto = Value(concepto),
       importe = Value(importe);
  static Insertable<MovimientosTesoreriaData> custom({
    Expression<int>? id,
    Expression<int>? campeonatoId,
    Expression<int>? pruebaId,
    Expression<String>? concepto,
    Expression<double>? importe,
    Expression<DateTime>? fecha,
    Expression<String>? notas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (pruebaId != null) 'prueba_id': pruebaId,
      if (concepto != null) 'concepto': concepto,
      if (importe != null) 'importe': importe,
      if (fecha != null) 'fecha': fecha,
      if (notas != null) 'notas': notas,
    });
  }

  MovimientosTesoreriaCompanion copyWith({
    Value<int>? id,
    Value<int>? campeonatoId,
    Value<int?>? pruebaId,
    Value<String>? concepto,
    Value<double>? importe,
    Value<DateTime>? fecha,
    Value<String?>? notas,
  }) {
    return MovimientosTesoreriaCompanion(
      id: id ?? this.id,
      campeonatoId: campeonatoId ?? this.campeonatoId,
      pruebaId: pruebaId ?? this.pruebaId,
      concepto: concepto ?? this.concepto,
      importe: importe ?? this.importe,
      fecha: fecha ?? this.fecha,
      notas: notas ?? this.notas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (pruebaId.present) {
      map['prueba_id'] = Variable<int>(pruebaId.value);
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (importe.present) {
      map['importe'] = Variable<double>(importe.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosTesoreriaCompanion(')
          ..write('id: $id, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('concepto: $concepto, ')
          ..write('importe: $importe, ')
          ..write('fecha: $fecha, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }
}

class $MovimientosCreditosTable extends MovimientosCreditos
    with TableInfo<$MovimientosCreditosTable, MovimientosCredito> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosCreditosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pilotoIdMeta = const VerificationMeta(
    'pilotoId',
  );
  @override
  late final GeneratedColumn<int> pilotoId = GeneratedColumn<int>(
    'piloto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pilotos (id)',
    ),
  );
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campeonatos (id)',
    ),
  );
  static const VerificationMeta _verificacionIdMeta = const VerificationMeta(
    'verificacionId',
  );
  @override
  late final GeneratedColumn<int> verificacionId = GeneratedColumn<int>(
    'verificacion_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES verificaciones (id)',
    ),
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
    'equipo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipos (id)',
    ),
  );
  static const VerificationMeta _pruebaIdMeta = const VerificationMeta(
    'pruebaId',
  );
  @override
  late final GeneratedColumn<int> pruebaId = GeneratedColumn<int>(
    'prueba_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pruebas (id)',
    ),
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoResultanteMeta = const VerificationMeta(
    'saldoResultante',
  );
  @override
  late final GeneratedColumn<int> saldoResultante = GeneratedColumn<int>(
    'saldo_resultante',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
    'motivo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pilotoId,
    campeonatoId,
    verificacionId,
    equipoId,
    pruebaId,
    delta,
    saldoResultante,
    motivo,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos_creditos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientosCredito> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('piloto_id')) {
      context.handle(
        _pilotoIdMeta,
        pilotoId.isAcceptableOrUnknown(data['piloto_id']!, _pilotoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pilotoIdMeta);
    }
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campeonatoIdMeta);
    }
    if (data.containsKey('verificacion_id')) {
      context.handle(
        _verificacionIdMeta,
        verificacionId.isAcceptableOrUnknown(
          data['verificacion_id']!,
          _verificacionIdMeta,
        ),
      );
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    }
    if (data.containsKey('prueba_id')) {
      context.handle(
        _pruebaIdMeta,
        pruebaId.isAcceptableOrUnknown(data['prueba_id']!, _pruebaIdMeta),
      );
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('saldo_resultante')) {
      context.handle(
        _saldoResultanteMeta,
        saldoResultante.isAcceptableOrUnknown(
          data['saldo_resultante']!,
          _saldoResultanteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saldoResultanteMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(
        _motivoMeta,
        motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta),
      );
    } else if (isInserting) {
      context.missing(_motivoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientosCredito map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientosCredito(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pilotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piloto_id'],
      )!,
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      )!,
      verificacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verificacion_id'],
      ),
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipo_id'],
      ),
      pruebaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prueba_id'],
      ),
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta'],
      )!,
      saldoResultante: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saldo_resultante'],
      )!,
      motivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  $MovimientosCreditosTable createAlias(String alias) {
    return $MovimientosCreditosTable(attachedDatabase, alias);
  }
}

class MovimientosCredito extends DataClass
    implements Insertable<MovimientosCredito> {
  final int id;
  final int pilotoId;
  final int campeonatoId;
  final int? verificacionId;
  final int? equipoId;
  final int? pruebaId;
  final int delta;

  /// Saldo del piloto justo después del movimiento (snapshot).
  final int saldoResultante;
  final String motivo;
  final DateTime fecha;
  const MovimientosCredito({
    required this.id,
    required this.pilotoId,
    required this.campeonatoId,
    this.verificacionId,
    this.equipoId,
    this.pruebaId,
    required this.delta,
    required this.saldoResultante,
    required this.motivo,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['piloto_id'] = Variable<int>(pilotoId);
    map['campeonato_id'] = Variable<int>(campeonatoId);
    if (!nullToAbsent || verificacionId != null) {
      map['verificacion_id'] = Variable<int>(verificacionId);
    }
    if (!nullToAbsent || equipoId != null) {
      map['equipo_id'] = Variable<int>(equipoId);
    }
    if (!nullToAbsent || pruebaId != null) {
      map['prueba_id'] = Variable<int>(pruebaId);
    }
    map['delta'] = Variable<int>(delta);
    map['saldo_resultante'] = Variable<int>(saldoResultante);
    map['motivo'] = Variable<String>(motivo);
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  MovimientosCreditosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCreditosCompanion(
      id: Value(id),
      pilotoId: Value(pilotoId),
      campeonatoId: Value(campeonatoId),
      verificacionId: verificacionId == null && nullToAbsent
          ? const Value.absent()
          : Value(verificacionId),
      equipoId: equipoId == null && nullToAbsent
          ? const Value.absent()
          : Value(equipoId),
      pruebaId: pruebaId == null && nullToAbsent
          ? const Value.absent()
          : Value(pruebaId),
      delta: Value(delta),
      saldoResultante: Value(saldoResultante),
      motivo: Value(motivo),
      fecha: Value(fecha),
    );
  }

  factory MovimientosCredito.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientosCredito(
      id: serializer.fromJson<int>(json['id']),
      pilotoId: serializer.fromJson<int>(json['pilotoId']),
      campeonatoId: serializer.fromJson<int>(json['campeonatoId']),
      verificacionId: serializer.fromJson<int?>(json['verificacionId']),
      equipoId: serializer.fromJson<int?>(json['equipoId']),
      pruebaId: serializer.fromJson<int?>(json['pruebaId']),
      delta: serializer.fromJson<int>(json['delta']),
      saldoResultante: serializer.fromJson<int>(json['saldoResultante']),
      motivo: serializer.fromJson<String>(json['motivo']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pilotoId': serializer.toJson<int>(pilotoId),
      'campeonatoId': serializer.toJson<int>(campeonatoId),
      'verificacionId': serializer.toJson<int?>(verificacionId),
      'equipoId': serializer.toJson<int?>(equipoId),
      'pruebaId': serializer.toJson<int?>(pruebaId),
      'delta': serializer.toJson<int>(delta),
      'saldoResultante': serializer.toJson<int>(saldoResultante),
      'motivo': serializer.toJson<String>(motivo),
      'fecha': serializer.toJson<DateTime>(fecha),
    };
  }

  MovimientosCredito copyWith({
    int? id,
    int? pilotoId,
    int? campeonatoId,
    Value<int?> verificacionId = const Value.absent(),
    Value<int?> equipoId = const Value.absent(),
    Value<int?> pruebaId = const Value.absent(),
    int? delta,
    int? saldoResultante,
    String? motivo,
    DateTime? fecha,
  }) => MovimientosCredito(
    id: id ?? this.id,
    pilotoId: pilotoId ?? this.pilotoId,
    campeonatoId: campeonatoId ?? this.campeonatoId,
    verificacionId: verificacionId.present
        ? verificacionId.value
        : this.verificacionId,
    equipoId: equipoId.present ? equipoId.value : this.equipoId,
    pruebaId: pruebaId.present ? pruebaId.value : this.pruebaId,
    delta: delta ?? this.delta,
    saldoResultante: saldoResultante ?? this.saldoResultante,
    motivo: motivo ?? this.motivo,
    fecha: fecha ?? this.fecha,
  );
  MovimientosCredito copyWithCompanion(MovimientosCreditosCompanion data) {
    return MovimientosCredito(
      id: data.id.present ? data.id.value : this.id,
      pilotoId: data.pilotoId.present ? data.pilotoId.value : this.pilotoId,
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      verificacionId: data.verificacionId.present
          ? data.verificacionId.value
          : this.verificacionId,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      pruebaId: data.pruebaId.present ? data.pruebaId.value : this.pruebaId,
      delta: data.delta.present ? data.delta.value : this.delta,
      saldoResultante: data.saldoResultante.present
          ? data.saldoResultante.value
          : this.saldoResultante,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCredito(')
          ..write('id: $id, ')
          ..write('pilotoId: $pilotoId, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('verificacionId: $verificacionId, ')
          ..write('equipoId: $equipoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('delta: $delta, ')
          ..write('saldoResultante: $saldoResultante, ')
          ..write('motivo: $motivo, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pilotoId,
    campeonatoId,
    verificacionId,
    equipoId,
    pruebaId,
    delta,
    saldoResultante,
    motivo,
    fecha,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientosCredito &&
          other.id == this.id &&
          other.pilotoId == this.pilotoId &&
          other.campeonatoId == this.campeonatoId &&
          other.verificacionId == this.verificacionId &&
          other.equipoId == this.equipoId &&
          other.pruebaId == this.pruebaId &&
          other.delta == this.delta &&
          other.saldoResultante == this.saldoResultante &&
          other.motivo == this.motivo &&
          other.fecha == this.fecha);
}

class MovimientosCreditosCompanion extends UpdateCompanion<MovimientosCredito> {
  final Value<int> id;
  final Value<int> pilotoId;
  final Value<int> campeonatoId;
  final Value<int?> verificacionId;
  final Value<int?> equipoId;
  final Value<int?> pruebaId;
  final Value<int> delta;
  final Value<int> saldoResultante;
  final Value<String> motivo;
  final Value<DateTime> fecha;
  const MovimientosCreditosCompanion({
    this.id = const Value.absent(),
    this.pilotoId = const Value.absent(),
    this.campeonatoId = const Value.absent(),
    this.verificacionId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.pruebaId = const Value.absent(),
    this.delta = const Value.absent(),
    this.saldoResultante = const Value.absent(),
    this.motivo = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  MovimientosCreditosCompanion.insert({
    this.id = const Value.absent(),
    required int pilotoId,
    required int campeonatoId,
    this.verificacionId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.pruebaId = const Value.absent(),
    required int delta,
    required int saldoResultante,
    required String motivo,
    this.fecha = const Value.absent(),
  }) : pilotoId = Value(pilotoId),
       campeonatoId = Value(campeonatoId),
       delta = Value(delta),
       saldoResultante = Value(saldoResultante),
       motivo = Value(motivo);
  static Insertable<MovimientosCredito> custom({
    Expression<int>? id,
    Expression<int>? pilotoId,
    Expression<int>? campeonatoId,
    Expression<int>? verificacionId,
    Expression<int>? equipoId,
    Expression<int>? pruebaId,
    Expression<int>? delta,
    Expression<int>? saldoResultante,
    Expression<String>? motivo,
    Expression<DateTime>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pilotoId != null) 'piloto_id': pilotoId,
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (verificacionId != null) 'verificacion_id': verificacionId,
      if (equipoId != null) 'equipo_id': equipoId,
      if (pruebaId != null) 'prueba_id': pruebaId,
      if (delta != null) 'delta': delta,
      if (saldoResultante != null) 'saldo_resultante': saldoResultante,
      if (motivo != null) 'motivo': motivo,
      if (fecha != null) 'fecha': fecha,
    });
  }

  MovimientosCreditosCompanion copyWith({
    Value<int>? id,
    Value<int>? pilotoId,
    Value<int>? campeonatoId,
    Value<int?>? verificacionId,
    Value<int?>? equipoId,
    Value<int?>? pruebaId,
    Value<int>? delta,
    Value<int>? saldoResultante,
    Value<String>? motivo,
    Value<DateTime>? fecha,
  }) {
    return MovimientosCreditosCompanion(
      id: id ?? this.id,
      pilotoId: pilotoId ?? this.pilotoId,
      campeonatoId: campeonatoId ?? this.campeonatoId,
      verificacionId: verificacionId ?? this.verificacionId,
      equipoId: equipoId ?? this.equipoId,
      pruebaId: pruebaId ?? this.pruebaId,
      delta: delta ?? this.delta,
      saldoResultante: saldoResultante ?? this.saldoResultante,
      motivo: motivo ?? this.motivo,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pilotoId.present) {
      map['piloto_id'] = Variable<int>(pilotoId.value);
    }
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (verificacionId.present) {
      map['verificacion_id'] = Variable<int>(verificacionId.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (pruebaId.present) {
      map['prueba_id'] = Variable<int>(pruebaId.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (saldoResultante.present) {
      map['saldo_resultante'] = Variable<int>(saldoResultante.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCreditosCompanion(')
          ..write('id: $id, ')
          ..write('pilotoId: $pilotoId, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('verificacionId: $verificacionId, ')
          ..write('equipoId: $equipoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('delta: $delta, ')
          ..write('saldoResultante: $saldoResultante, ')
          ..write('motivo: $motivo, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $CatalogoMarcasTable extends CatalogoMarcas
    with TableInfo<$CatalogoMarcasTable, CatalogoMarca> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoMarcasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, codigo, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_marcas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoMarca> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoMarca map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoMarca(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $CatalogoMarcasTable createAlias(String alias) {
    return $CatalogoMarcasTable(attachedDatabase, alias);
  }
}

class CatalogoMarca extends DataClass implements Insertable<CatalogoMarca> {
  final int id;
  final String codigo;
  final String nombre;
  const CatalogoMarca({
    required this.id,
    required this.codigo,
    required this.nombre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  CatalogoMarcasCompanion toCompanion(bool nullToAbsent) {
    return CatalogoMarcasCompanion(
      id: Value(id),
      codigo: Value(codigo),
      nombre: Value(nombre),
    );
  }

  factory CatalogoMarca.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoMarca(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  CatalogoMarca copyWith({int? id, String? codigo, String? nombre}) =>
      CatalogoMarca(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
      );
  CatalogoMarca copyWithCompanion(CatalogoMarcasCompanion data) {
    return CatalogoMarca(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoMarca(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, codigo, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoMarca &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nombre == this.nombre);
}

class CatalogoMarcasCompanion extends UpdateCompanion<CatalogoMarca> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<String> nombre;
  const CatalogoMarcasCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  CatalogoMarcasCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required String nombre,
  }) : codigo = Value(codigo),
       nombre = Value(nombre);
  static Insertable<CatalogoMarca> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (nombre != null) 'nombre': nombre,
    });
  }

  CatalogoMarcasCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<String>? nombre,
  }) {
    return CatalogoMarcasCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoMarcasCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $CatalogoLlantasTable extends CatalogoLlantas
    with TableInfo<$CatalogoLlantasTable, CatalogoLlanta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoLlantasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dimensionMeta = const VerificationMeta(
    'dimension',
  );
  @override
  late final GeneratedColumn<String> dimension = GeneratedColumn<String>(
    'dimension',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, dimension, tipo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_llantas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoLlanta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dimension')) {
      context.handle(
        _dimensionMeta,
        dimension.isAcceptableOrUnknown(data['dimension']!, _dimensionMeta),
      );
    } else if (isInserting) {
      context.missing(_dimensionMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoLlanta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoLlanta(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dimension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dimension'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
    );
  }

  @override
  $CatalogoLlantasTable createAlias(String alias) {
    return $CatalogoLlantasTable(attachedDatabase, alias);
  }
}

class CatalogoLlanta extends DataClass implements Insertable<CatalogoLlanta> {
  final int id;
  final String dimension;
  final String tipo;
  const CatalogoLlanta({
    required this.id,
    required this.dimension,
    required this.tipo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dimension'] = Variable<String>(dimension);
    map['tipo'] = Variable<String>(tipo);
    return map;
  }

  CatalogoLlantasCompanion toCompanion(bool nullToAbsent) {
    return CatalogoLlantasCompanion(
      id: Value(id),
      dimension: Value(dimension),
      tipo: Value(tipo),
    );
  }

  factory CatalogoLlanta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoLlanta(
      id: serializer.fromJson<int>(json['id']),
      dimension: serializer.fromJson<String>(json['dimension']),
      tipo: serializer.fromJson<String>(json['tipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dimension': serializer.toJson<String>(dimension),
      'tipo': serializer.toJson<String>(tipo),
    };
  }

  CatalogoLlanta copyWith({int? id, String? dimension, String? tipo}) =>
      CatalogoLlanta(
        id: id ?? this.id,
        dimension: dimension ?? this.dimension,
        tipo: tipo ?? this.tipo,
      );
  CatalogoLlanta copyWithCompanion(CatalogoLlantasCompanion data) {
    return CatalogoLlanta(
      id: data.id.present ? data.id.value : this.id,
      dimension: data.dimension.present ? data.dimension.value : this.dimension,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoLlanta(')
          ..write('id: $id, ')
          ..write('dimension: $dimension, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dimension, tipo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoLlanta &&
          other.id == this.id &&
          other.dimension == this.dimension &&
          other.tipo == this.tipo);
}

class CatalogoLlantasCompanion extends UpdateCompanion<CatalogoLlanta> {
  final Value<int> id;
  final Value<String> dimension;
  final Value<String> tipo;
  const CatalogoLlantasCompanion({
    this.id = const Value.absent(),
    this.dimension = const Value.absent(),
    this.tipo = const Value.absent(),
  });
  CatalogoLlantasCompanion.insert({
    this.id = const Value.absent(),
    required String dimension,
    required String tipo,
  }) : dimension = Value(dimension),
       tipo = Value(tipo);
  static Insertable<CatalogoLlanta> custom({
    Expression<int>? id,
    Expression<String>? dimension,
    Expression<String>? tipo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dimension != null) 'dimension': dimension,
      if (tipo != null) 'tipo': tipo,
    });
  }

  CatalogoLlantasCompanion copyWith({
    Value<int>? id,
    Value<String>? dimension,
    Value<String>? tipo,
  }) {
    return CatalogoLlantasCompanion(
      id: id ?? this.id,
      dimension: dimension ?? this.dimension,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dimension.present) {
      map['dimension'] = Variable<String>(dimension.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoLlantasCompanion(')
          ..write('id: $id, ')
          ..write('dimension: $dimension, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }
}

class $CatalogoBancadasTable extends CatalogoBancadas
    with TableInfo<$CatalogoBancadasTable, CatalogoBancada> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoBancadasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _copasJsonMeta = const VerificationMeta(
    'copasJson',
  );
  @override
  late final GeneratedColumn<String> copasJson = GeneratedColumn<String>(
    'copas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, copasJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_bancadas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoBancada> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('copas_json')) {
      context.handle(
        _copasJsonMeta,
        copasJson.isAcceptableOrUnknown(data['copas_json']!, _copasJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoBancada map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoBancada(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      copasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copas_json'],
      )!,
    );
  }

  @override
  $CatalogoBancadasTable createAlias(String alias) {
    return $CatalogoBancadasTable(attachedDatabase, alias);
  }
}

class CatalogoBancada extends DataClass implements Insertable<CatalogoBancada> {
  final int id;
  final String nombre;

  /// JSON array de copas donde aplica. Vacío "[]" = aplica a todas.
  final String copasJson;
  const CatalogoBancada({
    required this.id,
    required this.nombre,
    required this.copasJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['copas_json'] = Variable<String>(copasJson);
    return map;
  }

  CatalogoBancadasCompanion toCompanion(bool nullToAbsent) {
    return CatalogoBancadasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      copasJson: Value(copasJson),
    );
  }

  factory CatalogoBancada.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoBancada(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      copasJson: serializer.fromJson<String>(json['copasJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'copasJson': serializer.toJson<String>(copasJson),
    };
  }

  CatalogoBancada copyWith({int? id, String? nombre, String? copasJson}) =>
      CatalogoBancada(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        copasJson: copasJson ?? this.copasJson,
      );
  CatalogoBancada copyWithCompanion(CatalogoBancadasCompanion data) {
    return CatalogoBancada(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      copasJson: data.copasJson.present ? data.copasJson.value : this.copasJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoBancada(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('copasJson: $copasJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, copasJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoBancada &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.copasJson == this.copasJson);
}

class CatalogoBancadasCompanion extends UpdateCompanion<CatalogoBancada> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> copasJson;
  const CatalogoBancadasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.copasJson = const Value.absent(),
  });
  CatalogoBancadasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.copasJson = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<CatalogoBancada> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? copasJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (copasJson != null) 'copas_json': copasJson,
    });
  }

  CatalogoBancadasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? copasJson,
  }) {
    return CatalogoBancadasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      copasJson: copasJson ?? this.copasJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (copasJson.present) {
      map['copas_json'] = Variable<String>(copasJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoBancadasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('copasJson: $copasJson')
          ..write(')'))
        .toString();
  }
}

class $CatalogoChasisTable extends CatalogoChasis
    with TableInfo<$CatalogoChasisTable, CatalogoChasi> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoChasisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _copasJsonMeta = const VerificationMeta(
    'copasJson',
  );
  @override
  late final GeneratedColumn<String> copasJson = GeneratedColumn<String>(
    'copas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, copasJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_chasis';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoChasi> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('copas_json')) {
      context.handle(
        _copasJsonMeta,
        copasJson.isAcceptableOrUnknown(data['copas_json']!, _copasJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoChasi map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoChasi(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      copasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copas_json'],
      )!,
    );
  }

  @override
  $CatalogoChasisTable createAlias(String alias) {
    return $CatalogoChasisTable(attachedDatabase, alias);
  }
}

class CatalogoChasi extends DataClass implements Insertable<CatalogoChasi> {
  final int id;
  final String nombre;

  /// JSON array de copas donde aplica. Vacío "[]" = aplica a todas.
  final String copasJson;
  const CatalogoChasi({
    required this.id,
    required this.nombre,
    required this.copasJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['copas_json'] = Variable<String>(copasJson);
    return map;
  }

  CatalogoChasisCompanion toCompanion(bool nullToAbsent) {
    return CatalogoChasisCompanion(
      id: Value(id),
      nombre: Value(nombre),
      copasJson: Value(copasJson),
    );
  }

  factory CatalogoChasi.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoChasi(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      copasJson: serializer.fromJson<String>(json['copasJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'copasJson': serializer.toJson<String>(copasJson),
    };
  }

  CatalogoChasi copyWith({int? id, String? nombre, String? copasJson}) =>
      CatalogoChasi(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        copasJson: copasJson ?? this.copasJson,
      );
  CatalogoChasi copyWithCompanion(CatalogoChasisCompanion data) {
    return CatalogoChasi(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      copasJson: data.copasJson.present ? data.copasJson.value : this.copasJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoChasi(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('copasJson: $copasJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, copasJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoChasi &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.copasJson == this.copasJson);
}

class CatalogoChasisCompanion extends UpdateCompanion<CatalogoChasi> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> copasJson;
  const CatalogoChasisCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.copasJson = const Value.absent(),
  });
  CatalogoChasisCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.copasJson = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<CatalogoChasi> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? copasJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (copasJson != null) 'copas_json': copasJson,
    });
  }

  CatalogoChasisCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? copasJson,
  }) {
    return CatalogoChasisCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      copasJson: copasJson ?? this.copasJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (copasJson.present) {
      map['copas_json'] = Variable<String>(copasJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoChasisCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('copasJson: $copasJson')
          ..write(')'))
        .toString();
  }
}

class $CatalogoNeumaticosTable extends CatalogoNeumaticos
    with TableInfo<$CatalogoNeumaticosTable, CatalogoNeumatico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoNeumaticosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenciaMeta = const VerificationMeta(
    'referencia',
  );
  @override
  late final GeneratedColumn<String> referencia = GeneratedColumn<String>(
    'referencia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, referencia];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_neumaticos';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoNeumatico> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('referencia')) {
      context.handle(
        _referenciaMeta,
        referencia.isAcceptableOrUnknown(data['referencia']!, _referenciaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoNeumatico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoNeumatico(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      referencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia'],
      ),
    );
  }

  @override
  $CatalogoNeumaticosTable createAlias(String alias) {
    return $CatalogoNeumaticosTable(attachedDatabase, alias);
  }
}

class CatalogoNeumatico extends DataClass
    implements Insertable<CatalogoNeumatico> {
  final int id;
  final String nombre;
  final String? referencia;
  const CatalogoNeumatico({
    required this.id,
    required this.nombre,
    this.referencia,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || referencia != null) {
      map['referencia'] = Variable<String>(referencia);
    }
    return map;
  }

  CatalogoNeumaticosCompanion toCompanion(bool nullToAbsent) {
    return CatalogoNeumaticosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      referencia: referencia == null && nullToAbsent
          ? const Value.absent()
          : Value(referencia),
    );
  }

  factory CatalogoNeumatico.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoNeumatico(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      referencia: serializer.fromJson<String?>(json['referencia']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'referencia': serializer.toJson<String?>(referencia),
    };
  }

  CatalogoNeumatico copyWith({
    int? id,
    String? nombre,
    Value<String?> referencia = const Value.absent(),
  }) => CatalogoNeumatico(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    referencia: referencia.present ? referencia.value : this.referencia,
  );
  CatalogoNeumatico copyWithCompanion(CatalogoNeumaticosCompanion data) {
    return CatalogoNeumatico(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      referencia: data.referencia.present
          ? data.referencia.value
          : this.referencia,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoNeumatico(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('referencia: $referencia')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, referencia);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoNeumatico &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.referencia == this.referencia);
}

class CatalogoNeumaticosCompanion extends UpdateCompanion<CatalogoNeumatico> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> referencia;
  const CatalogoNeumaticosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.referencia = const Value.absent(),
  });
  CatalogoNeumaticosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.referencia = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<CatalogoNeumatico> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? referencia,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (referencia != null) 'referencia': referencia,
    });
  }

  CatalogoNeumaticosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? referencia,
  }) {
    return CatalogoNeumaticosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      referencia: referencia ?? this.referencia,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (referencia.present) {
      map['referencia'] = Variable<String>(referencia.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoNeumaticosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('referencia: $referencia')
          ..write(')'))
        .toString();
  }
}

class $CatalogoEngranajesTable extends CatalogoEngranajes
    with TableInfo<$CatalogoEngranajesTable, CatalogoEngranaje> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoEngranajesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dientesMeta = const VerificationMeta(
    'dientes',
  );
  @override
  late final GeneratedColumn<int> dientes = GeneratedColumn<int>(
    'dientes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tipo, marca, dientes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_engranajes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoEngranaje> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('dientes')) {
      context.handle(
        _dientesMeta,
        dientes.isAcceptableOrUnknown(data['dientes']!, _dientesMeta),
      );
    } else if (isInserting) {
      context.missing(_dientesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoEngranaje map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoEngranaje(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      )!,
      dientes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dientes'],
      )!,
    );
  }

  @override
  $CatalogoEngranajesTable createAlias(String alias) {
    return $CatalogoEngranajesTable(attachedDatabase, alias);
  }
}

class CatalogoEngranaje extends DataClass
    implements Insertable<CatalogoEngranaje> {
  final int id;
  final String tipo;
  final String marca;
  final int dientes;
  const CatalogoEngranaje({
    required this.id,
    required this.tipo,
    required this.marca,
    required this.dientes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo'] = Variable<String>(tipo);
    map['marca'] = Variable<String>(marca);
    map['dientes'] = Variable<int>(dientes);
    return map;
  }

  CatalogoEngranajesCompanion toCompanion(bool nullToAbsent) {
    return CatalogoEngranajesCompanion(
      id: Value(id),
      tipo: Value(tipo),
      marca: Value(marca),
      dientes: Value(dientes),
    );
  }

  factory CatalogoEngranaje.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoEngranaje(
      id: serializer.fromJson<int>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      marca: serializer.fromJson<String>(json['marca']),
      dientes: serializer.fromJson<int>(json['dientes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(tipo),
      'marca': serializer.toJson<String>(marca),
      'dientes': serializer.toJson<int>(dientes),
    };
  }

  CatalogoEngranaje copyWith({
    int? id,
    String? tipo,
    String? marca,
    int? dientes,
  }) => CatalogoEngranaje(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    marca: marca ?? this.marca,
    dientes: dientes ?? this.dientes,
  );
  CatalogoEngranaje copyWithCompanion(CatalogoEngranajesCompanion data) {
    return CatalogoEngranaje(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      marca: data.marca.present ? data.marca.value : this.marca,
      dientes: data.dientes.present ? data.dientes.value : this.dientes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoEngranaje(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('marca: $marca, ')
          ..write('dientes: $dientes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tipo, marca, dientes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoEngranaje &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.marca == this.marca &&
          other.dientes == this.dientes);
}

class CatalogoEngranajesCompanion extends UpdateCompanion<CatalogoEngranaje> {
  final Value<int> id;
  final Value<String> tipo;
  final Value<String> marca;
  final Value<int> dientes;
  const CatalogoEngranajesCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.marca = const Value.absent(),
    this.dientes = const Value.absent(),
  });
  CatalogoEngranajesCompanion.insert({
    this.id = const Value.absent(),
    required String tipo,
    required String marca,
    required int dientes,
  }) : tipo = Value(tipo),
       marca = Value(marca),
       dientes = Value(dientes);
  static Insertable<CatalogoEngranaje> custom({
    Expression<int>? id,
    Expression<String>? tipo,
    Expression<String>? marca,
    Expression<int>? dientes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (marca != null) 'marca': marca,
      if (dientes != null) 'dientes': dientes,
    });
  }

  CatalogoEngranajesCompanion copyWith({
    Value<int>? id,
    Value<String>? tipo,
    Value<String>? marca,
    Value<int>? dientes,
  }) {
    return CatalogoEngranajesCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      marca: marca ?? this.marca,
      dientes: dientes ?? this.dientes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (dientes.present) {
      map['dientes'] = Variable<int>(dientes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoEngranajesCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('marca: $marca, ')
          ..write('dientes: $dientes')
          ..write(')'))
        .toString();
  }
}

class $CatalogoMotoresTable extends CatalogoMotores
    with TableInfo<$CatalogoMotoresTable, CatalogoMotore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoMotoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rpmMeta = const VerificationMeta('rpm');
  @override
  late final GeneratedColumn<int> rpm = GeneratedColumn<int>(
    'rpm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gaussMeta = const VerificationMeta('gauss');
  @override
  late final GeneratedColumn<double> gauss = GeneratedColumn<double>(
    'gauss',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _copasJsonMeta = const VerificationMeta(
    'copasJson',
  );
  @override
  late final GeneratedColumn<String> copasJson = GeneratedColumn<String>(
    'copas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, rpm, gauss, copasJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_motores';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoMotore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('rpm')) {
      context.handle(
        _rpmMeta,
        rpm.isAcceptableOrUnknown(data['rpm']!, _rpmMeta),
      );
    }
    if (data.containsKey('gauss')) {
      context.handle(
        _gaussMeta,
        gauss.isAcceptableOrUnknown(data['gauss']!, _gaussMeta),
      );
    }
    if (data.containsKey('copas_json')) {
      context.handle(
        _copasJsonMeta,
        copasJson.isAcceptableOrUnknown(data['copas_json']!, _copasJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoMotore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoMotore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      rpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rpm'],
      ),
      gauss: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gauss'],
      ),
      copasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copas_json'],
      )!,
    );
  }

  @override
  $CatalogoMotoresTable createAlias(String alias) {
    return $CatalogoMotoresTable(attachedDatabase, alias);
  }
}

class CatalogoMotore extends DataClass implements Insertable<CatalogoMotore> {
  final int id;
  final String nombre;
  final int? rpm;
  final double? gauss;

  /// JSON array de copas donde aplica. Vacío "[]" = aplica a todas.
  final String copasJson;
  const CatalogoMotore({
    required this.id,
    required this.nombre,
    this.rpm,
    this.gauss,
    required this.copasJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || rpm != null) {
      map['rpm'] = Variable<int>(rpm);
    }
    if (!nullToAbsent || gauss != null) {
      map['gauss'] = Variable<double>(gauss);
    }
    map['copas_json'] = Variable<String>(copasJson);
    return map;
  }

  CatalogoMotoresCompanion toCompanion(bool nullToAbsent) {
    return CatalogoMotoresCompanion(
      id: Value(id),
      nombre: Value(nombre),
      rpm: rpm == null && nullToAbsent ? const Value.absent() : Value(rpm),
      gauss: gauss == null && nullToAbsent
          ? const Value.absent()
          : Value(gauss),
      copasJson: Value(copasJson),
    );
  }

  factory CatalogoMotore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoMotore(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      rpm: serializer.fromJson<int?>(json['rpm']),
      gauss: serializer.fromJson<double?>(json['gauss']),
      copasJson: serializer.fromJson<String>(json['copasJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'rpm': serializer.toJson<int?>(rpm),
      'gauss': serializer.toJson<double?>(gauss),
      'copasJson': serializer.toJson<String>(copasJson),
    };
  }

  CatalogoMotore copyWith({
    int? id,
    String? nombre,
    Value<int?> rpm = const Value.absent(),
    Value<double?> gauss = const Value.absent(),
    String? copasJson,
  }) => CatalogoMotore(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    rpm: rpm.present ? rpm.value : this.rpm,
    gauss: gauss.present ? gauss.value : this.gauss,
    copasJson: copasJson ?? this.copasJson,
  );
  CatalogoMotore copyWithCompanion(CatalogoMotoresCompanion data) {
    return CatalogoMotore(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      rpm: data.rpm.present ? data.rpm.value : this.rpm,
      gauss: data.gauss.present ? data.gauss.value : this.gauss,
      copasJson: data.copasJson.present ? data.copasJson.value : this.copasJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoMotore(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('rpm: $rpm, ')
          ..write('gauss: $gauss, ')
          ..write('copasJson: $copasJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, rpm, gauss, copasJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoMotore &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.rpm == this.rpm &&
          other.gauss == this.gauss &&
          other.copasJson == this.copasJson);
}

class CatalogoMotoresCompanion extends UpdateCompanion<CatalogoMotore> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int?> rpm;
  final Value<double?> gauss;
  final Value<String> copasJson;
  const CatalogoMotoresCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.rpm = const Value.absent(),
    this.gauss = const Value.absent(),
    this.copasJson = const Value.absent(),
  });
  CatalogoMotoresCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.rpm = const Value.absent(),
    this.gauss = const Value.absent(),
    this.copasJson = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<CatalogoMotore> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? rpm,
    Expression<double>? gauss,
    Expression<String>? copasJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (rpm != null) 'rpm': rpm,
      if (gauss != null) 'gauss': gauss,
      if (copasJson != null) 'copas_json': copasJson,
    });
  }

  CatalogoMotoresCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<int?>? rpm,
    Value<double?>? gauss,
    Value<String>? copasJson,
  }) {
    return CatalogoMotoresCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      rpm: rpm ?? this.rpm,
      gauss: gauss ?? this.gauss,
      copasJson: copasJson ?? this.copasJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (rpm.present) {
      map['rpm'] = Variable<int>(rpm.value);
    }
    if (gauss.present) {
      map['gauss'] = Variable<double>(gauss.value);
    }
    if (copasJson.present) {
      map['copas_json'] = Variable<String>(copasJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoMotoresCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('rpm: $rpm, ')
          ..write('gauss: $gauss, ')
          ..write('copasJson: $copasJson')
          ..write(')'))
        .toString();
  }
}

class $CatalogoCopasTable extends CatalogoCopas
    with TableInfo<$CatalogoCopasTable, CatalogoCopa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoCopasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_copas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoCopa> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoCopa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoCopa(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $CatalogoCopasTable createAlias(String alias) {
    return $CatalogoCopasTable(attachedDatabase, alias);
  }
}

class CatalogoCopa extends DataClass implements Insertable<CatalogoCopa> {
  final int id;
  final String nombre;
  const CatalogoCopa({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  CatalogoCopasCompanion toCompanion(bool nullToAbsent) {
    return CatalogoCopasCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory CatalogoCopa.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoCopa(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  CatalogoCopa copyWith({int? id, String? nombre}) =>
      CatalogoCopa(id: id ?? this.id, nombre: nombre ?? this.nombre);
  CatalogoCopa copyWithCompanion(CatalogoCopasCompanion data) {
    return CatalogoCopa(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoCopa(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoCopa &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class CatalogoCopasCompanion extends UpdateCompanion<CatalogoCopa> {
  final Value<int> id;
  final Value<String> nombre;
  const CatalogoCopasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  CatalogoCopasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<CatalogoCopa> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  CatalogoCopasCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return CatalogoCopasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoCopasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $CatalogoClubsTable extends CatalogoClubs
    with TableInfo<$CatalogoClubsTable, CatalogoClub> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogoClubsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogo_clubs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogoClub> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogoClub map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogoClub(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $CatalogoClubsTable createAlias(String alias) {
    return $CatalogoClubsTable(attachedDatabase, alias);
  }
}

class CatalogoClub extends DataClass implements Insertable<CatalogoClub> {
  final int id;
  final String nombre;
  const CatalogoClub({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  CatalogoClubsCompanion toCompanion(bool nullToAbsent) {
    return CatalogoClubsCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory CatalogoClub.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogoClub(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  CatalogoClub copyWith({int? id, String? nombre}) =>
      CatalogoClub(id: id ?? this.id, nombre: nombre ?? this.nombre);
  CatalogoClub copyWithCompanion(CatalogoClubsCompanion data) {
    return CatalogoClub(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoClub(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogoClub &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class CatalogoClubsCompanion extends UpdateCompanion<CatalogoClub> {
  final Value<int> id;
  final Value<String> nombre;
  const CatalogoClubsCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  CatalogoClubsCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<CatalogoClub> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  CatalogoClubsCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return CatalogoClubsCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogoClubsCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $HojasVinculadasTable extends HojasVinculadas
    with TableInfo<$HojasVinculadasTable, HojasVinculada> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HojasVinculadasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entidadMeta = const VerificationMeta(
    'entidad',
  );
  @override
  late final GeneratedColumn<String> entidad = GeneratedColumn<String>(
    'entidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _campeonatoIdMeta = const VerificationMeta(
    'campeonatoId',
  );
  @override
  late final GeneratedColumn<int> campeonatoId = GeneratedColumn<int>(
    'campeonato_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pruebaIdMeta = const VerificationMeta(
    'pruebaId',
  );
  @override
  late final GeneratedColumn<int> pruebaId = GeneratedColumn<int>(
    'prueba_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hojaIdMeta = const VerificationMeta('hojaId');
  @override
  late final GeneratedColumn<String> hojaId = GeneratedColumn<String>(
    'hoja_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hojaNombreMeta = const VerificationMeta(
    'hojaNombre',
  );
  @override
  late final GeneratedColumn<String> hojaNombre = GeneratedColumn<String>(
    'hoja_nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pestanaTituloMeta = const VerificationMeta(
    'pestanaTitulo',
  );
  @override
  late final GeneratedColumn<String> pestanaTitulo = GeneratedColumn<String>(
    'pestana_titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mapeoJsonMeta = const VerificationMeta(
    'mapeoJson',
  );
  @override
  late final GeneratedColumn<String> mapeoJson = GeneratedColumn<String>(
    'mapeo_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ultimaSyncMeta = const VerificationMeta(
    'ultimaSync',
  );
  @override
  late final GeneratedColumn<DateTime> ultimaSync = GeneratedColumn<DateTime>(
    'ultima_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ultimoResumenMeta = const VerificationMeta(
    'ultimoResumen',
  );
  @override
  late final GeneratedColumn<String> ultimoResumen = GeneratedColumn<String>(
    'ultimo_resumen',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entidad,
    campeonatoId,
    pruebaId,
    hojaId,
    hojaNombre,
    pestanaTitulo,
    mapeoJson,
    ultimaSync,
    ultimoResumen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hojas_vinculadas';
  @override
  VerificationContext validateIntegrity(
    Insertable<HojasVinculada> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entidad')) {
      context.handle(
        _entidadMeta,
        entidad.isAcceptableOrUnknown(data['entidad']!, _entidadMeta),
      );
    } else if (isInserting) {
      context.missing(_entidadMeta);
    }
    if (data.containsKey('campeonato_id')) {
      context.handle(
        _campeonatoIdMeta,
        campeonatoId.isAcceptableOrUnknown(
          data['campeonato_id']!,
          _campeonatoIdMeta,
        ),
      );
    }
    if (data.containsKey('prueba_id')) {
      context.handle(
        _pruebaIdMeta,
        pruebaId.isAcceptableOrUnknown(data['prueba_id']!, _pruebaIdMeta),
      );
    }
    if (data.containsKey('hoja_id')) {
      context.handle(
        _hojaIdMeta,
        hojaId.isAcceptableOrUnknown(data['hoja_id']!, _hojaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hojaIdMeta);
    }
    if (data.containsKey('hoja_nombre')) {
      context.handle(
        _hojaNombreMeta,
        hojaNombre.isAcceptableOrUnknown(data['hoja_nombre']!, _hojaNombreMeta),
      );
    } else if (isInserting) {
      context.missing(_hojaNombreMeta);
    }
    if (data.containsKey('pestana_titulo')) {
      context.handle(
        _pestanaTituloMeta,
        pestanaTitulo.isAcceptableOrUnknown(
          data['pestana_titulo']!,
          _pestanaTituloMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pestanaTituloMeta);
    }
    if (data.containsKey('mapeo_json')) {
      context.handle(
        _mapeoJsonMeta,
        mapeoJson.isAcceptableOrUnknown(data['mapeo_json']!, _mapeoJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_mapeoJsonMeta);
    }
    if (data.containsKey('ultima_sync')) {
      context.handle(
        _ultimaSyncMeta,
        ultimaSync.isAcceptableOrUnknown(data['ultima_sync']!, _ultimaSyncMeta),
      );
    }
    if (data.containsKey('ultimo_resumen')) {
      context.handle(
        _ultimoResumenMeta,
        ultimoResumen.isAcceptableOrUnknown(
          data['ultimo_resumen']!,
          _ultimoResumenMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HojasVinculada map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HojasVinculada(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entidad'],
      )!,
      campeonatoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campeonato_id'],
      ),
      pruebaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prueba_id'],
      ),
      hojaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hoja_id'],
      )!,
      hojaNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hoja_nombre'],
      )!,
      pestanaTitulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pestana_titulo'],
      )!,
      mapeoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mapeo_json'],
      )!,
      ultimaSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ultima_sync'],
      ),
      ultimoResumen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ultimo_resumen'],
      ),
    );
  }

  @override
  $HojasVinculadasTable createAlias(String alias) {
    return $HojasVinculadasTable(attachedDatabase, alias);
  }
}

class HojasVinculada extends DataClass implements Insertable<HojasVinculada> {
  final int id;

  /// 'pilotos' | 'equipos' | 'inscripciones'
  final String entidad;
  final int? campeonatoId;
  final int? pruebaId;
  final String hojaId;
  final String hojaNombre;
  final String pestanaTitulo;
  final String mapeoJson;
  final DateTime? ultimaSync;
  final String? ultimoResumen;
  const HojasVinculada({
    required this.id,
    required this.entidad,
    this.campeonatoId,
    this.pruebaId,
    required this.hojaId,
    required this.hojaNombre,
    required this.pestanaTitulo,
    required this.mapeoJson,
    this.ultimaSync,
    this.ultimoResumen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entidad'] = Variable<String>(entidad);
    if (!nullToAbsent || campeonatoId != null) {
      map['campeonato_id'] = Variable<int>(campeonatoId);
    }
    if (!nullToAbsent || pruebaId != null) {
      map['prueba_id'] = Variable<int>(pruebaId);
    }
    map['hoja_id'] = Variable<String>(hojaId);
    map['hoja_nombre'] = Variable<String>(hojaNombre);
    map['pestana_titulo'] = Variable<String>(pestanaTitulo);
    map['mapeo_json'] = Variable<String>(mapeoJson);
    if (!nullToAbsent || ultimaSync != null) {
      map['ultima_sync'] = Variable<DateTime>(ultimaSync);
    }
    if (!nullToAbsent || ultimoResumen != null) {
      map['ultimo_resumen'] = Variable<String>(ultimoResumen);
    }
    return map;
  }

  HojasVinculadasCompanion toCompanion(bool nullToAbsent) {
    return HojasVinculadasCompanion(
      id: Value(id),
      entidad: Value(entidad),
      campeonatoId: campeonatoId == null && nullToAbsent
          ? const Value.absent()
          : Value(campeonatoId),
      pruebaId: pruebaId == null && nullToAbsent
          ? const Value.absent()
          : Value(pruebaId),
      hojaId: Value(hojaId),
      hojaNombre: Value(hojaNombre),
      pestanaTitulo: Value(pestanaTitulo),
      mapeoJson: Value(mapeoJson),
      ultimaSync: ultimaSync == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimaSync),
      ultimoResumen: ultimoResumen == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimoResumen),
    );
  }

  factory HojasVinculada.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HojasVinculada(
      id: serializer.fromJson<int>(json['id']),
      entidad: serializer.fromJson<String>(json['entidad']),
      campeonatoId: serializer.fromJson<int?>(json['campeonatoId']),
      pruebaId: serializer.fromJson<int?>(json['pruebaId']),
      hojaId: serializer.fromJson<String>(json['hojaId']),
      hojaNombre: serializer.fromJson<String>(json['hojaNombre']),
      pestanaTitulo: serializer.fromJson<String>(json['pestanaTitulo']),
      mapeoJson: serializer.fromJson<String>(json['mapeoJson']),
      ultimaSync: serializer.fromJson<DateTime?>(json['ultimaSync']),
      ultimoResumen: serializer.fromJson<String?>(json['ultimoResumen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entidad': serializer.toJson<String>(entidad),
      'campeonatoId': serializer.toJson<int?>(campeonatoId),
      'pruebaId': serializer.toJson<int?>(pruebaId),
      'hojaId': serializer.toJson<String>(hojaId),
      'hojaNombre': serializer.toJson<String>(hojaNombre),
      'pestanaTitulo': serializer.toJson<String>(pestanaTitulo),
      'mapeoJson': serializer.toJson<String>(mapeoJson),
      'ultimaSync': serializer.toJson<DateTime?>(ultimaSync),
      'ultimoResumen': serializer.toJson<String?>(ultimoResumen),
    };
  }

  HojasVinculada copyWith({
    int? id,
    String? entidad,
    Value<int?> campeonatoId = const Value.absent(),
    Value<int?> pruebaId = const Value.absent(),
    String? hojaId,
    String? hojaNombre,
    String? pestanaTitulo,
    String? mapeoJson,
    Value<DateTime?> ultimaSync = const Value.absent(),
    Value<String?> ultimoResumen = const Value.absent(),
  }) => HojasVinculada(
    id: id ?? this.id,
    entidad: entidad ?? this.entidad,
    campeonatoId: campeonatoId.present ? campeonatoId.value : this.campeonatoId,
    pruebaId: pruebaId.present ? pruebaId.value : this.pruebaId,
    hojaId: hojaId ?? this.hojaId,
    hojaNombre: hojaNombre ?? this.hojaNombre,
    pestanaTitulo: pestanaTitulo ?? this.pestanaTitulo,
    mapeoJson: mapeoJson ?? this.mapeoJson,
    ultimaSync: ultimaSync.present ? ultimaSync.value : this.ultimaSync,
    ultimoResumen: ultimoResumen.present
        ? ultimoResumen.value
        : this.ultimoResumen,
  );
  HojasVinculada copyWithCompanion(HojasVinculadasCompanion data) {
    return HojasVinculada(
      id: data.id.present ? data.id.value : this.id,
      entidad: data.entidad.present ? data.entidad.value : this.entidad,
      campeonatoId: data.campeonatoId.present
          ? data.campeonatoId.value
          : this.campeonatoId,
      pruebaId: data.pruebaId.present ? data.pruebaId.value : this.pruebaId,
      hojaId: data.hojaId.present ? data.hojaId.value : this.hojaId,
      hojaNombre: data.hojaNombre.present
          ? data.hojaNombre.value
          : this.hojaNombre,
      pestanaTitulo: data.pestanaTitulo.present
          ? data.pestanaTitulo.value
          : this.pestanaTitulo,
      mapeoJson: data.mapeoJson.present ? data.mapeoJson.value : this.mapeoJson,
      ultimaSync: data.ultimaSync.present
          ? data.ultimaSync.value
          : this.ultimaSync,
      ultimoResumen: data.ultimoResumen.present
          ? data.ultimoResumen.value
          : this.ultimoResumen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HojasVinculada(')
          ..write('id: $id, ')
          ..write('entidad: $entidad, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('hojaId: $hojaId, ')
          ..write('hojaNombre: $hojaNombre, ')
          ..write('pestanaTitulo: $pestanaTitulo, ')
          ..write('mapeoJson: $mapeoJson, ')
          ..write('ultimaSync: $ultimaSync, ')
          ..write('ultimoResumen: $ultimoResumen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entidad,
    campeonatoId,
    pruebaId,
    hojaId,
    hojaNombre,
    pestanaTitulo,
    mapeoJson,
    ultimaSync,
    ultimoResumen,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HojasVinculada &&
          other.id == this.id &&
          other.entidad == this.entidad &&
          other.campeonatoId == this.campeonatoId &&
          other.pruebaId == this.pruebaId &&
          other.hojaId == this.hojaId &&
          other.hojaNombre == this.hojaNombre &&
          other.pestanaTitulo == this.pestanaTitulo &&
          other.mapeoJson == this.mapeoJson &&
          other.ultimaSync == this.ultimaSync &&
          other.ultimoResumen == this.ultimoResumen);
}

class HojasVinculadasCompanion extends UpdateCompanion<HojasVinculada> {
  final Value<int> id;
  final Value<String> entidad;
  final Value<int?> campeonatoId;
  final Value<int?> pruebaId;
  final Value<String> hojaId;
  final Value<String> hojaNombre;
  final Value<String> pestanaTitulo;
  final Value<String> mapeoJson;
  final Value<DateTime?> ultimaSync;
  final Value<String?> ultimoResumen;
  const HojasVinculadasCompanion({
    this.id = const Value.absent(),
    this.entidad = const Value.absent(),
    this.campeonatoId = const Value.absent(),
    this.pruebaId = const Value.absent(),
    this.hojaId = const Value.absent(),
    this.hojaNombre = const Value.absent(),
    this.pestanaTitulo = const Value.absent(),
    this.mapeoJson = const Value.absent(),
    this.ultimaSync = const Value.absent(),
    this.ultimoResumen = const Value.absent(),
  });
  HojasVinculadasCompanion.insert({
    this.id = const Value.absent(),
    required String entidad,
    this.campeonatoId = const Value.absent(),
    this.pruebaId = const Value.absent(),
    required String hojaId,
    required String hojaNombre,
    required String pestanaTitulo,
    required String mapeoJson,
    this.ultimaSync = const Value.absent(),
    this.ultimoResumen = const Value.absent(),
  }) : entidad = Value(entidad),
       hojaId = Value(hojaId),
       hojaNombre = Value(hojaNombre),
       pestanaTitulo = Value(pestanaTitulo),
       mapeoJson = Value(mapeoJson);
  static Insertable<HojasVinculada> custom({
    Expression<int>? id,
    Expression<String>? entidad,
    Expression<int>? campeonatoId,
    Expression<int>? pruebaId,
    Expression<String>? hojaId,
    Expression<String>? hojaNombre,
    Expression<String>? pestanaTitulo,
    Expression<String>? mapeoJson,
    Expression<DateTime>? ultimaSync,
    Expression<String>? ultimoResumen,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entidad != null) 'entidad': entidad,
      if (campeonatoId != null) 'campeonato_id': campeonatoId,
      if (pruebaId != null) 'prueba_id': pruebaId,
      if (hojaId != null) 'hoja_id': hojaId,
      if (hojaNombre != null) 'hoja_nombre': hojaNombre,
      if (pestanaTitulo != null) 'pestana_titulo': pestanaTitulo,
      if (mapeoJson != null) 'mapeo_json': mapeoJson,
      if (ultimaSync != null) 'ultima_sync': ultimaSync,
      if (ultimoResumen != null) 'ultimo_resumen': ultimoResumen,
    });
  }

  HojasVinculadasCompanion copyWith({
    Value<int>? id,
    Value<String>? entidad,
    Value<int?>? campeonatoId,
    Value<int?>? pruebaId,
    Value<String>? hojaId,
    Value<String>? hojaNombre,
    Value<String>? pestanaTitulo,
    Value<String>? mapeoJson,
    Value<DateTime?>? ultimaSync,
    Value<String?>? ultimoResumen,
  }) {
    return HojasVinculadasCompanion(
      id: id ?? this.id,
      entidad: entidad ?? this.entidad,
      campeonatoId: campeonatoId ?? this.campeonatoId,
      pruebaId: pruebaId ?? this.pruebaId,
      hojaId: hojaId ?? this.hojaId,
      hojaNombre: hojaNombre ?? this.hojaNombre,
      pestanaTitulo: pestanaTitulo ?? this.pestanaTitulo,
      mapeoJson: mapeoJson ?? this.mapeoJson,
      ultimaSync: ultimaSync ?? this.ultimaSync,
      ultimoResumen: ultimoResumen ?? this.ultimoResumen,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entidad.present) {
      map['entidad'] = Variable<String>(entidad.value);
    }
    if (campeonatoId.present) {
      map['campeonato_id'] = Variable<int>(campeonatoId.value);
    }
    if (pruebaId.present) {
      map['prueba_id'] = Variable<int>(pruebaId.value);
    }
    if (hojaId.present) {
      map['hoja_id'] = Variable<String>(hojaId.value);
    }
    if (hojaNombre.present) {
      map['hoja_nombre'] = Variable<String>(hojaNombre.value);
    }
    if (pestanaTitulo.present) {
      map['pestana_titulo'] = Variable<String>(pestanaTitulo.value);
    }
    if (mapeoJson.present) {
      map['mapeo_json'] = Variable<String>(mapeoJson.value);
    }
    if (ultimaSync.present) {
      map['ultima_sync'] = Variable<DateTime>(ultimaSync.value);
    }
    if (ultimoResumen.present) {
      map['ultimo_resumen'] = Variable<String>(ultimoResumen.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HojasVinculadasCompanion(')
          ..write('id: $id, ')
          ..write('entidad: $entidad, ')
          ..write('campeonatoId: $campeonatoId, ')
          ..write('pruebaId: $pruebaId, ')
          ..write('hojaId: $hojaId, ')
          ..write('hojaNombre: $hojaNombre, ')
          ..write('pestanaTitulo: $pestanaTitulo, ')
          ..write('mapeoJson: $mapeoJson, ')
          ..write('ultimaSync: $ultimaSync, ')
          ..write('ultimoResumen: $ultimoResumen')
          ..write(')'))
        .toString();
  }
}

class $SyncColaTable extends SyncCola
    with TableInfo<$SyncColaTable, SyncColaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncColaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entidadMeta = const VerificationMeta(
    'entidad',
  );
  @override
  late final GeneratedColumn<String> entidad = GeneratedColumn<String>(
    'entidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entidadIdMeta = const VerificationMeta(
    'entidadId',
  );
  @override
  late final GeneratedColumn<int> entidadId = GeneratedColumn<int>(
    'entidad_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accionMeta = const VerificationMeta('accion');
  @override
  late final GeneratedColumn<String> accion = GeneratedColumn<String>(
    'accion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDIENTE'),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _sincronizadoEnMeta = const VerificationMeta(
    'sincronizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEn =
      GeneratedColumn<DateTime>(
        'sincronizado_en',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entidad,
    entidadId,
    accion,
    payloadJson,
    estado,
    error,
    creadoEn,
    sincronizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cola';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncColaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entidad')) {
      context.handle(
        _entidadMeta,
        entidad.isAcceptableOrUnknown(data['entidad']!, _entidadMeta),
      );
    } else if (isInserting) {
      context.missing(_entidadMeta);
    }
    if (data.containsKey('entidad_id')) {
      context.handle(
        _entidadIdMeta,
        entidadId.isAcceptableOrUnknown(data['entidad_id']!, _entidadIdMeta),
      );
    }
    if (data.containsKey('accion')) {
      context.handle(
        _accionMeta,
        accion.isAcceptableOrUnknown(data['accion']!, _accionMeta),
      );
    } else if (isInserting) {
      context.missing(_accionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('sincronizado_en')) {
      context.handle(
        _sincronizadoEnMeta,
        sincronizadoEn.isAcceptableOrUnknown(
          data['sincronizado_en']!,
          _sincronizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncColaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncColaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entidad'],
      )!,
      entidadId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entidad_id'],
      ),
      accion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accion'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      sincronizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sincronizado_en'],
      ),
    );
  }

  @override
  $SyncColaTable createAlias(String alias) {
    return $SyncColaTable(attachedDatabase, alias);
  }
}

class SyncColaData extends DataClass implements Insertable<SyncColaData> {
  final int id;
  final String entidad;
  final int? entidadId;
  final String accion;
  final String payloadJson;
  final String estado;
  final String? error;
  final DateTime creadoEn;
  final DateTime? sincronizadoEn;
  const SyncColaData({
    required this.id,
    required this.entidad,
    this.entidadId,
    required this.accion,
    required this.payloadJson,
    required this.estado,
    this.error,
    required this.creadoEn,
    this.sincronizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entidad'] = Variable<String>(entidad);
    if (!nullToAbsent || entidadId != null) {
      map['entidad_id'] = Variable<int>(entidadId);
    }
    map['accion'] = Variable<String>(accion);
    map['payload_json'] = Variable<String>(payloadJson);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    if (!nullToAbsent || sincronizadoEn != null) {
      map['sincronizado_en'] = Variable<DateTime>(sincronizadoEn);
    }
    return map;
  }

  SyncColaCompanion toCompanion(bool nullToAbsent) {
    return SyncColaCompanion(
      id: Value(id),
      entidad: Value(entidad),
      entidadId: entidadId == null && nullToAbsent
          ? const Value.absent()
          : Value(entidadId),
      accion: Value(accion),
      payloadJson: Value(payloadJson),
      estado: Value(estado),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      creadoEn: Value(creadoEn),
      sincronizadoEn: sincronizadoEn == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEn),
    );
  }

  factory SyncColaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncColaData(
      id: serializer.fromJson<int>(json['id']),
      entidad: serializer.fromJson<String>(json['entidad']),
      entidadId: serializer.fromJson<int?>(json['entidadId']),
      accion: serializer.fromJson<String>(json['accion']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      estado: serializer.fromJson<String>(json['estado']),
      error: serializer.fromJson<String?>(json['error']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      sincronizadoEn: serializer.fromJson<DateTime?>(json['sincronizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entidad': serializer.toJson<String>(entidad),
      'entidadId': serializer.toJson<int?>(entidadId),
      'accion': serializer.toJson<String>(accion),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'estado': serializer.toJson<String>(estado),
      'error': serializer.toJson<String?>(error),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'sincronizadoEn': serializer.toJson<DateTime?>(sincronizadoEn),
    };
  }

  SyncColaData copyWith({
    int? id,
    String? entidad,
    Value<int?> entidadId = const Value.absent(),
    String? accion,
    String? payloadJson,
    String? estado,
    Value<String?> error = const Value.absent(),
    DateTime? creadoEn,
    Value<DateTime?> sincronizadoEn = const Value.absent(),
  }) => SyncColaData(
    id: id ?? this.id,
    entidad: entidad ?? this.entidad,
    entidadId: entidadId.present ? entidadId.value : this.entidadId,
    accion: accion ?? this.accion,
    payloadJson: payloadJson ?? this.payloadJson,
    estado: estado ?? this.estado,
    error: error.present ? error.value : this.error,
    creadoEn: creadoEn ?? this.creadoEn,
    sincronizadoEn: sincronizadoEn.present
        ? sincronizadoEn.value
        : this.sincronizadoEn,
  );
  SyncColaData copyWithCompanion(SyncColaCompanion data) {
    return SyncColaData(
      id: data.id.present ? data.id.value : this.id,
      entidad: data.entidad.present ? data.entidad.value : this.entidad,
      entidadId: data.entidadId.present ? data.entidadId.value : this.entidadId,
      accion: data.accion.present ? data.accion.value : this.accion,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      estado: data.estado.present ? data.estado.value : this.estado,
      error: data.error.present ? data.error.value : this.error,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      sincronizadoEn: data.sincronizadoEn.present
          ? data.sincronizadoEn.value
          : this.sincronizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncColaData(')
          ..write('id: $id, ')
          ..write('entidad: $entidad, ')
          ..write('entidadId: $entidadId, ')
          ..write('accion: $accion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('estado: $estado, ')
          ..write('error: $error, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('sincronizadoEn: $sincronizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entidad,
    entidadId,
    accion,
    payloadJson,
    estado,
    error,
    creadoEn,
    sincronizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncColaData &&
          other.id == this.id &&
          other.entidad == this.entidad &&
          other.entidadId == this.entidadId &&
          other.accion == this.accion &&
          other.payloadJson == this.payloadJson &&
          other.estado == this.estado &&
          other.error == this.error &&
          other.creadoEn == this.creadoEn &&
          other.sincronizadoEn == this.sincronizadoEn);
}

class SyncColaCompanion extends UpdateCompanion<SyncColaData> {
  final Value<int> id;
  final Value<String> entidad;
  final Value<int?> entidadId;
  final Value<String> accion;
  final Value<String> payloadJson;
  final Value<String> estado;
  final Value<String?> error;
  final Value<DateTime> creadoEn;
  final Value<DateTime?> sincronizadoEn;
  const SyncColaCompanion({
    this.id = const Value.absent(),
    this.entidad = const Value.absent(),
    this.entidadId = const Value.absent(),
    this.accion = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.estado = const Value.absent(),
    this.error = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.sincronizadoEn = const Value.absent(),
  });
  SyncColaCompanion.insert({
    this.id = const Value.absent(),
    required String entidad,
    this.entidadId = const Value.absent(),
    required String accion,
    required String payloadJson,
    this.estado = const Value.absent(),
    this.error = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.sincronizadoEn = const Value.absent(),
  }) : entidad = Value(entidad),
       accion = Value(accion),
       payloadJson = Value(payloadJson);
  static Insertable<SyncColaData> custom({
    Expression<int>? id,
    Expression<String>? entidad,
    Expression<int>? entidadId,
    Expression<String>? accion,
    Expression<String>? payloadJson,
    Expression<String>? estado,
    Expression<String>? error,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? sincronizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entidad != null) 'entidad': entidad,
      if (entidadId != null) 'entidad_id': entidadId,
      if (accion != null) 'accion': accion,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (estado != null) 'estado': estado,
      if (error != null) 'error': error,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (sincronizadoEn != null) 'sincronizado_en': sincronizadoEn,
    });
  }

  SyncColaCompanion copyWith({
    Value<int>? id,
    Value<String>? entidad,
    Value<int?>? entidadId,
    Value<String>? accion,
    Value<String>? payloadJson,
    Value<String>? estado,
    Value<String?>? error,
    Value<DateTime>? creadoEn,
    Value<DateTime?>? sincronizadoEn,
  }) {
    return SyncColaCompanion(
      id: id ?? this.id,
      entidad: entidad ?? this.entidad,
      entidadId: entidadId ?? this.entidadId,
      accion: accion ?? this.accion,
      payloadJson: payloadJson ?? this.payloadJson,
      estado: estado ?? this.estado,
      error: error ?? this.error,
      creadoEn: creadoEn ?? this.creadoEn,
      sincronizadoEn: sincronizadoEn ?? this.sincronizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entidad.present) {
      map['entidad'] = Variable<String>(entidad.value);
    }
    if (entidadId.present) {
      map['entidad_id'] = Variable<int>(entidadId.value);
    }
    if (accion.present) {
      map['accion'] = Variable<String>(accion.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (sincronizadoEn.present) {
      map['sincronizado_en'] = Variable<DateTime>(sincronizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncColaCompanion(')
          ..write('id: $id, ')
          ..write('entidad: $entidad, ')
          ..write('entidadId: $entidadId, ')
          ..write('accion: $accion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('estado: $estado, ')
          ..write('error: $error, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('sincronizadoEn: $sincronizadoEn')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CampeonatosTable campeonatos = $CampeonatosTable(this);
  late final $TablaPuntosTable tablaPuntos = $TablaPuntosTable(this);
  late final $TablaBonificacionTable tablaBonificacion =
      $TablaBonificacionTable(this);
  late final $PilotosTable pilotos = $PilotosTable(this);
  late final $PilotoCampeonatoTable pilotoCampeonato = $PilotoCampeonatoTable(
    this,
  );
  late final $EquiposTable equipos = $EquiposTable(this);
  late final $PruebasTable pruebas = $PruebasTable(this);
  late final $MangasTable mangas = $MangasTable(this);
  late final $InscripcionesTable inscripciones = $InscripcionesTable(this);
  late final $InscripcionesPruebaTable inscripcionesPrueba =
      $InscripcionesPruebaTable(this);
  late final $ResultadosTable resultados = $ResultadosTable(this);
  late final $DescartesPruebaTable descartesPrueba = $DescartesPruebaTable(
    this,
  );
  late final $OverridesCopaTable overridesCopa = $OverridesCopaTable(this);
  late final $CatalogoCochesTable catalogoCoches = $CatalogoCochesTable(this);
  late final $VerificacionesTable verificaciones = $VerificacionesTable(this);
  late final $PagosTable pagos = $PagosTable(this);
  late final $MovimientosTesoreriaTable movimientosTesoreria =
      $MovimientosTesoreriaTable(this);
  late final $MovimientosCreditosTable movimientosCreditos =
      $MovimientosCreditosTable(this);
  late final $CatalogoMarcasTable catalogoMarcas = $CatalogoMarcasTable(this);
  late final $CatalogoLlantasTable catalogoLlantas = $CatalogoLlantasTable(
    this,
  );
  late final $CatalogoBancadasTable catalogoBancadas = $CatalogoBancadasTable(
    this,
  );
  late final $CatalogoChasisTable catalogoChasis = $CatalogoChasisTable(this);
  late final $CatalogoNeumaticosTable catalogoNeumaticos =
      $CatalogoNeumaticosTable(this);
  late final $CatalogoEngranajesTable catalogoEngranajes =
      $CatalogoEngranajesTable(this);
  late final $CatalogoMotoresTable catalogoMotores = $CatalogoMotoresTable(
    this,
  );
  late final $CatalogoCopasTable catalogoCopas = $CatalogoCopasTable(this);
  late final $CatalogoClubsTable catalogoClubs = $CatalogoClubsTable(this);
  late final $HojasVinculadasTable hojasVinculadas = $HojasVinculadasTable(
    this,
  );
  late final $SyncColaTable syncCola = $SyncColaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    campeonatos,
    tablaPuntos,
    tablaBonificacion,
    pilotos,
    pilotoCampeonato,
    equipos,
    pruebas,
    mangas,
    inscripciones,
    inscripcionesPrueba,
    resultados,
    descartesPrueba,
    overridesCopa,
    catalogoCoches,
    verificaciones,
    pagos,
    movimientosTesoreria,
    movimientosCreditos,
    catalogoMarcas,
    catalogoLlantas,
    catalogoBancadas,
    catalogoChasis,
    catalogoNeumaticos,
    catalogoEngranajes,
    catalogoMotores,
    catalogoCopas,
    catalogoClubs,
    hojasVinculadas,
    syncCola,
  ];
}

typedef $$CampeonatosTableCreateCompanionBuilder =
    CampeonatosCompanion Function({
      Value<int> id,
      required String nombre,
      required String formato,
      required int anio,
      Value<String> organizacion,
      Value<bool> activo,
      Value<int> topeRegularizacion,
      Value<int> numDescartes,
      Value<bool> usaCreditos,
      Value<bool> usaTesoreria,
      Value<bool> finalizado,
      Value<String> copasJson,
      Value<double> cuotaPagat,
      Value<double> cuotaCoordinadora,
      Value<double> cuotaClub,
      Value<int?> motorSorteoMin,
      Value<int?> motorSorteoMax,
      Value<int> pinonDientesMin,
      Value<int> pinonDientesMax,
      Value<int> coronaDientesMin,
      Value<int> coronaDientesMax,
      Value<String?> marcaTitulo,
      Value<String?> marcaLema,
      Value<DateTime> creadoEn,
    });
typedef $$CampeonatosTableUpdateCompanionBuilder =
    CampeonatosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> formato,
      Value<int> anio,
      Value<String> organizacion,
      Value<bool> activo,
      Value<int> topeRegularizacion,
      Value<int> numDescartes,
      Value<bool> usaCreditos,
      Value<bool> usaTesoreria,
      Value<bool> finalizado,
      Value<String> copasJson,
      Value<double> cuotaPagat,
      Value<double> cuotaCoordinadora,
      Value<double> cuotaClub,
      Value<int?> motorSorteoMin,
      Value<int?> motorSorteoMax,
      Value<int> pinonDientesMin,
      Value<int> pinonDientesMax,
      Value<int> coronaDientesMin,
      Value<int> coronaDientesMax,
      Value<String?> marcaTitulo,
      Value<String?> marcaLema,
      Value<DateTime> creadoEn,
    });

final class $$CampeonatosTableReferences
    extends BaseReferences<_$AppDatabase, $CampeonatosTable, Campeonato> {
  $$CampeonatosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TablaPuntosTable, List<TablaPunto>>
  _tablaPuntosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tablaPuntos,
    aliasName: $_aliasNameGenerator(
      db.campeonatos.id,
      db.tablaPuntos.campeonatoId,
    ),
  );

  $$TablaPuntosTableProcessedTableManager get tablaPuntosRefs {
    final manager = $$TablaPuntosTableTableManager(
      $_db,
      $_db.tablaPuntos,
    ).filter((f) => f.campeonatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tablaPuntosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TablaBonificacionTable,
    List<TablaBonificacionData>
  >
  _tablaBonificacionRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tablaBonificacion,
        aliasName: $_aliasNameGenerator(
          db.campeonatos.id,
          db.tablaBonificacion.campeonatoId,
        ),
      );

  $$TablaBonificacionTableProcessedTableManager get tablaBonificacionRefs {
    final manager = $$TablaBonificacionTableTableManager(
      $_db,
      $_db.tablaBonificacion,
    ).filter((f) => f.campeonatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tablaBonificacionRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PilotoCampeonatoTable, List<PilotoCampeonatoData>>
  _pilotoCampeonatoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pilotoCampeonato,
    aliasName: $_aliasNameGenerator(
      db.campeonatos.id,
      db.pilotoCampeonato.campeonatoId,
    ),
  );

  $$PilotoCampeonatoTableProcessedTableManager get pilotoCampeonatoRefs {
    final manager = $$PilotoCampeonatoTableTableManager(
      $_db,
      $_db.pilotoCampeonato,
    ).filter((f) => f.campeonatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pilotoCampeonatoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EquiposTable, List<Equipo>> _equiposRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.equipos,
    aliasName: $_aliasNameGenerator(db.campeonatos.id, db.equipos.campeonatoId),
  );

  $$EquiposTableProcessedTableManager get equiposRefs {
    final manager = $$EquiposTableTableManager(
      $_db,
      $_db.equipos,
    ).filter((f) => f.campeonatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_equiposRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PruebasTable, List<Prueba>> _pruebasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pruebas,
    aliasName: $_aliasNameGenerator(db.campeonatos.id, db.pruebas.campeonatoId),
  );

  $$PruebasTableProcessedTableManager get pruebasRefs {
    final manager = $$PruebasTableTableManager(
      $_db,
      $_db.pruebas,
    ).filter((f) => f.campeonatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pruebasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OverridesCopaTable, List<OverridesCopaData>>
  _overridesCopaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.overridesCopa,
    aliasName: $_aliasNameGenerator(
      db.campeonatos.id,
      db.overridesCopa.campeonatoId,
    ),
  );

  $$OverridesCopaTableProcessedTableManager get overridesCopaRefs {
    final manager = $$OverridesCopaTableTableManager(
      $_db,
      $_db.overridesCopa,
    ).filter((f) => f.campeonatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_overridesCopaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovimientosTesoreriaTable,
    List<MovimientosTesoreriaData>
  >
  _movimientosTesoreriaRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosTesoreria,
        aliasName: $_aliasNameGenerator(
          db.campeonatos.id,
          db.movimientosTesoreria.campeonatoId,
        ),
      );

  $$MovimientosTesoreriaTableProcessedTableManager
  get movimientosTesoreriaRefs {
    final manager = $$MovimientosTesoreriaTableTableManager(
      $_db,
      $_db.movimientosTesoreria,
    ).filter((f) => f.campeonatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosTesoreriaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovimientosCreditosTable,
    List<MovimientosCredito>
  >
  _movimientosCreditosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosCreditos,
        aliasName: $_aliasNameGenerator(
          db.campeonatos.id,
          db.movimientosCreditos.campeonatoId,
        ),
      );

  $$MovimientosCreditosTableProcessedTableManager get movimientosCreditosRefs {
    final manager = $$MovimientosCreditosTableTableManager(
      $_db,
      $_db.movimientosCreditos,
    ).filter((f) => f.campeonatoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosCreditosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CampeonatosTableFilterComposer
    extends Composer<_$AppDatabase, $CampeonatosTable> {
  $$CampeonatosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formato => $composableBuilder(
    column: $table.formato,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anio => $composableBuilder(
    column: $table.anio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizacion => $composableBuilder(
    column: $table.organizacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get topeRegularizacion => $composableBuilder(
    column: $table.topeRegularizacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numDescartes => $composableBuilder(
    column: $table.numDescartes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get usaCreditos => $composableBuilder(
    column: $table.usaCreditos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get usaTesoreria => $composableBuilder(
    column: $table.usaTesoreria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get finalizado => $composableBuilder(
    column: $table.finalizado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cuotaPagat => $composableBuilder(
    column: $table.cuotaPagat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cuotaCoordinadora => $composableBuilder(
    column: $table.cuotaCoordinadora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cuotaClub => $composableBuilder(
    column: $table.cuotaClub,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motorSorteoMin => $composableBuilder(
    column: $table.motorSorteoMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motorSorteoMax => $composableBuilder(
    column: $table.motorSorteoMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinonDientesMin => $composableBuilder(
    column: $table.pinonDientesMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinonDientesMax => $composableBuilder(
    column: $table.pinonDientesMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coronaDientesMin => $composableBuilder(
    column: $table.coronaDientesMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coronaDientesMax => $composableBuilder(
    column: $table.coronaDientesMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marcaTitulo => $composableBuilder(
    column: $table.marcaTitulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marcaLema => $composableBuilder(
    column: $table.marcaLema,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tablaPuntosRefs(
    Expression<bool> Function($$TablaPuntosTableFilterComposer f) f,
  ) {
    final $$TablaPuntosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tablaPuntos,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablaPuntosTableFilterComposer(
            $db: $db,
            $table: $db.tablaPuntos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tablaBonificacionRefs(
    Expression<bool> Function($$TablaBonificacionTableFilterComposer f) f,
  ) {
    final $$TablaBonificacionTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tablaBonificacion,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablaBonificacionTableFilterComposer(
            $db: $db,
            $table: $db.tablaBonificacion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pilotoCampeonatoRefs(
    Expression<bool> Function($$PilotoCampeonatoTableFilterComposer f) f,
  ) {
    final $$PilotoCampeonatoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pilotoCampeonato,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotoCampeonatoTableFilterComposer(
            $db: $db,
            $table: $db.pilotoCampeonato,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> equiposRefs(
    Expression<bool> Function($$EquiposTableFilterComposer f) f,
  ) {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableFilterComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pruebasRefs(
    Expression<bool> Function($$PruebasTableFilterComposer f) f,
  ) {
    final $$PruebasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableFilterComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> overridesCopaRefs(
    Expression<bool> Function($$OverridesCopaTableFilterComposer f) f,
  ) {
    final $$OverridesCopaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overridesCopa,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverridesCopaTableFilterComposer(
            $db: $db,
            $table: $db.overridesCopa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosTesoreriaRefs(
    Expression<bool> Function($$MovimientosTesoreriaTableFilterComposer f) f,
  ) {
    final $$MovimientosTesoreriaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosTesoreria,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTesoreriaTableFilterComposer(
            $db: $db,
            $table: $db.movimientosTesoreria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosCreditosRefs(
    Expression<bool> Function($$MovimientosCreditosTableFilterComposer f) f,
  ) {
    final $$MovimientosCreditosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosCreditos,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosCreditosTableFilterComposer(
            $db: $db,
            $table: $db.movimientosCreditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CampeonatosTableOrderingComposer
    extends Composer<_$AppDatabase, $CampeonatosTable> {
  $$CampeonatosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formato => $composableBuilder(
    column: $table.formato,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anio => $composableBuilder(
    column: $table.anio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizacion => $composableBuilder(
    column: $table.organizacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get topeRegularizacion => $composableBuilder(
    column: $table.topeRegularizacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numDescartes => $composableBuilder(
    column: $table.numDescartes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get usaCreditos => $composableBuilder(
    column: $table.usaCreditos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get usaTesoreria => $composableBuilder(
    column: $table.usaTesoreria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get finalizado => $composableBuilder(
    column: $table.finalizado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cuotaPagat => $composableBuilder(
    column: $table.cuotaPagat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cuotaCoordinadora => $composableBuilder(
    column: $table.cuotaCoordinadora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cuotaClub => $composableBuilder(
    column: $table.cuotaClub,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motorSorteoMin => $composableBuilder(
    column: $table.motorSorteoMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motorSorteoMax => $composableBuilder(
    column: $table.motorSorteoMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinonDientesMin => $composableBuilder(
    column: $table.pinonDientesMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinonDientesMax => $composableBuilder(
    column: $table.pinonDientesMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coronaDientesMin => $composableBuilder(
    column: $table.coronaDientesMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coronaDientesMax => $composableBuilder(
    column: $table.coronaDientesMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marcaTitulo => $composableBuilder(
    column: $table.marcaTitulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marcaLema => $composableBuilder(
    column: $table.marcaLema,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CampeonatosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CampeonatosTable> {
  $$CampeonatosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get formato =>
      $composableBuilder(column: $table.formato, builder: (column) => column);

  GeneratedColumn<int> get anio =>
      $composableBuilder(column: $table.anio, builder: (column) => column);

  GeneratedColumn<String> get organizacion => $composableBuilder(
    column: $table.organizacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<int> get topeRegularizacion => $composableBuilder(
    column: $table.topeRegularizacion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numDescartes => $composableBuilder(
    column: $table.numDescartes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get usaCreditos => $composableBuilder(
    column: $table.usaCreditos,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get usaTesoreria => $composableBuilder(
    column: $table.usaTesoreria,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get finalizado => $composableBuilder(
    column: $table.finalizado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get copasJson =>
      $composableBuilder(column: $table.copasJson, builder: (column) => column);

  GeneratedColumn<double> get cuotaPagat => $composableBuilder(
    column: $table.cuotaPagat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cuotaCoordinadora => $composableBuilder(
    column: $table.cuotaCoordinadora,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cuotaClub =>
      $composableBuilder(column: $table.cuotaClub, builder: (column) => column);

  GeneratedColumn<int> get motorSorteoMin => $composableBuilder(
    column: $table.motorSorteoMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get motorSorteoMax => $composableBuilder(
    column: $table.motorSorteoMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pinonDientesMin => $composableBuilder(
    column: $table.pinonDientesMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pinonDientesMax => $composableBuilder(
    column: $table.pinonDientesMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coronaDientesMin => $composableBuilder(
    column: $table.coronaDientesMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coronaDientesMax => $composableBuilder(
    column: $table.coronaDientesMax,
    builder: (column) => column,
  );

  GeneratedColumn<String> get marcaTitulo => $composableBuilder(
    column: $table.marcaTitulo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get marcaLema =>
      $composableBuilder(column: $table.marcaLema, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> tablaPuntosRefs<T extends Object>(
    Expression<T> Function($$TablaPuntosTableAnnotationComposer a) f,
  ) {
    final $$TablaPuntosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tablaPuntos,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablaPuntosTableAnnotationComposer(
            $db: $db,
            $table: $db.tablaPuntos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tablaBonificacionRefs<T extends Object>(
    Expression<T> Function($$TablaBonificacionTableAnnotationComposer a) f,
  ) {
    final $$TablaBonificacionTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tablaBonificacion,
          getReferencedColumn: (t) => t.campeonatoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TablaBonificacionTableAnnotationComposer(
                $db: $db,
                $table: $db.tablaBonificacion,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> pilotoCampeonatoRefs<T extends Object>(
    Expression<T> Function($$PilotoCampeonatoTableAnnotationComposer a) f,
  ) {
    final $$PilotoCampeonatoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pilotoCampeonato,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotoCampeonatoTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotoCampeonato,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> equiposRefs<T extends Object>(
    Expression<T> Function($$EquiposTableAnnotationComposer a) f,
  ) {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableAnnotationComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pruebasRefs<T extends Object>(
    Expression<T> Function($$PruebasTableAnnotationComposer a) f,
  ) {
    final $$PruebasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableAnnotationComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> overridesCopaRefs<T extends Object>(
    Expression<T> Function($$OverridesCopaTableAnnotationComposer a) f,
  ) {
    final $$OverridesCopaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overridesCopa,
      getReferencedColumn: (t) => t.campeonatoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverridesCopaTableAnnotationComposer(
            $db: $db,
            $table: $db.overridesCopa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosTesoreriaRefs<T extends Object>(
    Expression<T> Function($$MovimientosTesoreriaTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTesoreriaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosTesoreria,
          getReferencedColumn: (t) => t.campeonatoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosTesoreriaTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosTesoreria,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> movimientosCreditosRefs<T extends Object>(
    Expression<T> Function($$MovimientosCreditosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosCreditosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosCreditos,
          getReferencedColumn: (t) => t.campeonatoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosCreditosTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosCreditos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CampeonatosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CampeonatosTable,
          Campeonato,
          $$CampeonatosTableFilterComposer,
          $$CampeonatosTableOrderingComposer,
          $$CampeonatosTableAnnotationComposer,
          $$CampeonatosTableCreateCompanionBuilder,
          $$CampeonatosTableUpdateCompanionBuilder,
          (Campeonato, $$CampeonatosTableReferences),
          Campeonato,
          PrefetchHooks Function({
            bool tablaPuntosRefs,
            bool tablaBonificacionRefs,
            bool pilotoCampeonatoRefs,
            bool equiposRefs,
            bool pruebasRefs,
            bool overridesCopaRefs,
            bool movimientosTesoreriaRefs,
            bool movimientosCreditosRefs,
          })
        > {
  $$CampeonatosTableTableManager(_$AppDatabase db, $CampeonatosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CampeonatosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CampeonatosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CampeonatosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> formato = const Value.absent(),
                Value<int> anio = const Value.absent(),
                Value<String> organizacion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> topeRegularizacion = const Value.absent(),
                Value<int> numDescartes = const Value.absent(),
                Value<bool> usaCreditos = const Value.absent(),
                Value<bool> usaTesoreria = const Value.absent(),
                Value<bool> finalizado = const Value.absent(),
                Value<String> copasJson = const Value.absent(),
                Value<double> cuotaPagat = const Value.absent(),
                Value<double> cuotaCoordinadora = const Value.absent(),
                Value<double> cuotaClub = const Value.absent(),
                Value<int?> motorSorteoMin = const Value.absent(),
                Value<int?> motorSorteoMax = const Value.absent(),
                Value<int> pinonDientesMin = const Value.absent(),
                Value<int> pinonDientesMax = const Value.absent(),
                Value<int> coronaDientesMin = const Value.absent(),
                Value<int> coronaDientesMax = const Value.absent(),
                Value<String?> marcaTitulo = const Value.absent(),
                Value<String?> marcaLema = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => CampeonatosCompanion(
                id: id,
                nombre: nombre,
                formato: formato,
                anio: anio,
                organizacion: organizacion,
                activo: activo,
                topeRegularizacion: topeRegularizacion,
                numDescartes: numDescartes,
                usaCreditos: usaCreditos,
                usaTesoreria: usaTesoreria,
                finalizado: finalizado,
                copasJson: copasJson,
                cuotaPagat: cuotaPagat,
                cuotaCoordinadora: cuotaCoordinadora,
                cuotaClub: cuotaClub,
                motorSorteoMin: motorSorteoMin,
                motorSorteoMax: motorSorteoMax,
                pinonDientesMin: pinonDientesMin,
                pinonDientesMax: pinonDientesMax,
                coronaDientesMin: coronaDientesMin,
                coronaDientesMax: coronaDientesMax,
                marcaTitulo: marcaTitulo,
                marcaLema: marcaLema,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String formato,
                required int anio,
                Value<String> organizacion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> topeRegularizacion = const Value.absent(),
                Value<int> numDescartes = const Value.absent(),
                Value<bool> usaCreditos = const Value.absent(),
                Value<bool> usaTesoreria = const Value.absent(),
                Value<bool> finalizado = const Value.absent(),
                Value<String> copasJson = const Value.absent(),
                Value<double> cuotaPagat = const Value.absent(),
                Value<double> cuotaCoordinadora = const Value.absent(),
                Value<double> cuotaClub = const Value.absent(),
                Value<int?> motorSorteoMin = const Value.absent(),
                Value<int?> motorSorteoMax = const Value.absent(),
                Value<int> pinonDientesMin = const Value.absent(),
                Value<int> pinonDientesMax = const Value.absent(),
                Value<int> coronaDientesMin = const Value.absent(),
                Value<int> coronaDientesMax = const Value.absent(),
                Value<String?> marcaTitulo = const Value.absent(),
                Value<String?> marcaLema = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => CampeonatosCompanion.insert(
                id: id,
                nombre: nombre,
                formato: formato,
                anio: anio,
                organizacion: organizacion,
                activo: activo,
                topeRegularizacion: topeRegularizacion,
                numDescartes: numDescartes,
                usaCreditos: usaCreditos,
                usaTesoreria: usaTesoreria,
                finalizado: finalizado,
                copasJson: copasJson,
                cuotaPagat: cuotaPagat,
                cuotaCoordinadora: cuotaCoordinadora,
                cuotaClub: cuotaClub,
                motorSorteoMin: motorSorteoMin,
                motorSorteoMax: motorSorteoMax,
                pinonDientesMin: pinonDientesMin,
                pinonDientesMax: pinonDientesMax,
                coronaDientesMin: coronaDientesMin,
                coronaDientesMax: coronaDientesMax,
                marcaTitulo: marcaTitulo,
                marcaLema: marcaLema,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CampeonatosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tablaPuntosRefs = false,
                tablaBonificacionRefs = false,
                pilotoCampeonatoRefs = false,
                equiposRefs = false,
                pruebasRefs = false,
                overridesCopaRefs = false,
                movimientosTesoreriaRefs = false,
                movimientosCreditosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tablaPuntosRefs) db.tablaPuntos,
                    if (tablaBonificacionRefs) db.tablaBonificacion,
                    if (pilotoCampeonatoRefs) db.pilotoCampeonato,
                    if (equiposRefs) db.equipos,
                    if (pruebasRefs) db.pruebas,
                    if (overridesCopaRefs) db.overridesCopa,
                    if (movimientosTesoreriaRefs) db.movimientosTesoreria,
                    if (movimientosCreditosRefs) db.movimientosCreditos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tablaPuntosRefs)
                        await $_getPrefetchedData<
                          Campeonato,
                          $CampeonatosTable,
                          TablaPunto
                        >(
                          currentTable: table,
                          referencedTable: $$CampeonatosTableReferences
                              ._tablaPuntosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CampeonatosTableReferences(
                                db,
                                table,
                                p0,
                              ).tablaPuntosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.campeonatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tablaBonificacionRefs)
                        await $_getPrefetchedData<
                          Campeonato,
                          $CampeonatosTable,
                          TablaBonificacionData
                        >(
                          currentTable: table,
                          referencedTable: $$CampeonatosTableReferences
                              ._tablaBonificacionRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CampeonatosTableReferences(
                                db,
                                table,
                                p0,
                              ).tablaBonificacionRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.campeonatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pilotoCampeonatoRefs)
                        await $_getPrefetchedData<
                          Campeonato,
                          $CampeonatosTable,
                          PilotoCampeonatoData
                        >(
                          currentTable: table,
                          referencedTable: $$CampeonatosTableReferences
                              ._pilotoCampeonatoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CampeonatosTableReferences(
                                db,
                                table,
                                p0,
                              ).pilotoCampeonatoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.campeonatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (equiposRefs)
                        await $_getPrefetchedData<
                          Campeonato,
                          $CampeonatosTable,
                          Equipo
                        >(
                          currentTable: table,
                          referencedTable: $$CampeonatosTableReferences
                              ._equiposRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CampeonatosTableReferences(
                                db,
                                table,
                                p0,
                              ).equiposRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.campeonatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pruebasRefs)
                        await $_getPrefetchedData<
                          Campeonato,
                          $CampeonatosTable,
                          Prueba
                        >(
                          currentTable: table,
                          referencedTable: $$CampeonatosTableReferences
                              ._pruebasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CampeonatosTableReferences(
                                db,
                                table,
                                p0,
                              ).pruebasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.campeonatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (overridesCopaRefs)
                        await $_getPrefetchedData<
                          Campeonato,
                          $CampeonatosTable,
                          OverridesCopaData
                        >(
                          currentTable: table,
                          referencedTable: $$CampeonatosTableReferences
                              ._overridesCopaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CampeonatosTableReferences(
                                db,
                                table,
                                p0,
                              ).overridesCopaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.campeonatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosTesoreriaRefs)
                        await $_getPrefetchedData<
                          Campeonato,
                          $CampeonatosTable,
                          MovimientosTesoreriaData
                        >(
                          currentTable: table,
                          referencedTable: $$CampeonatosTableReferences
                              ._movimientosTesoreriaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CampeonatosTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosTesoreriaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.campeonatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosCreditosRefs)
                        await $_getPrefetchedData<
                          Campeonato,
                          $CampeonatosTable,
                          MovimientosCredito
                        >(
                          currentTable: table,
                          referencedTable: $$CampeonatosTableReferences
                              ._movimientosCreditosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CampeonatosTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosCreditosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.campeonatoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CampeonatosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CampeonatosTable,
      Campeonato,
      $$CampeonatosTableFilterComposer,
      $$CampeonatosTableOrderingComposer,
      $$CampeonatosTableAnnotationComposer,
      $$CampeonatosTableCreateCompanionBuilder,
      $$CampeonatosTableUpdateCompanionBuilder,
      (Campeonato, $$CampeonatosTableReferences),
      Campeonato,
      PrefetchHooks Function({
        bool tablaPuntosRefs,
        bool tablaBonificacionRefs,
        bool pilotoCampeonatoRefs,
        bool equiposRefs,
        bool pruebasRefs,
        bool overridesCopaRefs,
        bool movimientosTesoreriaRefs,
        bool movimientosCreditosRefs,
      })
    >;
typedef $$TablaPuntosTableCreateCompanionBuilder =
    TablaPuntosCompanion Function({
      required int campeonatoId,
      required int posicion,
      required int puntos,
      Value<int> rowid,
    });
typedef $$TablaPuntosTableUpdateCompanionBuilder =
    TablaPuntosCompanion Function({
      Value<int> campeonatoId,
      Value<int> posicion,
      Value<int> puntos,
      Value<int> rowid,
    });

final class $$TablaPuntosTableReferences
    extends BaseReferences<_$AppDatabase, $TablaPuntosTable, TablaPunto> {
  $$TablaPuntosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CampeonatosTable _campeonatoIdTable(_$AppDatabase db) =>
      db.campeonatos.createAlias(
        $_aliasNameGenerator(db.tablaPuntos.campeonatoId, db.campeonatos.id),
      );

  $$CampeonatosTableProcessedTableManager get campeonatoId {
    final $_column = $_itemColumn<int>('campeonato_id')!;

    final manager = $$CampeonatosTableTableManager(
      $_db,
      $_db.campeonatos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campeonatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TablaPuntosTableFilterComposer
    extends Composer<_$AppDatabase, $TablaPuntosTable> {
  $$TablaPuntosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get posicion => $composableBuilder(
    column: $table.posicion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get puntos => $composableBuilder(
    column: $table.puntos,
    builder: (column) => ColumnFilters(column),
  );

  $$CampeonatosTableFilterComposer get campeonatoId {
    final $$CampeonatosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableFilterComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablaPuntosTableOrderingComposer
    extends Composer<_$AppDatabase, $TablaPuntosTable> {
  $$TablaPuntosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get posicion => $composableBuilder(
    column: $table.posicion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get puntos => $composableBuilder(
    column: $table.puntos,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampeonatosTableOrderingComposer get campeonatoId {
    final $$CampeonatosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableOrderingComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablaPuntosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TablaPuntosTable> {
  $$TablaPuntosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get posicion =>
      $composableBuilder(column: $table.posicion, builder: (column) => column);

  GeneratedColumn<int> get puntos =>
      $composableBuilder(column: $table.puntos, builder: (column) => column);

  $$CampeonatosTableAnnotationComposer get campeonatoId {
    final $$CampeonatosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableAnnotationComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablaPuntosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TablaPuntosTable,
          TablaPunto,
          $$TablaPuntosTableFilterComposer,
          $$TablaPuntosTableOrderingComposer,
          $$TablaPuntosTableAnnotationComposer,
          $$TablaPuntosTableCreateCompanionBuilder,
          $$TablaPuntosTableUpdateCompanionBuilder,
          (TablaPunto, $$TablaPuntosTableReferences),
          TablaPunto,
          PrefetchHooks Function({bool campeonatoId})
        > {
  $$TablaPuntosTableTableManager(_$AppDatabase db, $TablaPuntosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TablaPuntosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TablaPuntosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TablaPuntosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> campeonatoId = const Value.absent(),
                Value<int> posicion = const Value.absent(),
                Value<int> puntos = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TablaPuntosCompanion(
                campeonatoId: campeonatoId,
                posicion: posicion,
                puntos: puntos,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int campeonatoId,
                required int posicion,
                required int puntos,
                Value<int> rowid = const Value.absent(),
              }) => TablaPuntosCompanion.insert(
                campeonatoId: campeonatoId,
                posicion: posicion,
                puntos: puntos,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TablaPuntosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({campeonatoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (campeonatoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.campeonatoId,
                                referencedTable: $$TablaPuntosTableReferences
                                    ._campeonatoIdTable(db),
                                referencedColumn: $$TablaPuntosTableReferences
                                    ._campeonatoIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TablaPuntosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TablaPuntosTable,
      TablaPunto,
      $$TablaPuntosTableFilterComposer,
      $$TablaPuntosTableOrderingComposer,
      $$TablaPuntosTableAnnotationComposer,
      $$TablaPuntosTableCreateCompanionBuilder,
      $$TablaPuntosTableUpdateCompanionBuilder,
      (TablaPunto, $$TablaPuntosTableReferences),
      TablaPunto,
      PrefetchHooks Function({bool campeonatoId})
    >;
typedef $$TablaBonificacionTableCreateCompanionBuilder =
    TablaBonificacionCompanion Function({
      required int campeonatoId,
      required String categoria,
      required int carrerasMin,
      required int carrerasMax,
      required int bonificacion,
      Value<int> rowid,
    });
typedef $$TablaBonificacionTableUpdateCompanionBuilder =
    TablaBonificacionCompanion Function({
      Value<int> campeonatoId,
      Value<String> categoria,
      Value<int> carrerasMin,
      Value<int> carrerasMax,
      Value<int> bonificacion,
      Value<int> rowid,
    });

final class $$TablaBonificacionTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TablaBonificacionTable,
          TablaBonificacionData
        > {
  $$TablaBonificacionTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CampeonatosTable _campeonatoIdTable(_$AppDatabase db) =>
      db.campeonatos.createAlias(
        $_aliasNameGenerator(
          db.tablaBonificacion.campeonatoId,
          db.campeonatos.id,
        ),
      );

  $$CampeonatosTableProcessedTableManager get campeonatoId {
    final $_column = $_itemColumn<int>('campeonato_id')!;

    final manager = $$CampeonatosTableTableManager(
      $_db,
      $_db.campeonatos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campeonatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TablaBonificacionTableFilterComposer
    extends Composer<_$AppDatabase, $TablaBonificacionTable> {
  $$TablaBonificacionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carrerasMin => $composableBuilder(
    column: $table.carrerasMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carrerasMax => $composableBuilder(
    column: $table.carrerasMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonificacion => $composableBuilder(
    column: $table.bonificacion,
    builder: (column) => ColumnFilters(column),
  );

  $$CampeonatosTableFilterComposer get campeonatoId {
    final $$CampeonatosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableFilterComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablaBonificacionTableOrderingComposer
    extends Composer<_$AppDatabase, $TablaBonificacionTable> {
  $$TablaBonificacionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carrerasMin => $composableBuilder(
    column: $table.carrerasMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carrerasMax => $composableBuilder(
    column: $table.carrerasMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonificacion => $composableBuilder(
    column: $table.bonificacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampeonatosTableOrderingComposer get campeonatoId {
    final $$CampeonatosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableOrderingComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablaBonificacionTableAnnotationComposer
    extends Composer<_$AppDatabase, $TablaBonificacionTable> {
  $$TablaBonificacionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<int> get carrerasMin => $composableBuilder(
    column: $table.carrerasMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get carrerasMax => $composableBuilder(
    column: $table.carrerasMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonificacion => $composableBuilder(
    column: $table.bonificacion,
    builder: (column) => column,
  );

  $$CampeonatosTableAnnotationComposer get campeonatoId {
    final $$CampeonatosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableAnnotationComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablaBonificacionTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TablaBonificacionTable,
          TablaBonificacionData,
          $$TablaBonificacionTableFilterComposer,
          $$TablaBonificacionTableOrderingComposer,
          $$TablaBonificacionTableAnnotationComposer,
          $$TablaBonificacionTableCreateCompanionBuilder,
          $$TablaBonificacionTableUpdateCompanionBuilder,
          (TablaBonificacionData, $$TablaBonificacionTableReferences),
          TablaBonificacionData,
          PrefetchHooks Function({bool campeonatoId})
        > {
  $$TablaBonificacionTableTableManager(
    _$AppDatabase db,
    $TablaBonificacionTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TablaBonificacionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TablaBonificacionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TablaBonificacionTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> campeonatoId = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<int> carrerasMin = const Value.absent(),
                Value<int> carrerasMax = const Value.absent(),
                Value<int> bonificacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TablaBonificacionCompanion(
                campeonatoId: campeonatoId,
                categoria: categoria,
                carrerasMin: carrerasMin,
                carrerasMax: carrerasMax,
                bonificacion: bonificacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int campeonatoId,
                required String categoria,
                required int carrerasMin,
                required int carrerasMax,
                required int bonificacion,
                Value<int> rowid = const Value.absent(),
              }) => TablaBonificacionCompanion.insert(
                campeonatoId: campeonatoId,
                categoria: categoria,
                carrerasMin: carrerasMin,
                carrerasMax: carrerasMax,
                bonificacion: bonificacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TablaBonificacionTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({campeonatoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (campeonatoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.campeonatoId,
                                referencedTable:
                                    $$TablaBonificacionTableReferences
                                        ._campeonatoIdTable(db),
                                referencedColumn:
                                    $$TablaBonificacionTableReferences
                                        ._campeonatoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TablaBonificacionTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TablaBonificacionTable,
      TablaBonificacionData,
      $$TablaBonificacionTableFilterComposer,
      $$TablaBonificacionTableOrderingComposer,
      $$TablaBonificacionTableAnnotationComposer,
      $$TablaBonificacionTableCreateCompanionBuilder,
      $$TablaBonificacionTableUpdateCompanionBuilder,
      (TablaBonificacionData, $$TablaBonificacionTableReferences),
      TablaBonificacionData,
      PrefetchHooks Function({bool campeonatoId})
    >;
typedef $$PilotosTableCreateCompanionBuilder =
    PilotosCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> palmaresGlobal,
      Value<String?> telefono,
      Value<String?> email,
      Value<bool> esCoordinadora,
      Value<DateTime> creadoEn,
    });
typedef $$PilotosTableUpdateCompanionBuilder =
    PilotosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> palmaresGlobal,
      Value<String?> telefono,
      Value<String?> email,
      Value<bool> esCoordinadora,
      Value<DateTime> creadoEn,
    });

final class $$PilotosTableReferences
    extends BaseReferences<_$AppDatabase, $PilotosTable, Piloto> {
  $$PilotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PilotoCampeonatoTable, List<PilotoCampeonatoData>>
  _pilotoCampeonatoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pilotoCampeonato,
    aliasName: $_aliasNameGenerator(
      db.pilotos.id,
      db.pilotoCampeonato.pilotoId,
    ),
  );

  $$PilotoCampeonatoTableProcessedTableManager get pilotoCampeonatoRefs {
    final manager = $$PilotoCampeonatoTableTableManager(
      $_db,
      $_db.pilotoCampeonato,
    ).filter((f) => f.pilotoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pilotoCampeonatoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResultadosTable, List<Resultado>>
  _resultadosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.resultados,
    aliasName: $_aliasNameGenerator(db.pilotos.id, db.resultados.pilotoId),
  );

  $$ResultadosTableProcessedTableManager get resultadosRefs {
    final manager = $$ResultadosTableTableManager(
      $_db,
      $_db.resultados,
    ).filter((f) => f.pilotoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_resultadosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DescartesPruebaTable, List<DescartesPruebaData>>
  _descartesPruebaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.descartesPrueba,
    aliasName: $_aliasNameGenerator(db.pilotos.id, db.descartesPrueba.pilotoId),
  );

  $$DescartesPruebaTableProcessedTableManager get descartesPruebaRefs {
    final manager = $$DescartesPruebaTableTableManager(
      $_db,
      $_db.descartesPrueba,
    ).filter((f) => f.pilotoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _descartesPruebaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OverridesCopaTable, List<OverridesCopaData>>
  _overridesCopaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.overridesCopa,
    aliasName: $_aliasNameGenerator(db.pilotos.id, db.overridesCopa.pilotoId),
  );

  $$OverridesCopaTableProcessedTableManager get overridesCopaRefs {
    final manager = $$OverridesCopaTableTableManager(
      $_db,
      $_db.overridesCopa,
    ).filter((f) => f.pilotoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_overridesCopaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovimientosCreditosTable,
    List<MovimientosCredito>
  >
  _movimientosCreditosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosCreditos,
        aliasName: $_aliasNameGenerator(
          db.pilotos.id,
          db.movimientosCreditos.pilotoId,
        ),
      );

  $$MovimientosCreditosTableProcessedTableManager get movimientosCreditosRefs {
    final manager = $$MovimientosCreditosTableTableManager(
      $_db,
      $_db.movimientosCreditos,
    ).filter((f) => f.pilotoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosCreditosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PilotosTableFilterComposer
    extends Composer<_$AppDatabase, $PilotosTable> {
  $$PilotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get palmaresGlobal => $composableBuilder(
    column: $table.palmaresGlobal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esCoordinadora => $composableBuilder(
    column: $table.esCoordinadora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pilotoCampeonatoRefs(
    Expression<bool> Function($$PilotoCampeonatoTableFilterComposer f) f,
  ) {
    final $$PilotoCampeonatoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pilotoCampeonato,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotoCampeonatoTableFilterComposer(
            $db: $db,
            $table: $db.pilotoCampeonato,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> resultadosRefs(
    Expression<bool> Function($$ResultadosTableFilterComposer f) f,
  ) {
    final $$ResultadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableFilterComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> descartesPruebaRefs(
    Expression<bool> Function($$DescartesPruebaTableFilterComposer f) f,
  ) {
    final $$DescartesPruebaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.descartesPrueba,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DescartesPruebaTableFilterComposer(
            $db: $db,
            $table: $db.descartesPrueba,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> overridesCopaRefs(
    Expression<bool> Function($$OverridesCopaTableFilterComposer f) f,
  ) {
    final $$OverridesCopaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overridesCopa,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverridesCopaTableFilterComposer(
            $db: $db,
            $table: $db.overridesCopa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosCreditosRefs(
    Expression<bool> Function($$MovimientosCreditosTableFilterComposer f) f,
  ) {
    final $$MovimientosCreditosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosCreditos,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosCreditosTableFilterComposer(
            $db: $db,
            $table: $db.movimientosCreditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PilotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PilotosTable> {
  $$PilotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get palmaresGlobal => $composableBuilder(
    column: $table.palmaresGlobal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esCoordinadora => $composableBuilder(
    column: $table.esCoordinadora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PilotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PilotosTable> {
  $$PilotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get palmaresGlobal => $composableBuilder(
    column: $table.palmaresGlobal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get esCoordinadora => $composableBuilder(
    column: $table.esCoordinadora,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> pilotoCampeonatoRefs<T extends Object>(
    Expression<T> Function($$PilotoCampeonatoTableAnnotationComposer a) f,
  ) {
    final $$PilotoCampeonatoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pilotoCampeonato,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotoCampeonatoTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotoCampeonato,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> resultadosRefs<T extends Object>(
    Expression<T> Function($$ResultadosTableAnnotationComposer a) f,
  ) {
    final $$ResultadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableAnnotationComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> descartesPruebaRefs<T extends Object>(
    Expression<T> Function($$DescartesPruebaTableAnnotationComposer a) f,
  ) {
    final $$DescartesPruebaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.descartesPrueba,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DescartesPruebaTableAnnotationComposer(
            $db: $db,
            $table: $db.descartesPrueba,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> overridesCopaRefs<T extends Object>(
    Expression<T> Function($$OverridesCopaTableAnnotationComposer a) f,
  ) {
    final $$OverridesCopaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overridesCopa,
      getReferencedColumn: (t) => t.pilotoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverridesCopaTableAnnotationComposer(
            $db: $db,
            $table: $db.overridesCopa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosCreditosRefs<T extends Object>(
    Expression<T> Function($$MovimientosCreditosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosCreditosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosCreditos,
          getReferencedColumn: (t) => t.pilotoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosCreditosTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosCreditos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PilotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PilotosTable,
          Piloto,
          $$PilotosTableFilterComposer,
          $$PilotosTableOrderingComposer,
          $$PilotosTableAnnotationComposer,
          $$PilotosTableCreateCompanionBuilder,
          $$PilotosTableUpdateCompanionBuilder,
          (Piloto, $$PilotosTableReferences),
          Piloto,
          PrefetchHooks Function({
            bool pilotoCampeonatoRefs,
            bool resultadosRefs,
            bool descartesPruebaRefs,
            bool overridesCopaRefs,
            bool movimientosCreditosRefs,
          })
        > {
  $$PilotosTableTableManager(_$AppDatabase db, $PilotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PilotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PilotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PilotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> palmaresGlobal = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> esCoordinadora = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => PilotosCompanion(
                id: id,
                nombre: nombre,
                palmaresGlobal: palmaresGlobal,
                telefono: telefono,
                email: email,
                esCoordinadora: esCoordinadora,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> palmaresGlobal = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> esCoordinadora = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => PilotosCompanion.insert(
                id: id,
                nombre: nombre,
                palmaresGlobal: palmaresGlobal,
                telefono: telefono,
                email: email,
                esCoordinadora: esCoordinadora,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PilotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                pilotoCampeonatoRefs = false,
                resultadosRefs = false,
                descartesPruebaRefs = false,
                overridesCopaRefs = false,
                movimientosCreditosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pilotoCampeonatoRefs) db.pilotoCampeonato,
                    if (resultadosRefs) db.resultados,
                    if (descartesPruebaRefs) db.descartesPrueba,
                    if (overridesCopaRefs) db.overridesCopa,
                    if (movimientosCreditosRefs) db.movimientosCreditos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pilotoCampeonatoRefs)
                        await $_getPrefetchedData<
                          Piloto,
                          $PilotosTable,
                          PilotoCampeonatoData
                        >(
                          currentTable: table,
                          referencedTable: $$PilotosTableReferences
                              ._pilotoCampeonatoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PilotosTableReferences(
                                db,
                                table,
                                p0,
                              ).pilotoCampeonatoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pilotoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (resultadosRefs)
                        await $_getPrefetchedData<
                          Piloto,
                          $PilotosTable,
                          Resultado
                        >(
                          currentTable: table,
                          referencedTable: $$PilotosTableReferences
                              ._resultadosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PilotosTableReferences(
                                db,
                                table,
                                p0,
                              ).resultadosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pilotoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (descartesPruebaRefs)
                        await $_getPrefetchedData<
                          Piloto,
                          $PilotosTable,
                          DescartesPruebaData
                        >(
                          currentTable: table,
                          referencedTable: $$PilotosTableReferences
                              ._descartesPruebaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PilotosTableReferences(
                                db,
                                table,
                                p0,
                              ).descartesPruebaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pilotoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (overridesCopaRefs)
                        await $_getPrefetchedData<
                          Piloto,
                          $PilotosTable,
                          OverridesCopaData
                        >(
                          currentTable: table,
                          referencedTable: $$PilotosTableReferences
                              ._overridesCopaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PilotosTableReferences(
                                db,
                                table,
                                p0,
                              ).overridesCopaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pilotoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosCreditosRefs)
                        await $_getPrefetchedData<
                          Piloto,
                          $PilotosTable,
                          MovimientosCredito
                        >(
                          currentTable: table,
                          referencedTable: $$PilotosTableReferences
                              ._movimientosCreditosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PilotosTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosCreditosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pilotoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PilotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PilotosTable,
      Piloto,
      $$PilotosTableFilterComposer,
      $$PilotosTableOrderingComposer,
      $$PilotosTableAnnotationComposer,
      $$PilotosTableCreateCompanionBuilder,
      $$PilotosTableUpdateCompanionBuilder,
      (Piloto, $$PilotosTableReferences),
      Piloto,
      PrefetchHooks Function({
        bool pilotoCampeonatoRefs,
        bool resultadosRefs,
        bool descartesPruebaRefs,
        bool overridesCopaRefs,
        bool movimientosCreditosRefs,
      })
    >;
typedef $$PilotoCampeonatoTableCreateCompanionBuilder =
    PilotoCampeonatoCompanion Function({
      required int pilotoId,
      required int campeonatoId,
      required String categoria,
      Value<String?> categoriaFinal,
      required int creditosIniciales,
      required int creditosActuales,
      Value<int> saldoTemporadaAnterior,
      Value<int> bonificacionAplicada,
      Value<String?> palmaresLocal,
      Value<int> rowid,
    });
typedef $$PilotoCampeonatoTableUpdateCompanionBuilder =
    PilotoCampeonatoCompanion Function({
      Value<int> pilotoId,
      Value<int> campeonatoId,
      Value<String> categoria,
      Value<String?> categoriaFinal,
      Value<int> creditosIniciales,
      Value<int> creditosActuales,
      Value<int> saldoTemporadaAnterior,
      Value<int> bonificacionAplicada,
      Value<String?> palmaresLocal,
      Value<int> rowid,
    });

final class $$PilotoCampeonatoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PilotoCampeonatoTable,
          PilotoCampeonatoData
        > {
  $$PilotoCampeonatoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PilotosTable _pilotoIdTable(_$AppDatabase db) =>
      db.pilotos.createAlias(
        $_aliasNameGenerator(db.pilotoCampeonato.pilotoId, db.pilotos.id),
      );

  $$PilotosTableProcessedTableManager get pilotoId {
    final $_column = $_itemColumn<int>('piloto_id')!;

    final manager = $$PilotosTableTableManager(
      $_db,
      $_db.pilotos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pilotoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CampeonatosTable _campeonatoIdTable(_$AppDatabase db) =>
      db.campeonatos.createAlias(
        $_aliasNameGenerator(
          db.pilotoCampeonato.campeonatoId,
          db.campeonatos.id,
        ),
      );

  $$CampeonatosTableProcessedTableManager get campeonatoId {
    final $_column = $_itemColumn<int>('campeonato_id')!;

    final manager = $$CampeonatosTableTableManager(
      $_db,
      $_db.campeonatos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campeonatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PilotoCampeonatoTableFilterComposer
    extends Composer<_$AppDatabase, $PilotoCampeonatoTable> {
  $$PilotoCampeonatoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoriaFinal => $composableBuilder(
    column: $table.categoriaFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditosIniciales => $composableBuilder(
    column: $table.creditosIniciales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditosActuales => $composableBuilder(
    column: $table.creditosActuales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saldoTemporadaAnterior => $composableBuilder(
    column: $table.saldoTemporadaAnterior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonificacionAplicada => $composableBuilder(
    column: $table.bonificacionAplicada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get palmaresLocal => $composableBuilder(
    column: $table.palmaresLocal,
    builder: (column) => ColumnFilters(column),
  );

  $$PilotosTableFilterComposer get pilotoId {
    final $$PilotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableFilterComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CampeonatosTableFilterComposer get campeonatoId {
    final $$CampeonatosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableFilterComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PilotoCampeonatoTableOrderingComposer
    extends Composer<_$AppDatabase, $PilotoCampeonatoTable> {
  $$PilotoCampeonatoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoriaFinal => $composableBuilder(
    column: $table.categoriaFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditosIniciales => $composableBuilder(
    column: $table.creditosIniciales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditosActuales => $composableBuilder(
    column: $table.creditosActuales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saldoTemporadaAnterior => $composableBuilder(
    column: $table.saldoTemporadaAnterior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonificacionAplicada => $composableBuilder(
    column: $table.bonificacionAplicada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get palmaresLocal => $composableBuilder(
    column: $table.palmaresLocal,
    builder: (column) => ColumnOrderings(column),
  );

  $$PilotosTableOrderingComposer get pilotoId {
    final $$PilotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableOrderingComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CampeonatosTableOrderingComposer get campeonatoId {
    final $$CampeonatosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableOrderingComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PilotoCampeonatoTableAnnotationComposer
    extends Composer<_$AppDatabase, $PilotoCampeonatoTable> {
  $$PilotoCampeonatoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get categoriaFinal => $composableBuilder(
    column: $table.categoriaFinal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditosIniciales => $composableBuilder(
    column: $table.creditosIniciales,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditosActuales => $composableBuilder(
    column: $table.creditosActuales,
    builder: (column) => column,
  );

  GeneratedColumn<int> get saldoTemporadaAnterior => $composableBuilder(
    column: $table.saldoTemporadaAnterior,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonificacionAplicada => $composableBuilder(
    column: $table.bonificacionAplicada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get palmaresLocal => $composableBuilder(
    column: $table.palmaresLocal,
    builder: (column) => column,
  );

  $$PilotosTableAnnotationComposer get pilotoId {
    final $$PilotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CampeonatosTableAnnotationComposer get campeonatoId {
    final $$CampeonatosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableAnnotationComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PilotoCampeonatoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PilotoCampeonatoTable,
          PilotoCampeonatoData,
          $$PilotoCampeonatoTableFilterComposer,
          $$PilotoCampeonatoTableOrderingComposer,
          $$PilotoCampeonatoTableAnnotationComposer,
          $$PilotoCampeonatoTableCreateCompanionBuilder,
          $$PilotoCampeonatoTableUpdateCompanionBuilder,
          (PilotoCampeonatoData, $$PilotoCampeonatoTableReferences),
          PilotoCampeonatoData,
          PrefetchHooks Function({bool pilotoId, bool campeonatoId})
        > {
  $$PilotoCampeonatoTableTableManager(
    _$AppDatabase db,
    $PilotoCampeonatoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PilotoCampeonatoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PilotoCampeonatoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PilotoCampeonatoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> pilotoId = const Value.absent(),
                Value<int> campeonatoId = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<String?> categoriaFinal = const Value.absent(),
                Value<int> creditosIniciales = const Value.absent(),
                Value<int> creditosActuales = const Value.absent(),
                Value<int> saldoTemporadaAnterior = const Value.absent(),
                Value<int> bonificacionAplicada = const Value.absent(),
                Value<String?> palmaresLocal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PilotoCampeonatoCompanion(
                pilotoId: pilotoId,
                campeonatoId: campeonatoId,
                categoria: categoria,
                categoriaFinal: categoriaFinal,
                creditosIniciales: creditosIniciales,
                creditosActuales: creditosActuales,
                saldoTemporadaAnterior: saldoTemporadaAnterior,
                bonificacionAplicada: bonificacionAplicada,
                palmaresLocal: palmaresLocal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int pilotoId,
                required int campeonatoId,
                required String categoria,
                Value<String?> categoriaFinal = const Value.absent(),
                required int creditosIniciales,
                required int creditosActuales,
                Value<int> saldoTemporadaAnterior = const Value.absent(),
                Value<int> bonificacionAplicada = const Value.absent(),
                Value<String?> palmaresLocal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PilotoCampeonatoCompanion.insert(
                pilotoId: pilotoId,
                campeonatoId: campeonatoId,
                categoria: categoria,
                categoriaFinal: categoriaFinal,
                creditosIniciales: creditosIniciales,
                creditosActuales: creditosActuales,
                saldoTemporadaAnterior: saldoTemporadaAnterior,
                bonificacionAplicada: bonificacionAplicada,
                palmaresLocal: palmaresLocal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PilotoCampeonatoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pilotoId = false, campeonatoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pilotoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pilotoId,
                                referencedTable:
                                    $$PilotoCampeonatoTableReferences
                                        ._pilotoIdTable(db),
                                referencedColumn:
                                    $$PilotoCampeonatoTableReferences
                                        ._pilotoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (campeonatoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.campeonatoId,
                                referencedTable:
                                    $$PilotoCampeonatoTableReferences
                                        ._campeonatoIdTable(db),
                                referencedColumn:
                                    $$PilotoCampeonatoTableReferences
                                        ._campeonatoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PilotoCampeonatoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PilotoCampeonatoTable,
      PilotoCampeonatoData,
      $$PilotoCampeonatoTableFilterComposer,
      $$PilotoCampeonatoTableOrderingComposer,
      $$PilotoCampeonatoTableAnnotationComposer,
      $$PilotoCampeonatoTableCreateCompanionBuilder,
      $$PilotoCampeonatoTableUpdateCompanionBuilder,
      (PilotoCampeonatoData, $$PilotoCampeonatoTableReferences),
      PilotoCampeonatoData,
      PrefetchHooks Function({bool pilotoId, bool campeonatoId})
    >;
typedef $$EquiposTableCreateCompanionBuilder =
    EquiposCompanion Function({
      Value<int> id,
      required int campeonatoId,
      required String nombre,
      required String copa,
      required int piloto1Id,
      Value<int?> piloto2Id,
      Value<bool> activo,
    });
typedef $$EquiposTableUpdateCompanionBuilder =
    EquiposCompanion Function({
      Value<int> id,
      Value<int> campeonatoId,
      Value<String> nombre,
      Value<String> copa,
      Value<int> piloto1Id,
      Value<int?> piloto2Id,
      Value<bool> activo,
    });

final class $$EquiposTableReferences
    extends BaseReferences<_$AppDatabase, $EquiposTable, Equipo> {
  $$EquiposTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CampeonatosTable _campeonatoIdTable(_$AppDatabase db) =>
      db.campeonatos.createAlias(
        $_aliasNameGenerator(db.equipos.campeonatoId, db.campeonatos.id),
      );

  $$CampeonatosTableProcessedTableManager get campeonatoId {
    final $_column = $_itemColumn<int>('campeonato_id')!;

    final manager = $$CampeonatosTableTableManager(
      $_db,
      $_db.campeonatos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campeonatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PilotosTable _piloto1IdTable(_$AppDatabase db) => db.pilotos
      .createAlias($_aliasNameGenerator(db.equipos.piloto1Id, db.pilotos.id));

  $$PilotosTableProcessedTableManager get piloto1Id {
    final $_column = $_itemColumn<int>('piloto1_id')!;

    final manager = $$PilotosTableTableManager(
      $_db,
      $_db.pilotos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_piloto1IdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PilotosTable _piloto2IdTable(_$AppDatabase db) => db.pilotos
      .createAlias($_aliasNameGenerator(db.equipos.piloto2Id, db.pilotos.id));

  $$PilotosTableProcessedTableManager? get piloto2Id {
    final $_column = $_itemColumn<int>('piloto2_id');
    if ($_column == null) return null;
    final manager = $$PilotosTableTableManager(
      $_db,
      $_db.pilotos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_piloto2IdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InscripcionesTable, List<Inscripcione>>
  _inscripcionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inscripciones,
    aliasName: $_aliasNameGenerator(db.equipos.id, db.inscripciones.equipoId),
  );

  $$InscripcionesTableProcessedTableManager get inscripcionesRefs {
    final manager = $$InscripcionesTableTableManager(
      $_db,
      $_db.inscripciones,
    ).filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_inscripcionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $InscripcionesPruebaTable,
    List<InscripcionesPruebaData>
  >
  _inscripcionesPruebaRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inscripcionesPrueba,
        aliasName: $_aliasNameGenerator(
          db.equipos.id,
          db.inscripcionesPrueba.equipoId,
        ),
      );

  $$InscripcionesPruebaTableProcessedTableManager get inscripcionesPruebaRefs {
    final manager = $$InscripcionesPruebaTableTableManager(
      $_db,
      $_db.inscripcionesPrueba,
    ).filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inscripcionesPruebaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResultadosTable, List<Resultado>>
  _resultadosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.resultados,
    aliasName: $_aliasNameGenerator(db.equipos.id, db.resultados.equipoId),
  );

  $$ResultadosTableProcessedTableManager get resultadosRefs {
    final manager = $$ResultadosTableTableManager(
      $_db,
      $_db.resultados,
    ).filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_resultadosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VerificacionesTable, List<Verificacione>>
  _verificacionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.verificaciones,
    aliasName: $_aliasNameGenerator(db.equipos.id, db.verificaciones.equipoId),
  );

  $$VerificacionesTableProcessedTableManager get verificacionesRefs {
    final manager = $$VerificacionesTableTableManager(
      $_db,
      $_db.verificaciones,
    ).filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_verificacionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PagosTable, List<Pago>> _pagosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pagos,
    aliasName: $_aliasNameGenerator(db.equipos.id, db.pagos.equipoId),
  );

  $$PagosTableProcessedTableManager get pagosRefs {
    final manager = $$PagosTableTableManager(
      $_db,
      $_db.pagos,
    ).filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovimientosCreditosTable,
    List<MovimientosCredito>
  >
  _movimientosCreditosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosCreditos,
        aliasName: $_aliasNameGenerator(
          db.equipos.id,
          db.movimientosCreditos.equipoId,
        ),
      );

  $$MovimientosCreditosTableProcessedTableManager get movimientosCreditosRefs {
    final manager = $$MovimientosCreditosTableTableManager(
      $_db,
      $_db.movimientosCreditos,
    ).filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosCreditosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquiposTableFilterComposer
    extends Composer<_$AppDatabase, $EquiposTable> {
  $$EquiposTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copa => $composableBuilder(
    column: $table.copa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  $$CampeonatosTableFilterComposer get campeonatoId {
    final $$CampeonatosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableFilterComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableFilterComposer get piloto1Id {
    final $$PilotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.piloto1Id,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableFilterComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableFilterComposer get piloto2Id {
    final $$PilotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.piloto2Id,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableFilterComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> inscripcionesRefs(
    Expression<bool> Function($$InscripcionesTableFilterComposer f) f,
  ) {
    final $$InscripcionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inscripciones,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InscripcionesTableFilterComposer(
            $db: $db,
            $table: $db.inscripciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inscripcionesPruebaRefs(
    Expression<bool> Function($$InscripcionesPruebaTableFilterComposer f) f,
  ) {
    final $$InscripcionesPruebaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inscripcionesPrueba,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InscripcionesPruebaTableFilterComposer(
            $db: $db,
            $table: $db.inscripcionesPrueba,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> resultadosRefs(
    Expression<bool> Function($$ResultadosTableFilterComposer f) f,
  ) {
    final $$ResultadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableFilterComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> verificacionesRefs(
    Expression<bool> Function($$VerificacionesTableFilterComposer f) f,
  ) {
    final $$VerificacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableFilterComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pagosRefs(
    Expression<bool> Function($$PagosTableFilterComposer f) f,
  ) {
    final $$PagosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagos,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosTableFilterComposer(
            $db: $db,
            $table: $db.pagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosCreditosRefs(
    Expression<bool> Function($$MovimientosCreditosTableFilterComposer f) f,
  ) {
    final $$MovimientosCreditosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosCreditos,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosCreditosTableFilterComposer(
            $db: $db,
            $table: $db.movimientosCreditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquiposTableOrderingComposer
    extends Composer<_$AppDatabase, $EquiposTable> {
  $$EquiposTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copa => $composableBuilder(
    column: $table.copa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampeonatosTableOrderingComposer get campeonatoId {
    final $$CampeonatosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableOrderingComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableOrderingComposer get piloto1Id {
    final $$PilotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.piloto1Id,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableOrderingComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableOrderingComposer get piloto2Id {
    final $$PilotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.piloto2Id,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableOrderingComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EquiposTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquiposTable> {
  $$EquiposTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get copa =>
      $composableBuilder(column: $table.copa, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$CampeonatosTableAnnotationComposer get campeonatoId {
    final $$CampeonatosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableAnnotationComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableAnnotationComposer get piloto1Id {
    final $$PilotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.piloto1Id,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableAnnotationComposer get piloto2Id {
    final $$PilotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.piloto2Id,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> inscripcionesRefs<T extends Object>(
    Expression<T> Function($$InscripcionesTableAnnotationComposer a) f,
  ) {
    final $$InscripcionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inscripciones,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InscripcionesTableAnnotationComposer(
            $db: $db,
            $table: $db.inscripciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inscripcionesPruebaRefs<T extends Object>(
    Expression<T> Function($$InscripcionesPruebaTableAnnotationComposer a) f,
  ) {
    final $$InscripcionesPruebaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inscripcionesPrueba,
          getReferencedColumn: (t) => t.equipoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InscripcionesPruebaTableAnnotationComposer(
                $db: $db,
                $table: $db.inscripcionesPrueba,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> resultadosRefs<T extends Object>(
    Expression<T> Function($$ResultadosTableAnnotationComposer a) f,
  ) {
    final $$ResultadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableAnnotationComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> verificacionesRefs<T extends Object>(
    Expression<T> Function($$VerificacionesTableAnnotationComposer a) f,
  ) {
    final $$VerificacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pagosRefs<T extends Object>(
    Expression<T> Function($$PagosTableAnnotationComposer a) f,
  ) {
    final $$PagosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagos,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosTableAnnotationComposer(
            $db: $db,
            $table: $db.pagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosCreditosRefs<T extends Object>(
    Expression<T> Function($$MovimientosCreditosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosCreditosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosCreditos,
          getReferencedColumn: (t) => t.equipoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosCreditosTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosCreditos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EquiposTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquiposTable,
          Equipo,
          $$EquiposTableFilterComposer,
          $$EquiposTableOrderingComposer,
          $$EquiposTableAnnotationComposer,
          $$EquiposTableCreateCompanionBuilder,
          $$EquiposTableUpdateCompanionBuilder,
          (Equipo, $$EquiposTableReferences),
          Equipo,
          PrefetchHooks Function({
            bool campeonatoId,
            bool piloto1Id,
            bool piloto2Id,
            bool inscripcionesRefs,
            bool inscripcionesPruebaRefs,
            bool resultadosRefs,
            bool verificacionesRefs,
            bool pagosRefs,
            bool movimientosCreditosRefs,
          })
        > {
  $$EquiposTableTableManager(_$AppDatabase db, $EquiposTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquiposTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquiposTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquiposTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> campeonatoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> copa = const Value.absent(),
                Value<int> piloto1Id = const Value.absent(),
                Value<int?> piloto2Id = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => EquiposCompanion(
                id: id,
                campeonatoId: campeonatoId,
                nombre: nombre,
                copa: copa,
                piloto1Id: piloto1Id,
                piloto2Id: piloto2Id,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int campeonatoId,
                required String nombre,
                required String copa,
                required int piloto1Id,
                Value<int?> piloto2Id = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => EquiposCompanion.insert(
                id: id,
                campeonatoId: campeonatoId,
                nombre: nombre,
                copa: copa,
                piloto1Id: piloto1Id,
                piloto2Id: piloto2Id,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EquiposTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                campeonatoId = false,
                piloto1Id = false,
                piloto2Id = false,
                inscripcionesRefs = false,
                inscripcionesPruebaRefs = false,
                resultadosRefs = false,
                verificacionesRefs = false,
                pagosRefs = false,
                movimientosCreditosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inscripcionesRefs) db.inscripciones,
                    if (inscripcionesPruebaRefs) db.inscripcionesPrueba,
                    if (resultadosRefs) db.resultados,
                    if (verificacionesRefs) db.verificaciones,
                    if (pagosRefs) db.pagos,
                    if (movimientosCreditosRefs) db.movimientosCreditos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (campeonatoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.campeonatoId,
                                    referencedTable: $$EquiposTableReferences
                                        ._campeonatoIdTable(db),
                                    referencedColumn: $$EquiposTableReferences
                                        ._campeonatoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (piloto1Id) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.piloto1Id,
                                    referencedTable: $$EquiposTableReferences
                                        ._piloto1IdTable(db),
                                    referencedColumn: $$EquiposTableReferences
                                        ._piloto1IdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (piloto2Id) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.piloto2Id,
                                    referencedTable: $$EquiposTableReferences
                                        ._piloto2IdTable(db),
                                    referencedColumn: $$EquiposTableReferences
                                        ._piloto2IdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inscripcionesRefs)
                        await $_getPrefetchedData<
                          Equipo,
                          $EquiposTable,
                          Inscripcione
                        >(
                          currentTable: table,
                          referencedTable: $$EquiposTableReferences
                              ._inscripcionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquiposTableReferences(
                                db,
                                table,
                                p0,
                              ).inscripcionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inscripcionesPruebaRefs)
                        await $_getPrefetchedData<
                          Equipo,
                          $EquiposTable,
                          InscripcionesPruebaData
                        >(
                          currentTable: table,
                          referencedTable: $$EquiposTableReferences
                              ._inscripcionesPruebaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquiposTableReferences(
                                db,
                                table,
                                p0,
                              ).inscripcionesPruebaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (resultadosRefs)
                        await $_getPrefetchedData<
                          Equipo,
                          $EquiposTable,
                          Resultado
                        >(
                          currentTable: table,
                          referencedTable: $$EquiposTableReferences
                              ._resultadosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquiposTableReferences(
                                db,
                                table,
                                p0,
                              ).resultadosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (verificacionesRefs)
                        await $_getPrefetchedData<
                          Equipo,
                          $EquiposTable,
                          Verificacione
                        >(
                          currentTable: table,
                          referencedTable: $$EquiposTableReferences
                              ._verificacionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquiposTableReferences(
                                db,
                                table,
                                p0,
                              ).verificacionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pagosRefs)
                        await $_getPrefetchedData<Equipo, $EquiposTable, Pago>(
                          currentTable: table,
                          referencedTable: $$EquiposTableReferences
                              ._pagosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquiposTableReferences(db, table, p0).pagosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosCreditosRefs)
                        await $_getPrefetchedData<
                          Equipo,
                          $EquiposTable,
                          MovimientosCredito
                        >(
                          currentTable: table,
                          referencedTable: $$EquiposTableReferences
                              ._movimientosCreditosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquiposTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosCreditosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EquiposTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquiposTable,
      Equipo,
      $$EquiposTableFilterComposer,
      $$EquiposTableOrderingComposer,
      $$EquiposTableAnnotationComposer,
      $$EquiposTableCreateCompanionBuilder,
      $$EquiposTableUpdateCompanionBuilder,
      (Equipo, $$EquiposTableReferences),
      Equipo,
      PrefetchHooks Function({
        bool campeonatoId,
        bool piloto1Id,
        bool piloto2Id,
        bool inscripcionesRefs,
        bool inscripcionesPruebaRefs,
        bool resultadosRefs,
        bool verificacionesRefs,
        bool pagosRefs,
        bool movimientosCreditosRefs,
      })
    >;
typedef $$PruebasTableCreateCompanionBuilder =
    PruebasCompanion Function({
      Value<int> id,
      required int campeonatoId,
      required String nombre,
      Value<String?> sede,
      Value<DateTime?> fecha,
      required int orden,
      Value<String> estado,
    });
typedef $$PruebasTableUpdateCompanionBuilder =
    PruebasCompanion Function({
      Value<int> id,
      Value<int> campeonatoId,
      Value<String> nombre,
      Value<String?> sede,
      Value<DateTime?> fecha,
      Value<int> orden,
      Value<String> estado,
    });

final class $$PruebasTableReferences
    extends BaseReferences<_$AppDatabase, $PruebasTable, Prueba> {
  $$PruebasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CampeonatosTable _campeonatoIdTable(_$AppDatabase db) =>
      db.campeonatos.createAlias(
        $_aliasNameGenerator(db.pruebas.campeonatoId, db.campeonatos.id),
      );

  $$CampeonatosTableProcessedTableManager get campeonatoId {
    final $_column = $_itemColumn<int>('campeonato_id')!;

    final manager = $$CampeonatosTableTableManager(
      $_db,
      $_db.campeonatos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campeonatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MangasTable, List<Manga>> _mangasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.mangas,
    aliasName: $_aliasNameGenerator(db.pruebas.id, db.mangas.pruebaId),
  );

  $$MangasTableProcessedTableManager get mangasRefs {
    final manager = $$MangasTableTableManager(
      $_db,
      $_db.mangas,
    ).filter((f) => f.pruebaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mangasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $InscripcionesPruebaTable,
    List<InscripcionesPruebaData>
  >
  _inscripcionesPruebaRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inscripcionesPrueba,
        aliasName: $_aliasNameGenerator(
          db.pruebas.id,
          db.inscripcionesPrueba.pruebaId,
        ),
      );

  $$InscripcionesPruebaTableProcessedTableManager get inscripcionesPruebaRefs {
    final manager = $$InscripcionesPruebaTableTableManager(
      $_db,
      $_db.inscripcionesPrueba,
    ).filter((f) => f.pruebaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inscripcionesPruebaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DescartesPruebaTable, List<DescartesPruebaData>>
  _descartesPruebaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.descartesPrueba,
    aliasName: $_aliasNameGenerator(db.pruebas.id, db.descartesPrueba.pruebaId),
  );

  $$DescartesPruebaTableProcessedTableManager get descartesPruebaRefs {
    final manager = $$DescartesPruebaTableTableManager(
      $_db,
      $_db.descartesPrueba,
    ).filter((f) => f.pruebaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _descartesPruebaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OverridesCopaTable, List<OverridesCopaData>>
  _overridesCopaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.overridesCopa,
    aliasName: $_aliasNameGenerator(db.pruebas.id, db.overridesCopa.pruebaId),
  );

  $$OverridesCopaTableProcessedTableManager get overridesCopaRefs {
    final manager = $$OverridesCopaTableTableManager(
      $_db,
      $_db.overridesCopa,
    ).filter((f) => f.pruebaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_overridesCopaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PagosTable, List<Pago>> _pagosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pagos,
    aliasName: $_aliasNameGenerator(db.pruebas.id, db.pagos.pruebaId),
  );

  $$PagosTableProcessedTableManager get pagosRefs {
    final manager = $$PagosTableTableManager(
      $_db,
      $_db.pagos,
    ).filter((f) => f.pruebaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovimientosTesoreriaTable,
    List<MovimientosTesoreriaData>
  >
  _movimientosTesoreriaRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosTesoreria,
        aliasName: $_aliasNameGenerator(
          db.pruebas.id,
          db.movimientosTesoreria.pruebaId,
        ),
      );

  $$MovimientosTesoreriaTableProcessedTableManager
  get movimientosTesoreriaRefs {
    final manager = $$MovimientosTesoreriaTableTableManager(
      $_db,
      $_db.movimientosTesoreria,
    ).filter((f) => f.pruebaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosTesoreriaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovimientosCreditosTable,
    List<MovimientosCredito>
  >
  _movimientosCreditosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosCreditos,
        aliasName: $_aliasNameGenerator(
          db.pruebas.id,
          db.movimientosCreditos.pruebaId,
        ),
      );

  $$MovimientosCreditosTableProcessedTableManager get movimientosCreditosRefs {
    final manager = $$MovimientosCreditosTableTableManager(
      $_db,
      $_db.movimientosCreditos,
    ).filter((f) => f.pruebaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosCreditosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PruebasTableFilterComposer
    extends Composer<_$AppDatabase, $PruebasTable> {
  $$PruebasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sede => $composableBuilder(
    column: $table.sede,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  $$CampeonatosTableFilterComposer get campeonatoId {
    final $$CampeonatosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableFilterComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mangasRefs(
    Expression<bool> Function($$MangasTableFilterComposer f) f,
  ) {
    final $$MangasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableFilterComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inscripcionesPruebaRefs(
    Expression<bool> Function($$InscripcionesPruebaTableFilterComposer f) f,
  ) {
    final $$InscripcionesPruebaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inscripcionesPrueba,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InscripcionesPruebaTableFilterComposer(
            $db: $db,
            $table: $db.inscripcionesPrueba,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> descartesPruebaRefs(
    Expression<bool> Function($$DescartesPruebaTableFilterComposer f) f,
  ) {
    final $$DescartesPruebaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.descartesPrueba,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DescartesPruebaTableFilterComposer(
            $db: $db,
            $table: $db.descartesPrueba,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> overridesCopaRefs(
    Expression<bool> Function($$OverridesCopaTableFilterComposer f) f,
  ) {
    final $$OverridesCopaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overridesCopa,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverridesCopaTableFilterComposer(
            $db: $db,
            $table: $db.overridesCopa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pagosRefs(
    Expression<bool> Function($$PagosTableFilterComposer f) f,
  ) {
    final $$PagosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagos,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosTableFilterComposer(
            $db: $db,
            $table: $db.pagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosTesoreriaRefs(
    Expression<bool> Function($$MovimientosTesoreriaTableFilterComposer f) f,
  ) {
    final $$MovimientosTesoreriaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosTesoreria,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTesoreriaTableFilterComposer(
            $db: $db,
            $table: $db.movimientosTesoreria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosCreditosRefs(
    Expression<bool> Function($$MovimientosCreditosTableFilterComposer f) f,
  ) {
    final $$MovimientosCreditosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosCreditos,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosCreditosTableFilterComposer(
            $db: $db,
            $table: $db.movimientosCreditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PruebasTableOrderingComposer
    extends Composer<_$AppDatabase, $PruebasTable> {
  $$PruebasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sede => $composableBuilder(
    column: $table.sede,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampeonatosTableOrderingComposer get campeonatoId {
    final $$CampeonatosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableOrderingComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PruebasTableAnnotationComposer
    extends Composer<_$AppDatabase, $PruebasTable> {
  $$PruebasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get sede =>
      $composableBuilder(column: $table.sede, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  $$CampeonatosTableAnnotationComposer get campeonatoId {
    final $$CampeonatosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableAnnotationComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mangasRefs<T extends Object>(
    Expression<T> Function($$MangasTableAnnotationComposer a) f,
  ) {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableAnnotationComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inscripcionesPruebaRefs<T extends Object>(
    Expression<T> Function($$InscripcionesPruebaTableAnnotationComposer a) f,
  ) {
    final $$InscripcionesPruebaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inscripcionesPrueba,
          getReferencedColumn: (t) => t.pruebaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InscripcionesPruebaTableAnnotationComposer(
                $db: $db,
                $table: $db.inscripcionesPrueba,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> descartesPruebaRefs<T extends Object>(
    Expression<T> Function($$DescartesPruebaTableAnnotationComposer a) f,
  ) {
    final $$DescartesPruebaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.descartesPrueba,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DescartesPruebaTableAnnotationComposer(
            $db: $db,
            $table: $db.descartesPrueba,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> overridesCopaRefs<T extends Object>(
    Expression<T> Function($$OverridesCopaTableAnnotationComposer a) f,
  ) {
    final $$OverridesCopaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overridesCopa,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverridesCopaTableAnnotationComposer(
            $db: $db,
            $table: $db.overridesCopa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pagosRefs<T extends Object>(
    Expression<T> Function($$PagosTableAnnotationComposer a) f,
  ) {
    final $$PagosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagos,
      getReferencedColumn: (t) => t.pruebaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosTableAnnotationComposer(
            $db: $db,
            $table: $db.pagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosTesoreriaRefs<T extends Object>(
    Expression<T> Function($$MovimientosTesoreriaTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTesoreriaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosTesoreria,
          getReferencedColumn: (t) => t.pruebaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosTesoreriaTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosTesoreria,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> movimientosCreditosRefs<T extends Object>(
    Expression<T> Function($$MovimientosCreditosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosCreditosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosCreditos,
          getReferencedColumn: (t) => t.pruebaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosCreditosTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosCreditos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PruebasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PruebasTable,
          Prueba,
          $$PruebasTableFilterComposer,
          $$PruebasTableOrderingComposer,
          $$PruebasTableAnnotationComposer,
          $$PruebasTableCreateCompanionBuilder,
          $$PruebasTableUpdateCompanionBuilder,
          (Prueba, $$PruebasTableReferences),
          Prueba,
          PrefetchHooks Function({
            bool campeonatoId,
            bool mangasRefs,
            bool inscripcionesPruebaRefs,
            bool descartesPruebaRefs,
            bool overridesCopaRefs,
            bool pagosRefs,
            bool movimientosTesoreriaRefs,
            bool movimientosCreditosRefs,
          })
        > {
  $$PruebasTableTableManager(_$AppDatabase db, $PruebasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PruebasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PruebasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PruebasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> campeonatoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> sede = const Value.absent(),
                Value<DateTime?> fecha = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => PruebasCompanion(
                id: id,
                campeonatoId: campeonatoId,
                nombre: nombre,
                sede: sede,
                fecha: fecha,
                orden: orden,
                estado: estado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int campeonatoId,
                required String nombre,
                Value<String?> sede = const Value.absent(),
                Value<DateTime?> fecha = const Value.absent(),
                required int orden,
                Value<String> estado = const Value.absent(),
              }) => PruebasCompanion.insert(
                id: id,
                campeonatoId: campeonatoId,
                nombre: nombre,
                sede: sede,
                fecha: fecha,
                orden: orden,
                estado: estado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PruebasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                campeonatoId = false,
                mangasRefs = false,
                inscripcionesPruebaRefs = false,
                descartesPruebaRefs = false,
                overridesCopaRefs = false,
                pagosRefs = false,
                movimientosTesoreriaRefs = false,
                movimientosCreditosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mangasRefs) db.mangas,
                    if (inscripcionesPruebaRefs) db.inscripcionesPrueba,
                    if (descartesPruebaRefs) db.descartesPrueba,
                    if (overridesCopaRefs) db.overridesCopa,
                    if (pagosRefs) db.pagos,
                    if (movimientosTesoreriaRefs) db.movimientosTesoreria,
                    if (movimientosCreditosRefs) db.movimientosCreditos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (campeonatoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.campeonatoId,
                                    referencedTable: $$PruebasTableReferences
                                        ._campeonatoIdTable(db),
                                    referencedColumn: $$PruebasTableReferences
                                        ._campeonatoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mangasRefs)
                        await $_getPrefetchedData<Prueba, $PruebasTable, Manga>(
                          currentTable: table,
                          referencedTable: $$PruebasTableReferences
                              ._mangasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PruebasTableReferences(
                                db,
                                table,
                                p0,
                              ).mangasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pruebaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inscripcionesPruebaRefs)
                        await $_getPrefetchedData<
                          Prueba,
                          $PruebasTable,
                          InscripcionesPruebaData
                        >(
                          currentTable: table,
                          referencedTable: $$PruebasTableReferences
                              ._inscripcionesPruebaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PruebasTableReferences(
                                db,
                                table,
                                p0,
                              ).inscripcionesPruebaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pruebaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (descartesPruebaRefs)
                        await $_getPrefetchedData<
                          Prueba,
                          $PruebasTable,
                          DescartesPruebaData
                        >(
                          currentTable: table,
                          referencedTable: $$PruebasTableReferences
                              ._descartesPruebaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PruebasTableReferences(
                                db,
                                table,
                                p0,
                              ).descartesPruebaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pruebaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (overridesCopaRefs)
                        await $_getPrefetchedData<
                          Prueba,
                          $PruebasTable,
                          OverridesCopaData
                        >(
                          currentTable: table,
                          referencedTable: $$PruebasTableReferences
                              ._overridesCopaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PruebasTableReferences(
                                db,
                                table,
                                p0,
                              ).overridesCopaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pruebaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pagosRefs)
                        await $_getPrefetchedData<Prueba, $PruebasTable, Pago>(
                          currentTable: table,
                          referencedTable: $$PruebasTableReferences
                              ._pagosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PruebasTableReferences(db, table, p0).pagosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pruebaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosTesoreriaRefs)
                        await $_getPrefetchedData<
                          Prueba,
                          $PruebasTable,
                          MovimientosTesoreriaData
                        >(
                          currentTable: table,
                          referencedTable: $$PruebasTableReferences
                              ._movimientosTesoreriaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PruebasTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosTesoreriaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pruebaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientosCreditosRefs)
                        await $_getPrefetchedData<
                          Prueba,
                          $PruebasTable,
                          MovimientosCredito
                        >(
                          currentTable: table,
                          referencedTable: $$PruebasTableReferences
                              ._movimientosCreditosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PruebasTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosCreditosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pruebaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PruebasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PruebasTable,
      Prueba,
      $$PruebasTableFilterComposer,
      $$PruebasTableOrderingComposer,
      $$PruebasTableAnnotationComposer,
      $$PruebasTableCreateCompanionBuilder,
      $$PruebasTableUpdateCompanionBuilder,
      (Prueba, $$PruebasTableReferences),
      Prueba,
      PrefetchHooks Function({
        bool campeonatoId,
        bool mangasRefs,
        bool inscripcionesPruebaRefs,
        bool descartesPruebaRefs,
        bool overridesCopaRefs,
        bool pagosRefs,
        bool movimientosTesoreriaRefs,
        bool movimientosCreditosRefs,
      })
    >;
typedef $$MangasTableCreateCompanionBuilder =
    MangasCompanion Function({
      Value<int> id,
      required int pruebaId,
      required String nombre,
      Value<DateTime?> fechaHora,
      Value<int> numCarriles,
      Value<String> estado,
    });
typedef $$MangasTableUpdateCompanionBuilder =
    MangasCompanion Function({
      Value<int> id,
      Value<int> pruebaId,
      Value<String> nombre,
      Value<DateTime?> fechaHora,
      Value<int> numCarriles,
      Value<String> estado,
    });

final class $$MangasTableReferences
    extends BaseReferences<_$AppDatabase, $MangasTable, Manga> {
  $$MangasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PruebasTable _pruebaIdTable(_$AppDatabase db) => db.pruebas
      .createAlias($_aliasNameGenerator(db.mangas.pruebaId, db.pruebas.id));

  $$PruebasTableProcessedTableManager get pruebaId {
    final $_column = $_itemColumn<int>('prueba_id')!;

    final manager = $$PruebasTableTableManager(
      $_db,
      $_db.pruebas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pruebaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InscripcionesTable, List<Inscripcione>>
  _inscripcionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inscripciones,
    aliasName: $_aliasNameGenerator(db.mangas.id, db.inscripciones.mangaId),
  );

  $$InscripcionesTableProcessedTableManager get inscripcionesRefs {
    final manager = $$InscripcionesTableTableManager(
      $_db,
      $_db.inscripciones,
    ).filter((f) => f.mangaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_inscripcionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ResultadosTable, List<Resultado>>
  _resultadosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.resultados,
    aliasName: $_aliasNameGenerator(db.mangas.id, db.resultados.mangaId),
  );

  $$ResultadosTableProcessedTableManager get resultadosRefs {
    final manager = $$ResultadosTableTableManager(
      $_db,
      $_db.resultados,
    ).filter((f) => f.mangaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_resultadosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VerificacionesTable, List<Verificacione>>
  _verificacionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.verificaciones,
    aliasName: $_aliasNameGenerator(db.mangas.id, db.verificaciones.mangaId),
  );

  $$VerificacionesTableProcessedTableManager get verificacionesRefs {
    final manager = $$VerificacionesTableTableManager(
      $_db,
      $_db.verificaciones,
    ).filter((f) => f.mangaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_verificacionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MangasTableFilterComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaHora => $composableBuilder(
    column: $table.fechaHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numCarriles => $composableBuilder(
    column: $table.numCarriles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  $$PruebasTableFilterComposer get pruebaId {
    final $$PruebasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableFilterComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> inscripcionesRefs(
    Expression<bool> Function($$InscripcionesTableFilterComposer f) f,
  ) {
    final $$InscripcionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inscripciones,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InscripcionesTableFilterComposer(
            $db: $db,
            $table: $db.inscripciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> resultadosRefs(
    Expression<bool> Function($$ResultadosTableFilterComposer f) f,
  ) {
    final $$ResultadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableFilterComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> verificacionesRefs(
    Expression<bool> Function($$VerificacionesTableFilterComposer f) f,
  ) {
    final $$VerificacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableFilterComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MangasTableOrderingComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaHora => $composableBuilder(
    column: $table.fechaHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numCarriles => $composableBuilder(
    column: $table.numCarriles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  $$PruebasTableOrderingComposer get pruebaId {
    final $$PruebasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableOrderingComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MangasTableAnnotationComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaHora =>
      $composableBuilder(column: $table.fechaHora, builder: (column) => column);

  GeneratedColumn<int> get numCarriles => $composableBuilder(
    column: $table.numCarriles,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  $$PruebasTableAnnotationComposer get pruebaId {
    final $$PruebasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableAnnotationComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> inscripcionesRefs<T extends Object>(
    Expression<T> Function($$InscripcionesTableAnnotationComposer a) f,
  ) {
    final $$InscripcionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inscripciones,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InscripcionesTableAnnotationComposer(
            $db: $db,
            $table: $db.inscripciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> resultadosRefs<T extends Object>(
    Expression<T> Function($$ResultadosTableAnnotationComposer a) f,
  ) {
    final $$ResultadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.resultados,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ResultadosTableAnnotationComposer(
            $db: $db,
            $table: $db.resultados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> verificacionesRefs<T extends Object>(
    Expression<T> Function($$VerificacionesTableAnnotationComposer a) f,
  ) {
    final $$VerificacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MangasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MangasTable,
          Manga,
          $$MangasTableFilterComposer,
          $$MangasTableOrderingComposer,
          $$MangasTableAnnotationComposer,
          $$MangasTableCreateCompanionBuilder,
          $$MangasTableUpdateCompanionBuilder,
          (Manga, $$MangasTableReferences),
          Manga,
          PrefetchHooks Function({
            bool pruebaId,
            bool inscripcionesRefs,
            bool resultadosRefs,
            bool verificacionesRefs,
          })
        > {
  $$MangasTableTableManager(_$AppDatabase db, $MangasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MangasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MangasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MangasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pruebaId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<DateTime?> fechaHora = const Value.absent(),
                Value<int> numCarriles = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => MangasCompanion(
                id: id,
                pruebaId: pruebaId,
                nombre: nombre,
                fechaHora: fechaHora,
                numCarriles: numCarriles,
                estado: estado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pruebaId,
                required String nombre,
                Value<DateTime?> fechaHora = const Value.absent(),
                Value<int> numCarriles = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => MangasCompanion.insert(
                id: id,
                pruebaId: pruebaId,
                nombre: nombre,
                fechaHora: fechaHora,
                numCarriles: numCarriles,
                estado: estado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MangasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                pruebaId = false,
                inscripcionesRefs = false,
                resultadosRefs = false,
                verificacionesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inscripcionesRefs) db.inscripciones,
                    if (resultadosRefs) db.resultados,
                    if (verificacionesRefs) db.verificaciones,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (pruebaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.pruebaId,
                                    referencedTable: $$MangasTableReferences
                                        ._pruebaIdTable(db),
                                    referencedColumn: $$MangasTableReferences
                                        ._pruebaIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inscripcionesRefs)
                        await $_getPrefetchedData<
                          Manga,
                          $MangasTable,
                          Inscripcione
                        >(
                          currentTable: table,
                          referencedTable: $$MangasTableReferences
                              ._inscripcionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MangasTableReferences(
                                db,
                                table,
                                p0,
                              ).inscripcionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mangaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (resultadosRefs)
                        await $_getPrefetchedData<
                          Manga,
                          $MangasTable,
                          Resultado
                        >(
                          currentTable: table,
                          referencedTable: $$MangasTableReferences
                              ._resultadosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MangasTableReferences(
                                db,
                                table,
                                p0,
                              ).resultadosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mangaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (verificacionesRefs)
                        await $_getPrefetchedData<
                          Manga,
                          $MangasTable,
                          Verificacione
                        >(
                          currentTable: table,
                          referencedTable: $$MangasTableReferences
                              ._verificacionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MangasTableReferences(
                                db,
                                table,
                                p0,
                              ).verificacionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mangaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MangasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MangasTable,
      Manga,
      $$MangasTableFilterComposer,
      $$MangasTableOrderingComposer,
      $$MangasTableAnnotationComposer,
      $$MangasTableCreateCompanionBuilder,
      $$MangasTableUpdateCompanionBuilder,
      (Manga, $$MangasTableReferences),
      Manga,
      PrefetchHooks Function({
        bool pruebaId,
        bool inscripcionesRefs,
        bool resultadosRefs,
        bool verificacionesRefs,
      })
    >;
typedef $$InscripcionesTableCreateCompanionBuilder =
    InscripcionesCompanion Function({
      Value<int> id,
      required int mangaId,
      required int equipoId,
      Value<String?> carrilSalida,
      Value<bool> seedDirecto,
    });
typedef $$InscripcionesTableUpdateCompanionBuilder =
    InscripcionesCompanion Function({
      Value<int> id,
      Value<int> mangaId,
      Value<int> equipoId,
      Value<String?> carrilSalida,
      Value<bool> seedDirecto,
    });

final class $$InscripcionesTableReferences
    extends BaseReferences<_$AppDatabase, $InscripcionesTable, Inscripcione> {
  $$InscripcionesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MangasTable _mangaIdTable(_$AppDatabase db) => db.mangas.createAlias(
    $_aliasNameGenerator(db.inscripciones.mangaId, db.mangas.id),
  );

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<int>('manga_id')!;

    final manager = $$MangasTableTableManager(
      $_db,
      $_db.mangas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquiposTable _equipoIdTable(_$AppDatabase db) =>
      db.equipos.createAlias(
        $_aliasNameGenerator(db.inscripciones.equipoId, db.equipos.id),
      );

  $$EquiposTableProcessedTableManager get equipoId {
    final $_column = $_itemColumn<int>('equipo_id')!;

    final manager = $$EquiposTableTableManager(
      $_db,
      $_db.equipos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InscripcionesTableFilterComposer
    extends Composer<_$AppDatabase, $InscripcionesTable> {
  $$InscripcionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get carrilSalida => $composableBuilder(
    column: $table.carrilSalida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get seedDirecto => $composableBuilder(
    column: $table.seedDirecto,
    builder: (column) => ColumnFilters(column),
  );

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableFilterComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableFilterComposer get equipoId {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableFilterComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InscripcionesTableOrderingComposer
    extends Composer<_$AppDatabase, $InscripcionesTable> {
  $$InscripcionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get carrilSalida => $composableBuilder(
    column: $table.carrilSalida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get seedDirecto => $composableBuilder(
    column: $table.seedDirecto,
    builder: (column) => ColumnOrderings(column),
  );

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableOrderingComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableOrderingComposer get equipoId {
    final $$EquiposTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableOrderingComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InscripcionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InscripcionesTable> {
  $$InscripcionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get carrilSalida => $composableBuilder(
    column: $table.carrilSalida,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get seedDirecto => $composableBuilder(
    column: $table.seedDirecto,
    builder: (column) => column,
  );

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableAnnotationComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableAnnotationComposer get equipoId {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableAnnotationComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InscripcionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InscripcionesTable,
          Inscripcione,
          $$InscripcionesTableFilterComposer,
          $$InscripcionesTableOrderingComposer,
          $$InscripcionesTableAnnotationComposer,
          $$InscripcionesTableCreateCompanionBuilder,
          $$InscripcionesTableUpdateCompanionBuilder,
          (Inscripcione, $$InscripcionesTableReferences),
          Inscripcione,
          PrefetchHooks Function({bool mangaId, bool equipoId})
        > {
  $$InscripcionesTableTableManager(_$AppDatabase db, $InscripcionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InscripcionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InscripcionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InscripcionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mangaId = const Value.absent(),
                Value<int> equipoId = const Value.absent(),
                Value<String?> carrilSalida = const Value.absent(),
                Value<bool> seedDirecto = const Value.absent(),
              }) => InscripcionesCompanion(
                id: id,
                mangaId: mangaId,
                equipoId: equipoId,
                carrilSalida: carrilSalida,
                seedDirecto: seedDirecto,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mangaId,
                required int equipoId,
                Value<String?> carrilSalida = const Value.absent(),
                Value<bool> seedDirecto = const Value.absent(),
              }) => InscripcionesCompanion.insert(
                id: id,
                mangaId: mangaId,
                equipoId: equipoId,
                carrilSalida: carrilSalida,
                seedDirecto: seedDirecto,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InscripcionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mangaId = false, equipoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mangaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mangaId,
                                referencedTable: $$InscripcionesTableReferences
                                    ._mangaIdTable(db),
                                referencedColumn: $$InscripcionesTableReferences
                                    ._mangaIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (equipoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.equipoId,
                                referencedTable: $$InscripcionesTableReferences
                                    ._equipoIdTable(db),
                                referencedColumn: $$InscripcionesTableReferences
                                    ._equipoIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InscripcionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InscripcionesTable,
      Inscripcione,
      $$InscripcionesTableFilterComposer,
      $$InscripcionesTableOrderingComposer,
      $$InscripcionesTableAnnotationComposer,
      $$InscripcionesTableCreateCompanionBuilder,
      $$InscripcionesTableUpdateCompanionBuilder,
      (Inscripcione, $$InscripcionesTableReferences),
      Inscripcione,
      PrefetchHooks Function({bool mangaId, bool equipoId})
    >;
typedef $$InscripcionesPruebaTableCreateCompanionBuilder =
    InscripcionesPruebaCompanion Function({
      Value<int> id,
      required int pruebaId,
      required int equipoId,
      Value<DateTime> fechaInscripcion,
      Value<String?> preferenciaDia,
      Value<String?> notas,
      Value<bool> asignada,
      Value<bool> wildcard,
      Value<String?> copa,
    });
typedef $$InscripcionesPruebaTableUpdateCompanionBuilder =
    InscripcionesPruebaCompanion Function({
      Value<int> id,
      Value<int> pruebaId,
      Value<int> equipoId,
      Value<DateTime> fechaInscripcion,
      Value<String?> preferenciaDia,
      Value<String?> notas,
      Value<bool> asignada,
      Value<bool> wildcard,
      Value<String?> copa,
    });

final class $$InscripcionesPruebaTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InscripcionesPruebaTable,
          InscripcionesPruebaData
        > {
  $$InscripcionesPruebaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PruebasTable _pruebaIdTable(_$AppDatabase db) =>
      db.pruebas.createAlias(
        $_aliasNameGenerator(db.inscripcionesPrueba.pruebaId, db.pruebas.id),
      );

  $$PruebasTableProcessedTableManager get pruebaId {
    final $_column = $_itemColumn<int>('prueba_id')!;

    final manager = $$PruebasTableTableManager(
      $_db,
      $_db.pruebas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pruebaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquiposTable _equipoIdTable(_$AppDatabase db) =>
      db.equipos.createAlias(
        $_aliasNameGenerator(db.inscripcionesPrueba.equipoId, db.equipos.id),
      );

  $$EquiposTableProcessedTableManager get equipoId {
    final $_column = $_itemColumn<int>('equipo_id')!;

    final manager = $$EquiposTableTableManager(
      $_db,
      $_db.equipos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InscripcionesPruebaTableFilterComposer
    extends Composer<_$AppDatabase, $InscripcionesPruebaTable> {
  $$InscripcionesPruebaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInscripcion => $composableBuilder(
    column: $table.fechaInscripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferenciaDia => $composableBuilder(
    column: $table.preferenciaDia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get asignada => $composableBuilder(
    column: $table.asignada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wildcard => $composableBuilder(
    column: $table.wildcard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copa => $composableBuilder(
    column: $table.copa,
    builder: (column) => ColumnFilters(column),
  );

  $$PruebasTableFilterComposer get pruebaId {
    final $$PruebasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableFilterComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableFilterComposer get equipoId {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableFilterComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InscripcionesPruebaTableOrderingComposer
    extends Composer<_$AppDatabase, $InscripcionesPruebaTable> {
  $$InscripcionesPruebaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInscripcion => $composableBuilder(
    column: $table.fechaInscripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferenciaDia => $composableBuilder(
    column: $table.preferenciaDia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get asignada => $composableBuilder(
    column: $table.asignada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wildcard => $composableBuilder(
    column: $table.wildcard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copa => $composableBuilder(
    column: $table.copa,
    builder: (column) => ColumnOrderings(column),
  );

  $$PruebasTableOrderingComposer get pruebaId {
    final $$PruebasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableOrderingComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableOrderingComposer get equipoId {
    final $$EquiposTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableOrderingComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InscripcionesPruebaTableAnnotationComposer
    extends Composer<_$AppDatabase, $InscripcionesPruebaTable> {
  $$InscripcionesPruebaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInscripcion => $composableBuilder(
    column: $table.fechaInscripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferenciaDia => $composableBuilder(
    column: $table.preferenciaDia,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<bool> get asignada =>
      $composableBuilder(column: $table.asignada, builder: (column) => column);

  GeneratedColumn<bool> get wildcard =>
      $composableBuilder(column: $table.wildcard, builder: (column) => column);

  GeneratedColumn<String> get copa =>
      $composableBuilder(column: $table.copa, builder: (column) => column);

  $$PruebasTableAnnotationComposer get pruebaId {
    final $$PruebasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableAnnotationComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableAnnotationComposer get equipoId {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableAnnotationComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InscripcionesPruebaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InscripcionesPruebaTable,
          InscripcionesPruebaData,
          $$InscripcionesPruebaTableFilterComposer,
          $$InscripcionesPruebaTableOrderingComposer,
          $$InscripcionesPruebaTableAnnotationComposer,
          $$InscripcionesPruebaTableCreateCompanionBuilder,
          $$InscripcionesPruebaTableUpdateCompanionBuilder,
          (InscripcionesPruebaData, $$InscripcionesPruebaTableReferences),
          InscripcionesPruebaData,
          PrefetchHooks Function({bool pruebaId, bool equipoId})
        > {
  $$InscripcionesPruebaTableTableManager(
    _$AppDatabase db,
    $InscripcionesPruebaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InscripcionesPruebaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InscripcionesPruebaTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InscripcionesPruebaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pruebaId = const Value.absent(),
                Value<int> equipoId = const Value.absent(),
                Value<DateTime> fechaInscripcion = const Value.absent(),
                Value<String?> preferenciaDia = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<bool> asignada = const Value.absent(),
                Value<bool> wildcard = const Value.absent(),
                Value<String?> copa = const Value.absent(),
              }) => InscripcionesPruebaCompanion(
                id: id,
                pruebaId: pruebaId,
                equipoId: equipoId,
                fechaInscripcion: fechaInscripcion,
                preferenciaDia: preferenciaDia,
                notas: notas,
                asignada: asignada,
                wildcard: wildcard,
                copa: copa,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pruebaId,
                required int equipoId,
                Value<DateTime> fechaInscripcion = const Value.absent(),
                Value<String?> preferenciaDia = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<bool> asignada = const Value.absent(),
                Value<bool> wildcard = const Value.absent(),
                Value<String?> copa = const Value.absent(),
              }) => InscripcionesPruebaCompanion.insert(
                id: id,
                pruebaId: pruebaId,
                equipoId: equipoId,
                fechaInscripcion: fechaInscripcion,
                preferenciaDia: preferenciaDia,
                notas: notas,
                asignada: asignada,
                wildcard: wildcard,
                copa: copa,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InscripcionesPruebaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pruebaId = false, equipoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pruebaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pruebaId,
                                referencedTable:
                                    $$InscripcionesPruebaTableReferences
                                        ._pruebaIdTable(db),
                                referencedColumn:
                                    $$InscripcionesPruebaTableReferences
                                        ._pruebaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (equipoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.equipoId,
                                referencedTable:
                                    $$InscripcionesPruebaTableReferences
                                        ._equipoIdTable(db),
                                referencedColumn:
                                    $$InscripcionesPruebaTableReferences
                                        ._equipoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InscripcionesPruebaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InscripcionesPruebaTable,
      InscripcionesPruebaData,
      $$InscripcionesPruebaTableFilterComposer,
      $$InscripcionesPruebaTableOrderingComposer,
      $$InscripcionesPruebaTableAnnotationComposer,
      $$InscripcionesPruebaTableCreateCompanionBuilder,
      $$InscripcionesPruebaTableUpdateCompanionBuilder,
      (InscripcionesPruebaData, $$InscripcionesPruebaTableReferences),
      InscripcionesPruebaData,
      PrefetchHooks Function({bool pruebaId, bool equipoId})
    >;
typedef $$ResultadosTableCreateCompanionBuilder =
    ResultadosCompanion Function({
      Value<int> id,
      required int mangaId,
      required int pilotoId,
      required int equipoId,
      Value<int> puntos,
      Value<int?> posicion,
      Value<int> aRestar,
    });
typedef $$ResultadosTableUpdateCompanionBuilder =
    ResultadosCompanion Function({
      Value<int> id,
      Value<int> mangaId,
      Value<int> pilotoId,
      Value<int> equipoId,
      Value<int> puntos,
      Value<int?> posicion,
      Value<int> aRestar,
    });

final class $$ResultadosTableReferences
    extends BaseReferences<_$AppDatabase, $ResultadosTable, Resultado> {
  $$ResultadosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MangasTable _mangaIdTable(_$AppDatabase db) => db.mangas.createAlias(
    $_aliasNameGenerator(db.resultados.mangaId, db.mangas.id),
  );

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<int>('manga_id')!;

    final manager = $$MangasTableTableManager(
      $_db,
      $_db.mangas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PilotosTable _pilotoIdTable(_$AppDatabase db) => db.pilotos
      .createAlias($_aliasNameGenerator(db.resultados.pilotoId, db.pilotos.id));

  $$PilotosTableProcessedTableManager get pilotoId {
    final $_column = $_itemColumn<int>('piloto_id')!;

    final manager = $$PilotosTableTableManager(
      $_db,
      $_db.pilotos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pilotoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquiposTable _equipoIdTable(_$AppDatabase db) => db.equipos
      .createAlias($_aliasNameGenerator(db.resultados.equipoId, db.equipos.id));

  $$EquiposTableProcessedTableManager get equipoId {
    final $_column = $_itemColumn<int>('equipo_id')!;

    final manager = $$EquiposTableTableManager(
      $_db,
      $_db.equipos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ResultadosTableFilterComposer
    extends Composer<_$AppDatabase, $ResultadosTable> {
  $$ResultadosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get puntos => $composableBuilder(
    column: $table.puntos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posicion => $composableBuilder(
    column: $table.posicion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aRestar => $composableBuilder(
    column: $table.aRestar,
    builder: (column) => ColumnFilters(column),
  );

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableFilterComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableFilterComposer get pilotoId {
    final $$PilotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableFilterComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableFilterComposer get equipoId {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableFilterComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResultadosTableOrderingComposer
    extends Composer<_$AppDatabase, $ResultadosTable> {
  $$ResultadosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get puntos => $composableBuilder(
    column: $table.puntos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posicion => $composableBuilder(
    column: $table.posicion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aRestar => $composableBuilder(
    column: $table.aRestar,
    builder: (column) => ColumnOrderings(column),
  );

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableOrderingComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableOrderingComposer get pilotoId {
    final $$PilotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableOrderingComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableOrderingComposer get equipoId {
    final $$EquiposTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableOrderingComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResultadosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResultadosTable> {
  $$ResultadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get puntos =>
      $composableBuilder(column: $table.puntos, builder: (column) => column);

  GeneratedColumn<int> get posicion =>
      $composableBuilder(column: $table.posicion, builder: (column) => column);

  GeneratedColumn<int> get aRestar =>
      $composableBuilder(column: $table.aRestar, builder: (column) => column);

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableAnnotationComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableAnnotationComposer get pilotoId {
    final $$PilotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableAnnotationComposer get equipoId {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableAnnotationComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ResultadosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResultadosTable,
          Resultado,
          $$ResultadosTableFilterComposer,
          $$ResultadosTableOrderingComposer,
          $$ResultadosTableAnnotationComposer,
          $$ResultadosTableCreateCompanionBuilder,
          $$ResultadosTableUpdateCompanionBuilder,
          (Resultado, $$ResultadosTableReferences),
          Resultado,
          PrefetchHooks Function({bool mangaId, bool pilotoId, bool equipoId})
        > {
  $$ResultadosTableTableManager(_$AppDatabase db, $ResultadosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResultadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResultadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResultadosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mangaId = const Value.absent(),
                Value<int> pilotoId = const Value.absent(),
                Value<int> equipoId = const Value.absent(),
                Value<int> puntos = const Value.absent(),
                Value<int?> posicion = const Value.absent(),
                Value<int> aRestar = const Value.absent(),
              }) => ResultadosCompanion(
                id: id,
                mangaId: mangaId,
                pilotoId: pilotoId,
                equipoId: equipoId,
                puntos: puntos,
                posicion: posicion,
                aRestar: aRestar,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mangaId,
                required int pilotoId,
                required int equipoId,
                Value<int> puntos = const Value.absent(),
                Value<int?> posicion = const Value.absent(),
                Value<int> aRestar = const Value.absent(),
              }) => ResultadosCompanion.insert(
                id: id,
                mangaId: mangaId,
                pilotoId: pilotoId,
                equipoId: equipoId,
                puntos: puntos,
                posicion: posicion,
                aRestar: aRestar,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ResultadosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({mangaId = false, pilotoId = false, equipoId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (mangaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.mangaId,
                                    referencedTable: $$ResultadosTableReferences
                                        ._mangaIdTable(db),
                                    referencedColumn:
                                        $$ResultadosTableReferences
                                            ._mangaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (pilotoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.pilotoId,
                                    referencedTable: $$ResultadosTableReferences
                                        ._pilotoIdTable(db),
                                    referencedColumn:
                                        $$ResultadosTableReferences
                                            ._pilotoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (equipoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipoId,
                                    referencedTable: $$ResultadosTableReferences
                                        ._equipoIdTable(db),
                                    referencedColumn:
                                        $$ResultadosTableReferences
                                            ._equipoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ResultadosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResultadosTable,
      Resultado,
      $$ResultadosTableFilterComposer,
      $$ResultadosTableOrderingComposer,
      $$ResultadosTableAnnotationComposer,
      $$ResultadosTableCreateCompanionBuilder,
      $$ResultadosTableUpdateCompanionBuilder,
      (Resultado, $$ResultadosTableReferences),
      Resultado,
      PrefetchHooks Function({bool mangaId, bool pilotoId, bool equipoId})
    >;
typedef $$DescartesPruebaTableCreateCompanionBuilder =
    DescartesPruebaCompanion Function({
      required int pilotoId,
      required int pruebaId,
      Value<int> rowid,
    });
typedef $$DescartesPruebaTableUpdateCompanionBuilder =
    DescartesPruebaCompanion Function({
      Value<int> pilotoId,
      Value<int> pruebaId,
      Value<int> rowid,
    });

final class $$DescartesPruebaTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DescartesPruebaTable,
          DescartesPruebaData
        > {
  $$DescartesPruebaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PilotosTable _pilotoIdTable(_$AppDatabase db) =>
      db.pilotos.createAlias(
        $_aliasNameGenerator(db.descartesPrueba.pilotoId, db.pilotos.id),
      );

  $$PilotosTableProcessedTableManager get pilotoId {
    final $_column = $_itemColumn<int>('piloto_id')!;

    final manager = $$PilotosTableTableManager(
      $_db,
      $_db.pilotos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pilotoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PruebasTable _pruebaIdTable(_$AppDatabase db) =>
      db.pruebas.createAlias(
        $_aliasNameGenerator(db.descartesPrueba.pruebaId, db.pruebas.id),
      );

  $$PruebasTableProcessedTableManager get pruebaId {
    final $_column = $_itemColumn<int>('prueba_id')!;

    final manager = $$PruebasTableTableManager(
      $_db,
      $_db.pruebas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pruebaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DescartesPruebaTableFilterComposer
    extends Composer<_$AppDatabase, $DescartesPruebaTable> {
  $$DescartesPruebaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PilotosTableFilterComposer get pilotoId {
    final $$PilotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableFilterComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableFilterComposer get pruebaId {
    final $$PruebasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableFilterComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DescartesPruebaTableOrderingComposer
    extends Composer<_$AppDatabase, $DescartesPruebaTable> {
  $$DescartesPruebaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PilotosTableOrderingComposer get pilotoId {
    final $$PilotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableOrderingComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableOrderingComposer get pruebaId {
    final $$PruebasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableOrderingComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DescartesPruebaTableAnnotationComposer
    extends Composer<_$AppDatabase, $DescartesPruebaTable> {
  $$DescartesPruebaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PilotosTableAnnotationComposer get pilotoId {
    final $$PilotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableAnnotationComposer get pruebaId {
    final $$PruebasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableAnnotationComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DescartesPruebaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DescartesPruebaTable,
          DescartesPruebaData,
          $$DescartesPruebaTableFilterComposer,
          $$DescartesPruebaTableOrderingComposer,
          $$DescartesPruebaTableAnnotationComposer,
          $$DescartesPruebaTableCreateCompanionBuilder,
          $$DescartesPruebaTableUpdateCompanionBuilder,
          (DescartesPruebaData, $$DescartesPruebaTableReferences),
          DescartesPruebaData,
          PrefetchHooks Function({bool pilotoId, bool pruebaId})
        > {
  $$DescartesPruebaTableTableManager(
    _$AppDatabase db,
    $DescartesPruebaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DescartesPruebaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DescartesPruebaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DescartesPruebaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> pilotoId = const Value.absent(),
                Value<int> pruebaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DescartesPruebaCompanion(
                pilotoId: pilotoId,
                pruebaId: pruebaId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int pilotoId,
                required int pruebaId,
                Value<int> rowid = const Value.absent(),
              }) => DescartesPruebaCompanion.insert(
                pilotoId: pilotoId,
                pruebaId: pruebaId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DescartesPruebaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pilotoId = false, pruebaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pilotoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pilotoId,
                                referencedTable:
                                    $$DescartesPruebaTableReferences
                                        ._pilotoIdTable(db),
                                referencedColumn:
                                    $$DescartesPruebaTableReferences
                                        ._pilotoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (pruebaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pruebaId,
                                referencedTable:
                                    $$DescartesPruebaTableReferences
                                        ._pruebaIdTable(db),
                                referencedColumn:
                                    $$DescartesPruebaTableReferences
                                        ._pruebaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DescartesPruebaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DescartesPruebaTable,
      DescartesPruebaData,
      $$DescartesPruebaTableFilterComposer,
      $$DescartesPruebaTableOrderingComposer,
      $$DescartesPruebaTableAnnotationComposer,
      $$DescartesPruebaTableCreateCompanionBuilder,
      $$DescartesPruebaTableUpdateCompanionBuilder,
      (DescartesPruebaData, $$DescartesPruebaTableReferences),
      DescartesPruebaData,
      PrefetchHooks Function({bool pilotoId, bool pruebaId})
    >;
typedef $$OverridesCopaTableCreateCompanionBuilder =
    OverridesCopaCompanion Function({
      required int campeonatoId,
      required String copa,
      required int pilotoId,
      required int pruebaId,
      required int puntos,
      Value<int> rowid,
    });
typedef $$OverridesCopaTableUpdateCompanionBuilder =
    OverridesCopaCompanion Function({
      Value<int> campeonatoId,
      Value<String> copa,
      Value<int> pilotoId,
      Value<int> pruebaId,
      Value<int> puntos,
      Value<int> rowid,
    });

final class $$OverridesCopaTableReferences
    extends
        BaseReferences<_$AppDatabase, $OverridesCopaTable, OverridesCopaData> {
  $$OverridesCopaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CampeonatosTable _campeonatoIdTable(_$AppDatabase db) =>
      db.campeonatos.createAlias(
        $_aliasNameGenerator(db.overridesCopa.campeonatoId, db.campeonatos.id),
      );

  $$CampeonatosTableProcessedTableManager get campeonatoId {
    final $_column = $_itemColumn<int>('campeonato_id')!;

    final manager = $$CampeonatosTableTableManager(
      $_db,
      $_db.campeonatos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campeonatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PilotosTable _pilotoIdTable(_$AppDatabase db) =>
      db.pilotos.createAlias(
        $_aliasNameGenerator(db.overridesCopa.pilotoId, db.pilotos.id),
      );

  $$PilotosTableProcessedTableManager get pilotoId {
    final $_column = $_itemColumn<int>('piloto_id')!;

    final manager = $$PilotosTableTableManager(
      $_db,
      $_db.pilotos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pilotoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PruebasTable _pruebaIdTable(_$AppDatabase db) =>
      db.pruebas.createAlias(
        $_aliasNameGenerator(db.overridesCopa.pruebaId, db.pruebas.id),
      );

  $$PruebasTableProcessedTableManager get pruebaId {
    final $_column = $_itemColumn<int>('prueba_id')!;

    final manager = $$PruebasTableTableManager(
      $_db,
      $_db.pruebas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pruebaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OverridesCopaTableFilterComposer
    extends Composer<_$AppDatabase, $OverridesCopaTable> {
  $$OverridesCopaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get copa => $composableBuilder(
    column: $table.copa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get puntos => $composableBuilder(
    column: $table.puntos,
    builder: (column) => ColumnFilters(column),
  );

  $$CampeonatosTableFilterComposer get campeonatoId {
    final $$CampeonatosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableFilterComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableFilterComposer get pilotoId {
    final $$PilotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableFilterComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableFilterComposer get pruebaId {
    final $$PruebasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableFilterComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesCopaTableOrderingComposer
    extends Composer<_$AppDatabase, $OverridesCopaTable> {
  $$OverridesCopaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get copa => $composableBuilder(
    column: $table.copa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get puntos => $composableBuilder(
    column: $table.puntos,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampeonatosTableOrderingComposer get campeonatoId {
    final $$CampeonatosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableOrderingComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableOrderingComposer get pilotoId {
    final $$PilotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableOrderingComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableOrderingComposer get pruebaId {
    final $$PruebasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableOrderingComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesCopaTableAnnotationComposer
    extends Composer<_$AppDatabase, $OverridesCopaTable> {
  $$OverridesCopaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get copa =>
      $composableBuilder(column: $table.copa, builder: (column) => column);

  GeneratedColumn<int> get puntos =>
      $composableBuilder(column: $table.puntos, builder: (column) => column);

  $$CampeonatosTableAnnotationComposer get campeonatoId {
    final $$CampeonatosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableAnnotationComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PilotosTableAnnotationComposer get pilotoId {
    final $$PilotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableAnnotationComposer get pruebaId {
    final $$PruebasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableAnnotationComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesCopaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OverridesCopaTable,
          OverridesCopaData,
          $$OverridesCopaTableFilterComposer,
          $$OverridesCopaTableOrderingComposer,
          $$OverridesCopaTableAnnotationComposer,
          $$OverridesCopaTableCreateCompanionBuilder,
          $$OverridesCopaTableUpdateCompanionBuilder,
          (OverridesCopaData, $$OverridesCopaTableReferences),
          OverridesCopaData,
          PrefetchHooks Function({
            bool campeonatoId,
            bool pilotoId,
            bool pruebaId,
          })
        > {
  $$OverridesCopaTableTableManager(_$AppDatabase db, $OverridesCopaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OverridesCopaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OverridesCopaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OverridesCopaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> campeonatoId = const Value.absent(),
                Value<String> copa = const Value.absent(),
                Value<int> pilotoId = const Value.absent(),
                Value<int> pruebaId = const Value.absent(),
                Value<int> puntos = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OverridesCopaCompanion(
                campeonatoId: campeonatoId,
                copa: copa,
                pilotoId: pilotoId,
                pruebaId: pruebaId,
                puntos: puntos,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int campeonatoId,
                required String copa,
                required int pilotoId,
                required int pruebaId,
                required int puntos,
                Value<int> rowid = const Value.absent(),
              }) => OverridesCopaCompanion.insert(
                campeonatoId: campeonatoId,
                copa: copa,
                pilotoId: pilotoId,
                pruebaId: pruebaId,
                puntos: puntos,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OverridesCopaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({campeonatoId = false, pilotoId = false, pruebaId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (campeonatoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.campeonatoId,
                                    referencedTable:
                                        $$OverridesCopaTableReferences
                                            ._campeonatoIdTable(db),
                                    referencedColumn:
                                        $$OverridesCopaTableReferences
                                            ._campeonatoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (pilotoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.pilotoId,
                                    referencedTable:
                                        $$OverridesCopaTableReferences
                                            ._pilotoIdTable(db),
                                    referencedColumn:
                                        $$OverridesCopaTableReferences
                                            ._pilotoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (pruebaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.pruebaId,
                                    referencedTable:
                                        $$OverridesCopaTableReferences
                                            ._pruebaIdTable(db),
                                    referencedColumn:
                                        $$OverridesCopaTableReferences
                                            ._pruebaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$OverridesCopaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OverridesCopaTable,
      OverridesCopaData,
      $$OverridesCopaTableFilterComposer,
      $$OverridesCopaTableOrderingComposer,
      $$OverridesCopaTableAnnotationComposer,
      $$OverridesCopaTableCreateCompanionBuilder,
      $$OverridesCopaTableUpdateCompanionBuilder,
      (OverridesCopaData, $$OverridesCopaTableReferences),
      OverridesCopaData,
      PrefetchHooks Function({bool campeonatoId, bool pilotoId, bool pruebaId})
    >;
typedef $$CatalogoCochesTableCreateCompanionBuilder =
    CatalogoCochesCompanion Function({
      Value<int> id,
      required String nombre,
      required String marca,
      required String modelo,
      required double pesoMin,
      Value<int> creditosCoche,
      Value<bool> activo,
      Value<String> copasJson,
      Value<String?> fotoPath,
    });
typedef $$CatalogoCochesTableUpdateCompanionBuilder =
    CatalogoCochesCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> marca,
      Value<String> modelo,
      Value<double> pesoMin,
      Value<int> creditosCoche,
      Value<bool> activo,
      Value<String> copasJson,
      Value<String?> fotoPath,
    });

final class $$CatalogoCochesTableReferences
    extends BaseReferences<_$AppDatabase, $CatalogoCochesTable, CatalogoCoche> {
  $$CatalogoCochesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$VerificacionesTable, List<Verificacione>>
  _verificacionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.verificaciones,
    aliasName: $_aliasNameGenerator(
      db.catalogoCoches.id,
      db.verificaciones.cocheCatalogoId,
    ),
  );

  $$VerificacionesTableProcessedTableManager get verificacionesRefs {
    final manager = $$VerificacionesTableTableManager(
      $_db,
      $_db.verificaciones,
    ).filter((f) => f.cocheCatalogoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_verificacionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatalogoCochesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoCochesTable> {
  $$CatalogoCochesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoMin => $composableBuilder(
    column: $table.pesoMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditosCoche => $composableBuilder(
    column: $table.creditosCoche,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> verificacionesRefs(
    Expression<bool> Function($$VerificacionesTableFilterComposer f) f,
  ) {
    final $$VerificacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.cocheCatalogoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableFilterComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoCochesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoCochesTable> {
  $$CatalogoCochesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoMin => $composableBuilder(
    column: $table.pesoMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditosCoche => $composableBuilder(
    column: $table.creditosCoche,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoCochesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoCochesTable> {
  $$CatalogoCochesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<double> get pesoMin =>
      $composableBuilder(column: $table.pesoMin, builder: (column) => column);

  GeneratedColumn<int> get creditosCoche => $composableBuilder(
    column: $table.creditosCoche,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<String> get copasJson =>
      $composableBuilder(column: $table.copasJson, builder: (column) => column);

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  Expression<T> verificacionesRefs<T extends Object>(
    Expression<T> Function($$VerificacionesTableAnnotationComposer a) f,
  ) {
    final $$VerificacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.cocheCatalogoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatalogoCochesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoCochesTable,
          CatalogoCoche,
          $$CatalogoCochesTableFilterComposer,
          $$CatalogoCochesTableOrderingComposer,
          $$CatalogoCochesTableAnnotationComposer,
          $$CatalogoCochesTableCreateCompanionBuilder,
          $$CatalogoCochesTableUpdateCompanionBuilder,
          (CatalogoCoche, $$CatalogoCochesTableReferences),
          CatalogoCoche,
          PrefetchHooks Function({bool verificacionesRefs})
        > {
  $$CatalogoCochesTableTableManager(
    _$AppDatabase db,
    $CatalogoCochesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoCochesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoCochesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoCochesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> marca = const Value.absent(),
                Value<String> modelo = const Value.absent(),
                Value<double> pesoMin = const Value.absent(),
                Value<int> creditosCoche = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<String> copasJson = const Value.absent(),
                Value<String?> fotoPath = const Value.absent(),
              }) => CatalogoCochesCompanion(
                id: id,
                nombre: nombre,
                marca: marca,
                modelo: modelo,
                pesoMin: pesoMin,
                creditosCoche: creditosCoche,
                activo: activo,
                copasJson: copasJson,
                fotoPath: fotoPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String marca,
                required String modelo,
                required double pesoMin,
                Value<int> creditosCoche = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<String> copasJson = const Value.absent(),
                Value<String?> fotoPath = const Value.absent(),
              }) => CatalogoCochesCompanion.insert(
                id: id,
                nombre: nombre,
                marca: marca,
                modelo: modelo,
                pesoMin: pesoMin,
                creditosCoche: creditosCoche,
                activo: activo,
                copasJson: copasJson,
                fotoPath: fotoPath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CatalogoCochesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({verificacionesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (verificacionesRefs) db.verificaciones,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (verificacionesRefs)
                    await $_getPrefetchedData<
                      CatalogoCoche,
                      $CatalogoCochesTable,
                      Verificacione
                    >(
                      currentTable: table,
                      referencedTable: $$CatalogoCochesTableReferences
                          ._verificacionesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CatalogoCochesTableReferences(
                            db,
                            table,
                            p0,
                          ).verificacionesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.cocheCatalogoId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CatalogoCochesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoCochesTable,
      CatalogoCoche,
      $$CatalogoCochesTableFilterComposer,
      $$CatalogoCochesTableOrderingComposer,
      $$CatalogoCochesTableAnnotationComposer,
      $$CatalogoCochesTableCreateCompanionBuilder,
      $$CatalogoCochesTableUpdateCompanionBuilder,
      (CatalogoCoche, $$CatalogoCochesTableReferences),
      CatalogoCoche,
      PrefetchHooks Function({bool verificacionesRefs})
    >;
typedef $$VerificacionesTableCreateCompanionBuilder =
    VerificacionesCompanion Function({
      Value<int> id,
      required int mangaId,
      required int equipoId,
      Value<int?> cocheCatalogoId,
      Value<double?> pesoInicial,
      Value<double?> pesoFinal,
      Value<double?> pesoMin,
      Value<double?> pesoInicialCoche,
      Value<double?> pesoFinalCoche,
      Value<String?> motor,
      Value<String> motorTipo,
      Value<int?> motorRpm,
      Value<double?> motorUms,
      Value<String?> pinonMarca,
      Value<int?> pinonDientes,
      Value<String?> coronaMarca,
      Value<int?> coronaDientes,
      Value<String?> llantaDelMarca,
      Value<String?> llantaDelDimension,
      Value<String?> llantaTraMarca,
      Value<String?> llantaTraDimension,
      Value<String?> trencilla,
      Value<String?> suspension,
      Value<String?> bancada,
      Value<String?> chasis,
      Value<String?> neumatico,
      Value<String?> observaciones,
      Value<bool> validado,
      Value<String> fotosJson,
      Value<DateTime> fecha,
      Value<int> credAplicadoP1,
      Value<int> credAplicadoP2,
    });
typedef $$VerificacionesTableUpdateCompanionBuilder =
    VerificacionesCompanion Function({
      Value<int> id,
      Value<int> mangaId,
      Value<int> equipoId,
      Value<int?> cocheCatalogoId,
      Value<double?> pesoInicial,
      Value<double?> pesoFinal,
      Value<double?> pesoMin,
      Value<double?> pesoInicialCoche,
      Value<double?> pesoFinalCoche,
      Value<String?> motor,
      Value<String> motorTipo,
      Value<int?> motorRpm,
      Value<double?> motorUms,
      Value<String?> pinonMarca,
      Value<int?> pinonDientes,
      Value<String?> coronaMarca,
      Value<int?> coronaDientes,
      Value<String?> llantaDelMarca,
      Value<String?> llantaDelDimension,
      Value<String?> llantaTraMarca,
      Value<String?> llantaTraDimension,
      Value<String?> trencilla,
      Value<String?> suspension,
      Value<String?> bancada,
      Value<String?> chasis,
      Value<String?> neumatico,
      Value<String?> observaciones,
      Value<bool> validado,
      Value<String> fotosJson,
      Value<DateTime> fecha,
      Value<int> credAplicadoP1,
      Value<int> credAplicadoP2,
    });

final class $$VerificacionesTableReferences
    extends BaseReferences<_$AppDatabase, $VerificacionesTable, Verificacione> {
  $$VerificacionesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MangasTable _mangaIdTable(_$AppDatabase db) => db.mangas.createAlias(
    $_aliasNameGenerator(db.verificaciones.mangaId, db.mangas.id),
  );

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<int>('manga_id')!;

    final manager = $$MangasTableTableManager(
      $_db,
      $_db.mangas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquiposTable _equipoIdTable(_$AppDatabase db) =>
      db.equipos.createAlias(
        $_aliasNameGenerator(db.verificaciones.equipoId, db.equipos.id),
      );

  $$EquiposTableProcessedTableManager get equipoId {
    final $_column = $_itemColumn<int>('equipo_id')!;

    final manager = $$EquiposTableTableManager(
      $_db,
      $_db.equipos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CatalogoCochesTable _cocheCatalogoIdTable(_$AppDatabase db) =>
      db.catalogoCoches.createAlias(
        $_aliasNameGenerator(
          db.verificaciones.cocheCatalogoId,
          db.catalogoCoches.id,
        ),
      );

  $$CatalogoCochesTableProcessedTableManager? get cocheCatalogoId {
    final $_column = $_itemColumn<int>('coche_catalogo_id');
    if ($_column == null) return null;
    final manager = $$CatalogoCochesTableTableManager(
      $_db,
      $_db.catalogoCoches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cocheCatalogoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $MovimientosCreditosTable,
    List<MovimientosCredito>
  >
  _movimientosCreditosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientosCreditos,
        aliasName: $_aliasNameGenerator(
          db.verificaciones.id,
          db.movimientosCreditos.verificacionId,
        ),
      );

  $$MovimientosCreditosTableProcessedTableManager get movimientosCreditosRefs {
    final manager = $$MovimientosCreditosTableTableManager(
      $_db,
      $_db.movimientosCreditos,
    ).filter((f) => f.verificacionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosCreditosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VerificacionesTableFilterComposer
    extends Composer<_$AppDatabase, $VerificacionesTable> {
  $$VerificacionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoInicial => $composableBuilder(
    column: $table.pesoInicial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoFinal => $composableBuilder(
    column: $table.pesoFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoMin => $composableBuilder(
    column: $table.pesoMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoInicialCoche => $composableBuilder(
    column: $table.pesoInicialCoche,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pesoFinalCoche => $composableBuilder(
    column: $table.pesoFinalCoche,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motor => $composableBuilder(
    column: $table.motor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motorTipo => $composableBuilder(
    column: $table.motorTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motorRpm => $composableBuilder(
    column: $table.motorRpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get motorUms => $composableBuilder(
    column: $table.motorUms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinonMarca => $composableBuilder(
    column: $table.pinonMarca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinonDientes => $composableBuilder(
    column: $table.pinonDientes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coronaMarca => $composableBuilder(
    column: $table.coronaMarca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coronaDientes => $composableBuilder(
    column: $table.coronaDientes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get llantaDelMarca => $composableBuilder(
    column: $table.llantaDelMarca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get llantaDelDimension => $composableBuilder(
    column: $table.llantaDelDimension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get llantaTraMarca => $composableBuilder(
    column: $table.llantaTraMarca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get llantaTraDimension => $composableBuilder(
    column: $table.llantaTraDimension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trencilla => $composableBuilder(
    column: $table.trencilla,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suspension => $composableBuilder(
    column: $table.suspension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bancada => $composableBuilder(
    column: $table.bancada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chasis => $composableBuilder(
    column: $table.chasis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neumatico => $composableBuilder(
    column: $table.neumatico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get validado => $composableBuilder(
    column: $table.validado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotosJson => $composableBuilder(
    column: $table.fotosJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get credAplicadoP1 => $composableBuilder(
    column: $table.credAplicadoP1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get credAplicadoP2 => $composableBuilder(
    column: $table.credAplicadoP2,
    builder: (column) => ColumnFilters(column),
  );

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableFilterComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableFilterComposer get equipoId {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableFilterComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoCochesTableFilterComposer get cocheCatalogoId {
    final $$CatalogoCochesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cocheCatalogoId,
      referencedTable: $db.catalogoCoches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoCochesTableFilterComposer(
            $db: $db,
            $table: $db.catalogoCoches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movimientosCreditosRefs(
    Expression<bool> Function($$MovimientosCreditosTableFilterComposer f) f,
  ) {
    final $$MovimientosCreditosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosCreditos,
      getReferencedColumn: (t) => t.verificacionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosCreditosTableFilterComposer(
            $db: $db,
            $table: $db.movimientosCreditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VerificacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $VerificacionesTable> {
  $$VerificacionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoInicial => $composableBuilder(
    column: $table.pesoInicial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoFinal => $composableBuilder(
    column: $table.pesoFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoMin => $composableBuilder(
    column: $table.pesoMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoInicialCoche => $composableBuilder(
    column: $table.pesoInicialCoche,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pesoFinalCoche => $composableBuilder(
    column: $table.pesoFinalCoche,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motor => $composableBuilder(
    column: $table.motor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motorTipo => $composableBuilder(
    column: $table.motorTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motorRpm => $composableBuilder(
    column: $table.motorRpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get motorUms => $composableBuilder(
    column: $table.motorUms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinonMarca => $composableBuilder(
    column: $table.pinonMarca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinonDientes => $composableBuilder(
    column: $table.pinonDientes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coronaMarca => $composableBuilder(
    column: $table.coronaMarca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coronaDientes => $composableBuilder(
    column: $table.coronaDientes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get llantaDelMarca => $composableBuilder(
    column: $table.llantaDelMarca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get llantaDelDimension => $composableBuilder(
    column: $table.llantaDelDimension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get llantaTraMarca => $composableBuilder(
    column: $table.llantaTraMarca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get llantaTraDimension => $composableBuilder(
    column: $table.llantaTraDimension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trencilla => $composableBuilder(
    column: $table.trencilla,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suspension => $composableBuilder(
    column: $table.suspension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bancada => $composableBuilder(
    column: $table.bancada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chasis => $composableBuilder(
    column: $table.chasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neumatico => $composableBuilder(
    column: $table.neumatico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get validado => $composableBuilder(
    column: $table.validado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotosJson => $composableBuilder(
    column: $table.fotosJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get credAplicadoP1 => $composableBuilder(
    column: $table.credAplicadoP1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get credAplicadoP2 => $composableBuilder(
    column: $table.credAplicadoP2,
    builder: (column) => ColumnOrderings(column),
  );

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableOrderingComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableOrderingComposer get equipoId {
    final $$EquiposTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableOrderingComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoCochesTableOrderingComposer get cocheCatalogoId {
    final $$CatalogoCochesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cocheCatalogoId,
      referencedTable: $db.catalogoCoches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoCochesTableOrderingComposer(
            $db: $db,
            $table: $db.catalogoCoches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerificacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerificacionesTable> {
  $$VerificacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get pesoInicial => $composableBuilder(
    column: $table.pesoInicial,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pesoFinal =>
      $composableBuilder(column: $table.pesoFinal, builder: (column) => column);

  GeneratedColumn<double> get pesoMin =>
      $composableBuilder(column: $table.pesoMin, builder: (column) => column);

  GeneratedColumn<double> get pesoInicialCoche => $composableBuilder(
    column: $table.pesoInicialCoche,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pesoFinalCoche => $composableBuilder(
    column: $table.pesoFinalCoche,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motor =>
      $composableBuilder(column: $table.motor, builder: (column) => column);

  GeneratedColumn<String> get motorTipo =>
      $composableBuilder(column: $table.motorTipo, builder: (column) => column);

  GeneratedColumn<int> get motorRpm =>
      $composableBuilder(column: $table.motorRpm, builder: (column) => column);

  GeneratedColumn<double> get motorUms =>
      $composableBuilder(column: $table.motorUms, builder: (column) => column);

  GeneratedColumn<String> get pinonMarca => $composableBuilder(
    column: $table.pinonMarca,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pinonDientes => $composableBuilder(
    column: $table.pinonDientes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coronaMarca => $composableBuilder(
    column: $table.coronaMarca,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coronaDientes => $composableBuilder(
    column: $table.coronaDientes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get llantaDelMarca => $composableBuilder(
    column: $table.llantaDelMarca,
    builder: (column) => column,
  );

  GeneratedColumn<String> get llantaDelDimension => $composableBuilder(
    column: $table.llantaDelDimension,
    builder: (column) => column,
  );

  GeneratedColumn<String> get llantaTraMarca => $composableBuilder(
    column: $table.llantaTraMarca,
    builder: (column) => column,
  );

  GeneratedColumn<String> get llantaTraDimension => $composableBuilder(
    column: $table.llantaTraDimension,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trencilla =>
      $composableBuilder(column: $table.trencilla, builder: (column) => column);

  GeneratedColumn<String> get suspension => $composableBuilder(
    column: $table.suspension,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bancada =>
      $composableBuilder(column: $table.bancada, builder: (column) => column);

  GeneratedColumn<String> get chasis =>
      $composableBuilder(column: $table.chasis, builder: (column) => column);

  GeneratedColumn<String> get neumatico =>
      $composableBuilder(column: $table.neumatico, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get validado =>
      $composableBuilder(column: $table.validado, builder: (column) => column);

  GeneratedColumn<String> get fotosJson =>
      $composableBuilder(column: $table.fotosJson, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<int> get credAplicadoP1 => $composableBuilder(
    column: $table.credAplicadoP1,
    builder: (column) => column,
  );

  GeneratedColumn<int> get credAplicadoP2 => $composableBuilder(
    column: $table.credAplicadoP2,
    builder: (column) => column,
  );

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableAnnotationComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableAnnotationComposer get equipoId {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableAnnotationComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CatalogoCochesTableAnnotationComposer get cocheCatalogoId {
    final $$CatalogoCochesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cocheCatalogoId,
      referencedTable: $db.catalogoCoches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatalogoCochesTableAnnotationComposer(
            $db: $db,
            $table: $db.catalogoCoches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movimientosCreditosRefs<T extends Object>(
    Expression<T> Function($$MovimientosCreditosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosCreditosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movimientosCreditos,
          getReferencedColumn: (t) => t.verificacionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovimientosCreditosTableAnnotationComposer(
                $db: $db,
                $table: $db.movimientosCreditos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$VerificacionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerificacionesTable,
          Verificacione,
          $$VerificacionesTableFilterComposer,
          $$VerificacionesTableOrderingComposer,
          $$VerificacionesTableAnnotationComposer,
          $$VerificacionesTableCreateCompanionBuilder,
          $$VerificacionesTableUpdateCompanionBuilder,
          (Verificacione, $$VerificacionesTableReferences),
          Verificacione,
          PrefetchHooks Function({
            bool mangaId,
            bool equipoId,
            bool cocheCatalogoId,
            bool movimientosCreditosRefs,
          })
        > {
  $$VerificacionesTableTableManager(
    _$AppDatabase db,
    $VerificacionesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerificacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerificacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerificacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mangaId = const Value.absent(),
                Value<int> equipoId = const Value.absent(),
                Value<int?> cocheCatalogoId = const Value.absent(),
                Value<double?> pesoInicial = const Value.absent(),
                Value<double?> pesoFinal = const Value.absent(),
                Value<double?> pesoMin = const Value.absent(),
                Value<double?> pesoInicialCoche = const Value.absent(),
                Value<double?> pesoFinalCoche = const Value.absent(),
                Value<String?> motor = const Value.absent(),
                Value<String> motorTipo = const Value.absent(),
                Value<int?> motorRpm = const Value.absent(),
                Value<double?> motorUms = const Value.absent(),
                Value<String?> pinonMarca = const Value.absent(),
                Value<int?> pinonDientes = const Value.absent(),
                Value<String?> coronaMarca = const Value.absent(),
                Value<int?> coronaDientes = const Value.absent(),
                Value<String?> llantaDelMarca = const Value.absent(),
                Value<String?> llantaDelDimension = const Value.absent(),
                Value<String?> llantaTraMarca = const Value.absent(),
                Value<String?> llantaTraDimension = const Value.absent(),
                Value<String?> trencilla = const Value.absent(),
                Value<String?> suspension = const Value.absent(),
                Value<String?> bancada = const Value.absent(),
                Value<String?> chasis = const Value.absent(),
                Value<String?> neumatico = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<bool> validado = const Value.absent(),
                Value<String> fotosJson = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<int> credAplicadoP1 = const Value.absent(),
                Value<int> credAplicadoP2 = const Value.absent(),
              }) => VerificacionesCompanion(
                id: id,
                mangaId: mangaId,
                equipoId: equipoId,
                cocheCatalogoId: cocheCatalogoId,
                pesoInicial: pesoInicial,
                pesoFinal: pesoFinal,
                pesoMin: pesoMin,
                pesoInicialCoche: pesoInicialCoche,
                pesoFinalCoche: pesoFinalCoche,
                motor: motor,
                motorTipo: motorTipo,
                motorRpm: motorRpm,
                motorUms: motorUms,
                pinonMarca: pinonMarca,
                pinonDientes: pinonDientes,
                coronaMarca: coronaMarca,
                coronaDientes: coronaDientes,
                llantaDelMarca: llantaDelMarca,
                llantaDelDimension: llantaDelDimension,
                llantaTraMarca: llantaTraMarca,
                llantaTraDimension: llantaTraDimension,
                trencilla: trencilla,
                suspension: suspension,
                bancada: bancada,
                chasis: chasis,
                neumatico: neumatico,
                observaciones: observaciones,
                validado: validado,
                fotosJson: fotosJson,
                fecha: fecha,
                credAplicadoP1: credAplicadoP1,
                credAplicadoP2: credAplicadoP2,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mangaId,
                required int equipoId,
                Value<int?> cocheCatalogoId = const Value.absent(),
                Value<double?> pesoInicial = const Value.absent(),
                Value<double?> pesoFinal = const Value.absent(),
                Value<double?> pesoMin = const Value.absent(),
                Value<double?> pesoInicialCoche = const Value.absent(),
                Value<double?> pesoFinalCoche = const Value.absent(),
                Value<String?> motor = const Value.absent(),
                Value<String> motorTipo = const Value.absent(),
                Value<int?> motorRpm = const Value.absent(),
                Value<double?> motorUms = const Value.absent(),
                Value<String?> pinonMarca = const Value.absent(),
                Value<int?> pinonDientes = const Value.absent(),
                Value<String?> coronaMarca = const Value.absent(),
                Value<int?> coronaDientes = const Value.absent(),
                Value<String?> llantaDelMarca = const Value.absent(),
                Value<String?> llantaDelDimension = const Value.absent(),
                Value<String?> llantaTraMarca = const Value.absent(),
                Value<String?> llantaTraDimension = const Value.absent(),
                Value<String?> trencilla = const Value.absent(),
                Value<String?> suspension = const Value.absent(),
                Value<String?> bancada = const Value.absent(),
                Value<String?> chasis = const Value.absent(),
                Value<String?> neumatico = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<bool> validado = const Value.absent(),
                Value<String> fotosJson = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<int> credAplicadoP1 = const Value.absent(),
                Value<int> credAplicadoP2 = const Value.absent(),
              }) => VerificacionesCompanion.insert(
                id: id,
                mangaId: mangaId,
                equipoId: equipoId,
                cocheCatalogoId: cocheCatalogoId,
                pesoInicial: pesoInicial,
                pesoFinal: pesoFinal,
                pesoMin: pesoMin,
                pesoInicialCoche: pesoInicialCoche,
                pesoFinalCoche: pesoFinalCoche,
                motor: motor,
                motorTipo: motorTipo,
                motorRpm: motorRpm,
                motorUms: motorUms,
                pinonMarca: pinonMarca,
                pinonDientes: pinonDientes,
                coronaMarca: coronaMarca,
                coronaDientes: coronaDientes,
                llantaDelMarca: llantaDelMarca,
                llantaDelDimension: llantaDelDimension,
                llantaTraMarca: llantaTraMarca,
                llantaTraDimension: llantaTraDimension,
                trencilla: trencilla,
                suspension: suspension,
                bancada: bancada,
                chasis: chasis,
                neumatico: neumatico,
                observaciones: observaciones,
                validado: validado,
                fotosJson: fotosJson,
                fecha: fecha,
                credAplicadoP1: credAplicadoP1,
                credAplicadoP2: credAplicadoP2,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VerificacionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                mangaId = false,
                equipoId = false,
                cocheCatalogoId = false,
                movimientosCreditosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientosCreditosRefs) db.movimientosCreditos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (mangaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.mangaId,
                                    referencedTable:
                                        $$VerificacionesTableReferences
                                            ._mangaIdTable(db),
                                    referencedColumn:
                                        $$VerificacionesTableReferences
                                            ._mangaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (equipoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipoId,
                                    referencedTable:
                                        $$VerificacionesTableReferences
                                            ._equipoIdTable(db),
                                    referencedColumn:
                                        $$VerificacionesTableReferences
                                            ._equipoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (cocheCatalogoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cocheCatalogoId,
                                    referencedTable:
                                        $$VerificacionesTableReferences
                                            ._cocheCatalogoIdTable(db),
                                    referencedColumn:
                                        $$VerificacionesTableReferences
                                            ._cocheCatalogoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientosCreditosRefs)
                        await $_getPrefetchedData<
                          Verificacione,
                          $VerificacionesTable,
                          MovimientosCredito
                        >(
                          currentTable: table,
                          referencedTable: $$VerificacionesTableReferences
                              ._movimientosCreditosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VerificacionesTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosCreditosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.verificacionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VerificacionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerificacionesTable,
      Verificacione,
      $$VerificacionesTableFilterComposer,
      $$VerificacionesTableOrderingComposer,
      $$VerificacionesTableAnnotationComposer,
      $$VerificacionesTableCreateCompanionBuilder,
      $$VerificacionesTableUpdateCompanionBuilder,
      (Verificacione, $$VerificacionesTableReferences),
      Verificacione,
      PrefetchHooks Function({
        bool mangaId,
        bool equipoId,
        bool cocheCatalogoId,
        bool movimientosCreditosRefs,
      })
    >;
typedef $$PagosTableCreateCompanionBuilder =
    PagosCompanion Function({
      Value<int> id,
      required int pruebaId,
      required int equipoId,
      Value<double> pagat,
      Value<double> coordinadora,
      Value<double> club,
      Value<DateTime> fecha,
      Value<String?> observaciones,
    });
typedef $$PagosTableUpdateCompanionBuilder =
    PagosCompanion Function({
      Value<int> id,
      Value<int> pruebaId,
      Value<int> equipoId,
      Value<double> pagat,
      Value<double> coordinadora,
      Value<double> club,
      Value<DateTime> fecha,
      Value<String?> observaciones,
    });

final class $$PagosTableReferences
    extends BaseReferences<_$AppDatabase, $PagosTable, Pago> {
  $$PagosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PruebasTable _pruebaIdTable(_$AppDatabase db) => db.pruebas
      .createAlias($_aliasNameGenerator(db.pagos.pruebaId, db.pruebas.id));

  $$PruebasTableProcessedTableManager get pruebaId {
    final $_column = $_itemColumn<int>('prueba_id')!;

    final manager = $$PruebasTableTableManager(
      $_db,
      $_db.pruebas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pruebaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquiposTable _equipoIdTable(_$AppDatabase db) => db.equipos
      .createAlias($_aliasNameGenerator(db.pagos.equipoId, db.equipos.id));

  $$EquiposTableProcessedTableManager get equipoId {
    final $_column = $_itemColumn<int>('equipo_id')!;

    final manager = $$EquiposTableTableManager(
      $_db,
      $_db.equipos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PagosTableFilterComposer extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pagat => $composableBuilder(
    column: $table.pagat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get coordinadora => $composableBuilder(
    column: $table.coordinadora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get club => $composableBuilder(
    column: $table.club,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  $$PruebasTableFilterComposer get pruebaId {
    final $$PruebasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableFilterComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableFilterComposer get equipoId {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableFilterComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableOrderingComposer
    extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pagat => $composableBuilder(
    column: $table.pagat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get coordinadora => $composableBuilder(
    column: $table.coordinadora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get club => $composableBuilder(
    column: $table.club,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  $$PruebasTableOrderingComposer get pruebaId {
    final $$PruebasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableOrderingComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableOrderingComposer get equipoId {
    final $$EquiposTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableOrderingComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get pagat =>
      $composableBuilder(column: $table.pagat, builder: (column) => column);

  GeneratedColumn<double> get coordinadora => $composableBuilder(
    column: $table.coordinadora,
    builder: (column) => column,
  );

  GeneratedColumn<double> get club =>
      $composableBuilder(column: $table.club, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  $$PruebasTableAnnotationComposer get pruebaId {
    final $$PruebasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableAnnotationComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableAnnotationComposer get equipoId {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableAnnotationComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PagosTable,
          Pago,
          $$PagosTableFilterComposer,
          $$PagosTableOrderingComposer,
          $$PagosTableAnnotationComposer,
          $$PagosTableCreateCompanionBuilder,
          $$PagosTableUpdateCompanionBuilder,
          (Pago, $$PagosTableReferences),
          Pago,
          PrefetchHooks Function({bool pruebaId, bool equipoId})
        > {
  $$PagosTableTableManager(_$AppDatabase db, $PagosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pruebaId = const Value.absent(),
                Value<int> equipoId = const Value.absent(),
                Value<double> pagat = const Value.absent(),
                Value<double> coordinadora = const Value.absent(),
                Value<double> club = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
              }) => PagosCompanion(
                id: id,
                pruebaId: pruebaId,
                equipoId: equipoId,
                pagat: pagat,
                coordinadora: coordinadora,
                club: club,
                fecha: fecha,
                observaciones: observaciones,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pruebaId,
                required int equipoId,
                Value<double> pagat = const Value.absent(),
                Value<double> coordinadora = const Value.absent(),
                Value<double> club = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
              }) => PagosCompanion.insert(
                id: id,
                pruebaId: pruebaId,
                equipoId: equipoId,
                pagat: pagat,
                coordinadora: coordinadora,
                club: club,
                fecha: fecha,
                observaciones: observaciones,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PagosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({pruebaId = false, equipoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pruebaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pruebaId,
                                referencedTable: $$PagosTableReferences
                                    ._pruebaIdTable(db),
                                referencedColumn: $$PagosTableReferences
                                    ._pruebaIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (equipoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.equipoId,
                                referencedTable: $$PagosTableReferences
                                    ._equipoIdTable(db),
                                referencedColumn: $$PagosTableReferences
                                    ._equipoIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PagosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PagosTable,
      Pago,
      $$PagosTableFilterComposer,
      $$PagosTableOrderingComposer,
      $$PagosTableAnnotationComposer,
      $$PagosTableCreateCompanionBuilder,
      $$PagosTableUpdateCompanionBuilder,
      (Pago, $$PagosTableReferences),
      Pago,
      PrefetchHooks Function({bool pruebaId, bool equipoId})
    >;
typedef $$MovimientosTesoreriaTableCreateCompanionBuilder =
    MovimientosTesoreriaCompanion Function({
      Value<int> id,
      required int campeonatoId,
      Value<int?> pruebaId,
      required String concepto,
      required double importe,
      Value<DateTime> fecha,
      Value<String?> notas,
    });
typedef $$MovimientosTesoreriaTableUpdateCompanionBuilder =
    MovimientosTesoreriaCompanion Function({
      Value<int> id,
      Value<int> campeonatoId,
      Value<int?> pruebaId,
      Value<String> concepto,
      Value<double> importe,
      Value<DateTime> fecha,
      Value<String?> notas,
    });

final class $$MovimientosTesoreriaTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MovimientosTesoreriaTable,
          MovimientosTesoreriaData
        > {
  $$MovimientosTesoreriaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CampeonatosTable _campeonatoIdTable(_$AppDatabase db) =>
      db.campeonatos.createAlias(
        $_aliasNameGenerator(
          db.movimientosTesoreria.campeonatoId,
          db.campeonatos.id,
        ),
      );

  $$CampeonatosTableProcessedTableManager get campeonatoId {
    final $_column = $_itemColumn<int>('campeonato_id')!;

    final manager = $$CampeonatosTableTableManager(
      $_db,
      $_db.campeonatos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campeonatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PruebasTable _pruebaIdTable(_$AppDatabase db) =>
      db.pruebas.createAlias(
        $_aliasNameGenerator(db.movimientosTesoreria.pruebaId, db.pruebas.id),
      );

  $$PruebasTableProcessedTableManager? get pruebaId {
    final $_column = $_itemColumn<int>('prueba_id');
    if ($_column == null) return null;
    final manager = $$PruebasTableTableManager(
      $_db,
      $_db.pruebas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pruebaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimientosTesoreriaTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosTesoreriaTable> {
  $$MovimientosTesoreriaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  $$CampeonatosTableFilterComposer get campeonatoId {
    final $$CampeonatosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableFilterComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableFilterComposer get pruebaId {
    final $$PruebasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableFilterComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTesoreriaTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosTesoreriaTable> {
  $$MovimientosTesoreriaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importe => $composableBuilder(
    column: $table.importe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampeonatosTableOrderingComposer get campeonatoId {
    final $$CampeonatosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableOrderingComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableOrderingComposer get pruebaId {
    final $$PruebasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableOrderingComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTesoreriaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosTesoreriaTable> {
  $$MovimientosTesoreriaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<double> get importe =>
      $composableBuilder(column: $table.importe, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  $$CampeonatosTableAnnotationComposer get campeonatoId {
    final $$CampeonatosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableAnnotationComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableAnnotationComposer get pruebaId {
    final $$PruebasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableAnnotationComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTesoreriaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimientosTesoreriaTable,
          MovimientosTesoreriaData,
          $$MovimientosTesoreriaTableFilterComposer,
          $$MovimientosTesoreriaTableOrderingComposer,
          $$MovimientosTesoreriaTableAnnotationComposer,
          $$MovimientosTesoreriaTableCreateCompanionBuilder,
          $$MovimientosTesoreriaTableUpdateCompanionBuilder,
          (MovimientosTesoreriaData, $$MovimientosTesoreriaTableReferences),
          MovimientosTesoreriaData,
          PrefetchHooks Function({bool campeonatoId, bool pruebaId})
        > {
  $$MovimientosTesoreriaTableTableManager(
    _$AppDatabase db,
    $MovimientosTesoreriaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTesoreriaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTesoreriaTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MovimientosTesoreriaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> campeonatoId = const Value.absent(),
                Value<int?> pruebaId = const Value.absent(),
                Value<String> concepto = const Value.absent(),
                Value<double> importe = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => MovimientosTesoreriaCompanion(
                id: id,
                campeonatoId: campeonatoId,
                pruebaId: pruebaId,
                concepto: concepto,
                importe: importe,
                fecha: fecha,
                notas: notas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int campeonatoId,
                Value<int?> pruebaId = const Value.absent(),
                required String concepto,
                required double importe,
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => MovimientosTesoreriaCompanion.insert(
                id: id,
                campeonatoId: campeonatoId,
                pruebaId: pruebaId,
                concepto: concepto,
                importe: importe,
                fecha: fecha,
                notas: notas,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MovimientosTesoreriaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({campeonatoId = false, pruebaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (campeonatoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.campeonatoId,
                                referencedTable:
                                    $$MovimientosTesoreriaTableReferences
                                        ._campeonatoIdTable(db),
                                referencedColumn:
                                    $$MovimientosTesoreriaTableReferences
                                        ._campeonatoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (pruebaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pruebaId,
                                referencedTable:
                                    $$MovimientosTesoreriaTableReferences
                                        ._pruebaIdTable(db),
                                referencedColumn:
                                    $$MovimientosTesoreriaTableReferences
                                        ._pruebaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovimientosTesoreriaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimientosTesoreriaTable,
      MovimientosTesoreriaData,
      $$MovimientosTesoreriaTableFilterComposer,
      $$MovimientosTesoreriaTableOrderingComposer,
      $$MovimientosTesoreriaTableAnnotationComposer,
      $$MovimientosTesoreriaTableCreateCompanionBuilder,
      $$MovimientosTesoreriaTableUpdateCompanionBuilder,
      (MovimientosTesoreriaData, $$MovimientosTesoreriaTableReferences),
      MovimientosTesoreriaData,
      PrefetchHooks Function({bool campeonatoId, bool pruebaId})
    >;
typedef $$MovimientosCreditosTableCreateCompanionBuilder =
    MovimientosCreditosCompanion Function({
      Value<int> id,
      required int pilotoId,
      required int campeonatoId,
      Value<int?> verificacionId,
      Value<int?> equipoId,
      Value<int?> pruebaId,
      required int delta,
      required int saldoResultante,
      required String motivo,
      Value<DateTime> fecha,
    });
typedef $$MovimientosCreditosTableUpdateCompanionBuilder =
    MovimientosCreditosCompanion Function({
      Value<int> id,
      Value<int> pilotoId,
      Value<int> campeonatoId,
      Value<int?> verificacionId,
      Value<int?> equipoId,
      Value<int?> pruebaId,
      Value<int> delta,
      Value<int> saldoResultante,
      Value<String> motivo,
      Value<DateTime> fecha,
    });

final class $$MovimientosCreditosTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MovimientosCreditosTable,
          MovimientosCredito
        > {
  $$MovimientosCreditosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PilotosTable _pilotoIdTable(_$AppDatabase db) =>
      db.pilotos.createAlias(
        $_aliasNameGenerator(db.movimientosCreditos.pilotoId, db.pilotos.id),
      );

  $$PilotosTableProcessedTableManager get pilotoId {
    final $_column = $_itemColumn<int>('piloto_id')!;

    final manager = $$PilotosTableTableManager(
      $_db,
      $_db.pilotos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pilotoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CampeonatosTable _campeonatoIdTable(_$AppDatabase db) =>
      db.campeonatos.createAlias(
        $_aliasNameGenerator(
          db.movimientosCreditos.campeonatoId,
          db.campeonatos.id,
        ),
      );

  $$CampeonatosTableProcessedTableManager get campeonatoId {
    final $_column = $_itemColumn<int>('campeonato_id')!;

    final manager = $$CampeonatosTableTableManager(
      $_db,
      $_db.campeonatos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campeonatoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VerificacionesTable _verificacionIdTable(_$AppDatabase db) =>
      db.verificaciones.createAlias(
        $_aliasNameGenerator(
          db.movimientosCreditos.verificacionId,
          db.verificaciones.id,
        ),
      );

  $$VerificacionesTableProcessedTableManager? get verificacionId {
    final $_column = $_itemColumn<int>('verificacion_id');
    if ($_column == null) return null;
    final manager = $$VerificacionesTableTableManager(
      $_db,
      $_db.verificaciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_verificacionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquiposTable _equipoIdTable(_$AppDatabase db) =>
      db.equipos.createAlias(
        $_aliasNameGenerator(db.movimientosCreditos.equipoId, db.equipos.id),
      );

  $$EquiposTableProcessedTableManager? get equipoId {
    final $_column = $_itemColumn<int>('equipo_id');
    if ($_column == null) return null;
    final manager = $$EquiposTableTableManager(
      $_db,
      $_db.equipos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PruebasTable _pruebaIdTable(_$AppDatabase db) =>
      db.pruebas.createAlias(
        $_aliasNameGenerator(db.movimientosCreditos.pruebaId, db.pruebas.id),
      );

  $$PruebasTableProcessedTableManager? get pruebaId {
    final $_column = $_itemColumn<int>('prueba_id');
    if ($_column == null) return null;
    final manager = $$PruebasTableTableManager(
      $_db,
      $_db.pruebas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pruebaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimientosCreditosTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosCreditosTable> {
  $$MovimientosCreditosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saldoResultante => $composableBuilder(
    column: $table.saldoResultante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $$PilotosTableFilterComposer get pilotoId {
    final $$PilotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableFilterComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CampeonatosTableFilterComposer get campeonatoId {
    final $$CampeonatosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableFilterComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VerificacionesTableFilterComposer get verificacionId {
    final $$VerificacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verificacionId,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableFilterComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableFilterComposer get equipoId {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableFilterComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableFilterComposer get pruebaId {
    final $$PruebasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableFilterComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosCreditosTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosCreditosTable> {
  $$MovimientosCreditosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saldoResultante => $composableBuilder(
    column: $table.saldoResultante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $$PilotosTableOrderingComposer get pilotoId {
    final $$PilotosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableOrderingComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CampeonatosTableOrderingComposer get campeonatoId {
    final $$CampeonatosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableOrderingComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VerificacionesTableOrderingComposer get verificacionId {
    final $$VerificacionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verificacionId,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableOrderingComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableOrderingComposer get equipoId {
    final $$EquiposTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableOrderingComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableOrderingComposer get pruebaId {
    final $$PruebasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableOrderingComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosCreditosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosCreditosTable> {
  $$MovimientosCreditosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<int> get saldoResultante => $composableBuilder(
    column: $table.saldoResultante,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $$PilotosTableAnnotationComposer get pilotoId {
    final $$PilotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pilotoId,
      referencedTable: $db.pilotos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PilotosTableAnnotationComposer(
            $db: $db,
            $table: $db.pilotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CampeonatosTableAnnotationComposer get campeonatoId {
    final $$CampeonatosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campeonatoId,
      referencedTable: $db.campeonatos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampeonatosTableAnnotationComposer(
            $db: $db,
            $table: $db.campeonatos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VerificacionesTableAnnotationComposer get verificacionId {
    final $$VerificacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verificacionId,
      referencedTable: $db.verificaciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerificacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.verificaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableAnnotationComposer get equipoId {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equipos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableAnnotationComposer(
            $db: $db,
            $table: $db.equipos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PruebasTableAnnotationComposer get pruebaId {
    final $$PruebasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pruebaId,
      referencedTable: $db.pruebas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PruebasTableAnnotationComposer(
            $db: $db,
            $table: $db.pruebas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosCreditosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimientosCreditosTable,
          MovimientosCredito,
          $$MovimientosCreditosTableFilterComposer,
          $$MovimientosCreditosTableOrderingComposer,
          $$MovimientosCreditosTableAnnotationComposer,
          $$MovimientosCreditosTableCreateCompanionBuilder,
          $$MovimientosCreditosTableUpdateCompanionBuilder,
          (MovimientosCredito, $$MovimientosCreditosTableReferences),
          MovimientosCredito,
          PrefetchHooks Function({
            bool pilotoId,
            bool campeonatoId,
            bool verificacionId,
            bool equipoId,
            bool pruebaId,
          })
        > {
  $$MovimientosCreditosTableTableManager(
    _$AppDatabase db,
    $MovimientosCreditosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosCreditosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosCreditosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MovimientosCreditosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pilotoId = const Value.absent(),
                Value<int> campeonatoId = const Value.absent(),
                Value<int?> verificacionId = const Value.absent(),
                Value<int?> equipoId = const Value.absent(),
                Value<int?> pruebaId = const Value.absent(),
                Value<int> delta = const Value.absent(),
                Value<int> saldoResultante = const Value.absent(),
                Value<String> motivo = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
              }) => MovimientosCreditosCompanion(
                id: id,
                pilotoId: pilotoId,
                campeonatoId: campeonatoId,
                verificacionId: verificacionId,
                equipoId: equipoId,
                pruebaId: pruebaId,
                delta: delta,
                saldoResultante: saldoResultante,
                motivo: motivo,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pilotoId,
                required int campeonatoId,
                Value<int?> verificacionId = const Value.absent(),
                Value<int?> equipoId = const Value.absent(),
                Value<int?> pruebaId = const Value.absent(),
                required int delta,
                required int saldoResultante,
                required String motivo,
                Value<DateTime> fecha = const Value.absent(),
              }) => MovimientosCreditosCompanion.insert(
                id: id,
                pilotoId: pilotoId,
                campeonatoId: campeonatoId,
                verificacionId: verificacionId,
                equipoId: equipoId,
                pruebaId: pruebaId,
                delta: delta,
                saldoResultante: saldoResultante,
                motivo: motivo,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MovimientosCreditosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                pilotoId = false,
                campeonatoId = false,
                verificacionId = false,
                equipoId = false,
                pruebaId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (pilotoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.pilotoId,
                                    referencedTable:
                                        $$MovimientosCreditosTableReferences
                                            ._pilotoIdTable(db),
                                    referencedColumn:
                                        $$MovimientosCreditosTableReferences
                                            ._pilotoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (campeonatoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.campeonatoId,
                                    referencedTable:
                                        $$MovimientosCreditosTableReferences
                                            ._campeonatoIdTable(db),
                                    referencedColumn:
                                        $$MovimientosCreditosTableReferences
                                            ._campeonatoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (verificacionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.verificacionId,
                                    referencedTable:
                                        $$MovimientosCreditosTableReferences
                                            ._verificacionIdTable(db),
                                    referencedColumn:
                                        $$MovimientosCreditosTableReferences
                                            ._verificacionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (equipoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipoId,
                                    referencedTable:
                                        $$MovimientosCreditosTableReferences
                                            ._equipoIdTable(db),
                                    referencedColumn:
                                        $$MovimientosCreditosTableReferences
                                            ._equipoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (pruebaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.pruebaId,
                                    referencedTable:
                                        $$MovimientosCreditosTableReferences
                                            ._pruebaIdTable(db),
                                    referencedColumn:
                                        $$MovimientosCreditosTableReferences
                                            ._pruebaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$MovimientosCreditosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimientosCreditosTable,
      MovimientosCredito,
      $$MovimientosCreditosTableFilterComposer,
      $$MovimientosCreditosTableOrderingComposer,
      $$MovimientosCreditosTableAnnotationComposer,
      $$MovimientosCreditosTableCreateCompanionBuilder,
      $$MovimientosCreditosTableUpdateCompanionBuilder,
      (MovimientosCredito, $$MovimientosCreditosTableReferences),
      MovimientosCredito,
      PrefetchHooks Function({
        bool pilotoId,
        bool campeonatoId,
        bool verificacionId,
        bool equipoId,
        bool pruebaId,
      })
    >;
typedef $$CatalogoMarcasTableCreateCompanionBuilder =
    CatalogoMarcasCompanion Function({
      Value<int> id,
      required String codigo,
      required String nombre,
    });
typedef $$CatalogoMarcasTableUpdateCompanionBuilder =
    CatalogoMarcasCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<String> nombre,
    });

class $$CatalogoMarcasTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoMarcasTable> {
  $$CatalogoMarcasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoMarcasTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoMarcasTable> {
  $$CatalogoMarcasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoMarcasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoMarcasTable> {
  $$CatalogoMarcasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);
}

class $$CatalogoMarcasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoMarcasTable,
          CatalogoMarca,
          $$CatalogoMarcasTableFilterComposer,
          $$CatalogoMarcasTableOrderingComposer,
          $$CatalogoMarcasTableAnnotationComposer,
          $$CatalogoMarcasTableCreateCompanionBuilder,
          $$CatalogoMarcasTableUpdateCompanionBuilder,
          (
            CatalogoMarca,
            BaseReferences<_$AppDatabase, $CatalogoMarcasTable, CatalogoMarca>,
          ),
          CatalogoMarca,
          PrefetchHooks Function()
        > {
  $$CatalogoMarcasTableTableManager(
    _$AppDatabase db,
    $CatalogoMarcasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoMarcasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoMarcasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoMarcasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> nombre = const Value.absent(),
              }) => CatalogoMarcasCompanion(
                id: id,
                codigo: codigo,
                nombre: nombre,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required String nombre,
              }) => CatalogoMarcasCompanion.insert(
                id: id,
                codigo: codigo,
                nombre: nombre,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoMarcasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoMarcasTable,
      CatalogoMarca,
      $$CatalogoMarcasTableFilterComposer,
      $$CatalogoMarcasTableOrderingComposer,
      $$CatalogoMarcasTableAnnotationComposer,
      $$CatalogoMarcasTableCreateCompanionBuilder,
      $$CatalogoMarcasTableUpdateCompanionBuilder,
      (
        CatalogoMarca,
        BaseReferences<_$AppDatabase, $CatalogoMarcasTable, CatalogoMarca>,
      ),
      CatalogoMarca,
      PrefetchHooks Function()
    >;
typedef $$CatalogoLlantasTableCreateCompanionBuilder =
    CatalogoLlantasCompanion Function({
      Value<int> id,
      required String dimension,
      required String tipo,
    });
typedef $$CatalogoLlantasTableUpdateCompanionBuilder =
    CatalogoLlantasCompanion Function({
      Value<int> id,
      Value<String> dimension,
      Value<String> tipo,
    });

class $$CatalogoLlantasTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoLlantasTable> {
  $$CatalogoLlantasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dimension => $composableBuilder(
    column: $table.dimension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoLlantasTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoLlantasTable> {
  $$CatalogoLlantasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dimension => $composableBuilder(
    column: $table.dimension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoLlantasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoLlantasTable> {
  $$CatalogoLlantasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dimension =>
      $composableBuilder(column: $table.dimension, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);
}

class $$CatalogoLlantasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoLlantasTable,
          CatalogoLlanta,
          $$CatalogoLlantasTableFilterComposer,
          $$CatalogoLlantasTableOrderingComposer,
          $$CatalogoLlantasTableAnnotationComposer,
          $$CatalogoLlantasTableCreateCompanionBuilder,
          $$CatalogoLlantasTableUpdateCompanionBuilder,
          (
            CatalogoLlanta,
            BaseReferences<
              _$AppDatabase,
              $CatalogoLlantasTable,
              CatalogoLlanta
            >,
          ),
          CatalogoLlanta,
          PrefetchHooks Function()
        > {
  $$CatalogoLlantasTableTableManager(
    _$AppDatabase db,
    $CatalogoLlantasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoLlantasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoLlantasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoLlantasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dimension = const Value.absent(),
                Value<String> tipo = const Value.absent(),
              }) => CatalogoLlantasCompanion(
                id: id,
                dimension: dimension,
                tipo: tipo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dimension,
                required String tipo,
              }) => CatalogoLlantasCompanion.insert(
                id: id,
                dimension: dimension,
                tipo: tipo,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoLlantasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoLlantasTable,
      CatalogoLlanta,
      $$CatalogoLlantasTableFilterComposer,
      $$CatalogoLlantasTableOrderingComposer,
      $$CatalogoLlantasTableAnnotationComposer,
      $$CatalogoLlantasTableCreateCompanionBuilder,
      $$CatalogoLlantasTableUpdateCompanionBuilder,
      (
        CatalogoLlanta,
        BaseReferences<_$AppDatabase, $CatalogoLlantasTable, CatalogoLlanta>,
      ),
      CatalogoLlanta,
      PrefetchHooks Function()
    >;
typedef $$CatalogoBancadasTableCreateCompanionBuilder =
    CatalogoBancadasCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String> copasJson,
    });
typedef $$CatalogoBancadasTableUpdateCompanionBuilder =
    CatalogoBancadasCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> copasJson,
    });

class $$CatalogoBancadasTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoBancadasTable> {
  $$CatalogoBancadasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoBancadasTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoBancadasTable> {
  $$CatalogoBancadasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoBancadasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoBancadasTable> {
  $$CatalogoBancadasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get copasJson =>
      $composableBuilder(column: $table.copasJson, builder: (column) => column);
}

class $$CatalogoBancadasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoBancadasTable,
          CatalogoBancada,
          $$CatalogoBancadasTableFilterComposer,
          $$CatalogoBancadasTableOrderingComposer,
          $$CatalogoBancadasTableAnnotationComposer,
          $$CatalogoBancadasTableCreateCompanionBuilder,
          $$CatalogoBancadasTableUpdateCompanionBuilder,
          (
            CatalogoBancada,
            BaseReferences<
              _$AppDatabase,
              $CatalogoBancadasTable,
              CatalogoBancada
            >,
          ),
          CatalogoBancada,
          PrefetchHooks Function()
        > {
  $$CatalogoBancadasTableTableManager(
    _$AppDatabase db,
    $CatalogoBancadasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoBancadasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoBancadasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoBancadasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> copasJson = const Value.absent(),
              }) => CatalogoBancadasCompanion(
                id: id,
                nombre: nombre,
                copasJson: copasJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String> copasJson = const Value.absent(),
              }) => CatalogoBancadasCompanion.insert(
                id: id,
                nombre: nombre,
                copasJson: copasJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoBancadasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoBancadasTable,
      CatalogoBancada,
      $$CatalogoBancadasTableFilterComposer,
      $$CatalogoBancadasTableOrderingComposer,
      $$CatalogoBancadasTableAnnotationComposer,
      $$CatalogoBancadasTableCreateCompanionBuilder,
      $$CatalogoBancadasTableUpdateCompanionBuilder,
      (
        CatalogoBancada,
        BaseReferences<_$AppDatabase, $CatalogoBancadasTable, CatalogoBancada>,
      ),
      CatalogoBancada,
      PrefetchHooks Function()
    >;
typedef $$CatalogoChasisTableCreateCompanionBuilder =
    CatalogoChasisCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String> copasJson,
    });
typedef $$CatalogoChasisTableUpdateCompanionBuilder =
    CatalogoChasisCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> copasJson,
    });

class $$CatalogoChasisTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoChasisTable> {
  $$CatalogoChasisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoChasisTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoChasisTable> {
  $$CatalogoChasisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoChasisTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoChasisTable> {
  $$CatalogoChasisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get copasJson =>
      $composableBuilder(column: $table.copasJson, builder: (column) => column);
}

class $$CatalogoChasisTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoChasisTable,
          CatalogoChasi,
          $$CatalogoChasisTableFilterComposer,
          $$CatalogoChasisTableOrderingComposer,
          $$CatalogoChasisTableAnnotationComposer,
          $$CatalogoChasisTableCreateCompanionBuilder,
          $$CatalogoChasisTableUpdateCompanionBuilder,
          (
            CatalogoChasi,
            BaseReferences<_$AppDatabase, $CatalogoChasisTable, CatalogoChasi>,
          ),
          CatalogoChasi,
          PrefetchHooks Function()
        > {
  $$CatalogoChasisTableTableManager(
    _$AppDatabase db,
    $CatalogoChasisTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoChasisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoChasisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoChasisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> copasJson = const Value.absent(),
              }) => CatalogoChasisCompanion(
                id: id,
                nombre: nombre,
                copasJson: copasJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String> copasJson = const Value.absent(),
              }) => CatalogoChasisCompanion.insert(
                id: id,
                nombre: nombre,
                copasJson: copasJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoChasisTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoChasisTable,
      CatalogoChasi,
      $$CatalogoChasisTableFilterComposer,
      $$CatalogoChasisTableOrderingComposer,
      $$CatalogoChasisTableAnnotationComposer,
      $$CatalogoChasisTableCreateCompanionBuilder,
      $$CatalogoChasisTableUpdateCompanionBuilder,
      (
        CatalogoChasi,
        BaseReferences<_$AppDatabase, $CatalogoChasisTable, CatalogoChasi>,
      ),
      CatalogoChasi,
      PrefetchHooks Function()
    >;
typedef $$CatalogoNeumaticosTableCreateCompanionBuilder =
    CatalogoNeumaticosCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> referencia,
    });
typedef $$CatalogoNeumaticosTableUpdateCompanionBuilder =
    CatalogoNeumaticosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> referencia,
    });

class $$CatalogoNeumaticosTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoNeumaticosTable> {
  $$CatalogoNeumaticosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoNeumaticosTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoNeumaticosTable> {
  $$CatalogoNeumaticosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoNeumaticosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoNeumaticosTable> {
  $$CatalogoNeumaticosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => column,
  );
}

class $$CatalogoNeumaticosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoNeumaticosTable,
          CatalogoNeumatico,
          $$CatalogoNeumaticosTableFilterComposer,
          $$CatalogoNeumaticosTableOrderingComposer,
          $$CatalogoNeumaticosTableAnnotationComposer,
          $$CatalogoNeumaticosTableCreateCompanionBuilder,
          $$CatalogoNeumaticosTableUpdateCompanionBuilder,
          (
            CatalogoNeumatico,
            BaseReferences<
              _$AppDatabase,
              $CatalogoNeumaticosTable,
              CatalogoNeumatico
            >,
          ),
          CatalogoNeumatico,
          PrefetchHooks Function()
        > {
  $$CatalogoNeumaticosTableTableManager(
    _$AppDatabase db,
    $CatalogoNeumaticosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoNeumaticosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoNeumaticosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoNeumaticosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> referencia = const Value.absent(),
              }) => CatalogoNeumaticosCompanion(
                id: id,
                nombre: nombre,
                referencia: referencia,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> referencia = const Value.absent(),
              }) => CatalogoNeumaticosCompanion.insert(
                id: id,
                nombre: nombre,
                referencia: referencia,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoNeumaticosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoNeumaticosTable,
      CatalogoNeumatico,
      $$CatalogoNeumaticosTableFilterComposer,
      $$CatalogoNeumaticosTableOrderingComposer,
      $$CatalogoNeumaticosTableAnnotationComposer,
      $$CatalogoNeumaticosTableCreateCompanionBuilder,
      $$CatalogoNeumaticosTableUpdateCompanionBuilder,
      (
        CatalogoNeumatico,
        BaseReferences<
          _$AppDatabase,
          $CatalogoNeumaticosTable,
          CatalogoNeumatico
        >,
      ),
      CatalogoNeumatico,
      PrefetchHooks Function()
    >;
typedef $$CatalogoEngranajesTableCreateCompanionBuilder =
    CatalogoEngranajesCompanion Function({
      Value<int> id,
      required String tipo,
      required String marca,
      required int dientes,
    });
typedef $$CatalogoEngranajesTableUpdateCompanionBuilder =
    CatalogoEngranajesCompanion Function({
      Value<int> id,
      Value<String> tipo,
      Value<String> marca,
      Value<int> dientes,
    });

class $$CatalogoEngranajesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoEngranajesTable> {
  $$CatalogoEngranajesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dientes => $composableBuilder(
    column: $table.dientes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoEngranajesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoEngranajesTable> {
  $$CatalogoEngranajesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dientes => $composableBuilder(
    column: $table.dientes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoEngranajesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoEngranajesTable> {
  $$CatalogoEngranajesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<int> get dientes =>
      $composableBuilder(column: $table.dientes, builder: (column) => column);
}

class $$CatalogoEngranajesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoEngranajesTable,
          CatalogoEngranaje,
          $$CatalogoEngranajesTableFilterComposer,
          $$CatalogoEngranajesTableOrderingComposer,
          $$CatalogoEngranajesTableAnnotationComposer,
          $$CatalogoEngranajesTableCreateCompanionBuilder,
          $$CatalogoEngranajesTableUpdateCompanionBuilder,
          (
            CatalogoEngranaje,
            BaseReferences<
              _$AppDatabase,
              $CatalogoEngranajesTable,
              CatalogoEngranaje
            >,
          ),
          CatalogoEngranaje,
          PrefetchHooks Function()
        > {
  $$CatalogoEngranajesTableTableManager(
    _$AppDatabase db,
    $CatalogoEngranajesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoEngranajesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoEngranajesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoEngranajesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> marca = const Value.absent(),
                Value<int> dientes = const Value.absent(),
              }) => CatalogoEngranajesCompanion(
                id: id,
                tipo: tipo,
                marca: marca,
                dientes: dientes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tipo,
                required String marca,
                required int dientes,
              }) => CatalogoEngranajesCompanion.insert(
                id: id,
                tipo: tipo,
                marca: marca,
                dientes: dientes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoEngranajesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoEngranajesTable,
      CatalogoEngranaje,
      $$CatalogoEngranajesTableFilterComposer,
      $$CatalogoEngranajesTableOrderingComposer,
      $$CatalogoEngranajesTableAnnotationComposer,
      $$CatalogoEngranajesTableCreateCompanionBuilder,
      $$CatalogoEngranajesTableUpdateCompanionBuilder,
      (
        CatalogoEngranaje,
        BaseReferences<
          _$AppDatabase,
          $CatalogoEngranajesTable,
          CatalogoEngranaje
        >,
      ),
      CatalogoEngranaje,
      PrefetchHooks Function()
    >;
typedef $$CatalogoMotoresTableCreateCompanionBuilder =
    CatalogoMotoresCompanion Function({
      Value<int> id,
      required String nombre,
      Value<int?> rpm,
      Value<double?> gauss,
      Value<String> copasJson,
    });
typedef $$CatalogoMotoresTableUpdateCompanionBuilder =
    CatalogoMotoresCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<int?> rpm,
      Value<double?> gauss,
      Value<String> copasJson,
    });

class $$CatalogoMotoresTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoMotoresTable> {
  $$CatalogoMotoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rpm => $composableBuilder(
    column: $table.rpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gauss => $composableBuilder(
    column: $table.gauss,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoMotoresTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoMotoresTable> {
  $$CatalogoMotoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rpm => $composableBuilder(
    column: $table.rpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gauss => $composableBuilder(
    column: $table.gauss,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copasJson => $composableBuilder(
    column: $table.copasJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoMotoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoMotoresTable> {
  $$CatalogoMotoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get rpm =>
      $composableBuilder(column: $table.rpm, builder: (column) => column);

  GeneratedColumn<double> get gauss =>
      $composableBuilder(column: $table.gauss, builder: (column) => column);

  GeneratedColumn<String> get copasJson =>
      $composableBuilder(column: $table.copasJson, builder: (column) => column);
}

class $$CatalogoMotoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoMotoresTable,
          CatalogoMotore,
          $$CatalogoMotoresTableFilterComposer,
          $$CatalogoMotoresTableOrderingComposer,
          $$CatalogoMotoresTableAnnotationComposer,
          $$CatalogoMotoresTableCreateCompanionBuilder,
          $$CatalogoMotoresTableUpdateCompanionBuilder,
          (
            CatalogoMotore,
            BaseReferences<
              _$AppDatabase,
              $CatalogoMotoresTable,
              CatalogoMotore
            >,
          ),
          CatalogoMotore,
          PrefetchHooks Function()
        > {
  $$CatalogoMotoresTableTableManager(
    _$AppDatabase db,
    $CatalogoMotoresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoMotoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoMotoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoMotoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int?> rpm = const Value.absent(),
                Value<double?> gauss = const Value.absent(),
                Value<String> copasJson = const Value.absent(),
              }) => CatalogoMotoresCompanion(
                id: id,
                nombre: nombre,
                rpm: rpm,
                gauss: gauss,
                copasJson: copasJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<int?> rpm = const Value.absent(),
                Value<double?> gauss = const Value.absent(),
                Value<String> copasJson = const Value.absent(),
              }) => CatalogoMotoresCompanion.insert(
                id: id,
                nombre: nombre,
                rpm: rpm,
                gauss: gauss,
                copasJson: copasJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoMotoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoMotoresTable,
      CatalogoMotore,
      $$CatalogoMotoresTableFilterComposer,
      $$CatalogoMotoresTableOrderingComposer,
      $$CatalogoMotoresTableAnnotationComposer,
      $$CatalogoMotoresTableCreateCompanionBuilder,
      $$CatalogoMotoresTableUpdateCompanionBuilder,
      (
        CatalogoMotore,
        BaseReferences<_$AppDatabase, $CatalogoMotoresTable, CatalogoMotore>,
      ),
      CatalogoMotore,
      PrefetchHooks Function()
    >;
typedef $$CatalogoCopasTableCreateCompanionBuilder =
    CatalogoCopasCompanion Function({Value<int> id, required String nombre});
typedef $$CatalogoCopasTableUpdateCompanionBuilder =
    CatalogoCopasCompanion Function({Value<int> id, Value<String> nombre});

class $$CatalogoCopasTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoCopasTable> {
  $$CatalogoCopasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoCopasTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoCopasTable> {
  $$CatalogoCopasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoCopasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoCopasTable> {
  $$CatalogoCopasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);
}

class $$CatalogoCopasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoCopasTable,
          CatalogoCopa,
          $$CatalogoCopasTableFilterComposer,
          $$CatalogoCopasTableOrderingComposer,
          $$CatalogoCopasTableAnnotationComposer,
          $$CatalogoCopasTableCreateCompanionBuilder,
          $$CatalogoCopasTableUpdateCompanionBuilder,
          (
            CatalogoCopa,
            BaseReferences<_$AppDatabase, $CatalogoCopasTable, CatalogoCopa>,
          ),
          CatalogoCopa,
          PrefetchHooks Function()
        > {
  $$CatalogoCopasTableTableManager(_$AppDatabase db, $CatalogoCopasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoCopasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoCopasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoCopasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
              }) => CatalogoCopasCompanion(id: id, nombre: nombre),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
              }) => CatalogoCopasCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoCopasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoCopasTable,
      CatalogoCopa,
      $$CatalogoCopasTableFilterComposer,
      $$CatalogoCopasTableOrderingComposer,
      $$CatalogoCopasTableAnnotationComposer,
      $$CatalogoCopasTableCreateCompanionBuilder,
      $$CatalogoCopasTableUpdateCompanionBuilder,
      (
        CatalogoCopa,
        BaseReferences<_$AppDatabase, $CatalogoCopasTable, CatalogoCopa>,
      ),
      CatalogoCopa,
      PrefetchHooks Function()
    >;
typedef $$CatalogoClubsTableCreateCompanionBuilder =
    CatalogoClubsCompanion Function({Value<int> id, required String nombre});
typedef $$CatalogoClubsTableUpdateCompanionBuilder =
    CatalogoClubsCompanion Function({Value<int> id, Value<String> nombre});

class $$CatalogoClubsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogoClubsTable> {
  $$CatalogoClubsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogoClubsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogoClubsTable> {
  $$CatalogoClubsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogoClubsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogoClubsTable> {
  $$CatalogoClubsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);
}

class $$CatalogoClubsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogoClubsTable,
          CatalogoClub,
          $$CatalogoClubsTableFilterComposer,
          $$CatalogoClubsTableOrderingComposer,
          $$CatalogoClubsTableAnnotationComposer,
          $$CatalogoClubsTableCreateCompanionBuilder,
          $$CatalogoClubsTableUpdateCompanionBuilder,
          (
            CatalogoClub,
            BaseReferences<_$AppDatabase, $CatalogoClubsTable, CatalogoClub>,
          ),
          CatalogoClub,
          PrefetchHooks Function()
        > {
  $$CatalogoClubsTableTableManager(_$AppDatabase db, $CatalogoClubsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogoClubsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogoClubsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogoClubsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
              }) => CatalogoClubsCompanion(id: id, nombre: nombre),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
              }) => CatalogoClubsCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogoClubsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogoClubsTable,
      CatalogoClub,
      $$CatalogoClubsTableFilterComposer,
      $$CatalogoClubsTableOrderingComposer,
      $$CatalogoClubsTableAnnotationComposer,
      $$CatalogoClubsTableCreateCompanionBuilder,
      $$CatalogoClubsTableUpdateCompanionBuilder,
      (
        CatalogoClub,
        BaseReferences<_$AppDatabase, $CatalogoClubsTable, CatalogoClub>,
      ),
      CatalogoClub,
      PrefetchHooks Function()
    >;
typedef $$HojasVinculadasTableCreateCompanionBuilder =
    HojasVinculadasCompanion Function({
      Value<int> id,
      required String entidad,
      Value<int?> campeonatoId,
      Value<int?> pruebaId,
      required String hojaId,
      required String hojaNombre,
      required String pestanaTitulo,
      required String mapeoJson,
      Value<DateTime?> ultimaSync,
      Value<String?> ultimoResumen,
    });
typedef $$HojasVinculadasTableUpdateCompanionBuilder =
    HojasVinculadasCompanion Function({
      Value<int> id,
      Value<String> entidad,
      Value<int?> campeonatoId,
      Value<int?> pruebaId,
      Value<String> hojaId,
      Value<String> hojaNombre,
      Value<String> pestanaTitulo,
      Value<String> mapeoJson,
      Value<DateTime?> ultimaSync,
      Value<String?> ultimoResumen,
    });

class $$HojasVinculadasTableFilterComposer
    extends Composer<_$AppDatabase, $HojasVinculadasTable> {
  $$HojasVinculadasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entidad => $composableBuilder(
    column: $table.entidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get campeonatoId => $composableBuilder(
    column: $table.campeonatoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pruebaId => $composableBuilder(
    column: $table.pruebaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hojaId => $composableBuilder(
    column: $table.hojaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hojaNombre => $composableBuilder(
    column: $table.hojaNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pestanaTitulo => $composableBuilder(
    column: $table.pestanaTitulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mapeoJson => $composableBuilder(
    column: $table.mapeoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ultimaSync => $composableBuilder(
    column: $table.ultimaSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ultimoResumen => $composableBuilder(
    column: $table.ultimoResumen,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HojasVinculadasTableOrderingComposer
    extends Composer<_$AppDatabase, $HojasVinculadasTable> {
  $$HojasVinculadasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entidad => $composableBuilder(
    column: $table.entidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get campeonatoId => $composableBuilder(
    column: $table.campeonatoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pruebaId => $composableBuilder(
    column: $table.pruebaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hojaId => $composableBuilder(
    column: $table.hojaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hojaNombre => $composableBuilder(
    column: $table.hojaNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pestanaTitulo => $composableBuilder(
    column: $table.pestanaTitulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mapeoJson => $composableBuilder(
    column: $table.mapeoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ultimaSync => $composableBuilder(
    column: $table.ultimaSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ultimoResumen => $composableBuilder(
    column: $table.ultimoResumen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HojasVinculadasTableAnnotationComposer
    extends Composer<_$AppDatabase, $HojasVinculadasTable> {
  $$HojasVinculadasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entidad =>
      $composableBuilder(column: $table.entidad, builder: (column) => column);

  GeneratedColumn<int> get campeonatoId => $composableBuilder(
    column: $table.campeonatoId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pruebaId =>
      $composableBuilder(column: $table.pruebaId, builder: (column) => column);

  GeneratedColumn<String> get hojaId =>
      $composableBuilder(column: $table.hojaId, builder: (column) => column);

  GeneratedColumn<String> get hojaNombre => $composableBuilder(
    column: $table.hojaNombre,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pestanaTitulo => $composableBuilder(
    column: $table.pestanaTitulo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mapeoJson =>
      $composableBuilder(column: $table.mapeoJson, builder: (column) => column);

  GeneratedColumn<DateTime> get ultimaSync => $composableBuilder(
    column: $table.ultimaSync,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ultimoResumen => $composableBuilder(
    column: $table.ultimoResumen,
    builder: (column) => column,
  );
}

class $$HojasVinculadasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HojasVinculadasTable,
          HojasVinculada,
          $$HojasVinculadasTableFilterComposer,
          $$HojasVinculadasTableOrderingComposer,
          $$HojasVinculadasTableAnnotationComposer,
          $$HojasVinculadasTableCreateCompanionBuilder,
          $$HojasVinculadasTableUpdateCompanionBuilder,
          (
            HojasVinculada,
            BaseReferences<
              _$AppDatabase,
              $HojasVinculadasTable,
              HojasVinculada
            >,
          ),
          HojasVinculada,
          PrefetchHooks Function()
        > {
  $$HojasVinculadasTableTableManager(
    _$AppDatabase db,
    $HojasVinculadasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HojasVinculadasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HojasVinculadasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HojasVinculadasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entidad = const Value.absent(),
                Value<int?> campeonatoId = const Value.absent(),
                Value<int?> pruebaId = const Value.absent(),
                Value<String> hojaId = const Value.absent(),
                Value<String> hojaNombre = const Value.absent(),
                Value<String> pestanaTitulo = const Value.absent(),
                Value<String> mapeoJson = const Value.absent(),
                Value<DateTime?> ultimaSync = const Value.absent(),
                Value<String?> ultimoResumen = const Value.absent(),
              }) => HojasVinculadasCompanion(
                id: id,
                entidad: entidad,
                campeonatoId: campeonatoId,
                pruebaId: pruebaId,
                hojaId: hojaId,
                hojaNombre: hojaNombre,
                pestanaTitulo: pestanaTitulo,
                mapeoJson: mapeoJson,
                ultimaSync: ultimaSync,
                ultimoResumen: ultimoResumen,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entidad,
                Value<int?> campeonatoId = const Value.absent(),
                Value<int?> pruebaId = const Value.absent(),
                required String hojaId,
                required String hojaNombre,
                required String pestanaTitulo,
                required String mapeoJson,
                Value<DateTime?> ultimaSync = const Value.absent(),
                Value<String?> ultimoResumen = const Value.absent(),
              }) => HojasVinculadasCompanion.insert(
                id: id,
                entidad: entidad,
                campeonatoId: campeonatoId,
                pruebaId: pruebaId,
                hojaId: hojaId,
                hojaNombre: hojaNombre,
                pestanaTitulo: pestanaTitulo,
                mapeoJson: mapeoJson,
                ultimaSync: ultimaSync,
                ultimoResumen: ultimoResumen,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HojasVinculadasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HojasVinculadasTable,
      HojasVinculada,
      $$HojasVinculadasTableFilterComposer,
      $$HojasVinculadasTableOrderingComposer,
      $$HojasVinculadasTableAnnotationComposer,
      $$HojasVinculadasTableCreateCompanionBuilder,
      $$HojasVinculadasTableUpdateCompanionBuilder,
      (
        HojasVinculada,
        BaseReferences<_$AppDatabase, $HojasVinculadasTable, HojasVinculada>,
      ),
      HojasVinculada,
      PrefetchHooks Function()
    >;
typedef $$SyncColaTableCreateCompanionBuilder =
    SyncColaCompanion Function({
      Value<int> id,
      required String entidad,
      Value<int?> entidadId,
      required String accion,
      required String payloadJson,
      Value<String> estado,
      Value<String?> error,
      Value<DateTime> creadoEn,
      Value<DateTime?> sincronizadoEn,
    });
typedef $$SyncColaTableUpdateCompanionBuilder =
    SyncColaCompanion Function({
      Value<int> id,
      Value<String> entidad,
      Value<int?> entidadId,
      Value<String> accion,
      Value<String> payloadJson,
      Value<String> estado,
      Value<String?> error,
      Value<DateTime> creadoEn,
      Value<DateTime?> sincronizadoEn,
    });

class $$SyncColaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncColaTable> {
  $$SyncColaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entidad => $composableBuilder(
    column: $table.entidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entidadId => $composableBuilder(
    column: $table.entidadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accion => $composableBuilder(
    column: $table.accion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncColaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncColaTable> {
  $$SyncColaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entidad => $composableBuilder(
    column: $table.entidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entidadId => $composableBuilder(
    column: $table.entidadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accion => $composableBuilder(
    column: $table.accion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncColaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncColaTable> {
  $$SyncColaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entidad =>
      $composableBuilder(column: $table.entidad, builder: (column) => column);

  GeneratedColumn<int> get entidadId =>
      $composableBuilder(column: $table.entidadId, builder: (column) => column);

  GeneratedColumn<String> get accion =>
      $composableBuilder(column: $table.accion, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => column,
  );
}

class $$SyncColaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncColaTable,
          SyncColaData,
          $$SyncColaTableFilterComposer,
          $$SyncColaTableOrderingComposer,
          $$SyncColaTableAnnotationComposer,
          $$SyncColaTableCreateCompanionBuilder,
          $$SyncColaTableUpdateCompanionBuilder,
          (
            SyncColaData,
            BaseReferences<_$AppDatabase, $SyncColaTable, SyncColaData>,
          ),
          SyncColaData,
          PrefetchHooks Function()
        > {
  $$SyncColaTableTableManager(_$AppDatabase db, $SyncColaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncColaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncColaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncColaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entidad = const Value.absent(),
                Value<int?> entidadId = const Value.absent(),
                Value<String> accion = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime?> sincronizadoEn = const Value.absent(),
              }) => SyncColaCompanion(
                id: id,
                entidad: entidad,
                entidadId: entidadId,
                accion: accion,
                payloadJson: payloadJson,
                estado: estado,
                error: error,
                creadoEn: creadoEn,
                sincronizadoEn: sincronizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entidad,
                Value<int?> entidadId = const Value.absent(),
                required String accion,
                required String payloadJson,
                Value<String> estado = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime?> sincronizadoEn = const Value.absent(),
              }) => SyncColaCompanion.insert(
                id: id,
                entidad: entidad,
                entidadId: entidadId,
                accion: accion,
                payloadJson: payloadJson,
                estado: estado,
                error: error,
                creadoEn: creadoEn,
                sincronizadoEn: sincronizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncColaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncColaTable,
      SyncColaData,
      $$SyncColaTableFilterComposer,
      $$SyncColaTableOrderingComposer,
      $$SyncColaTableAnnotationComposer,
      $$SyncColaTableCreateCompanionBuilder,
      $$SyncColaTableUpdateCompanionBuilder,
      (
        SyncColaData,
        BaseReferences<_$AppDatabase, $SyncColaTable, SyncColaData>,
      ),
      SyncColaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CampeonatosTableTableManager get campeonatos =>
      $$CampeonatosTableTableManager(_db, _db.campeonatos);
  $$TablaPuntosTableTableManager get tablaPuntos =>
      $$TablaPuntosTableTableManager(_db, _db.tablaPuntos);
  $$TablaBonificacionTableTableManager get tablaBonificacion =>
      $$TablaBonificacionTableTableManager(_db, _db.tablaBonificacion);
  $$PilotosTableTableManager get pilotos =>
      $$PilotosTableTableManager(_db, _db.pilotos);
  $$PilotoCampeonatoTableTableManager get pilotoCampeonato =>
      $$PilotoCampeonatoTableTableManager(_db, _db.pilotoCampeonato);
  $$EquiposTableTableManager get equipos =>
      $$EquiposTableTableManager(_db, _db.equipos);
  $$PruebasTableTableManager get pruebas =>
      $$PruebasTableTableManager(_db, _db.pruebas);
  $$MangasTableTableManager get mangas =>
      $$MangasTableTableManager(_db, _db.mangas);
  $$InscripcionesTableTableManager get inscripciones =>
      $$InscripcionesTableTableManager(_db, _db.inscripciones);
  $$InscripcionesPruebaTableTableManager get inscripcionesPrueba =>
      $$InscripcionesPruebaTableTableManager(_db, _db.inscripcionesPrueba);
  $$ResultadosTableTableManager get resultados =>
      $$ResultadosTableTableManager(_db, _db.resultados);
  $$DescartesPruebaTableTableManager get descartesPrueba =>
      $$DescartesPruebaTableTableManager(_db, _db.descartesPrueba);
  $$OverridesCopaTableTableManager get overridesCopa =>
      $$OverridesCopaTableTableManager(_db, _db.overridesCopa);
  $$CatalogoCochesTableTableManager get catalogoCoches =>
      $$CatalogoCochesTableTableManager(_db, _db.catalogoCoches);
  $$VerificacionesTableTableManager get verificaciones =>
      $$VerificacionesTableTableManager(_db, _db.verificaciones);
  $$PagosTableTableManager get pagos =>
      $$PagosTableTableManager(_db, _db.pagos);
  $$MovimientosTesoreriaTableTableManager get movimientosTesoreria =>
      $$MovimientosTesoreriaTableTableManager(_db, _db.movimientosTesoreria);
  $$MovimientosCreditosTableTableManager get movimientosCreditos =>
      $$MovimientosCreditosTableTableManager(_db, _db.movimientosCreditos);
  $$CatalogoMarcasTableTableManager get catalogoMarcas =>
      $$CatalogoMarcasTableTableManager(_db, _db.catalogoMarcas);
  $$CatalogoLlantasTableTableManager get catalogoLlantas =>
      $$CatalogoLlantasTableTableManager(_db, _db.catalogoLlantas);
  $$CatalogoBancadasTableTableManager get catalogoBancadas =>
      $$CatalogoBancadasTableTableManager(_db, _db.catalogoBancadas);
  $$CatalogoChasisTableTableManager get catalogoChasis =>
      $$CatalogoChasisTableTableManager(_db, _db.catalogoChasis);
  $$CatalogoNeumaticosTableTableManager get catalogoNeumaticos =>
      $$CatalogoNeumaticosTableTableManager(_db, _db.catalogoNeumaticos);
  $$CatalogoEngranajesTableTableManager get catalogoEngranajes =>
      $$CatalogoEngranajesTableTableManager(_db, _db.catalogoEngranajes);
  $$CatalogoMotoresTableTableManager get catalogoMotores =>
      $$CatalogoMotoresTableTableManager(_db, _db.catalogoMotores);
  $$CatalogoCopasTableTableManager get catalogoCopas =>
      $$CatalogoCopasTableTableManager(_db, _db.catalogoCopas);
  $$CatalogoClubsTableTableManager get catalogoClubs =>
      $$CatalogoClubsTableTableManager(_db, _db.catalogoClubs);
  $$HojasVinculadasTableTableManager get hojasVinculadas =>
      $$HojasVinculadasTableTableManager(_db, _db.hojasVinculadas);
  $$SyncColaTableTableManager get syncCola =>
      $$SyncColaTableTableManager(_db, _db.syncCola);
}
