<?php
if ( ! defined( 'ABSPATH' ) ) exit;

add_action( 'init', 'resb_register_cpts' );
function resb_register_cpts() {
    $args_base = [
        'public'              => true,
        'show_in_rest'        => true,
        'has_archive'         => false,
        'menu_icon'           => 'dashicons-flag',
        'supports'            => [ 'title', 'editor', 'custom-fields' ],
        'capability_type'     => 'post',
    ];

    register_post_type( 'resb_piloto', array_merge( $args_base, [
        'label'   => __( 'Pilotos', 'resisbarna-sync' ),
        'rewrite' => [ 'slug' => 'piloto' ],
        'menu_position' => 30,
    ] ) );
    register_post_type( 'resb_equipo', array_merge( $args_base, [
        'label'   => __( 'Equipos', 'resisbarna-sync' ),
        'rewrite' => [ 'slug' => 'equipo' ],
    ] ) );
    register_post_type( 'resb_prueba', array_merge( $args_base, [
        'label'   => __( 'Pruebas', 'resisbarna-sync' ),
        'rewrite' => [ 'slug' => 'prueba' ],
    ] ) );
    register_post_type( 'resb_verificacion', array_merge( $args_base, [
        'label'   => __( 'Verificaciones', 'resisbarna-sync' ),
        'rewrite' => [ 'slug' => 'verificacion' ],
        'public'  => false,
        'show_ui' => true,
    ] ) );
}

/**
 * Crea o actualiza un CPT por slug único guardado en post_meta `resb_uid`.
 * Devuelve el post_id.
 */
function resb_upsert_cpt( $tipo, $uid, $datos ) {
    $existente = get_posts( [
        'post_type'   => $tipo,
        'meta_key'    => 'resb_uid',
        'meta_value'  => $uid,
        'numberposts' => 1,
        'post_status' => 'any',
    ] );
    $postarr = [
        'post_type'    => $tipo,
        'post_status'  => 'publish',
        'post_title'   => isset( $datos['titulo'] ) ? sanitize_text_field( $datos['titulo'] ) : $uid,
        'post_content' => isset( $datos['contenido'] ) ? wp_kses_post( $datos['contenido'] ) : '',
    ];
    if ( $existente ) {
        $postarr['ID'] = $existente[0]->ID;
        $id = wp_update_post( $postarr );
    } else {
        $id = wp_insert_post( $postarr );
    }
    if ( is_wp_error( $id ) || ! $id ) return 0;
    update_post_meta( $id, 'resb_uid', $uid );
    if ( ! empty( $datos['meta'] ) && is_array( $datos['meta'] ) ) {
        foreach ( $datos['meta'] as $k => $v ) {
            update_post_meta( $id, sanitize_key( $k ), $v );
        }
    }
    return $id;
}
