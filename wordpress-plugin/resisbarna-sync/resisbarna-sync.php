<?php
/**
 * Plugin Name: Resisbarna Sync
 * Plugin URI:  https://www.resisbarna.es
 * Description: Recibe datos desde la app Resisbarna (pilotos, equipos, pruebas, clasificación, verificaciones) y los publica con shortcodes.
 * Version:     0.1.0
 * Author:      Resisbarna
 * License:     GPLv2 or later
 * Text Domain: resisbarna-sync
 */

if ( ! defined( 'ABSPATH' ) ) exit;

define( 'RESB_VERSION', '0.1.0' );
define( 'RESB_PATH', plugin_dir_path( __FILE__ ) );
define( 'RESB_URL',  plugin_dir_url( __FILE__ ) );

// Tabla custom para la clasificación general (más eficiente que CPT para tablas grandes).
function resb_table_name() {
    global $wpdb;
    return $wpdb->prefix . 'resb_clasificacion';
}
function resb_table_pruebas() {
    global $wpdb;
    return $wpdb->prefix . 'resb_pruebas';
}

require_once RESB_PATH . 'includes/cpts.php';
require_once RESB_PATH . 'includes/rest.php';
require_once RESB_PATH . 'includes/shortcodes.php';

register_activation_hook( __FILE__, 'resb_on_activate' );
function resb_on_activate() {
    global $wpdb;
    $charset = $wpdb->get_charset_collate();
    $tabla = resb_table_name();
    $sql = "CREATE TABLE IF NOT EXISTS $tabla (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        campeonato_slug VARCHAR(120) NOT NULL,
        piloto_id VARCHAR(120) NOT NULL,
        piloto_nombre VARCHAR(200) NOT NULL,
        equipo_nombre VARCHAR(200) NOT NULL,
        copa VARCHAR(50) NOT NULL,
        categoria VARCHAR(50) NOT NULL,
        posicion INT NOT NULL,
        total_bruto INT NOT NULL DEFAULT 0,
        total_descarte INT NOT NULL DEFAULT 0,
        total_neto INT NOT NULL DEFAULT 0,
        creditos_actuales INT NOT NULL DEFAULT 0,
        puntos_por_prueba LONGTEXT NULL,
        descartes LONGTEXT NULL,
        actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uniq_campeonato_piloto (campeonato_slug, piloto_id),
        KEY idx_campeonato_pos (campeonato_slug, posicion)
    ) $charset;";

    $tabla_p = resb_table_pruebas();
    $sql_p = "CREATE TABLE IF NOT EXISTS $tabla_p (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        campeonato_slug VARCHAR(120) NOT NULL,
        prueba_id VARCHAR(120) NOT NULL,
        nombre VARCHAR(200) NOT NULL,
        orden INT NOT NULL DEFAULT 0,
        UNIQUE KEY uniq_camp_prueba (campeonato_slug, prueba_id)
    ) $charset;";

    require_once ABSPATH . 'wp-admin/includes/upgrade.php';
    dbDelta( $sql );
    dbDelta( $sql_p );

    flush_rewrite_rules();
}

register_deactivation_hook( __FILE__, 'flush_rewrite_rules' );
