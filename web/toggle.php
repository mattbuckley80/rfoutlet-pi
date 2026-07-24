<?php
header('Content-Type: application/json');
header('Cache-Control: no-cache, must-revalidate');

// ============================================================
// EDIT THESE CODES FOR YOUR SPECIFIC OUTLETS
// Use RFSniffer to capture codes from your remote:
//   sudo /var/www/html/rfoutlet/RFSniffer
// ============================================================
$codes = array(
    "1" => array(
        "on"  => 1111111,
        "off" => 1111112
    ),
    "2" => array(
        "on"  => 2222221,
        "off" => 2222222
    ),
    "3" => array(
        "on"  => 3333331,
        "off" => 3333332
    ),
    "4" => array(
        "on"  => 4444441,
        "off" => 4444442
    ),
    "5" => array(
        "on"  => 5555551,
        "off" => 5555552
    ),
);

// Path to the Python transmitter script
$codeSendPath = 'python3 /var/www/html/rfoutlet/codesend.py';

// GPIO pin number for the transmitter DATA wire (BCM numbering)
// SYN115 transmitter DATA -> GPIO17
$codeSendPIN = "17";

// Pulse length for your specific RF outlets
// Use RFSniffer to determine the correct value for your remotes
// Common values: 170, 189, 200
$codeSendPulseLength = "189";

// ============================================================
// DO NOT EDIT BELOW THIS LINE
// ============================================================

if (!file_exists('/var/www/html/rfoutlet/codesend.py')) {
    error_log("codesend.py is missing", 0);
    die(json_encode(array('success' => false, 'error' => 'codesend.py not found')));
}

$outletLight  = isset($_POST['outletId'])     ? $_POST['outletId']     : null;
$outletStatus = isset($_POST['outletStatus']) ? $_POST['outletStatus'] : null;

$validOutlets  = array("1","2","3","4","5","6");
$validStatuses = array("on","off");

if (!in_array($outletLight, $validOutlets) || !in_array($outletStatus, $validStatuses)) {
    die(json_encode(array('success' => false, 'error' => 'Invalid input')));
}

if ($outletLight == "6") {
    // 6 = all outlets
    if (function_exists('array_column')) {
        $codesToToggle = array_column($codes, $outletStatus);
    } else {
        $codesToToggle = array();
        foreach ($codes as $outletCodes) {
            array_push($codesToToggle, $outletCodes[$outletStatus]);
        }
    }
} else {
    $codesToToggle = array($codes[$outletLight][$outletStatus]);
}

foreach ($codesToToggle as $codeSendCode) {
    shell_exec($codeSendPath . ' ' . $codeSendCode . ' ' . $codeSendPulseLength . ' ' . $codeSendPIN);
    sleep(1);
}

die(json_encode(array('success' => true)));
?>
