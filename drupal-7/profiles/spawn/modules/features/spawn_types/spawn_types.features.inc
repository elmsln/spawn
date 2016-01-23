<?php
/**
 * @file
 * spawn_types.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function spawn_types_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_node_info().
 */
function spawn_types_node_info() {
  $items = array(
    'aws_server' => array(
      'name' => t('AWS Server'),
      'base' => 'node_content',
      'description' => t('An AWS Server, AMI, zone, etc'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => '',
    ),
    'drupal_site' => array(
      'name' => t('Drupal Site'),
      'base' => 'node_content',
      'description' => t('Launch a new Drupal site'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => '',
    ),
  );
  drupal_alter('node_info', $items);
  return $items;
}
