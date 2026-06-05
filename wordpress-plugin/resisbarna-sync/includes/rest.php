<?php
if ( ! defined( 'ABSPATH' ) ) exit;

add_action( 'rest_api_init', 'resb_register_routes' );
function resb_register_routes() {
    register_rest_route( 'resisbarna/v1', '/ping', [
        'methods'             => 'GET',
        'callback'            => 'resb_route_ping',
        'permission_callback' => 'resb_perms_publicar',
    ] );
    register_rest_route( 'resisbarna/v1', '/clasificacion', [
        'methods'             => 'POST',
        'callback'            => 'resb_route_clasificacion',
        'permission_callback' => 'resb_perms_publicar',
    ] );
    register_rest_route( 'resisbarna/v1', '/pilotos', [
        'methods'             => 'POST',
        'callback'            => 'resb_route_pilotos',
        'permission_callback' => 'resb_perms_publicar',
    ] );
    register_rest_route( 'resisbarna/v1', '/equipos', [
        'methods'             => 'POST',
        'callback'            => 'resb_route_equipos',
        'permission_callback' => 'resb_perms_publicar',
    ] );
    register_rest_route( 'resisbarna/v1', '/pruebas', [
        'methods'             => 'POST',
        'callback'            => 'resb_route_pruebas',
        'permission_callback' => 'resb_perms_publicar',
    ] );
    register_rest_route( 'resisbarna/v1', '/verificaciones', [
        'methods'             => 'POST',
        'callback'            => 'resb_route_verificaciones',
        'permission_callback' => 'resb_perms_publicar',
    ] );
}

function resb_perms_publicar() {
    return current_user_can( 'edit_posts' );
}

function resb_route_ping( WP_REST_Request $r ) {
    return [
        'ok'      => true,
        'version' => RESB_VERSION,
        'user'    => wp_get_current_user()->user_login,
        'site'    => get_bloginfo( 'name' ),
    ];
}

/**
 * Espera un payload:
 * {
 *   "campeonato": { "slug": "resisbarna-2026", "nombre": "Resisbarna 2026" },
 *   "pruebas":    [ { "id": "1", "nombre": "EL SOT", "orden": 1 }, ... ],
 *   "filas":      [ { "piloto_id": "12", "piloto_nombre": "...", "equipo_nombre": "...", "copa": "GT",
 *                     "categoria": "ORO", "posicion": 1, "total_bruto": 350, "total_descarte": 0,
 *                     "total_neto": 350, "creditos_actuales": 14,
 *                     "puntos_por_prueba": { "1": 70, "2": 64 },
 *                     "descartes": [ "3" ] }, ... ]
 * }
 */
function resb_route_clasificacion( WP_REST_Request $r ) {
    global $wpdb;
    $body = $r->get_json_params();
    if ( ! is_array( $body ) ) return new WP_Error( 'bad', 'Body inválido', [ 'status' => 400 ] );

    $camp = isset( $body['campeonato'] ) ? $body['campeonato'] : null;
    if ( ! $camp || empty( $camp['slug'] ) ) {
        return new WP_Error( 'bad', 'Falta campeonato.slug', [ 'status' => 400 ] );
    }
    $slug = sanitize_title( $camp['slug'] );

    $tabla = resb_table_name();
    // Reemplazar toda la clasificación de ese campeonato (más simple que diff)
    $wpdb->delete( $tabla, [ 'campeonato_slug' => $slug ], [ '%s' ] );

    $insertados = 0;
    foreach ( (array) $body['filas'] as $f ) {
        $wpdb->insert( $tabla, [
            'campeonato_slug'   => $slug,
            'piloto_id'         => (string) ( $f['piloto_id'] ?? '' ),
            'piloto_nombre'     => sanitize_text_field( $f['piloto_nombre'] ?? '' ),
            'equipo_nombre'     => sanitize_text_field( $f['equipo_nombre'] ?? '' ),
            'copa'              => sanitize_text_field( $f['copa'] ?? '' ),
            'categoria'         => sanitize_text_field( $f['categoria'] ?? '' ),
            'posicion'          => (int) ( $f['posicion'] ?? 0 ),
            'total_bruto'       => (int) ( $f['total_bruto'] ?? 0 ),
            'total_descarte'    => (int) ( $f['total_descarte'] ?? 0 ),
            'total_neto'        => (int) ( $f['total_neto'] ?? 0 ),
            'creditos_actuales' => (int) ( $f['creditos_actuales'] ?? 0 ),
            'puntos_por_prueba' => wp_json_encode( $f['puntos_por_prueba'] ?? [] ),
            'descartes'         => wp_json_encode( $f['descartes'] ?? [] ),
            'actualizado_en'    => current_time( 'mysql' ),
        ], [
            '%s','%s','%s','%s','%s','%s','%d','%d','%d','%d','%d','%s','%s','%s'
        ] );
        $insertados++;
    }

    // Guardar pruebas para que el shortcode pueda mostrar columnas
    if ( ! empty( $body['pruebas'] ) && is_array( $body['pruebas'] ) ) {
        $tabla_p = resb_table_pruebas();
        $wpdb->delete( $tabla_p, [ 'campeonato_slug' => $slug ], [ '%s' ] );
        foreach ( $body['pruebas'] as $p ) {
            $wpdb->insert( $tabla_p, [
                'campeonato_slug' => $slug,
                'prueba_id'       => (string) ( $p['id'] ?? '' ),
                'nombre'          => sanitize_text_field( $p['nombre'] ?? '' ),
                'orden'           => (int) ( $p['orden'] ?? 0 ),
            ], [ '%s','%s','%s','%d' ] );
        }
    }

    return [ 'ok' => true, 'campeonato' => $slug, 'filas' => $insertados ];
}

function resb_route_pilotos( WP_REST_Request $r ) {
    $body = $r->get_json_params();
    if ( ! is_array( $body ) || empty( $body['items'] ) ) {
        return new WP_Error( 'bad', 'Falta items', [ 'status' => 400 ] );
    }
    $ok = 0;
    foreach ( (array) $body['items'] as $p ) {
        $uid = sanitize_title( $p['uid'] ?? '' );
        if ( ! $uid ) continue;
        resb_upsert_cpt( 'resb_piloto', $uid, [
            'titulo' => $p['nombre'] ?? $uid,
            'contenido' => $p['palmares'] ?? '',
            'meta' => [
                'resb_categoria' => $p['categoria'] ?? '',
                'resb_creditos'  => $p['creditos'] ?? 0,
                'resb_email'     => $p['email'] ?? '',
                'resb_telefono'  => $p['telefono'] ?? '',
                'resb_campeonato'=> $p['campeonato_slug'] ?? '',
            ],
        ] );
        $ok++;
    }
    return [ 'ok' => true, 'pilotos' => $ok ];
}

function resb_route_equipos( WP_REST_Request $r ) {
    $body = $r->get_json_params();
    if ( ! is_array( $body ) || empty( $body['items'] ) ) {
        return new WP_Error( 'bad', 'Falta items', [ 'status' => 400 ] );
    }
    $ok = 0;
    foreach ( (array) $body['items'] as $e ) {
        $uid = sanitize_title( $e['uid'] ?? '' );
        if ( ! $uid ) continue;
        resb_upsert_cpt( 'resb_equipo', $uid, [
            'titulo' => $e['nombre'] ?? $uid,
            'meta' => [
                'resb_copa'      => $e['copa'] ?? '',
                'resb_piloto1'   => $e['piloto1'] ?? '',
                'resb_piloto2'   => $e['piloto2'] ?? '',
                'resb_campeonato'=> $e['campeonato_slug'] ?? '',
            ],
        ] );
        $ok++;
    }
    return [ 'ok' => true, 'equipos' => $ok ];
}

function resb_route_pruebas( WP_REST_Request $r ) {
    $body = $r->get_json_params();
    if ( ! is_array( $body ) || empty( $body['items'] ) ) {
        return new WP_Error( 'bad', 'Falta items', [ 'status' => 400 ] );
    }
    $ok = 0;
    foreach ( (array) $body['items'] as $p ) {
        $uid = sanitize_title( $p['uid'] ?? '' );
        if ( ! $uid ) continue;
        resb_upsert_cpt( 'resb_prueba', $uid, [
            'titulo'    => $p['nombre'] ?? $uid,
            'contenido' => $p['descripcion'] ?? '',
            'meta' => [
                'resb_sede'      => $p['sede'] ?? '',
                'resb_fecha'     => $p['fecha'] ?? '',
                'resb_orden'     => $p['orden'] ?? 0,
                'resb_estado'    => $p['estado'] ?? '',
                'resb_campeonato'=> $p['campeonato_slug'] ?? '',
                'resb_resultados'=> wp_json_encode( $p['resultados'] ?? [] ),
            ],
        ] );
        $ok++;
    }
    return [ 'ok' => true, 'pruebas' => $ok ];
}

function resb_route_verificaciones( WP_REST_Request $r ) {
    $body = $r->get_json_params();
    if ( ! is_array( $body ) || empty( $body['items'] ) ) {
        return new WP_Error( 'bad', 'Falta items', [ 'status' => 400 ] );
    }
    $ok = 0;
    foreach ( (array) $body['items'] as $v ) {
        $uid = sanitize_title( $v['uid'] ?? '' );
        if ( ! $uid ) continue;
        resb_upsert_cpt( 'resb_verificacion', $uid, [
            'titulo' => $v['titulo'] ?? $uid,
            'meta' => [
                'resb_equipo'       => $v['equipo'] ?? '',
                'resb_prueba'       => $v['prueba'] ?? '',
                'resb_coche'        => $v['coche'] ?? '',
                'resb_peso_inicial' => $v['peso_inicial'] ?? '',
                'resb_peso_final'   => $v['peso_final'] ?? '',
                'resb_validado'     => ! empty( $v['validado'] ) ? '1' : '0',
                'resb_datos'        => wp_json_encode( $v ),
                'resb_campeonato'   => $v['campeonato_slug'] ?? '',
            ],
        ] );
        $ok++;
    }
    return [ 'ok' => true, 'verificaciones' => $ok ];
}
