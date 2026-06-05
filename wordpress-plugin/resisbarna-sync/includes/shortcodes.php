<?php
if ( ! defined( 'ABSPATH' ) ) exit;

add_action( 'init', 'resb_register_shortcodes' );
function resb_register_shortcodes() {
    add_shortcode( 'resisbarna_clasificacion', 'resb_sc_clasificacion' );
    add_shortcode( 'resisbarna_calendario',    'resb_sc_calendario' );
    add_shortcode( 'resisbarna_pilotos',       'resb_sc_pilotos' );
    add_shortcode( 'resisbarna_equipos',       'resb_sc_equipos' );
    add_shortcode( 'resisbarna_verificaciones','resb_sc_verificaciones' );
    add_shortcode( 'resisbarna_prueba',        'resb_sc_prueba' );
}

add_action( 'wp_enqueue_scripts', 'resb_enqueue' );
function resb_enqueue() {
    wp_register_style( 'resb-css', RESB_URL . 'assets/resisbarna.css', [], RESB_VERSION );
}

function resb_inline_style() {
    static $hecho = false;
    if ( $hecho ) return '';
    $hecho = true;
    return '<style>
    .resb-tabla{border-collapse:collapse;width:100%;font-family:system-ui,-apple-system,sans-serif;font-size:14px}
    .resb-tabla th,.resb-tabla td{border-bottom:1px solid #e5e5e5;padding:8px 10px;text-align:left}
    .resb-tabla th{background:#fafafa;font-weight:700}
    .resb-tabla tr:nth-child(even){background:#fcfcfc}
    .resb-pos{display:inline-block;min-width:28px;text-align:center;font-weight:700;padding:4px 6px;border-radius:14px;background:#eee;color:#333}
    .resb-pos.oro{background:#E6A700;color:#fff}
    .resb-pos.plata{background:#9E9E9E;color:#fff}
    .resb-pos.bronce{background:#B36A38;color:#fff}
    .resb-chip{display:inline-block;padding:2px 8px;border-radius:6px;background:#eef2ff;color:#3730a3;font-size:12px;font-weight:600}
    .resb-desc{text-decoration:line-through;color:#a00}
    .resb-total{font-weight:800;color:#D32F2F}
    .resb-card{border:1px solid #e5e5e5;border-radius:10px;padding:12px;margin-bottom:8px}
    .resb-card h4{margin:0 0 4px 0}
    .resb-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:12px}
    </style>';
}

function resb_sc_clasificacion( $atts ) {
    global $wpdb;
    $atts = shortcode_atts( [
        'campeonato' => '',
        'copa'       => '',
        'limite'     => 200,
    ], $atts, 'resisbarna_clasificacion' );

    $slug = sanitize_title( $atts['campeonato'] );
    if ( ! $slug ) return '<em>Indica el campeonato: [resisbarna_clasificacion campeonato="..."]</em>';

    $tabla   = resb_table_name();
    $tabla_p = resb_table_pruebas();

    $pruebas = $wpdb->get_results( $wpdb->prepare(
        "SELECT * FROM $tabla_p WHERE campeonato_slug=%s ORDER BY orden ASC", $slug
    ) );

    $where = $wpdb->prepare( 'campeonato_slug=%s', $slug );
    if ( ! empty( $atts['copa'] ) ) {
        $where .= $wpdb->prepare( ' AND copa=%s', $atts['copa'] );
    }
    $limite = max( 1, min( 500, (int) $atts['limite'] ) );
    $filas = $wpdb->get_results(
        "SELECT * FROM $tabla WHERE $where ORDER BY posicion ASC LIMIT $limite"
    );

    if ( empty( $filas ) ) {
        return '<p>Aún no hay datos de clasificación para este campeonato.</p>';
    }

    ob_start();
    echo resb_inline_style();
    echo '<table class="resb-tabla resb-clasif">';
    echo '<thead><tr>';
    echo '<th>#</th><th>Piloto</th><th>Equipo</th><th>Copa</th><th>Cat.</th>';
    foreach ( $pruebas as $p ) {
        echo '<th title="' . esc_attr( $p->nombre ) . '">' . esc_html( resb_corta( $p->nombre, 8 ) ) . '</th>';
    }
    echo '<th>Bruto</th><th>Desc.</th><th>TOTAL</th>';
    echo '</tr></thead><tbody>';
    foreach ( $filas as $f ) {
        $puntos = json_decode( $f->puntos_por_prueba, true ) ?: [];
        $descartes = json_decode( $f->descartes, true ) ?: [];
        $clasePos = '';
        if ( $f->posicion == 1 ) $clasePos = 'oro';
        elseif ( $f->posicion == 2 ) $clasePos = 'plata';
        elseif ( $f->posicion == 3 ) $clasePos = 'bronce';
        echo '<tr>';
        echo '<td><span class="resb-pos ' . esc_attr( $clasePos ) . '">' . (int) $f->posicion . '</span></td>';
        echo '<td>' . esc_html( $f->piloto_nombre ) . '</td>';
        echo '<td>' . esc_html( $f->equipo_nombre ) . '</td>';
        echo '<td><span class="resb-chip">' . esc_html( $f->copa ) . '</span></td>';
        echo '<td>' . esc_html( $f->categoria ) . '</td>';
        foreach ( $pruebas as $p ) {
            $pid = $p->prueba_id;
            $pts = isset( $puntos[ $pid ] ) ? (int) $puntos[ $pid ] : 0;
            $desc = in_array( $pid, (array) $descartes );
            if ( $pts === 0 && ! $desc ) {
                echo '<td>—</td>';
            } else {
                $clase = $desc ? 'resb-desc' : '';
                echo '<td class="' . $clase . '">' . $pts . '</td>';
            }
        }
        echo '<td>' . (int) $f->total_bruto . '</td>';
        echo '<td>' . ( $f->total_descarte > 0 ? '-' . (int) $f->total_descarte : '0' ) . '</td>';
        echo '<td class="resb-total">' . (int) $f->total_neto . '</td>';
        echo '</tr>';
    }
    echo '</tbody></table>';
    return ob_get_clean();
}

function resb_sc_calendario( $atts ) {
    $atts = shortcode_atts( [ 'campeonato' => '' ], $atts, 'resisbarna_calendario' );
    $slug = sanitize_title( $atts['campeonato'] );
    $args = [
        'post_type'      => 'resb_prueba',
        'posts_per_page' => -1,
        'orderby'        => 'meta_value_num',
        'meta_key'       => 'resb_orden',
        'order'          => 'ASC',
    ];
    if ( $slug ) {
        $args['meta_query'] = [
            [ 'key' => 'resb_campeonato', 'value' => $slug ],
            [ 'key' => 'resb_orden' ],
        ];
    }
    $q = new WP_Query( $args );
    if ( ! $q->have_posts() ) return '<p>Aún no hay pruebas programadas.</p>';

    ob_start();
    echo resb_inline_style();
    echo '<div class="resb-grid">';
    while ( $q->have_posts() ) { $q->the_post();
        $orden = (int) get_post_meta( get_the_ID(), 'resb_orden', true );
        $sede  = get_post_meta( get_the_ID(), 'resb_sede', true );
        $fecha = get_post_meta( get_the_ID(), 'resb_fecha', true );
        $estado = get_post_meta( get_the_ID(), 'resb_estado', true );
        echo '<div class="resb-card">';
        echo '<small>Prueba #' . $orden . '</small>';
        echo '<h4>' . esc_html( get_the_title() ) . '</h4>';
        if ( $sede )  echo '<div>📍 ' . esc_html( $sede ) . '</div>';
        if ( $fecha ) echo '<div>📅 ' . esc_html( $fecha ) . '</div>';
        if ( $estado ) echo '<div><span class="resb-chip">' . esc_html( $estado ) . '</span></div>';
        echo '</div>';
    }
    echo '</div>';
    wp_reset_postdata();
    return ob_get_clean();
}

function resb_sc_pilotos( $atts ) {
    $atts = shortcode_atts( [ 'campeonato' => '' ], $atts, 'resisbarna_pilotos' );
    $args = [
        'post_type'      => 'resb_piloto',
        'posts_per_page' => -1,
        'orderby'        => 'title',
        'order'          => 'ASC',
    ];
    if ( $atts['campeonato'] ) {
        $args['meta_query'] = [
            [ 'key' => 'resb_campeonato', 'value' => sanitize_title( $atts['campeonato'] ) ],
        ];
    }
    $q = new WP_Query( $args );
    if ( ! $q->have_posts() ) return '<p>Aún no hay pilotos publicados.</p>';
    ob_start();
    echo resb_inline_style();
    echo '<table class="resb-tabla"><thead><tr>';
    echo '<th>Piloto</th><th>Categoría</th><th>Créditos</th><th>Palmarés</th>';
    echo '</tr></thead><tbody>';
    while ( $q->have_posts() ) { $q->the_post();
        $cat = get_post_meta( get_the_ID(), 'resb_categoria', true );
        $cred = get_post_meta( get_the_ID(), 'resb_creditos', true );
        echo '<tr>';
        echo '<td>' . esc_html( get_the_title() ) . '</td>';
        echo '<td><span class="resb-chip">' . esc_html( $cat ) . '</span></td>';
        echo '<td>' . esc_html( $cred ) . '</td>';
        echo '<td>' . wp_kses_post( get_the_content() ) . '</td>';
        echo '</tr>';
    }
    echo '</tbody></table>';
    wp_reset_postdata();
    return ob_get_clean();
}

function resb_sc_equipos( $atts ) {
    $atts = shortcode_atts( [ 'campeonato' => '' ], $atts, 'resisbarna_equipos' );
    $args = [
        'post_type'      => 'resb_equipo',
        'posts_per_page' => -1,
        'orderby'        => 'title',
        'order'          => 'ASC',
    ];
    if ( $atts['campeonato'] ) {
        $args['meta_query'] = [
            [ 'key' => 'resb_campeonato', 'value' => sanitize_title( $atts['campeonato'] ) ],
        ];
    }
    $q = new WP_Query( $args );
    if ( ! $q->have_posts() ) return '<p>Aún no hay equipos publicados.</p>';
    ob_start();
    echo resb_inline_style();
    echo '<table class="resb-tabla"><thead><tr>';
    echo '<th>Equipo</th><th>Pilotos</th><th>Copa</th>';
    echo '</tr></thead><tbody>';
    while ( $q->have_posts() ) { $q->the_post();
        $p1 = get_post_meta( get_the_ID(), 'resb_piloto1', true );
        $p2 = get_post_meta( get_the_ID(), 'resb_piloto2', true );
        $copa = get_post_meta( get_the_ID(), 'resb_copa', true );
        echo '<tr>';
        echo '<td><strong>' . esc_html( get_the_title() ) . '</strong></td>';
        echo '<td>' . esc_html( $p2 ? "$p1 + $p2" : $p1 ) . '</td>';
        echo '<td><span class="resb-chip">' . esc_html( $copa ) . '</span></td>';
        echo '</tr>';
    }
    echo '</tbody></table>';
    wp_reset_postdata();
    return ob_get_clean();
}

function resb_sc_verificaciones( $atts ) {
    $atts = shortcode_atts( [ 'prueba' => '' ], $atts, 'resisbarna_verificaciones' );
    $args = [
        'post_type'      => 'resb_verificacion',
        'posts_per_page' => -1,
        'orderby'        => 'title',
        'order'          => 'ASC',
    ];
    if ( $atts['prueba'] ) {
        $args['meta_query'] = [
            [ 'key' => 'resb_prueba', 'value' => sanitize_text_field( $atts['prueba'] ) ],
        ];
    }
    $q = new WP_Query( $args );
    if ( ! $q->have_posts() ) return '<p>Aún no hay verificaciones publicadas.</p>';
    ob_start();
    echo resb_inline_style();
    echo '<table class="resb-tabla"><thead><tr>';
    echo '<th>Equipo</th><th>Coche</th><th>Peso ini.</th><th>Peso final</th><th>Validada</th>';
    echo '</tr></thead><tbody>';
    while ( $q->have_posts() ) { $q->the_post();
        $eq = get_post_meta( get_the_ID(), 'resb_equipo', true );
        $coche = get_post_meta( get_the_ID(), 'resb_coche', true );
        $pi = get_post_meta( get_the_ID(), 'resb_peso_inicial', true );
        $pf = get_post_meta( get_the_ID(), 'resb_peso_final', true );
        $val = get_post_meta( get_the_ID(), 'resb_validado', true );
        echo '<tr>';
        echo '<td>' . esc_html( $eq ) . '</td>';
        echo '<td>' . esc_html( $coche ) . '</td>';
        echo '<td>' . esc_html( $pi ) . '</td>';
        echo '<td>' . esc_html( $pf ) . '</td>';
        echo '<td>' . ( $val === '1' ? '✅' : '⏳' ) . '</td>';
        echo '</tr>';
    }
    echo '</tbody></table>';
    wp_reset_postdata();
    return ob_get_clean();
}

function resb_sc_prueba( $atts ) {
    $atts = shortcode_atts( [ 'uid' => '' ], $atts, 'resisbarna_prueba' );
    if ( ! $atts['uid'] ) return '';
    $posts = get_posts( [
        'post_type'   => 'resb_prueba',
        'meta_key'    => 'resb_uid',
        'meta_value'  => $atts['uid'],
        'numberposts' => 1,
    ] );
    if ( ! $posts ) return '<p>Prueba no encontrada.</p>';
    $post = $posts[0];
    $datos = json_decode( get_post_meta( $post->ID, 'resb_resultados', true ), true ) ?: [];
    ob_start();
    echo resb_inline_style();
    echo '<div class="resb-card"><h4>' . esc_html( $post->post_title ) . '</h4>';
    $sede  = get_post_meta( $post->ID, 'resb_sede', true );
    $fecha = get_post_meta( $post->ID, 'resb_fecha', true );
    if ( $sede )  echo '<div>📍 ' . esc_html( $sede ) . '</div>';
    if ( $fecha ) echo '<div>📅 ' . esc_html( $fecha ) . '</div>';
    echo '</div>';
    if ( ! empty( $datos ) ) {
        echo '<table class="resb-tabla"><thead><tr><th>Pos.</th><th>Equipo</th><th>Pilotos</th><th>Pts</th></tr></thead><tbody>';
        foreach ( $datos as $r ) {
            echo '<tr>';
            echo '<td>' . (int) ( $r['posicion'] ?? 0 ) . '</td>';
            echo '<td>' . esc_html( $r['equipo'] ?? '' ) . '</td>';
            echo '<td>' . esc_html( $r['pilotos'] ?? '' ) . '</td>';
            echo '<td>' . (int) ( $r['puntos'] ?? 0 ) . '</td>';
            echo '</tr>';
        }
        echo '</tbody></table>';
    }
    return ob_get_clean();
}

function resb_corta( $s, $n ) {
    if ( strlen( $s ) <= $n ) return $s;
    return substr( $s, 0, $n - 1 ) . '…';
}
