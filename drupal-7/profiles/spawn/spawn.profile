<?php
/**
 * Implements hook_form_FORM_ID_alter().
 *
 * Allows the profile to alter the site configuration form.
 */
if (!function_exists("system_form_install_configure_form_alter")) {
  function system_form_install_configure_form_alter(&$form, $form_state) {
    $form['site_information']['site_name']['#default_value'] = 'spawn';
  }
}

/**
 * Implements hook_form_alter().
 *
 * Select the current install profile by default.
 */
if (!function_exists("system_form_install_select_profile_form_alter")) {
  function system_form_install_select_profile_form_alter(&$form, $form_state) {
    foreach ($form['profile'] as $key => $element) {
      $form['profile'][$key]['#value'] = 'spawn';
    }
  }
}

/**
 * Implements hook_install_tasks().
 */
function spawn_install_tasks() {
  $tasks = array(
    'spawn_client_form' => array(
      'display_name' => st('AWS Configure'),
      'type' => 'form',
    ),
  );
  return $tasks;
}
function spawn_client_form() {
  $form = array();
  $form['intro'] = array(
    '#markup' => '<p>' . st('This will configure your AWS IAM user credentials API Key and Secret') . '</p>',
  );
  $form['aws_key'] = array(
    '#type' => 'textfield',
    '#title' => st('AWS Access Key ID'),
    '#required' => TRUE,
  );
  $form['aws_secret'] = array(
    '#type' => 'password',
    '#title' => st('AWS Secret Access Key'),
    '#required' => TRUE,
  );
  $form['aws_region'] = array(
    '#type' => 'textfield',
    '#title' => st('Default region name'),
  );
  $form['aws_output'] = array(
    '#type' => 'textfield',
    '#title' => st('Default output format'),
  );
  $form['submit'] = array(
    '#type' => 'submit',
    '#value' => st('Continue'),
  );
  return $form;
}

function spawn_client_form_validate($form, &$form_state) {
  // todo validate
}

function spawn_client_form_submit($form, &$form_state) {
  $values = $form_state['values'];

  // Setup the user account array to programatically create a new user.
  $aws_configure = array(
    'key' => $values['aws_key'],
    'secret' => $values['aws_secret'],
    'region' => $values['aws_region'],
    'output' => $values['aws_ouput'],
    'init' => $values['client_mail'],
  );
  // todo process the form into a shell execution where it makes the shell run
  // => aws configure
  $aws_configure = shell_exec(string $cmd); //<< figure this out. ;)

}